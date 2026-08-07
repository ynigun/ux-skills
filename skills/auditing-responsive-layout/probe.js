// Responsive-layout probe — measures layout bugs across viewport × persisted state.
// Run with the dev-browser CLI:  dev-browser --headless --timeout 120 run probe.js
// (Adapt to Playwright/Puppeteer if dev-browser is unavailable — the page.evaluate
//  body is the portable part.)
//
// EDIT CONFIG for your target, then read the ⚠ lines. Every ⚠ is a candidate bug;
// open the implicated element's CSS and confirm before reporting it (verify, don't
// pattern-match).

const CONFIG = {
  url: 'http://localhost:5173/your-page',
  widths: [360, 390, 768, 1280],
  // Persisted UI states that change layout. ALWAYS test the empty state AND each
  // toggle — most "can't reproduce" layout bugs only appear in a non-default state
  // (collapsed sidebar, theme, density). Add every localStorage key that gates CSS.
  states: [{}, { sidebarCollapsed: '1' }],
};

const page = await browser.getPage('probe');

const PROBE = () => {
  const vw = document.documentElement.clientWidth;
  const out = { overflow: null, overWide: [], floaty: [], insetScroll: [] };
  out.overflow = document.documentElement.scrollWidth > vw + 1 ? document.documentElement.scrollWidth : null;
  const seen = new Set();
  for (const e of document.querySelectorAll('body *')) {
    const cs = getComputedStyle(e);
    if (cs.display === 'none' || cs.visibility === 'hidden') continue;
    const b = e.getBoundingClientRect();
    const key = e.tagName + (e.className ? '.' + e.className.toString().trim().split(/\s+/)[0] : '');
    // 1) rendered wider than viewport, with no scroll container to absorb it
    if (b.width > vw + 1 && cs.overflowX !== 'auto' && cs.overflowX !== 'scroll'
        && !/tab|nav|carousel|scroll|marquee/i.test(key) && !seen.has('w' + key)) {
      seen.add('w' + key); out.overWide.push(`${key} = ${Math.round(b.width)}px`);
    }
    // 2) narrow floating box: margin:auto inside a flex parent → shrinks to content,
    //    leaves side gaps, and its scrollbar sits inset from the edge
    const p = e.parentElement;
    if (p) {
      const pp = getComputedStyle(p);
      if ((pp.display === 'flex' || pp.display === 'inline-flex')
          && (cs.marginInlineStart === 'auto' || cs.marginLeft === 'auto' || cs.marginRight === 'auto')
          && b.width < p.clientWidth - 24 && !seen.has('f' + key)) {
        seen.add('f' + key); out.floaty.push(`${key} ${Math.round(b.width)}px inside ${Math.round(p.clientWidth)}px parent`);
      }
    }
    // 3) inner scroll container narrower than the viewport → scrollbar floats mid-screen
    if ((cs.overflowY === 'auto' || cs.overflowY === 'scroll') && e.scrollHeight > e.clientHeight + 1
        && e.clientWidth < vw - 8 && !seen.has('s' + key)) {
      seen.add('s' + key); out.insetScroll.push(`${key} clientW ${e.clientWidth} < vw ${vw}`);
    }
  }
  return out;
};

for (const state of CONFIG.states) {
  for (const w of CONFIG.widths) {
    await page.setViewportSize({ width: w, height: 900 });
    await page.goto(CONFIG.url, { waitUntil: 'networkidle' });
    await page.evaluate((s) => { for (const k in s) localStorage.setItem(k, s[k]); }, state);
    await page.reload({ waitUntil: 'networkidle' });
    await page.waitForTimeout(500);
    await page.evaluate(() => document.querySelectorAll('details').forEach((d) => (d.open = true)));
    await page.evaluate(() => { window.scrollTo(0, 0); document.querySelectorAll('*').forEach((e) => { e.scrollLeft = 0; }); });
    await page.waitForTimeout(250);
    const r = await page.evaluate(PROBE);
    const bugs = [];
    if (r.overflow) bugs.push(`horizontal overflow: doc ${r.overflow} > vw ${w}`);
    r.overWide.forEach((x) => bugs.push(`over-wide, no scroll container: ${x}`));
    r.floaty.forEach((x) => bugs.push(`narrow floating box (margin:auto in flex): ${x}`));
    r.insetScroll.forEach((x) => bugs.push(`inset scroll container (scrollbar off the edge): ${x}`));
    console.log(`\n=== ${w}px  state=${JSON.stringify(state)} ===`);
    console.log(bugs.length ? bugs.map((b) => '  ⚠ ' + b).join('\n') : '  ok');
  }
}

// Resize WITHOUT reload — reproduces DevTools device-mode. Catches JS that sets a
// layout class on load (from innerWidth/localStorage) but never updates on resize.
await page.setViewportSize({ width: 1280, height: 900 });
await page.goto(CONFIG.url, { waitUntil: 'networkidle' });
await page.waitForTimeout(400);
await page.setViewportSize({ width: 375, height: 812 });
await page.waitForTimeout(400);
const resize = await page.evaluate(() => document.documentElement.scrollWidth > document.documentElement.clientWidth + 1);
console.log('\n=== resize 1280→375 (no reload) ===');
console.log(resize ? '  ⚠ overflow appears only after resize — JS layout state not reacting to width' : '  ok');
