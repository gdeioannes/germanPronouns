"""Set Kafka's Die Verwandlung (Project Gutenberg #22367) as a reader's PDF
in twelve stages, each opened by a glossary. Trim 5.5 x 8.5 in (KDP standard,
the nearest to A5), black and white.

    python tool/kafka-pdf.py assets/reference/kafka_die_verwandlung.txt docs/reference

The text is the 1917 Kurt Wolff edition as Gutenberg transcribed it, old
spelling kept ("daß"). The stages and their glossaries live next to it in
kafka_die_verwandlung_stages.json: four stages per chapter, split at
paragraph breaks, each with a title, a one-line summary and the words a B1
reader is unlikely to know, in order of appearance. An entry may carry
"form", the word as the text has it, for separable and irregular verbs.

Each stage may also carry "notes": a short note on the German, tied to an
exact phrase ("at"). The phrase is underlined faintly and the note is set
as a footnote by Paged.js (loaded from unpkg), so it lands at the foot of
the page the phrase is on.

Prints a warning for any glossary word whose stem does not occur in its
stage, and for any note whose phrase is not in its stage, so neither can
drift from the text.
"""
import html
import json
import os
import re
import subprocess
import sys
import tempfile

import pyphen  # pip install pyphen: German hyphenation, so the text can be justified

HYPH = pyphen.Pyphen(lang="de_DE", left=3, right=3)


def hyphenate(text: str) -> str:
    """Escape for HTML and put soft hyphens into words of eight letters or
    more; headless Chrome has no German hyphenation of its own."""
    out = []
    for token in re.split(r"(\w+)", text):
        if len(token) >= 8 and token.isalpha():
            out.append(HYPH.inserted(token, hyphen="­"))
        else:
            out.append(html.escape(token))
    return "".join(out)

src, out = sys.argv[1], sys.argv[2]
spec = json.load(open(src.replace(".txt", "_stages.json"), encoding="utf-8"))
# The rights page and the closing page, shared with the Kindle edition.
edition = json.load(open(src.replace(".txt", "_edition.json"), encoding="utf-8"))
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOGO = "file:///" + os.path.join(ROOT, "static", "icons", "Icon-192.png").replace("\\", "/")

text = open(src, encoding="utf-8").read()
body = text.split("*** START OF THE PROJECT GUTENBERG EBOOK DIE VERWANDLUNG ***")[1]
body = body.split("*** END OF THE PROJECT GUTENBERG EBOOK DIE VERWANDLUNG ***")[0]
body = body[body.index("\nI.\n") :]
split = re.split(r"\n(I{1,3})\.\n", body)
chapters = {
    split[i]: [" ".join(p.split()) for p in re.split(r"\n\s*\n", split[i + 1]) if p.strip()]
    for i in range(1, len(split), 2)
}

# Every paragraph must belong to exactly one stage, in order.
for num, paras in chapters.items():
    ranges = sorted((s["from"], s["to"]) for s in spec["stages"] if s["chapter"] == num)
    covered = [i for a, z in ranges for i in range(a, z)]
    if covered != list(range(len(paras))):
        sys.exit(f"chapter {num}: stages cover paragraphs {ranges}, the chapter has {len(paras)}")

esc = html.escape
ARTICLES = ("der ", "die ", "das ", "sich ")


def stem(headword: str) -> str:
    """The part of a glossary headword to look for in the text."""
    w = re.sub(r"\(.*?\)", "", headword).strip()
    for a in ARTICLES:
        if w.startswith(a):
            w = w[len(a) :]
    w = w.split()[0] if w else w
    return w.lower().rstrip("!»«")[: max(4, min(6, len(w) - 2))]


def word_html(w: dict) -> str:
    de = esc(w["de"])
    pl = w.get("pl")
    if pl == "pl.":
        de += ' <span class="pl">(plural)</span>'
    elif pl and pl != "—":
        de += f' <span class="pl">· {esc(pl)}</span>'
    return f'<li><span class="de">{de}</span><span class="en">{esc(w["en"])}</span></li>'


warnings = []
pages = []
total = len(spec["stages"])
seen_chapters = set()
for n, s in enumerate(spec["stages"], 1):
    paras = chapters[s["chapter"]][s["from"] : s["to"]]
    joined = " ".join(paras).lower()
    found = []
    for w in s["words"]:
        # "form" is the word as the text has it, for separable and irregular verbs.
        probe = w.get("form", "").lower() or stem(w["de"])
        at = joined.find(probe)
        if at < 0:
            warnings.append(f'stage {n}: "{w["de"]}" (looked for "{probe}")')
        found.append((at if at >= 0 else len(joined), w))
    # The glossary reads in the order the words come up in the text.
    ordered = [w for _, w in sorted(found, key=lambda pair: pair[0])]
    opener = ""
    if s["chapter"] not in seen_chapters:
        seen_chapters.add(s["chapter"])
        opener = f'<p class="chapter-no">Kapitel {s["chapter"]}</p>'
    words = "\n".join(word_html(w) for w in ordered)
    # Language notes: each is tied to an exact phrase of the stage. The phrase
    # gets a faint dotted underline and a footnote call; the note itself is a
    # Paged.js footnote, so it lands at the foot of the page the phrase is on.
    marks = {i: [] for i in range(len(paras))}
    for note in s.get("notes", []):
        hit = next(((i, p.find(note["at"])) for i, p in enumerate(paras) if note["at"] in p), None)
        if hit is None:
            warnings.append(f'stage {n}: note phrase not found: "{note["at"]}"')
            continue
        i, at = hit
        marks[i].append((at, at + len(note["at"]), note["note"]))

    def para_html(i: int, p: str) -> str:
        out, pos = [], 0
        for a, z, note in sorted(marks[i]):
            if a < pos:
                warnings.append(f'stage {n}: overlapping note phrases in paragraph {i}')
                continue
            out.append(hyphenate(p[pos:a]))
            # The note is authored HTML (<b>, <i>); the phrase is escaped text.
            out.append(f'<span class="mark">{hyphenate(p[a:z])}</span><span class="fn">{note}</span>')
            pos = z
        out.append(hyphenate(p[pos:]))
        # Gutenberg's plain text writes the dash as "--"; print it as a real one.
        return "<p>" + "".join(out).replace("--", "–") + "</p>"

    text_html = "\n".join(para_html(i, p) for i, p in enumerate(paras))
    pages.append(
        f"""<section class="stage">
  {opener}
  <p class="kicker">Stufe {n} von {total} · Kapitel {s["chapter"]} · {sum(len(p.split()) for p in paras)} Wörter</p>
  <h2>{esc(s["title"])}</h2>
  <p class="summary">{esc(s["en"])}</p>
  <div class="gloss"><p class="gloss-head">Words for this stage</p><ul>{words}</ul></div>
</section>
<section class="text">{text_html}</section>"""
    )

spelling = "".join(f"<tr><td>{esc(a)}</td><td>{esc(b)}</td></tr>" for a, b in spec["spelling"])

doc = f"""<!doctype html><html lang="de"><head><meta charset="utf-8">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,700;1,8..60,400&family=Inter:wght@500;600;700;800&display=block">
<script>
  // Paged.js makes each footnote call a link to its note. A link becomes a PDF
  // annotation, which KDP strips as non-printable markup; on paper it is
  // meaningless anyway. So the links go once the layout is done.
  window.PagedConfig = {{ auto: true, after: () => {{
    document.querySelectorAll('a[href]').forEach((a) => a.removeAttribute('href'));
    window.pagedDone = true;
  }} }};
</script>
<script src="https://unpkg.com/pagedjs@0.4.3/dist/paged.polyfill.js"></script>
<style>
@page {{ size: 5.5in 8.5in; margin: 18mm 15mm 20mm;
  counter-reset: footnote;
  @bottom-center {{ content: counter(page); font: 600 8pt Inter, sans-serif; color: #555555; }}
  @footnote {{ border-top: .2mm solid #999999; padding-top: 1.5mm; margin-top: 3mm; }} }}
@page front {{ @bottom-center {{ content: none; }} }}
body {{ font-family: 'Source Serif 4', Georgia, serif; font-size: 10.5pt; line-height: 1.5; color: #000000; margin: 0; }}
.title {{ page: front; height: 168mm; display: flex; flex-direction: column; justify-content: center; text-align: center; }}
.title .author {{ font: 800 9pt Inter, sans-serif; letter-spacing: .16em; text-transform: uppercase; color: #555555; margin: 0 0 6mm; }}
.title h1 {{ font-size: 30pt; color: #000000; margin: 0 0 4mm; font-weight: 700; }}
.title .sub {{ font-style: italic; color: #000000; margin: 0 0 2mm; }}
.title .ed {{ font: 600 8pt Inter, sans-serif; color: #555555; margin: 0; }}
.title .pub {{ margin: 22mm 0 0; font: 700 7.6pt Inter, sans-serif; letter-spacing: .04em; color: #333333;
  display: flex; align-items: center; justify-content: center; gap: 2mm; }}
/* The logo is in colour; the interior is black and white. */
.title .pub img, .about-logo {{ filter: grayscale(1); }}
.title .pub img {{ width: 5mm; height: 5mm; border-radius: 1.1mm; }}
.rights {{ page: front; break-before: page; font: 500 7.4pt/1.5 Inter, sans-serif; color: #333333;
  display: flex; flex-direction: column; justify-content: flex-end; height: 170mm; }}
.rights p {{ margin: 0 0 2.2mm; }}
.rights b {{ color: #000000; }}
.rights .colophon {{ margin-top: 2mm; font-size: 6.8pt; color: #555555; }}
.about {{ break-before: page; font: 500 8.6pt/1.55 Inter, sans-serif; color: #333333; padding-top: 18mm; }}
.about-logo {{ width: 12mm; height: 12mm; border-radius: 2.6mm; }}
.about h3 {{ font: 700 15pt 'Source Serif 4', serif; color: #000000; margin: 4mm 0 3mm; }}
.about ul {{ padding-left: 4.5mm; margin: 3mm 0 6mm; }}
.about li {{ margin-bottom: 1.6mm; }}
.about b {{ color: #000000; }}
.about-url {{ font: 800 12pt Inter, sans-serif; letter-spacing: .04em; color: #000000; }}
.front {{ page: front; break-before: page; font: 500 8.4pt/1.5 Inter, sans-serif; color: #333333; }}
.front h3 {{ font: 700 13pt 'Source Serif 4', serif; color: #000000; margin: 0 0 3mm; }}
.front p {{ margin: 0 0 2.5mm; }}
.front table {{ border-collapse: collapse; margin: 1mm 0 3mm; }}
.front td {{ padding: .6mm 4mm .6mm 0; border-bottom: .2mm solid #bbbbbb; font-family: 'Source Serif 4', serif; font-size: 9.5pt; }}
.front .credit {{ margin-top: 6mm; font-size: 7.6pt; color: #555555; }}
.stage {{ break-before: page; }}
.chapter-no {{ font: 700 22pt 'Source Serif 4', serif; color: #000000; text-align: center; margin: 2mm 0 6mm; }}
.kicker {{ font: 800 7pt Inter, sans-serif; letter-spacing: .1em; text-transform: uppercase; color: #333333; margin: 0 0 1mm; }}
h2 {{ font-size: 16pt; color: #000000; margin: 0 0 1.5mm; font-weight: 700; }}
.summary {{ font-style: italic; color: #555555; margin: 0 0 4mm; font-size: 9.5pt; line-height: 1.4; }}
.gloss {{ border-top: .4mm solid #000000; border-bottom: .2mm solid #999999; padding: 2mm 0 1.5mm; margin: 0 0 5mm; }}
.gloss-head {{ font: 800 6.4pt Inter, sans-serif; letter-spacing: .1em; text-transform: uppercase; color: #555555; margin: 0 0 1.5mm; }}
.gloss ul {{ list-style: none; margin: 0; padding: 0; columns: 3; column-gap: 3.5mm; }}
.gloss li {{ break-inside: avoid; margin: 0 0 1mm; line-height: 1.15; }}
.gloss .de {{ display: block; font-weight: 700; font-size: 7.6pt; color: #000000; }}
.gloss .pl {{ font-weight: 400; color: #555555; font-size: 7pt; }}
.gloss .en {{ display: block; font: 500 6.4pt Inter, sans-serif; color: #555555; }}
.text p {{ margin: 0; text-indent: 1.2em; orphans: 2; widows: 2; text-align: justify; }}
.text p:first-child {{ text-indent: 0; }}
/* The language notes: a faint dotted underline on the phrase, a small
   number after it, and the note at the foot of the page. */
.mark {{ text-decoration: underline dotted #8c8c8c; text-decoration-thickness: .35pt; text-underline-offset: 2.2pt; }}
.fn {{ float: footnote; font: 500 6.9pt/1.35 Inter, sans-serif; color: #333333; text-align: left; text-indent: 0; hyphens: manual; }}
.fn b {{ font-weight: 700; color: #000000; }}
.fn::footnote-call {{ content: counter(footnote); font: 700 5.6pt Inter, sans-serif; color: #000000; vertical-align: super; line-height: 0; margin-left: .3pt; }}
.fn::footnote-marker {{ content: counter(footnote-marker) "\\00a0\\00a0"; font: 700 6.4pt Inter, sans-serif; color: #000000; }}
</style></head><body>
<section class="title">
  <p class="author">Franz Kafka</p>
  <h1>Die Verwandlung</h1>
  <p class="sub">Erzählung · 1915</p>
  <p class="ed">In zwölf Stufen, mit Wörtern zum Lesen</p>
  <p class="pub"><img src="{LOGO}" alt="" /> Language Quiz · languagequiz.org</p>
</section>
<section class="rights">
  {''.join(f"<p>{p}</p>" for p in edition["rights"])}
  <p class="colophon">{edition["colophon"]}</p>
</section>
<section class="front">
  <h3>How to read this edition</h3>
  <p>The story is split into <b>twelve stages</b> of about 1,600 words, four per chapter.
  At an unhurried pace a stage is a 20 to 30 minute read, a good amount for one sitting.</p>
  <p>Each stage opens with a one-line summary, which never tells you more than the stage itself,
  and with <b>the words for that stage</b>: the ones a B1 reader is unlikely to know, in the order
  they appear. Nouns show their article and plural (<i>· -e</i>, <i>· ¨e</i> for an umlaut). Read
  the list once, then read the text without stopping at every word. The context does the rest.</p>
  <p><b>Notes on the German.</b> A faint dotted underline with a small number marks a phrase that
  shows something worth noticing: a grammar point, an idiom, a word only Prague used. The note is at
  the foot of the page. Skip them on a first reading if you like; they will still be there.</p>
  <p><b>Old spelling.</b> The text keeps the spelling of 1917. Most of it is the old <i>ß</i> after a
  short vowel, which today is <i>ss</i>:</p>
  <table>{spelling}</table>
  <p><b>Prague German.</b> {esc(spec["regional"])}</p>
  <p class="credit"><b>Franz Kafka</b> (1883–1924). <i>Die Verwandlung</i> appeared in
  <i>Die weißen Blätter</i> in October 1915 and as a book in the series <i>Der jüngste Tag</i>
  (Kurt Wolff Verlag, Leipzig). This edition follows the 1917 Kurt Wolff text.</p>
</section>
{''.join(pages)}
<section class="about">
  <img class="about-logo" src="{LOGO}" alt="" />
  <h3>{edition["about"]["title"]}</h3>
  <p>{edition["about"]["intro"]}</p>
  <ul>{''.join(f"<li>{pt}</li>" for pt in edition["about"]["points"])}</ul>
  <p class="about-url">{edition["about"]["url"]}</p>
</section>
</body></html>"""

os.makedirs(out, exist_ok=True)
tmp = tempfile.mkdtemp()
html_path = os.path.join(tmp, "verwandlung.html")
open(html_path, "w", encoding="utf-8").write(doc)

js = r"""
const puppeteer = require('C:/Projects/german_pronouns_articles/node_modules/puppeteer-core');
const fs = require('fs');
const [htmlPath, pdfPath] = process.argv.slice(2);
(async () => {
  const b = await puppeteer.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const p = await b.newPage();
  await p.goto('file:///' + htmlPath.split('\\').join('/'), { waitUntil: 'networkidle0', timeout: 300000 });
  // Paged.js lays the book out into pages, footnotes included, after load.
  await p.waitForFunction(() => window.pagedDone === true, { timeout: 600000, polling: 500 });
  fs.writeFileSync(pdfPath, await p.pdf({ preferCSSPageSize: true, printBackground: true, timeout: 600000 }));
  await b.close();
})();
"""
js_path = os.path.join(tmp, "print.cjs")
open(js_path, "w").write(js)
pdf_path = os.path.join(out, "kafka_die_verwandlung.pdf")
subprocess.run(["node", js_path, html_path, pdf_path], check=True)
print(f"{total} stages, {sum(len(s['words']) for s in spec['stages'])} glossary words")
for w in warnings:
    print("  not found in its stage:", w)
print(pdf_path)
