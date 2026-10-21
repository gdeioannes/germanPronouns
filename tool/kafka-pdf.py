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
    # In a phrase the longest word is the telling one: Erstaunen, not "in".
    w = max(w.split(), key=len) if w else w
    return w.lower().rstrip("!»«")[: max(4, min(6, len(w) - 2))]


def word_html(w: dict) -> str:
    # In a narrow margin gloss the article stays with its noun, and a long
    # word breaks with a hyphen (Gewissens-bisse) rather than leave "die" alone.
    de = re.sub(r"^(der|die|das|sich) ", "\\1&nbsp;", hyphenate(w["de"]))
    pl = w.get("pl")
    if pl == "pl.":
        de += ' <span class="pl">(plural)</span>'
    elif pl and pl != "—":
        de += f' <span class="pl">· {esc(pl)}</span>'
    return f'<span class="de">{de}</span><span class="en">{esc(w["en"])}</span>'


def sort_key(headword: str) -> str:
    """Where a headword files in the dictionary: by the word, not its article."""
    w = headword.lower()
    for a in ARTICLES:
        if w.startswith(a):
            w = w[len(a) :]
    return w.translate(str.maketrans({"ä": "a", "ö": "o", "ü": "u", "ß": "ss"}))


def repeat_patterns(w: dict, always: bool = False) -> list:
    """Where else in the book this word stands, for its repeat glosses. A
    noun is matched as a whole word with its case endings, which its capital
    letter makes safe. Anything else matches only its exact listed form or
    its bare headword, never a stem: "schon" must not pass for schonen.
    "again": false turns repeats off where a lookalike means something else
    (Trotz, the noun, and trotz, the preposition)."""
    if not w.get("again", True) and not always:
        return []
    pats = []
    base = re.sub(r"\(.*?\)", "", w["de"]).strip()
    for a in ARTICLES:
        if base.startswith(a):
            base = base[len(a) :]
    noun = base[:1].isupper()
    # Case matters for everything but a noun's lowercase "form": a verb must
    # not gloss the noun it looks like (rücken, to shift; der Rücken, back).
    # "also" lists further forms the text uses (opferte beside opfern).
    for form in [w.get("form", "")] + w.get("also", []):
        if form:
            pats.append(re.compile(rf"\b{re.escape(form)}\b", re.IGNORECASE if noun else 0))
    if " " not in base and base:
        pats.append(re.compile(rf"\b{re.escape(base)}{'(?:e|n|en|s|es|ns)?' if noun else ''}\b"))
    return pats


# Each word is glossed in the margin beside the line it first appears on in
# its stage (the main gloss, always printed), and again wherever else it
# stands in the book (a repeat, printed when the word is not explained on
# that page already and the margin has room beside the line). The text
# carries an empty anchor at the start of each occurrence; once Paged.js has
# laid out the pages, the script in the head measures where the anchors
# landed and sets the glosses in the outer margin level with them.
stage_paras = [chapters[s["chapter"]][s["from"] : s["to"]] for s in spec["stages"]]
anchors = [{i: {} for i in range(len(p))} for p in stage_paras]
warnings = []
dictionary = []  # (sort key, gloss html, anchor id), every glossed word
glossed = []  # (anchor id, entry, (stage, paragraph, offset) of the main gloss)
for n, (s, paras) in enumerate(zip(spec["stages"], stage_paras), 1):
    for k, w in enumerate(s["words"]):
        # The whole word first, as its form or headword; failing that, its stem
        # ("form" is the word as the text has it, for separable and irregular
        # verbs). A stem alone can land on an earlier word: "schwer" for
        # Schwerhörigkeit would gloss "schweren".
        whole = [(i, m.start()) for pat in repeat_patterns(w, always=True) for i, p in enumerate(paras) if (m := pat.search(p))]
        # The stem should start a word, or "erer" for ererbt finds besond-erer;
        # only failing that may it sit inside one (ge-kündig-t, hervor-rag-te).
        probe = w.get("form", "").lower() or stem(w["de"])
        at_start = re.compile(rf"\b{re.escape(probe)}", re.IGNORECASE)
        hit = (
            min(whole)
            if whole
            else next(((i, m.start()) for i, p in enumerate(paras) if (m := at_start.search(p))), None)
            or next(((i, p.lower().find(probe)) for i, p in enumerate(paras) if probe in p.lower()), None)
        )
        if hit is None:
            warnings.append(f'stage {n}: "{w["de"]}" (looked for "{probe}")')
            continue
        i, at = hit
        while at > 0 and paras[i][at - 1].isalpha():
            at -= 1  # back to the start of the word the stem was found in
        gid = f"g{n}-{k}"
        g = esc(word_html(w), quote=True)
        anchors[n - 1][i].setdefault(at, []).append(f'<span class="ga" id="{gid}" data-k="{gid}" data-g="{g}"></span>')
        dictionary.append((sort_key(w["de"]), word_html(w), gid))
        glossed.append((gid, w, (n - 1, i, at)))

repeats = 0
for gid, w, main in glossed:
    g = esc(word_html(w), quote=True)
    for pat in repeat_patterns(w):
        for sn, paras in enumerate(stage_paras):
            for i, p in enumerate(paras):
                for m in pat.finditer(p):
                    if (sn, i, m.start()) == main or any(f'data-k="{gid}"' in a for a in anchors[sn][i].get(m.start(), [])):
                        continue
                    anchors[sn][i].setdefault(m.start(), []).append(
                        f'<span class="ga ga-r" data-k="{gid}" data-g="{g}"></span>'
                    )
                    repeats += 1

pages = []
total = len(spec["stages"])
seen_chapters = set()
for n, (s, paras) in enumerate(zip(spec["stages"], stage_paras), 1):
    opener = ""
    if s["chapter"] not in seen_chapters:
        seen_chapters.add(s["chapter"])
        opener = f'<p class="chapter-no">Kapitel {s["chapter"]}</p>'
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
        def seg(a: int, z: int) -> str:
            """p[a:z] as HTML, with the gloss anchors that fall inside it."""
            out, pos = [], a
            for at in sorted(x for x in anchors[n - 1][i] if a <= x < z):
                out.append(hyphenate(p[pos:at]))
                # The anchor holds the word's first letter: an empty one can be
                # left at the end of the line before when the word starts a new
                # line, and its gloss would point a line too high.
                first, *more = anchors[n - 1][i][at]
                out.append(first.removesuffix("</span>") + "".join(more) + esc(p[at]) + "</span>")
                pos = at + 1
            out.append(hyphenate(p[pos:z]))
            # Gutenberg's plain text writes the dash as "--"; print it as a real one.
            return "".join(out).replace("--", "–")

        out, pos = [], 0
        for a, z, note in sorted(marks[i]):
            if a < pos:
                warnings.append(f'stage {n}: overlapping note phrases in paragraph {i}')
                continue
            out.append(seg(pos, a))
            # The note is authored HTML (<b>, <i>); the phrase is escaped text.
            out.append(f'<span class="mark">{seg(a, z)}</span><span class="fn">{note}</span>')
            pos = z
        out.append(seg(pos, len(p)))
        return "<p>" + "".join(out) + "</p>"

    text_html = "\n".join(para_html(i, p) for i, p in enumerate(paras))
    pages.append(
        f"""<section class="stage">
  {opener}
  <p class="kicker">Stufe {n} von {total} · Kapitel {s["chapter"]} · {sum(len(p.split()) for p in paras)} Wörter</p>
  <h2>{esc(s["title"])}</h2>
  <p class="summary">{esc(s["en"])}</p>
  <div class="text">{text_html}</div>
</section>"""
    )

dictionary.sort(key=lambda d: d[0])
dict_html = "".join(f'<li>{g}<span class="pg" data-for="{gid}"></span></li>' for _, g, gid in dictionary)

spelling = "".join(f"<tr><td>{esc(a)}</td><td>{esc(b)}</td></tr>" for a, b in spec["spelling"])

doc = f"""<!doctype html><html lang="de"><head><meta charset="utf-8">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Source+Serif+4:ital,opsz,wght@0,8..60,400;0,8..60,700;1,8..60,400&family=Inter:wght@500;600;700;800&display=block">
<script>
  // Paged.js makes each footnote call a link to its note. A link becomes a PDF
  // annotation, which KDP strips as non-printable markup; on paper it is
  // meaningless anyway. So the links go once the layout is done.
  window.PagedConfig = {{ auto: true, after: () => {{
    document.querySelectorAll('a[href]').forEach((a) => a.removeAttribute('href'));
    placeGlosses();
    window.pagedDone = true;
  }} }};

  // Every occurrence of a glossed word left an empty anchor at its start. Now
  // that the pages exist, set the glosses in the outer margin level with their
  // lines: right of the text on a right-hand page, left of it on a left-hand
  // one, so nothing runs into the binding. A word is explained once per page,
  // at its first occurrence there. Glosses stay beside the body text, never
  // beside a heading or the footnotes. Main glosses (the word's first
  // appearance in its stage) are always printed: overlapping ones are pushed
  // down, any that would run past the last line are pushed back up, and a page
  // with more than its margin holds sets them a size smaller. Repeats then
  // fill the gaps, each only if it fits close beside its own line. A thin grey
  // leader runs from each gloss to the edge of the text at its line.
  function placeGlosses() {{
    const MM = 96 / 25.4, GAP = 6 * MM, WIDTH = 24 * MM, DRIFT = 5 * MM;
    const SVG = 'http://www.w3.org/2000/svg';
    for (const page of document.querySelectorAll('.pagedjs_page')) {{
      const box = page.getBoundingClientRect();
      const byWord = new Map();
      for (const a of page.querySelectorAll('.ga')) {{
        const r = a.getBoundingClientRect();
        const want = r.top - box.top; // the top of its line
        const main = !a.classList.contains('ga-r');
        const seen = byWord.get(a.dataset.k);
        if (!seen) byWord.set(a.dataset.k, {{ a, want, mid: want + r.height / 2, main }});
        else if (main) seen.main = true; // explained here anyway, at the first occurrence
      }}
      if (!byWord.size) continue;
      const area = page.querySelector('.pagedjs_page_content').getBoundingClientRect();
      const texts = [...page.querySelectorAll('.text')].map((t) => t.getBoundingClientRect());
      if (!texts.length) continue;
      const ceiling = Math.min(...texts.map((r) => r.top)) - box.top;
      const bottom = Math.max(...texts.map((r) => r.bottom)) - box.top;
      const right = page.classList.contains('pagedjs_right_page');
      const x = right ? area.right - box.left + GAP : area.left - box.left - GAP - WIDTH;
      const notes = [...byWord.values()].sort((p, q) => p.want - q.want);
      for (const n of notes) {{
        n.g = document.createElement('div');
        n.g.className = 'gm ' + (right ? 'gm-r' : 'gm-l');
        n.g.innerHTML = n.a.dataset.g;
        n.g.style.left = x + 'px';
        n.g.style.width = WIDTH + 'px';
        page.appendChild(n.g);
      }}
      const mains = notes.filter((n) => n.main);
      // Shrink the type on this page until the main glosses fit beside the text.
      let space;
      for (const s of [1, 0.92, 0.85, 0.78, 0.72]) {{
        for (const n of notes) {{ n.g.style.setProperty('--s', s); n.h = n.g.offsetHeight; }}
        space = 1.4 * MM * s;
        if (mains.reduce((sum, n) => sum + n.h + space, 0) <= bottom - ceiling + space) break;
      }}
      let next = ceiling;
      for (const n of mains) {{
        n.top = Math.max(n.want, next);
        next = n.top + n.h + space;
      }}
      let limit = bottom;
      for (const n of [...mains].reverse()) {{
        n.top = Math.max(ceiling, Math.min(n.top, limit - n.h));
        limit = n.top - space;
      }}
      const placed = mains.map((n) => [n.top, n.top + n.h]);
      for (const n of notes.filter((n) => !n.main)) {{
        let top = Math.max(n.want, ceiling), moved = true;
        while (moved) {{
          moved = false;
          for (const [a, z] of placed) {{
            if (top < z + space && top + n.h + space > a) {{ top = z + space; moved = true; }}
          }}
        }}
        if (top - n.want > DRIFT || top + n.h > bottom) {{ n.g.remove(); continue; }}
        n.top = top;
        placed.push([top, top + n.h]);
      }}
      const svg = document.createElementNS(SVG, 'svg');
      svg.setAttribute('class', 'leaders');
      svg.setAttribute('width', box.width);
      svg.setAttribute('height', box.height);
      const edge = right ? area.right - box.left + 0.8 * MM : area.left - box.left - 0.8 * MM;
      const start = right ? x - 0.8 * MM : x + WIDTH + 0.8 * MM;
      for (const n of notes) {{
        if (n.top === undefined) continue;
        n.g.style.top = n.top + 'px';
        // From the middle of the headword's first line to the text at the word's line.
        const de = n.g.querySelector('.de');
        const y = n.top + parseFloat(getComputedStyle(de).fontSize) * 0.62;
        const line = document.createElementNS(SVG, 'line');
        line.setAttribute('x1', start);
        line.setAttribute('y1', y);
        line.setAttribute('x2', edge);
        line.setAttribute('y2', n.mid);
        svg.appendChild(line);
      }}
      page.appendChild(svg);
    }}
    // The dictionary at the back gives the page each word is glossed on.
    for (const pg of document.querySelectorAll('.pg')) {{
      const a = document.getElementById(pg.dataset.for);
      const page = a && a.closest('.pagedjs_page');
      if (page) pg.textContent = page.dataset.pageNumber;
    }}
  }}
</script>
<script src="https://unpkg.com/pagedjs@0.4.3/dist/paged.polyfill.js"></script>
<style>
@page {{ size: 5.5in 8.5in; margin: 18mm 15mm 20mm;
  counter-reset: footnote;
  @bottom-center {{ content: counter(page); font: 600 8pt Inter, sans-serif; color: #555555; }}
  @footnote {{ border-top: .2mm solid #999999; padding-top: 1.5mm; margin-top: 3mm; }} }}
/* The story pages keep a wide outer margin for the word glosses. */
@page :right {{ margin-left: 11mm; margin-right: 38mm; }}
@page :left {{ margin-left: 38mm; margin-right: 11mm; }}
@page front {{ margin: 18mm 15mm 20mm; @bottom-center {{ content: none; }} }}
@page back {{ margin: 18mm 15mm 20mm; }}
.pagedjs_page {{ position: relative; }}
.gm {{ position: absolute; line-height: 1.12; }}
.gm-l {{ text-align: right; }}
/* --s shrinks the glosses on a page that holds more than its margin fits. */
.gm .de {{ display: block; font-weight: 700; font-size: calc(7.3pt * var(--s, 1)); color: #000000; }}
.gm .pl {{ font-weight: 400; color: #555555; font-size: calc(6.7pt * var(--s, 1)); }}
.gm .en {{ display: block; font: 500 calc(6.2pt * var(--s, 1))/1.2 Inter, sans-serif; color: #444444; }}
.leaders {{ position: absolute; left: 0; top: 0; pointer-events: none; overflow: visible; }}
.leaders line {{ stroke: #a6a6a6; stroke-width: .3pt; }}
.dict {{ page: back; break-before: page; }}
.dict h3 {{ font: 700 15pt 'Source Serif 4', serif; color: #000000; margin: 0 0 1.5mm; }}
.dict .intro {{ font: 500 7.8pt/1.45 Inter, sans-serif; color: #333333; margin: 0 0 4mm; }}
.dict ul {{ list-style: none; margin: 0; padding: 0; columns: 2; column-gap: 6mm; }}
/* One line per word where it fits: headword, meaning, page. */
.dict li {{ break-inside: avoid; margin: 0 0 .55mm; line-height: 1.22; position: relative; padding: 0 5mm 0 2.5mm; text-indent: -2.5mm; }}
.dict .de {{ font-weight: 700; font-size: 7.4pt; color: #000000; margin-right: 1.2mm; }}
.dict .pl {{ font-weight: 400; color: #555555; font-size: 6.8pt; }}
.dict .en {{ font: 500 6.5pt Inter, sans-serif; color: #444444; }}
.dict .pg {{ position: absolute; right: 0; top: .2mm; font: 600 6.5pt Inter, sans-serif; color: #555555; text-indent: 0; }}
.gm .pl, .dict .pl {{ white-space: nowrap; }}
.about {{ page: back; }}
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
  <p>Each stage opens with a one-line summary, which never tells you more than the stage itself.</p>
  <p><b>Words in the margin.</b> The words a B1 reader is unlikely to know are explained in the
  outer margin, level with the line they first appear on, so the help is beside you when you need
  it. Nouns show their article and plural (<i>· -e</i>, <i>· ¨e</i> for an umlaut). Glance across
  when a word stops you, then read on; the context does the rest. When a word comes back later it
  is explained again, once a page, wherever the margin has room. If it is not beside you,
  <b>the dictionary at the back</b> lists every word, A to Z, with the page that explains it.</p>
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
<section class="dict">
  <h3>Wörterbuch</h3>
  <p class="intro">Every word explained in the margins, A to Z by the word itself (articles and
  <i>sich</i> aside), with the page where it is explained in context.</p>
  <ul>{dict_html}</ul>
</section>
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
print(f"{total} stages, {sum(len(s['words']) for s in spec['stages'])} glossary words, {repeats} repeat anchors")
for w in warnings:
    print("  not found in its stage:", w)

# KDP rejects anything within 0.25 in of the trim on a book without bleed, so
# every page is checked here, with half a millimetre to spare, before KDP's
# previewer has to say so.
import fitz  # PyMuPDF

SAFE = 0.25 * 72 + 0.5 / 25.4 * 72
book = fitz.open(pdf_path)
for k, pg in enumerate(book, 1):
    W, H = pg.rect.width, pg.rect.height
    boxes = [fitz.Rect(w[:4]) for w in pg.get_text("words")] + [d["rect"] for d in pg.get_drawings()]
    out_of = [r for r in boxes if r.x0 < SAFE or r.y0 < SAFE or r.x1 > W - SAFE or r.y1 > H - SAFE]
    if out_of:
        print(f"  page {k}: {len(out_of)} object(s) inside KDP's 0.25 in edge margin")
print(pdf_path)
