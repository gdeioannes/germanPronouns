"""The wrap-around covers for the Kafka reader (back, spine, front): paperback,
hardcover (case laminate) and the Kindle front.

    python tool/kafka-cover.py docs/reference/kafka_die_verwandlung.pdf docs/reference
    python tool/kafka-cover.py docs/reference/kafka_die_verwandlung.pdf docs/reference --hardcover 12.962 9.917

Trim 5.5 x 8.5 in, 0.125 in bleed all round, spine from KDP's white-paper
factor (0.002252 in per page) and the interior's page count, so a new build
of the interior only needs this run again. Chrome will not print a sheet
wider than it is tall, so the page is photographed at 300 dpi and wrapped
into a one-page PDF of the exact sheet size with PyMuPDF.

The front shows a door left ajar, not the insect: in 1915 Kafka asked his
publisher that the insect itself never be drawn on the cover.
"""
import json
import os
import subprocess
import sys
import tempfile

import fitz  # PyMuPDF

interior, out = sys.argv[1], sys.argv[2]
pages = fitz.open(interior).page_count
pages += pages % 2  # KDP counts a blank last page on an odd count

TRIM_W, TRIM_H = 5.5, 8.5
# Hardcover: pass the sheet KDP asks for, e.g. --hardcover 12.962 9.917. The
# printed sheet wraps round the boards, so each outer edge carries a turn-in
# (BLEED here, about 0.709 in) and the spine is board-thick; both follow from
# KDP's numbers rather than a formula that could drift from theirs. Content
# also stays clear of the hinge, the strip beside the spine where it bends.
HARDCOVER = "--hardcover" in sys.argv
if HARDCOVER:
    i = sys.argv.index("--hardcover")
    W, H = float(sys.argv[i + 1]), float(sys.argv[i + 2])
    BLEED = (H - TRIM_H) / 2
    SPINE = round(W - 2 * TRIM_W - 2 * BLEED, 4)
    HINGE = 0.4
    NAME = "kafka_die_verwandlung_hardcover"
else:
    BLEED = 0.125
    SPINE = round(pages * 0.002252, 4)
    W = 2 * TRIM_W + SPINE + 2 * BLEED
    H = TRIM_H + 2 * BLEED
    HINGE = 0.0
    NAME = "kafka_die_verwandlung_cover"
# A spine of a third of an inch or more is wide enough for its title.
SPINE_TEXT = SPINE >= 0.3
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# The counts on the covers come from the edition itself, so they follow it.
STAGES = json.load(open(os.path.join(ROOT, "assets", "reference", "kafka_die_verwandlung_stages.json"), encoding="utf-8"))["stages"]
WORDS = sum(len(s["words"]) for s in STAGES)
NOTES = sum(len(s.get("notes", [])) for s in STAGES)
LOGO ="file:///" + os.path.join(ROOT, "static", "icons", "Icon-192.png").replace(os.sep, "/")

# The door: a frame, a dark opening, and the leaf swung a little inward so a
# wedge of darkness shows. Drawn in the cover's own units (viewBox 0 0 200 300).
DOOR = """
<svg viewBox="0 0 200 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="A door left ajar">
  <rect x="20" y="10" width="160" height="285" fill="none" stroke="#1a1a1a" stroke-width="5"/>
  <rect x="27" y="17" width="146" height="278" fill="#141414"/>
  <polygon points="27,17 150,30 150,284 27,295" fill="#efe8da" stroke="#1a1a1a" stroke-width="3"/>
  <rect x="48" y="52" width="80" height="88" fill="none" stroke="#1a1a1a" stroke-width="2.2"/>
  <rect x="48" y="168" width="80" height="96" fill="none" stroke="#1a1a1a" stroke-width="2.2"/>
  <circle cx="136" cy="160" r="4.2" fill="#1a1a1a"/>
  <rect x="134.2" y="168" width="3.6" height="7" fill="#1a1a1a"/>
  <line x1="0" y1="296" x2="200" y2="296" stroke="#1a1a1a" stroke-width="3"/>
</svg>
"""

html = f"""<!doctype html><html lang="de"><head><meta charset="utf-8">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,600;0,8..60,700;1,8..60,400&family=Inter:wght@500;600;800&display=block">
<style>
  html, body {{ margin: 0; }}
  .sheet {{
    width: {W}in; height: {H}in; display: grid;
    grid-template-columns: {BLEED + TRIM_W}in {SPINE}in {TRIM_W + BLEED}in;
    background: #efe8da; color: #141414; font-family: 'Source Serif 4', Georgia, serif;
  }}
  .panel {{ position: relative; box-sizing: border-box; }}
  /* Everything that matters stays 0.375 in inside the trim (KDP safe zone is 0.125 in). */
  .back {{ padding: {BLEED + 0.5}in {0.55 + HINGE}in {BLEED + 0.5}in {BLEED + 0.55}in; }}
  .front {{ padding: {BLEED + 0.55}in {BLEED + 0.5}in {BLEED + 0.5}in {0.5 + HINGE}in;
    display: flex; flex-direction: column; align-items: center; text-align: center; }}
  .author {{ font: 800 9.5pt Inter, sans-serif; letter-spacing: .32em; text-transform: uppercase; margin: 0; }}
  .rule {{ width: 0.6in; height: 1.5pt; background: #141414; margin: 0.16in auto 0.18in; }}
  h1 {{ font-weight: 700; font-size: 37pt; line-height: 1; margin: 0; letter-spacing: -.01em; }}
  .en-title {{ font-style: italic; font-size: 13.5pt; margin: 0.12in 0 0; color: #333; }}
  .door {{ width: 2.15in; margin: 0.42in auto 0; flex: 1; display: flex; align-items: flex-start; justify-content: center; }}
  .door svg {{ width: 100%; height: auto; }}
  .tag {{ margin: 0.3in 0 0; font: 600 8pt Inter, sans-serif; letter-spacing: .06em; color: #333; line-height: 1.6; }}
  .tag b {{ font-weight: 800; color: #141414; }}
  .back h2 {{ font-size: 15pt; line-height: 1.2; margin: 0 0 0.16in; }}
  .back p {{ font-size: 9.6pt; line-height: 1.5; margin: 0 0 0.12in; }}
  .back .quote {{ font-style: italic; font-size: 9.8pt; color: #333; border-left: 1.5pt solid #141414; padding-left: 0.12in; }}
  .back ul {{ margin: 0.06in 0 0.14in; padding-left: 0.16in; font: 500 8.4pt/1.5 Inter, sans-serif; }}
  .back li {{ margin-bottom: 0.04in; }}
  .back .wish {{ font-size: 8.6pt; color: #444; font-style: italic; }}
  .back .lvl {{ position: absolute; left: {BLEED + 0.55}in; bottom: {BLEED + 1.0}in;
    font: 800 8pt Inter, sans-serif; letter-spacing: .12em; text-transform: uppercase; }}
  /* KDP prints the barcode bottom right on the back: 2 x 1.2 in, kept empty. */
  .spine {{ display: flex; align-items: center; justify-content: center; overflow: hidden; }}
  .spine-text {{ writing-mode: vertical-rl; white-space: nowrap; font-size: 11pt; letter-spacing: .02em; }}
  .spine-text b {{ font-weight: 700; }}
  .pub {{ position: absolute; left: {BLEED + 0.55}in; bottom: {BLEED + 0.5}in; display: flex; align-items: center; gap: 0.1in; margin: 0; }}
  .pub img {{ width: 0.36in; height: 0.36in; border-radius: 0.08in; }}
  .pub span {{ font: 500 7.4pt/1.45 Inter, sans-serif; color: #333; }}
  .pub b {{ font-weight: 800; color: #141414; }}
  /* The publisher on the front, logo and name: on the Kindle cover it is the only place it shows. */
  .site {{ margin: 0.16in 0 0; display: flex; align-items: center; justify-content: center; gap: 0.09in; }}
  .site img {{ width: 0.3in; height: 0.3in; border-radius: 0.07in; }}
  .site span {{ font: 500 7.6pt/1.35 Inter, sans-serif; color: #333; text-align: left; }}
  .site b {{ display: block; font-weight: 800; font-size: 9pt; letter-spacing: .02em; color: #141414; }}
  .spine-logo {{ position: absolute; bottom: {BLEED + 0.3}in; left: 50%; width: 0.3in; height: 0.3in; margin-left: -0.15in; border-radius: 0.06in; }}
  .spine {{ position: relative; }}
  .spine-text span {{ font: 800 7.5pt Inter, sans-serif; letter-spacing: .28em; text-transform: uppercase; }}
</style></head><body>
<div class="sheet">
  <section class="panel back">
    <h2>Read Kafka's most famous story in the German he wrote it in.</h2>
    <p class="quote">Als Gregor Samsa eines Morgens aus unruhigen Träumen erwachte, fand er sich
    in seinem Bett zu einem ungeheueren Ungeziefer verwandelt.</p>
    <p>One morning a travelling salesman wakes up as a giant insect, and his first worry is the
    train he has missed. This edition gives English-speaking learners the complete original text,
    with the help to read it without a dictionary.</p>
    <ul>
      <li>Twelve reading stages of about 20 minutes each</li>
      <li>{WORDS} words explained in the margin, beside the line they are on</li>
      <li>{NOTES} notes on grammar, idioms and Prague German</li>
      <li>The unabridged 1917 text, with a guide to its spelling</li>
    </ul>
    <p class="wish">In 1915 Kafka asked his publisher that the insect never be drawn on the cover.
    This one keeps his wish.</p>
    <p class="lvl">German · B1–B2 · Annotated</p>
    <p class="pub"><img src="{LOGO}" alt="" /><span><b>Language Quiz</b> · languagequiz.org<br/>the free German course, A1 to C2</span></p>
  </section>
  <section class="panel spine">{'<p class="spine-text"><span>Franz Kafka</span>&#160;&#160;&#160;<b>Die Verwandlung</b></p><img class="spine-logo" src="' + LOGO + '" alt="" />' if SPINE_TEXT else ''}</section>
  <section class="panel front">
    <p class="author">Franz Kafka</p>
    <div class="rule"></div>
    <h1>Die Verwandlung</h1>
    <p class="en-title">The Metamorphosis in German</p>
    <div class="door">{DOOR}</div>
    <p class="tag"><b>Annotated for English speakers</b><br>{len(STAGES)} reading stages · {WORDS} words · {NOTES} notes</p>
    <p class="site"><img src="{LOGO}" alt="" /><span><b>Language Quiz</b>languagequiz.org</span></p>
  </section>
</div>
</body></html>"""

tmp = tempfile.mkdtemp()
html_path = os.path.join(tmp, "cover.html")
open(html_path, "w", encoding="utf-8").write(html)
png = os.path.join(out, f"{NAME}.png")
js = r"""
const puppeteer = require('C:/Projects/german_pronouns_articles/node_modules/puppeteer-core');
const [htmlPath, pngPath, wIn, hIn] = process.argv.slice(2);
(async () => {
  const b = await puppeteer.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const p = await b.newPage();
  await p.setViewport({ width: Math.ceil(wIn * 96), height: Math.ceil(hIn * 96), deviceScaleFactor: 300 / 96 });
  await p.goto('file:///' + htmlPath.split('\\').join('/'), { waitUntil: 'networkidle0', timeout: 120000 });
  await p.evaluate(() => document.fonts.ready);
  const el = await p.$('.sheet');
  await el.screenshot({ path: pngPath });
  await b.close();
})();
"""
js_path = os.path.join(tmp, "shot.cjs")
open(js_path, "w").write(js)
subprocess.run(["node", js_path, html_path, png, str(W), str(H)], check=True)

doc = fitz.open()
page = doc.new_page(width=W * 72, height=H * 72)
page.insert_image(page.rect, filename=png)
pdf = os.path.join(out, f"{NAME}.pdf")
doc.save(pdf, deflate=True, garbage=3)  # compressed: stored raw, the 300 dpi picture is ~30 MB
print(f"{'hardcover' if HARDCOVER else 'paperback'}: {pages} pages, spine {SPINE} in, sheet {W:.3f} x {H:.3f} in")
print(pdf)
if HARDCOVER:
    sys.exit(0)  # the Kindle cover comes from the paperback run

# The Kindle cover: the front alone, 1600 x 2560 px (KDP's 1:1.6), as JPEG.
# Same page, with the back and spine hidden and the bleed padding dropped.
EBOOK_W, EBOOK_H = 5.5, 8.8
ebook_css = f""".sheet {{ width: {EBOOK_W}in; height: {EBOOK_H}in; grid-template-columns: {EBOOK_W}in; }}
  .back, .spine {{ display: none; }}
  .front {{ padding: 0.75in 0.5in 0.6in; }}
  .door {{ width: 2.35in; }}
</style>"""
ebook_html = os.path.join(tmp, "ebook.html")
open(ebook_html, "w", encoding="utf-8").write(html.replace("</style>", ebook_css, 1))
jpg = os.path.join(out, "kafka_die_verwandlung_ebook_cover.jpg")
js_ebook = r"""
const puppeteer = require('C:/Projects/german_pronouns_articles/node_modules/puppeteer-core');
const [htmlPath, jpgPath, wIn, hIn, pxW] = process.argv.slice(2);
(async () => {
  const b = await puppeteer.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const p = await b.newPage();
  await p.setViewport({ width: Math.ceil(wIn * 96), height: Math.ceil(hIn * 96), deviceScaleFactor: pxW / (wIn * 96) });
  await p.goto('file:///' + htmlPath.split('\\').join('/'), { waitUntil: 'networkidle0', timeout: 120000 });
  await p.evaluate(() => document.fonts.ready);
  const el = await p.$('.sheet');
  await el.screenshot({ path: jpgPath, type: 'jpeg', quality: 92 });
  await b.close();
})();
"""
js_ebook_path = os.path.join(tmp, "ebook.cjs")
open(js_ebook_path, "w").write(js_ebook)
subprocess.run(["node", js_ebook_path, ebook_html, jpg, str(EBOOK_W), str(EBOOK_H), "1600"], check=True)
print(jpg)
