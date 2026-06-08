/* ==========================================================================
   Word 图文排版工具 - 主程序
   ==========================================================================
   职责：
   - 解析 .docx：提取段落、图片、图注、原始尺寸
   - 同组图片识别（4 种策略）
   - 模拟分页排版（页尾留白控制、等尺寸约束、等比缩放）
   - 渲染 A4 预览
   - 导出排版后的 .docx
   ========================================================================== */

(function () {
  'use strict';

  // ===== 全局状态 =====
  const state = {
    blocks: [],            // 文档块序列: text | image
    images: [],            // 仅图片引用
    groups: [],            // 图片分组
    pages: [],             // 排版后的分页结果
    pageMetrics: null,     // 当前页面度量数据
    zoom: 0.75,
    originalDocxBlob: null,
    sourceFileName: '',
  };

  // ===== DOM 引用 =====
  const $ = (sel) => document.querySelector(sel);
  const dropZone = $('#drop-zone');
  const fileInput = $('#file-input');
  const fileInfo = $('#file-info');
  const previewContainer = $('#preview-container');
  const groupsList = $('#groups-list');
  const logArea = $('#log-area');
  const btnExport = $('#btn-export');
  const btnRelayout = $('#btn-relayout');
  const btnSample = $('#btn-sample');
  const btnLoadSample = $('#btn-load-sample');
  const zoomLabel = $('#zoom-label');
  const pageStats = $('#page-stats');

  // ===== 日志 =====
  function log(msg, level = 'info') {
    const entry = document.createElement('div');
    entry.className = `log-entry ${level}`;
    const ts = new Date().toLocaleTimeString('zh-CN', { hour12: false });
    entry.innerHTML = `<span class="ts">[${ts}]</span>${escapeHtml(msg)}`;
    logArea.appendChild(entry);
    logArea.scrollTop = logArea.scrollHeight;
    // 清掉初始占位
    const placeholder = logArea.querySelector('.muted');
    if (placeholder) placeholder.remove();
  }

  function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, c => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[c]));
  }

  // ===== 单位换算 =====
  // 1 inch = 25.4 mm = 72 pt = 96 px (CSS)，1 EMU = 1/914400 inch
  const MM_TO_PT = 72 / 25.4;
  const PT_TO_PX = 96 / 72;
  const EMU_PER_INCH = 914400;

  function mmToPt(mm) { return mm * MM_TO_PT; }
  function ptToPx(pt) { return pt * PT_TO_PX; }
  function mmToPx(mm) { return ptToPx(mmToPt(mm)); }

  // ===== 读取配置 =====
  function readConfig() {
    const paperSizes = {
      A4: [210, 297], A3: [297, 420], Letter: [216, 279]
    };
    const paper = $('#cfg-paper').value;
    const [pageWmm, pageHmm] = paperSizes[paper];
    const cfg = {
      pageWmm, pageHmm,
      mTop: parseFloat($('#cfg-margin-top').value),
      mBot: parseFloat($('#cfg-margin-bottom').value),
      mLeft: parseFloat($('#cfg-margin-left').value),
      mRight: parseFloat($('#cfg-margin-right').value),
      fontSize: parseFloat($('#cfg-fontsize').value),
      lineSpacing: parseFloat($('#cfg-linespacing').value),
      tailLines: parseInt($('#cfg-tail-lines').value, 10),
      minWidthPct: parseFloat($('#cfg-min-width').value),
      maxWidthPct: parseFloat($('#cfg-max-width').value),
      captionAfter: parseFloat($('#cfg-caption-after').value),
      centerCaption: $('#cfg-center-caption').checked,
      equalGroup: $('#cfg-equal-group').checked,
      detectNumber: $('#cfg-detect-number').checked,
      detectKeyword: $('#cfg-detect-keyword').checked,
      detectSimilarity: $('#cfg-detect-similarity').checked,
      detectRatio: $('#cfg-detect-ratio').checked,
      simThreshold: parseFloat($('#cfg-sim-threshold').value),
    };
    // 派生量（pt 单位）
    cfg.contentWmm = cfg.pageWmm - cfg.mLeft - cfg.mRight;
    cfg.contentHmm = cfg.pageHmm - cfg.mTop - cfg.mBot;
    cfg.contentWpt = mmToPt(cfg.contentWmm);
    cfg.contentHpt = mmToPt(cfg.contentHmm);
    cfg.lineHeightPt = cfg.fontSize * cfg.lineSpacing;
    return cfg;
  }

  // ===== docx 解析 =====
  // 直接解开 docx 压缩包并读 OOXML，覆盖以下图片类型：
  // - 嵌入式 (wp:inline + a:blip)
  // - 浮动式 (wp:anchor + a:blip，含文字环绕)
  // - VML 旧版 (v:imagedata)
  // - 表格单元格内的图片
  // - 页眉/页脚里的图片（仅提示，不参与主流排版）
  // - 矢量格式 EMF/WMF（用占位图预览，导出时保留原始字节）
  const NS = {
    W: 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
    A: 'http://schemas.openxmlformats.org/drawingml/2006/main',
    R: 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
    WP: 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing',
    V: 'urn:schemas-microsoft-com:vml',
  };

  async function parseDocx(file) {
    state.sourceFileName = file.name;
    state.originalDocxBlob = file;
    log(`正在解析 ${file.name} (${(file.size / 1024).toFixed(1)} KB)…`);

    // 步骤 1：解压 zip
    let zip;
    try {
      zip = await JSZip.loadAsync(file);
    } catch (e) {
      throw new Error(`解压 docx 失败（文件可能损坏）：${e.message}`);
    }

    // 步骤 2：读关系文件
    const relsFile = zip.file('word/_rels/document.xml.rels');
    if (!relsFile) throw new Error('文档结构异常：缺少 word/_rels/document.xml.rels');
    let rels;
    try {
      rels = parseRels(await relsFile.async('text'));
    } catch (e) {
      throw new Error(`解析关系文件失败：${e.message}`);
    }

    // 步骤 3：读 document.xml
    const docFile = zip.file('word/document.xml');
    if (!docFile) throw new Error('文档结构异常：缺少 word/document.xml');
    const docXmlText = await docFile.async('text');
    let doc;
    try {
      doc = parseXml(docXmlText);
    } catch (e) {
      throw new Error(`document.xml 解析失败：${e.message}`);
    }

    // 步骤 4：收集所有 w:p（含表格内）
    const paragraphs = Array.from(doc.getElementsByTagNameNS(NS.W, 'p'));
    log(`共 ${paragraphs.length} 个段落，开始抽取图片…`);

    // 步骤 5：缓存 - 同一 rId 仅加载/测量一次
    const imageCache = new Map(); // rId -> { dataUrl, base64, nw, nh, ctype, ext, isVector }
    async function loadImageByRid(rid, ref) {
      if (imageCache.has(rid)) return imageCache.get(rid);
      const target = rels[rid];
      if (!target) return null;
      const path = target.startsWith('/') ? target.slice(1)
                  : target.startsWith('word/') ? target
                  : 'word/' + target;
      const fileEntry = zip.file(path);
      if (!fileEntry) return null;

      const ext = (path.split('.').pop() || 'png').toLowerCase();
      const ctype = imageMime(ext);
      const base64 = await fileEntry.async('base64');
      const isVector = ext === 'emf' || ext === 'wmf';

      let dataUrl, nw, nh;
      if (isVector) {
        dataUrl = makeVectorPlaceholder(ext);
        nw = ref.cxEmu ? ref.cxEmu / EMU_PER_INCH * 96 : 800;
        nh = ref.cyEmu ? ref.cyEmu / EMU_PER_INCH * 96 : 600;
      } else {
        dataUrl = `data:${ctype};base64,${base64}`;
        const dim = await measureImage(dataUrl);
        nw = dim.naturalWidth; nh = dim.naturalHeight;
      }
      const entry = { dataUrl, base64, nw, nh, ctype, ext, isVector };
      imageCache.set(rid, entry);
      return entry;
    }

    const blocks = [];
    let imgIndex = 0;
    const stats = { inline: 0, float: 0, vml: 0, vector: 0, skipped: 0 };
    const consumedAsCaption = new Set();

    for (let pi = 0; pi < paragraphs.length; pi++) {
      if (consumedAsCaption.has(pi)) continue;
      const p = paragraphs[pi];

      let refs;
      try {
        refs = extractImageRefs(p);
      } catch (e) {
        log(`段落 ${pi} 抽取图片引用失败：${e.message}`, 'warn');
        refs = [];
      }

      if (refs.length === 0) {
        const text = p.textContent.trim();
        if (text) blocks.push({ type: 'text', content: text });
        continue;
      }

      // 同一段含多张图时，下段图注只挂给第一张
      let captionText = '';
      if (refs.length >= 1 && paragraphs[pi + 1]) {
        const nxt = paragraphs[pi + 1];
        const nxtText = nxt.textContent.trim();
        if (nxtText && isLikelyCaption(nxtText) && extractImageRefs(nxt).length === 0) {
          captionText = nxtText;
          consumedAsCaption.add(pi + 1);
        }
      }

      let firstInThisPara = true;
      for (const ref of refs) {
        try {
          const entry = await loadImageByRid(ref.rid, ref);
          if (!entry) {
            log(`图片 ${ref.rid} 文件/关系缺失，跳过`, 'warn');
            stats.skipped++;
            continue;
          }

          if (ref.type === 'float') stats.float++;
          else if (ref.type === 'vml') stats.vml++;
          else stats.inline++;
          if (entry.isVector) stats.vector++;

          blocks.push({
            type: 'image',
            idx: imgIndex++,
            src: entry.dataUrl,
            originalBase64: entry.base64,
            originalExt: entry.ext,
            naturalW: entry.nw,
            naturalH: entry.nh,
            contentType: entry.ctype,
            caption: firstInThisPara ? captionText : '',
            displayW: 0,
            displayH: 0,
            groupId: -1,
            imageType: ref.type,
          });
          firstInThisPara = false;
        } catch (e) {
          log(`段落 ${pi} 处理图片 ${ref.rid} 出错：${e.message}`, 'error');
          stats.skipped++;
        }
      }
    }

    state.blocks = blocks;
    state.images = blocks.filter(b => b.type === 'image');

    const total = state.images.length;
    log(`提取完成：${blocks.length} 段，图片 ${total} 张（嵌入式 ${stats.inline} · 浮动 ${stats.float} · VML ${stats.vml}），唯一图片资源 ${imageCache.size} 个`, 'ok');
    if (stats.float > 0) log(`已把 ${stats.float} 处浮动图片按嵌入式重新参与排版`, 'warn');
    if (stats.vml > 0) log(`检测到 ${stats.vml} 处 VML 旧版图片，已正常解析`, 'warn');
    if (stats.vector > 0) log(`${stats.vector} 处矢量图 (EMF/WMF) 浏览器无法预览，但导出会保留原始字节`, 'warn');
    if (stats.skipped > 0) log(`${stats.skipped} 处图片关系/文件缺失，已跳过`, 'warn');
    if (total === 0) log('未在文档中找到任何图片', 'warn');
  }

  function parseXml(text) {
    const doc = new DOMParser().parseFromString(text, 'application/xml');
    // 仅当 documentElement 本身是 parsererror（Chrome/Firefox 失败时的根）才报错；
    // 不用 querySelector，避免误命中合法文档里恰好叫这个名字的元素。
    const root = doc.documentElement;
    if (!root) throw new Error('XML 无根元素');
    if (root.localName === 'parsererror' || root.tagName === 'parsererror') {
      throw new Error(root.textContent.slice(0, 200));
    }
    return doc;
  }

  function parseRels(xmlText) {
    const doc = parseXml(xmlText);
    const map = {};
    Array.from(doc.getElementsByTagName('Relationship')).forEach(r => {
      map[r.getAttribute('Id')] = r.getAttribute('Target');
    });
    return map;
  }

  // 从一个 <w:p> 中提取所有图片引用（inline / float / VML）
  function extractImageRefs(p) {
    const refs = [];

    // 1) DrawingML 图片 —— a:blip[r:embed]
    const blips = Array.from(p.getElementsByTagNameNS(NS.A, 'blip'));
    for (const blip of blips) {
      const rid = blip.getAttributeNS(NS.R, 'embed') || blip.getAttributeNS(NS.R, 'link');
      if (!rid) continue;

      // 判断是 inline 还是 anchor，并提取 wp:extent
      let type = 'inline';
      let cxEmu = 0, cyEmu = 0;
      let cur = blip.parentNode;
      while (cur && cur.nodeType === 1) {
        if (cur.namespaceURI === NS.WP) {
          if (cur.localName === 'anchor') type = 'float';
          else if (cur.localName === 'inline') type = 'inline';
          const exts = cur.getElementsByTagNameNS(NS.WP, 'extent');
          if (exts.length > 0) {
            cxEmu = parseInt(exts[0].getAttribute('cx'), 10) || 0;
            cyEmu = parseInt(exts[0].getAttribute('cy'), 10) || 0;
          }
          break;
        }
        cur = cur.parentNode;
      }
      refs.push({ rid, type, cxEmu, cyEmu });
    }

    // 2) VML 旧版图片 —— v:imagedata[r:id]
    const vmls = Array.from(p.getElementsByTagNameNS(NS.V, 'imagedata'));
    for (const v of vmls) {
      const rid = v.getAttributeNS(NS.R, 'id');
      if (rid) refs.push({ rid, type: 'vml', cxEmu: 0, cyEmu: 0 });
    }

    return refs;
  }

  function imageMime(ext) {
    const map = {
      png: 'image/png', jpg: 'image/jpeg', jpeg: 'image/jpeg',
      gif: 'image/gif', bmp: 'image/bmp', tif: 'image/tiff', tiff: 'image/tiff',
      svg: 'image/svg+xml', webp: 'image/webp',
      emf: 'image/x-emf', wmf: 'image/x-wmf',
    };
    return map[ext] || 'application/octet-stream';
  }

  function makeVectorPlaceholder(ext) {
    const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="500" viewBox="0 0 800 500">
      <rect width="800" height="500" fill="#eef0f4" stroke="#c8ccd4" stroke-width="2" stroke-dasharray="8 6"/>
      <g transform="translate(400 230)" text-anchor="middle" font-family="sans-serif" fill="#6b7280">
        <text font-size="56" font-weight="700">${ext.toUpperCase()}</text>
        <text y="60" font-size="22">矢量图 · 浏览器无法预览</text>
        <text y="92" font-size="16" fill="#9ca3af">导出时保留原始字节</text>
      </g>
    </svg>`;
    return 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svg)));
  }

  function measureImage(dataUrl) {
    return new Promise((resolve) => {
      const img = new Image();
      img.onload = () => resolve({ naturalWidth: img.naturalWidth, naturalHeight: img.naturalHeight });
      img.onerror = () => resolve({ naturalWidth: 800, naturalHeight: 600 });
      img.src = dataUrl;
    });
  }

  function isLikelyCaption(text) {
    if (!text) return false;
    const t = text.trim();
    // 常见图注模式："图 3-1"、"图3-1"、"Figure 3-1"、"图 3.1"
    return /^(图|Figure|Fig\.?)\s*[\d一二三四五六七八九十]+[\-．\.][\d一二三四五六七八九十]+/.test(t)
      || /^(图|Figure)\s*\d+\s/.test(t);
  }

  // ===== 图片分组识别 =====
  function detectGroups(cfg) {
    const imgs = state.images;
    const n = imgs.length;
    if (n === 0) { state.groups = []; return; }

    // 并查集
    const parent = Array.from({ length: n }, (_, i) => i);
    const find = (x) => parent[x] === x ? x : (parent[x] = find(parent[x]));
    const union = (a, b) => { const ra = find(a), rb = find(b); if (ra !== rb) parent[ra] = rb; };

    // 策略 1：编号规律（同一章节连续编号）
    if (cfg.detectNumber) {
      const numbered = imgs.map((img, i) => {
        const m = img.caption.match(/(?:图|Figure|Fig\.?)\s*(\d+|[一二三四五六七八九十]+)[\-．\.](\d+|[一二三四五六七八九十]+)/);
        return m ? { i, chapter: m[1], sub: m[2] } : null;
      }).filter(Boolean);
      // 同 chapter 的归一组
      const byChapter = {};
      numbered.forEach(x => {
        (byChapter[x.chapter] = byChapter[x.chapter] || []).push(x.i);
      });
      Object.values(byChapter).forEach(arr => {
        if (arr.length >= 2) {
          for (let i = 1; i < arr.length; i++) union(arr[0], arr[i]);
        }
      });
    }

    // 策略 2：关键词
    if (cfg.detectKeyword) {
      const keywords = ['云图', '温度', '速度场', '应力', '应变', '位移', '压力', '流线', '矢量', '等值线'];
      const captionWords = imgs.map(img => {
        return keywords.filter(k => img.caption.includes(k));
      });
      for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
          if (captionWords[i].some(w => captionWords[j].includes(w))) {
            union(i, j);
          }
        }
      }
    }

    // 策略 3：图注语义相似度（Jaccard token 相似度）
    if (cfg.detectSimilarity) {
      const tokens = imgs.map(img => tokenize(img.caption));
      for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
          const sim = jaccard(tokens[i], tokens[j]);
          if (sim >= cfg.simThreshold) union(i, j);
        }
      }
    }

    // 策略 4：宽高比相近（仅在已经有别的依据连接时辅助；这里作为额外候选）
    if (cfg.detectRatio) {
      const ratios = imgs.map(img => img.naturalW / img.naturalH);
      for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) {
          const ri = ratios[i], rj = ratios[j];
          if (Math.abs(ri - rj) / Math.max(ri, rj) <= 0.05) {
            // 仅当两张图相邻或图注存在相同章节号时才用比例归并，避免误并
            if (Math.abs(i - j) <= 3) union(i, j);
          }
        }
      }
    }

    // 收集分组
    const groupsMap = {};
    for (let i = 0; i < n; i++) {
      const r = find(i);
      (groupsMap[r] = groupsMap[r] || []).push(i);
    }
    const groups = [];
    Object.values(groupsMap).forEach(memberIdxs => {
      if (memberIdxs.length >= 2) {
        groups.push({
          id: groups.length,
          memberIdxs,
          label: deriveGroupLabel(memberIdxs.map(i => imgs[i].caption)),
          color: pickColor(groups.length),
        });
      }
    });
    // 标记单图片为独立组（id = -1 表示不参与等尺寸约束）
    state.groups = groups;
    groups.forEach(g => g.memberIdxs.forEach(i => imgs[i].groupId = g.id));
    imgs.forEach(img => { if (img.groupId === undefined) img.groupId = -1; });

    log(`识别到 ${groups.length} 个图片分组（共 ${groups.reduce((a, g) => a + g.memberIdxs.length, 0)} 张图片在组内）。`);
  }

  function tokenize(s) {
    // 中文按字符切分 + 英文按词切分，去除编号和常见停用词
    const cleaned = s.replace(/(?:图|Figure|Fig\.?)\s*[\d一二三四五六七八九十]+[\-．\.][\d一二三四五六七八九十]+/g, '');
    const tokens = new Set();
    const chinese = cleaned.match(/[一-龥]/g) || [];
    chinese.forEach(c => tokens.add(c));
    const english = cleaned.match(/[a-zA-Z]+/g) || [];
    english.forEach(w => tokens.add(w.toLowerCase()));
    // 移除常见无意义字符
    ['示', '意', '图', '的', '与', '及', '为', '是', '在'].forEach(c => tokens.delete(c));
    return tokens;
  }

  function jaccard(a, b) {
    if (a.size === 0 || b.size === 0) return 0;
    let inter = 0;
    a.forEach(x => { if (b.has(x)) inter++; });
    return inter / (a.size + b.size - inter);
  }

  function deriveGroupLabel(captions) {
    if (captions.length === 0) return '未命名组';
    // 寻找公共前缀
    const minLen = Math.min(...captions.map(c => c.length));
    let prefix = '';
    for (let i = 0; i < minLen; i++) {
      const c = captions[0][i];
      if (captions.every(cap => cap[i] === c)) prefix += c;
      else break;
    }
    prefix = prefix.replace(/^(图|Figure|Fig\.?)\s*[\d一二三四五六七八九十]*[\-．\.]?[\d一二三四五六七八九十]*\s*/, '').trim();
    return prefix || (captions[0].slice(0, 12) + '…');
  }

  function pickColor(i) {
    const palette = ['#2563eb', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899', '#14b8a6', '#f97316'];
    return palette[i % palette.length];
  }

  // ===== 排版算法 =====
  // 单位：所有计算以 pt 为单位
  function layoutDocument(cfg) {
    detectGroups(cfg);
    const blocks = state.blocks;
    if (blocks.length === 0) { state.pages = []; return; }

    // 1) 先为每张图片确定"初始显示宽度"
    //    - 默认：使用版心宽度的较优值（按高宽比限制不超过页高的 80%）
    //    - 同组图片以组内最严格约束（最小可用宽）为基准
    const images = state.images;
    const lineHpt = cfg.lineHeightPt;
    const captionHpt = cfg.fontSize * 1.4; // 图注按 1.4 行高估算（单行）
    const captionAfterPt = cfg.captionAfter;
    const maxWidthPt = cfg.contentWpt * (cfg.maxWidthPct / 100);
    const minWidthPt = cfg.contentWpt * (cfg.minWidthPct / 100);
    const maxImgHpt = cfg.contentHpt * 0.78; // 单张图加图注尽量不超过 78% 页高，便于留有正文位置

    function widthForImage(img, targetW) {
      // 等比缩放：返回 {w, h, captionH}
      const w = clamp(targetW, minWidthPt, maxWidthPt);
      const h = w * img.naturalH / img.naturalW;
      const totalH = h + (img.caption ? captionHpt + 2 : 0);
      return { w, h, totalH };
    }

    // 初始化每张图初始宽度（按各自原始尺寸，但限制在 [min, 版心]）
    images.forEach(img => {
      const orig = pxToPtForImage(img.naturalW); // 假设原始像素按 96dpi → pt
      let w = clamp(orig, minWidthPt, maxWidthPt);
      // 高度限制
      let h = w * img.naturalH / img.naturalW;
      if (h > maxImgHpt) {
        h = maxImgHpt;
        w = h * img.naturalW / img.naturalH;
        w = Math.max(w, minWidthPt);
      }
      img.displayW = w;
      img.displayH = w * img.naturalH / img.naturalW;
    });

    // 2) 同组等尺寸：取组内"最小可用宽"作为统一宽度
    if (cfg.equalGroup) {
      state.groups.forEach(g => {
        const minW = Math.min(...g.memberIdxs.map(i => images[i].displayW));
        g.memberIdxs.forEach(i => {
          images[i].displayW = minW;
          images[i].displayH = minW * images[i].naturalH / images[i].naturalW;
        });
      });
    }

    // 3) 分页：模拟自上而下流式排版
    const pages = [];
    let cur = newPage();
    function newPage() { return { blocks: [], usedH: 0 }; }
    function pushPage() { pages.push(cur); cur = newPage(); }

    // 文本段落估算高度（按字数 / 行宽）
    function textHeight(text) {
      // 单行能容纳的中文字符数 ≈ 版心宽度(pt) / 字号(pt)（中文为方块字）
      const charsPerLine = Math.floor(cfg.contentWpt / cfg.fontSize) - 2; // 减去缩进
      const lines = Math.max(1, Math.ceil(text.length / Math.max(1, charsPerLine)));
      return lines * lineHpt + 2; // 段后 2pt
    }

    function imageHeight(img) {
      const cap = img.caption ? captionHpt + 2 : 0;
      return img.displayH + cap + captionAfterPt;
    }

    function tailWhitespace(page) {
      return cfg.contentHpt - page.usedH;
    }

    // 主循环
    for (let bi = 0; bi < blocks.length; bi++) {
      const b = blocks[bi];
      if (b.type === 'text') {
        const h = textHeight(b.content);
        if (cur.usedH + h > cfg.contentHpt) {
          pushPage();
        }
        cur.blocks.push({ ...b, layoutH: h });
        cur.usedH += h;
      } else {
        // 图片
        const img = b;
        const h = imageHeight(img);
        if (cur.usedH + h > cfg.contentHpt) {
          // 当前页放不下：尝试在不破坏组等尺寸的前提下缩小
          if (img.groupId === -1) {
            // 单图：尝试缩小到可放下且不小于 minWidth
            const remain = cfg.contentHpt - cur.usedH - (img.caption ? captionHpt + 2 : 0) - captionAfterPt;
            if (remain > minWidthPt * (img.naturalH / img.naturalW)) {
              // 仍然装得下时（极少见），不动它
              // 此处省略，因为前面已判断超出
            }
          }
          // 推到下一页
          pushPage();
        }
        cur.blocks.push({ ...img, layoutH: imageHeight(img) });
        cur.usedH += imageHeight(img);

        // 判断这是否为"本页末尾图片"（之后无内容或仅有图注/正文且足以填满）
        // 简化：每张图入页后，向前看若下一个块加入会触发跨页，则当前图视为页末图。
        // 但若整个文档已无后续内容（!next），则当前是末页，留白多少都正常，不触发放大。
        const next = blocks[bi + 1];
        const isLastOnPage = next && (cur.usedH + (next.type === 'text' ? textHeight(next.content) : imageHeight(next)) > cfg.contentHpt);
        if (isLastOnPage) {
          // 校验页尾留白
          const tail = tailWhitespace(cur);
          const tailLimitPt = cfg.tailLines * lineHpt;
          if (tail > tailLimitPt) {
            // 尝试放大本图（含同组联动）
            tryEnlargeImageForTail(img, cur, cfg, blocks, bi);
            // 重新计算高度
            recomputePageHeights(cur, cfg);
          }
        }
      }
    }
    if (cur.blocks.length > 0) pages.push(cur);

    state.pages = pages;
    log(`排版完成：共 ${pages.length} 页。`, 'ok');
  }

  function pxToPtForImage(px) {
    // 假设源图以 96dpi 渲染：px / 96 * 72 = pt
    return px * 72 / 96;
  }

  function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }

  // 尝试通过放大本页末尾图片填补页尾留白
  function tryEnlargeImageForTail(img, page, cfg, blocks, bi) {
    const captionHpt = cfg.fontSize * 1.4;
    const captionAfterPt = cfg.captionAfter;
    const maxWidthPt = cfg.contentWpt * (cfg.maxWidthPct / 100);
    const tailLimitPt = cfg.tailLines * cfg.lineHeightPt;

    // 当前 tail
    let tail = cfg.contentHpt - page.usedH;
    if (tail <= tailLimitPt) return;

    // 计算把该图放大多少（含同组联动）
    const targetExtraH = tail - tailLimitPt; // 至少要再"长高" targetExtraH

    if (cfg.equalGroup && img.groupId !== -1) {
      // 同组联动放大：所有同组图同步增加同样比例
      const group = state.groups[img.groupId];
      // 同组的所有图都参与；放大当前图导致的额外页高仅来自本页内的同组图（本页可能只有当前图）
      const groupImagesOnPage = page.blocks.filter(b => b.type === 'image' && b.groupId === img.groupId);
      const totalCurrentH = groupImagesOnPage.reduce((sum, gi) => {
        const real = state.images[gi.idx];
        return sum + real.displayH;
      }, 0);
      // 等比放大因子 k：需要 k*totalCurrentH - totalCurrentH ≥ targetExtraH
      let k = 1 + targetExtraH / Math.max(1, totalCurrentH);
      // 受最大宽限制
      group.memberIdxs.forEach(i => {
        const im = state.images[i];
        const maxK = maxWidthPt / im.displayW;
        if (maxK < k) k = maxK;
      });
      if (k > 1.001) {
        group.memberIdxs.forEach(i => {
          const im = state.images[i];
          im.displayW *= k;
          im.displayH = im.displayW * im.naturalH / im.naturalW;
        });
      }
    } else {
      // 独立放大
      const target = img;
      // 目标新高度 = 当前 displayH + targetExtraH
      let newH = target.displayH + targetExtraH;
      let newW = newH * target.naturalW / target.naturalH;
      if (newW > maxWidthPt) {
        newW = maxWidthPt;
        newH = newW * target.naturalH / target.naturalW;
      }
      if (newW > target.displayW) {
        target.displayW = newW;
        target.displayH = newH;
      }
    }
  }

  function recomputePageHeights(page, cfg) {
    const captionHpt = cfg.fontSize * 1.4;
    const captionAfterPt = cfg.captionAfter;
    page.usedH = 0;
    page.blocks.forEach(b => {
      if (b.type === 'image') {
        const img = state.images[b.idx];
        b.layoutH = img.displayH + (img.caption ? captionHpt + 2 : 0) + captionAfterPt;
      }
      page.usedH += b.layoutH;
    });
  }

  // ===== 渲染预览 =====
  function renderPreview(cfg) {
    previewContainer.innerHTML = '';
    if (state.pages.length === 0) {
      const empty = document.createElement('div');
      empty.className = 'empty-state';
      empty.innerHTML = '<p>暂无内容</p>';
      previewContainer.appendChild(empty);
      return;
    }

    const pageWpx = mmToPx(cfg.pageWmm);
    const pageHpx = mmToPx(cfg.pageHmm);
    const contentWpx = mmToPx(cfg.contentWmm);
    const contentHpx = ptToPx(cfg.contentHpt);
    const mTopPx = mmToPx(cfg.mTop);
    const mLeftPx = mmToPx(cfg.mLeft);
    const lineHpx = ptToPx(cfg.lineHeightPt);
    const tailLimitPx = cfg.tailLines * lineHpx;

    state.pages.forEach((page, pageIdx) => {
      const pageEl = document.createElement('div');
      pageEl.className = 'page';
      pageEl.style.width = pageWpx + 'px';
      pageEl.style.height = pageHpx + 'px';
      pageEl.style.transform = `scale(${state.zoom})`;
      pageEl.style.marginBottom = `${(state.zoom - 1) * pageHpx + 20}px`;

      const label = document.createElement('div');
      label.className = 'page-label';
      label.textContent = `第 ${pageIdx + 1} / ${state.pages.length} 页`;
      pageEl.appendChild(label);

      const content = document.createElement('div');
      content.className = 'page-content';
      content.style.position = 'absolute';
      content.style.top = mTopPx + 'px';
      content.style.left = mLeftPx + 'px';
      content.style.width = contentWpx + 'px';
      content.style.height = contentHpx + 'px';
      content.style.fontSize = cfg.fontSize + 'pt';
      content.style.lineHeight = cfg.lineSpacing;
      pageEl.appendChild(content);

      // 渲染块
      page.blocks.forEach(b => {
        if (b.type === 'text') {
          const p = document.createElement('p');
          p.className = 'text-block';
          p.textContent = b.content;
          content.appendChild(p);
        } else {
          const im = state.images[b.idx];
          const wrap = document.createElement('div');
          wrap.className = 'image-block';
          if (im.groupId !== -1) {
            wrap.classList.add('grouped');
            const marker = document.createElement('span');
            marker.className = 'group-marker';
            const grp = state.groups[im.groupId];
            marker.textContent = `组 ${im.groupId + 1}`;
            marker.style.background = grp.color;
            wrap.appendChild(marker);
          }
          const img = document.createElement('img');
          img.src = im.src;
          img.style.width = ptToPx(im.displayW) + 'px';
          img.style.height = ptToPx(im.displayH) + 'px';
          wrap.appendChild(img);
          if (im.caption) {
            const cap = document.createElement('div');
            cap.className = 'caption';
            cap.textContent = im.caption;
            cap.style.fontSize = (cfg.fontSize - 1) + 'pt';
            cap.style.textAlign = cfg.centerCaption ? 'center' : 'left';
            cap.style.marginBottom = cfg.captionAfter + 'pt';
            wrap.appendChild(cap);
          } else {
            wrap.style.marginBottom = cfg.captionAfter + 'pt';
          }
          content.appendChild(wrap);
        }
      });

      // 页尾留白指示：末页不参与超限校验（全文已结束，留白多少都正常）
      const isLastPage = pageIdx === state.pages.length - 1;
      const usedHpx = ptToPx(page.usedH);
      const tailPx = contentHpx - usedHpx;
      if (tailPx > 4 && !isLastPage) {
        const indicator = document.createElement('div');
        indicator.className = 'tail-whitespace-indicator';
        if (tailPx > tailLimitPx) indicator.classList.add('warn');
        indicator.style.top = (mTopPx + usedHpx) + 'px';
        indicator.style.height = tailPx + 'px';
        indicator.style.left = mLeftPx + 'px';
        indicator.style.width = contentWpx + 'px';
        const tailLines = (tailPx / lineHpx).toFixed(1);
        indicator.textContent = `页尾留白 ≈ ${tailLines} 行${tailPx > tailLimitPx ? ' (超限!)' : ''}`;
        pageEl.appendChild(indicator);
      }

      previewContainer.appendChild(pageEl);
    });

    pageStats.textContent = `${state.pages.length} 页 · ${state.images.length} 张图片 · ${state.groups.length} 组`;
  }

  // ===== 渲染右栏分组列表 =====
  function renderGroups() {
    groupsList.innerHTML = '';
    if (state.groups.length === 0) {
      groupsList.innerHTML = '<p class="muted small">没有识别到同组图片</p>';
      return;
    }
    state.groups.forEach(g => {
      const item = document.createElement('div');
      item.className = 'group-item';
      const header = document.createElement('div');
      header.className = 'group-header';
      header.innerHTML = `
        <span class="group-name">
          <span class="group-color" style="background:${g.color}"></span>
          组 ${g.id + 1}：${escapeHtml(g.label)}
        </span>
        <span class="group-meta">${g.memberIdxs.length} 张</span>
      `;
      item.appendChild(header);
      const thumbs = document.createElement('div');
      thumbs.className = 'group-thumbs';
      g.memberIdxs.forEach(i => {
        const t = document.createElement('div');
        t.className = 'group-thumb';
        const im = document.createElement('img');
        im.src = state.images[i].src;
        im.title = state.images[i].caption || `图 ${i + 1}`;
        t.appendChild(im);
        thumbs.appendChild(t);
      });
      item.appendChild(thumbs);
      groupsList.appendChild(item);
    });
  }

  // ===== 完整运行流程 =====
  async function runFullPipeline() {
    if (state.blocks.length === 0) return;
    const cfg = readConfig();
    log('开始排版计算…');
    try {
      layoutDocument(cfg);
      renderPreview(cfg);
      renderGroups();
      btnExport.disabled = false;
      btnRelayout.disabled = false;
    } catch (e) {
      log('排版异常：' + e.message, 'error');
      console.error(e);
    }
  }

  // ===== 导出 .docx =====
  // 生成一个新的 docx 文件，使用解析后的块序列 + 排版后的尺寸
  async function exportDocx() {
    log('生成排版后的 .docx 文件…');
    const cfg = readConfig();
    try {
      const blob = await buildDocx(cfg);
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      const baseName = state.sourceFileName.replace(/\.docx$/i, '') || 'document';
      a.download = `${baseName}_排版后.docx`;
      a.click();
      URL.revokeObjectURL(url);
      log('导出完成。', 'ok');
    } catch (e) {
      log('导出失败：' + e.message, 'error');
      console.error(e);
    }
  }

  // 最小 OOXML docx 构造器
  async function buildDocx(cfg) {
    const zip = new JSZip();

    // [Content_Types].xml
    const contentTypes = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Default Extension="png" ContentType="image/png"/>
  <Default Extension="jpg" ContentType="image/jpeg"/>
  <Default Extension="jpeg" ContentType="image/jpeg"/>
  <Default Extension="gif" ContentType="image/gif"/>
  <Default Extension="bmp" ContentType="image/bmp"/>
  <Default Extension="tif" ContentType="image/tiff"/>
  <Default Extension="tiff" ContentType="image/tiff"/>
  <Default Extension="svg" ContentType="image/svg+xml"/>
  <Default Extension="webp" ContentType="image/webp"/>
  <Default Extension="emf" ContentType="image/x-emf"/>
  <Default Extension="wmf" ContentType="image/x-wmf"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>`;
    zip.file('[Content_Types].xml', contentTypes);

    // _rels/.rels
    zip.folder('_rels').file('.rels',
      `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>`);

    // word/styles.xml （极简）
    zip.folder('word').file('styles.xml',
      `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:docDefaults>
    <w:rPrDefault><w:rPr><w:rFonts w:ascii="Times New Roman" w:eastAsia="宋体" w:hAnsi="Times New Roman"/><w:sz w:val="${Math.round(cfg.fontSize * 2)}"/></w:rPr></w:rPrDefault>
    <w:pPrDefault><w:pPr><w:spacing w:line="${Math.round(cfg.lineSpacing * 240)}" w:lineRule="auto"/></w:pPr></w:pPrDefault>
  </w:docDefaults>
</w:styles>`);

    // 收集媒体文件并构建关系
    const mediaFolder = zip.folder('word').folder('media');
    const relationships = [];
    let relIdCounter = 1;
    const imageRels = []; // {rid, target}

    for (let i = 0; i < state.images.length; i++) {
      const im = state.images[i];
      // 优先用原始字节 + 原始扩展名（保护 EMF/WMF/TIFF 等浏览器不能渲染但 Word 能用的格式）
      const ext = im.originalExt || ((im.contentType || 'image/png').split('/')[1] || 'png');
      const filename = `image${i + 1}.${ext}`;
      const base64 = im.originalBase64 || im.src.split(',')[1];
      mediaFolder.file(filename, base64, { base64: true });
      const rid = `rId${100 + i}`;
      imageRels.push({ rid, target: `media/${filename}` });
      im._rid = rid;
    }

    // word/_rels/document.xml.rels
    const relsXml = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
  ${imageRels.map(r => `<Relationship Id="${r.rid}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="${r.target}"/>`).join('\n')}
</Relationships>`;
    zip.folder('word').folder('_rels').file('document.xml.rels', relsXml);

    // 生成 document.xml
    const body = [];
    let drawingDocId = 1;
    state.blocks.forEach(b => {
      if (b.type === 'text') {
        body.push(makeTextParagraph(b.content));
      } else {
        const im = state.images[b.idx];
        const widthEMU = Math.round(im.displayW / 72 * EMU_PER_INCH);
        const heightEMU = Math.round(im.displayH / 72 * EMU_PER_INCH);
        body.push(makeImageParagraph(im._rid, widthEMU, heightEMU, drawingDocId++, `Picture ${b.idx + 1}`));
        if (im.caption) {
          body.push(makeCaptionParagraph(im.caption, cfg.centerCaption, cfg.captionAfter));
        }
      }
    });

    // 节属性（页面大小、边距）
    const pageW_twip = Math.round(cfg.pageWmm / 25.4 * 1440);
    const pageH_twip = Math.round(cfg.pageHmm / 25.4 * 1440);
    const mTop_twip = Math.round(cfg.mTop / 25.4 * 1440);
    const mBot_twip = Math.round(cfg.mBot / 25.4 * 1440);
    const mLeft_twip = Math.round(cfg.mLeft / 25.4 * 1440);
    const mRight_twip = Math.round(cfg.mRight / 25.4 * 1440);
    const sectPr = `<w:sectPr>
  <w:pgSz w:w="${pageW_twip}" w:h="${pageH_twip}"/>
  <w:pgMar w:top="${mTop_twip}" w:right="${mRight_twip}" w:bottom="${mBot_twip}" w:left="${mLeft_twip}" w:header="720" w:footer="720" w:gutter="0"/>
</w:sectPr>`;

    const documentXml = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">
  <w:body>
    ${body.join('\n')}
    ${sectPr}
  </w:body>
</w:document>`;
    zip.folder('word').file('document.xml', documentXml);

    return await zip.generateAsync({ type: 'blob', mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' });
  }

  function escapeXml(s) {
    return String(s).replace(/[&<>"']/g, c => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&apos;'
    }[c]));
  }

  function makeTextParagraph(text) {
    return `<w:p><w:pPr><w:ind w:firstLineChars="200"/></w:pPr><w:r><w:t xml:space="preserve">${escapeXml(text)}</w:t></w:r></w:p>`;
  }

  function makeCaptionParagraph(text, center, spaceAfterPt) {
    const align = center ? '<w:jc w:val="center"/>' : '';
    const spacing = `<w:spacing w:after="${Math.round(spaceAfterPt * 20)}"/>`;
    return `<w:p><w:pPr>${align}${spacing}</w:pPr><w:r><w:t xml:space="preserve">${escapeXml(text)}</w:t></w:r></w:p>`;
  }

  function makeImageParagraph(rid, cx, cy, docId, name) {
    return `<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:drawing>
      <wp:inline distT="0" distB="0" distL="0" distR="0">
        <wp:extent cx="${cx}" cy="${cy}"/>
        <wp:effectExtent l="0" t="0" r="0" b="0"/>
        <wp:docPr id="${docId}" name="${escapeXml(name)}"/>
        <wp:cNvGraphicFramePr><a:graphicFrameLocks xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" noChangeAspect="1"/></wp:cNvGraphicFramePr>
        <a:graphic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main">
          <a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture">
            <pic:pic xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">
              <pic:nvPicPr>
                <pic:cNvPr id="${docId}" name="${escapeXml(name)}"/>
                <pic:cNvPicPr/>
              </pic:nvPicPr>
              <pic:blipFill>
                <a:blip r:embed="${rid}"/>
                <a:stretch><a:fillRect/></a:stretch>
              </pic:blipFill>
              <pic:spPr>
                <a:xfrm><a:off x="0" y="0"/><a:ext cx="${cx}" cy="${cy}"/></a:xfrm>
                <a:prstGeom prst="rect"><a:avLst/></a:prstGeom>
              </pic:spPr>
            </pic:pic>
          </a:graphicData>
        </a:graphic>
      </wp:inline>
    </w:drawing></w:r></w:p>`;
  }

  // ===== 示例文档 =====
  function loadSampleDocument() {
    log('载入内置示例文档…');
    // 用 canvas 生成几张演示图片
    const blocks = [];
    blocks.push({ type: 'text', content: '本节将介绍数值仿真的结果分析。通过对不同工况下的流场与温度场进行后处理，可以直观地揭示物理量的空间分布特征及其演化规律。' });

    // 第一组：3 张速度云图
    for (let i = 1; i <= 3; i++) {
      blocks.push(makeFakeImage(`工况 ${'ABC'[i-1]} 速度云图`, `图 3-${i} 工况 ${'ABC'[i-1]} 速度场云图`, [800, 500], i));
    }
    blocks.push({ type: 'text', content: '从上述速度云图可以观察到，随着工况的变化，主流区的流动结构发生明显改变，回流区位置也随之迁移。' });

    // 第二组：2 张温度云图（宽高比不同）
    for (let i = 1; i <= 2; i++) {
      blocks.push(makeFakeImage(`温度分布 ${i}`, `图 3-${i+3} 温度分布${i === 1 ? '稳态' : '瞬态'}结果`, [900, 600], 10 + i));
    }
    blocks.push({ type: 'text', content: '温度分布显示，热边界层在迎风侧显著增厚，并在尾迹区出现典型的卡门涡街结构。该结果与实验观测高度吻合，验证了仿真模型的可靠性。该结论可进一步用于工程优化设计。' });

    // 独立图片
    blocks.push(makeFakeImage('实验装置示意图', '图 3-6 实验装置示意图', [700, 900], 20));
    blocks.push({ type: 'text', content: '实验装置由测试段、流量控制系统、数据采集系统三部分组成。各模块通过标准接口对接，便于在不同实验条件下灵活组合。' });

    // 第三组：4 张应力分布（演示跨页）
    for (let i = 1; i <= 4; i++) {
      blocks.push(makeFakeImage(`应力分布 ${i}`, `图 4-${i} 载荷工况${i}下的等效应力分布`, [800, 550], 30 + i));
    }
    blocks.push({ type: 'text', content: '应力分析表明，最大主应力出现在结构倒角处，与有限元理论分析结果一致。' });

    state.blocks = blocks;
    state.images = blocks.filter(b => b.type === 'image');
    state.sourceFileName = '示例文档.docx';
    log(`示例载入完成：${blocks.length} 个段落，${state.images.length} 张图片。`, 'ok');
  }

  function makeFakeImage(title, caption, [w, h], seed) {
    const canvas = document.createElement('canvas');
    canvas.width = w; canvas.height = h;
    const ctx = canvas.getContext('2d');
    // 用伪随机生成一张"科学云图"风格的图
    const grad = ctx.createLinearGradient(0, 0, w, h);
    const palette = [
      ['#001f3f', '#0074d9', '#7fdbff', '#ffdc00', '#ff4136'],
      ['#003366', '#00aaaa', '#aaffaa', '#ffaa00', '#cc0066'],
      ['#220033', '#5e3c99', '#5ab4ac', '#fdb863', '#e66101'],
    ][seed % 3];
    palette.forEach((c, i) => grad.addColorStop(i / (palette.length - 1), c));
    ctx.fillStyle = grad;
    ctx.fillRect(0, 0, w, h);
    // 加点等值线
    ctx.strokeStyle = 'rgba(255,255,255,0.3)';
    ctx.lineWidth = 1;
    for (let i = 0; i < 8; i++) {
      ctx.beginPath();
      const r = 50 + i * 40 + (seed * 7) % 30;
      ctx.ellipse(w / 2 + (seed * 11) % 100 - 50, h / 2, r * 1.2, r * 0.8, 0, 0, Math.PI * 2);
      ctx.stroke();
    }
    // 标题
    ctx.fillStyle = 'white';
    ctx.font = 'bold 28px sans-serif';
    ctx.fillText(title, 20, 40);
    // 假坐标轴
    ctx.strokeStyle = 'white'; ctx.lineWidth = 2;
    ctx.strokeRect(40, 60, w - 80, h - 100);

    return {
      type: 'image',
      idx: 0, // 重新计算
      src: canvas.toDataURL('image/png'),
      naturalW: w,
      naturalH: h,
      contentType: 'image/png',
      caption,
      displayW: 0,
      displayH: 0,
      groupId: -1,
    };
  }

  // ===== 事件绑定 =====
  function setupEvents() {
    // 文件上传
    dropZone.addEventListener('click', () => fileInput.click());
    dropZone.addEventListener('dragover', e => { e.preventDefault(); dropZone.classList.add('dragover'); });
    dropZone.addEventListener('dragleave', () => dropZone.classList.remove('dragover'));
    dropZone.addEventListener('drop', e => {
      e.preventDefault();
      dropZone.classList.remove('dragover');
      const f = e.dataTransfer.files[0];
      if (f) handleFile(f);
    });
    fileInput.addEventListener('change', e => {
      const f = e.target.files[0];
      if (f) handleFile(f);
    });

    btnRelayout.addEventListener('click', runFullPipeline);
    btnExport.addEventListener('click', exportDocx);
    btnSample.addEventListener('click', handleSample);
    btnLoadSample.addEventListener('click', handleSample);

    $('#zoom-in').addEventListener('click', () => setZoom(state.zoom + 0.1));
    $('#zoom-out').addEventListener('click', () => setZoom(state.zoom - 0.1));

    // 配置项变更时自动重算（带防抖）
    let timer;
    document.querySelectorAll('.card input, .card select').forEach(el => {
      el.addEventListener('change', () => {
        if (state.blocks.length === 0) return;
        clearTimeout(timer);
        timer = setTimeout(runFullPipeline, 300);
      });
    });
  }

  async function handleFile(file) {
    if (!file.name.toLowerCase().endsWith('.docx')) {
      log('请选择 .docx 文件', 'error');
      return;
    }
    fileInfo.classList.remove('hidden');
    fileInfo.textContent = `${file.name} (${(file.size / 1024).toFixed(1)} KB)`;
    try {
      await parseDocx(file);
      await runFullPipeline();
    } catch (e) {
      log('解析失败：' + e.message, 'error');
      // 把第一行 stack 也打到日志，方便排查
      const stackLine = (e.stack || '').split('\n').find(l => l.includes('app.js'));
      if (stackLine) log('  位置：' + stackLine.trim(), 'error');
      console.error(e);
    }
  }

  function handleSample() {
    loadSampleDocument();
    fileInfo.classList.remove('hidden');
    fileInfo.textContent = '示例文档（内置）';
    runFullPipeline();
  }

  function setZoom(z) {
    state.zoom = clamp(z, 0.3, 1.5);
    zoomLabel.textContent = Math.round(state.zoom * 100) + '%';
    const cfg = readConfig();
    renderPreview(cfg);
  }

  // ===== 启动 =====
  setupEvents();
  log('排版工具已就绪。点击"载入示例"或上传 .docx 开始。');
})();
