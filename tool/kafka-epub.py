"""The Kindle edition of the Kafka reader, as EPUB 3 (what KDP prefers).

    python tool/kafka-epub.py assets/reference/kafka_die_verwandlung.txt docs/reference

Same text, stages, glossaries and notes as the paperback (tool/kafka-pdf.py),
laid out for a reflowable screen: one file per stage, the glossary as a list
before the text, and the notes on the German as pop-up footnotes (EPUB 3
noteref / footnote, which Kindle shows over the page when tapped). Builds
with the standard library only; the cover image is the ebook front made by
tool/kafka-cover.py, included when it exists.

Every XHTML file is parsed back before the zip is written, so a malformed
page fails here and not in KDP's previewer.
"""
import html
import json
import os
import re
import sys
import uuid
import zipfile
from datetime import date
from xml.etree import ElementTree

src, out = sys.argv[1], sys.argv[2]
spec = json.load(open(src.replace(".txt", "_stages.json"), encoding="utf-8"))
text = open(src, encoding="utf-8").read()
body = text.split("*** START OF THE PROJECT GUTENBERG EBOOK DIE VERWANDLUNG ***")[1]
body = body.split("*** END OF THE PROJECT GUTENBERG EBOOK DIE VERWANDLUNG ***")[0]
body = body[body.index("\nI.\n") :]
split = re.split(r"\n(I{1,3})\.\n", body)
chapters = {
    split[i]: [" ".join(p.split()) for p in re.split(r"\n\s*\n", split[i + 1]) if p.strip()]
    for i in range(1, len(split), 2)
}
esc = html.escape
BOOK_ID = "urn:uuid:" + str(uuid.uuid5(uuid.NAMESPACE_URL, "languagequiz.org/kafka/die-verwandlung/annotated"))
TITLE = "The Metamorphosis in German (Annotated)"
SUBTITLE = "Kafka's Die Verwandlung for English Speakers: The Original Text in 12 Reading Stages, with Vocabulary and Grammar Notes (B1–B2)"


def page(title: str, body_html: str, lang: str = "en") -> str:
    return f"""<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="{lang}" lang="{lang}">
<head><meta charset="utf-8"/><title>{esc(title)}</title><link rel="stylesheet" type="text/css" href="style.css"/></head>
<body>
{body_html}
</body>
</html>
"""


def word_html(w: dict) -> str:
    pl = w.get("pl")
    extra = " <span class=\"pl\">(plural)</span>" if pl == "pl." else (f' <span class="pl">· {esc(pl)}</span>' if pl and pl != "—" else "")
    return f'<p class="g"><b lang="de" xml:lang="de">{esc(w["de"])}</b>{extra} <span class="en">{esc(w["en"])}</span></p>'


def stem(headword: str) -> str:
    w = re.sub(r"\(.*?\)", "", headword).strip()
    for a in ("der ", "die ", "das ", "sich "):
        if w.startswith(a):
            w = w[len(a) :]
    w = w.split()[0] if w else w
    return w.lower().rstrip("!»«")[: max(4, min(6, len(w) - 2))]


files = []  # (id, href, title, xhtml)
total = len(spec["stages"])

files.append(("title", "title.xhtml", "Title", page("Die Verwandlung", f"""
<section class="titlepage" epub:type="titlepage">
<p class="author">Franz Kafka</p>
<h1 lang="de" xml:lang="de">Die Verwandlung</h1>
<p class="sub">The Metamorphosis in German · Annotated</p>
<p class="ed">Twelve reading stages, with English glossaries and notes on the language</p>
</section>""")))

# The rights page, shared with the print edition (assets/reference/*_edition.json).
edition = json.load(open(src.replace(".txt", "_edition.json"), encoding="utf-8"))
rights = "\n".join(f"<p>{p}</p>" for p in edition["rights"])
files.append(("rights", "rights.xhtml", "Rights and publisher", page("Rights and publisher", f"""
<section epub:type="copyright-page" class="rights">
{rights}
</section>""")))

spelling = "".join(f"<tr><td>{esc(a)}</td><td>{esc(b)}</td></tr>" for a, b in spec["spelling"])
files.append(("howto", "howto.xhtml", "How to read this edition", page("How to read this edition", f"""
<section epub:type="preface">
<h2>How to read this edition</h2>
<p>The story is split into <b>twelve stages</b> of about 1,600 words, four per chapter. At an
unhurried pace a stage is a 20 to 30 minute read, a good amount for one sitting.</p>
<p>Each stage opens with a one-line summary, which never tells you more than the stage itself, and
with <b>the words for that stage</b>: the ones a B1 reader is unlikely to know, in the order they
appear. Nouns show their article and plural. Read the list once, then read the text without stopping
at every word.</p>
<p><b>Notes on the German.</b> An underlined phrase with a small number shows something worth
noticing: a grammar point, an idiom, a word only Prague used. Tap the number to read the note.</p>
<p><b>Old spelling.</b> The text keeps the spelling of 1917. Most of it is the old <i>ß</i> after a
short vowel, which today is <i>ss</i>:</p>
<table>{spelling}</table>
<p><b>Prague German.</b> {esc(spec["regional"])}</p>
<p class="credit"><b>Franz Kafka</b> (1883–1924). <i>Die Verwandlung</i> appeared in <i>Die weißen
Blätter</i> in October 1915 and as a book in the series <i>Der jüngste Tag</i> (Kurt Wolff Verlag,
Leipzig). This edition follows the 1917 Kurt Wolff text. The work is in the public domain; the
stages, summaries, glossaries and notes were written for this edition.</p>
</section>""")))

warnings = []
for n, s in enumerate(spec["stages"], 1):
    paras = chapters[s["chapter"]][s["from"] : s["to"]]
    joined = " ".join(paras).lower()
    found = []
    for w in s["words"]:
        probe = w.get("form", "").lower() or stem(w["de"])
        at = joined.find(probe)
        if at < 0:
            warnings.append(f'stage {n}: "{w["de"]}" not found')
        found.append((at if at >= 0 else len(joined), w))
    words = "\n".join(word_html(w) for _, w in sorted(found, key=lambda pair: pair[0]))

    marks = {i: [] for i in range(len(paras))}
    for k, note in enumerate(s.get("notes", []), 1):
        hit = next(((i, p.find(note["at"])) for i, p in enumerate(paras) if note["at"] in p), None)
        if hit is None:
            warnings.append(f'stage {n}: note phrase not found: "{note["at"]}"')
            continue
        i, at = hit
        marks[i].append((at, at + len(note["at"]), k, note["note"]))
    asides = []
    text_html = []
    for i, p in enumerate(paras):
        out_p, pos = [], 0
        for a, z, k, note in sorted(marks[i]):
            out_p.append(esc(p[pos:a]))
            nid = f"n{n}-{k}"
            out_p.append(
                f'<span class="mark">{esc(p[a:z])}</span><a epub:type="noteref" class="ref" href="#{nid}" id="r{nid}">{k}</a>'
            )
            asides.append(f'<aside epub:type="footnote" id="{nid}"><p><a class="back" href="#r{nid}">{k}</a> {note}</p></aside>')
            pos = z
        out_p.append(esc(p[pos:]))
        cls = ' class="first"' if i == 0 else ""
        text_html.append(f"<p{cls}>" + "".join(out_p).replace("--", "–") + "</p>")

    opener = f'<p class="chapter-no">Kapitel {s["chapter"]}</p>' if s["from"] == 0 else ""
    words_count = sum(len(p.split()) for p in paras)
    body_html = f"""<section epub:type="chapter">
{opener}
<p class="kicker">Stufe {n} von {total} · Kapitel {s["chapter"]} · {words_count} Wörter</p>
<h2 lang="de" xml:lang="de">{esc(s["title"])}</h2>
<p class="summary">{esc(s["en"])}</p>
<div class="gloss"><p class="gloss-head">Words for this stage</p>
{words}
</div>
<div class="text" lang="de" xml:lang="de">
{chr(10).join(text_html)}
</div>
{chr(10).join(asides)}
</section>"""
    files.append((f"stage{n:02d}", f"stage{n:02d}.xhtml", f"Stufe {n}: {s['title']}", page(s["title"], body_html)))

about = edition["about"]
points = "".join(f"<li>{pt}</li>" for pt in about["points"])
files.append(("about", "about.xhtml", about["title"], page(about["title"], f"""
<section epub:type="backmatter">
<h2>{esc(about["title"])}</h2>
<p>{about["intro"]}</p>
<ul>{points}</ul>
<p class="url"><b>{esc(about["url"])}</b></p>
</section>""")))

CSS = """
body { font-family: serif; line-height: 1.45; margin: 0 0.4em; }
h1 { font-size: 2em; text-align: center; margin: 0.4em 0; }
h2 { font-size: 1.4em; margin: 0.2em 0 0.3em; }
.titlepage { text-align: center; margin-top: 30%; }
.author { font-family: sans-serif; font-weight: bold; letter-spacing: 0.2em; text-transform: uppercase; font-size: 0.8em; }
.sub { font-style: italic; }
.ed { font-family: sans-serif; font-size: 0.8em; color: #444; }
.chapter-no { text-align: center; font-size: 1.6em; font-weight: bold; margin: 0.6em 0 1em; }
.kicker { font-family: sans-serif; font-size: 0.7em; font-weight: bold; letter-spacing: 0.08em; text-transform: uppercase; color: #444; margin: 0; }
.summary { font-style: italic; color: #444; margin: 0 0 1em; }
.gloss { border-top: 2px solid #000; border-bottom: 1px solid #999; padding: 0.4em 0; margin: 0 0 1.4em; }
.gloss-head { font-family: sans-serif; font-size: 0.7em; font-weight: bold; letter-spacing: 0.08em; text-transform: uppercase; color: #444; margin: 0 0 0.4em; }
.g { margin: 0 0 0.25em; font-size: 0.9em; line-height: 1.3; text-indent: 0; }
.g .pl { color: #555; }
.g .en { font-family: sans-serif; font-size: 0.85em; color: #444; }
.text p { margin: 0; text-indent: 1.2em; text-align: justify; }
.text p.first { text-indent: 0; }
.mark { text-decoration: underline; text-decoration-style: dotted; }
a.ref { font-family: sans-serif; font-size: 0.65em; vertical-align: super; line-height: 0; text-decoration: none; font-weight: bold; }
aside { font-family: sans-serif; font-size: 0.85em; }
aside a.back { font-weight: bold; text-decoration: none; }
table { border-collapse: collapse; margin: 0.3em 0 0.8em; }
td { padding: 0.15em 1.2em 0.15em 0; border-bottom: 1px solid #ccc; }
.credit { font-size: 0.8em; color: #444; margin-top: 1.5em; }
.rights { font-family: sans-serif; font-size: 0.8em; color: #333; }
.rights p { margin: 0 0 0.7em; }
.url { font-family: sans-serif; font-size: 1.1em; letter-spacing: 0.04em; margin-top: 1.2em; }
"""

nav_items = "\n".join(f'<li><a href="{href}">{esc(title)}</a></li>' for _, href, title, _ in files)
nav = page("Contents", f"""<nav epub:type="toc" id="toc"><h2>Contents</h2><ol>
{nav_items}
</ol></nav>""")
ncx_points = "\n".join(
    f'<navPoint id="np{i}" playOrder="{i}"><navLabel><text>{esc(title)}</text></navLabel><content src="{href}"/></navPoint>'
    for i, (_, href, title, _) in enumerate(files, 1)
)
ncx = f"""<?xml version="1.0" encoding="utf-8"?>
<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">
<head><meta name="dtb:uid" content="{BOOK_ID}"/></head>
<docTitle><text>{esc(TITLE)}</text></docTitle>
<navMap>
{ncx_points}
</navMap>
</ncx>
"""

cover = os.path.join(out, "kafka_die_verwandlung_ebook_cover.jpg")
has_cover = os.path.exists(cover)
manifest = [
    '<item id="nav" href="nav.xhtml" media-type="application/xhtml+xml" properties="nav"/>',
    '<item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>',
    '<item id="css" href="style.css" media-type="text/css"/>',
]
if has_cover:
    manifest.append('<item id="cover-image" href="cover.jpg" media-type="image/jpeg" properties="cover-image"/>')
    manifest.append('<item id="cover" href="cover.xhtml" media-type="application/xhtml+xml"/>')
manifest += [f'<item id="{fid}" href="{href}" media-type="application/xhtml+xml"/>' for fid, href, _, _ in files]
spine = (['<itemref idref="cover" linear="no"/>'] if has_cover else []) + [f'<itemref idref="{fid}"/>' for fid, _, _, _ in files]
opf = f"""<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="bookid" xml:lang="en">
<metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
<dc:identifier id="bookid">{BOOK_ID}</dc:identifier>
<dc:title>{esc(TITLE)}</dc:title>
<dc:creator>Franz Kafka</dc:creator>
<dc:language>de</dc:language>
<dc:language>en</dc:language>
<dc:description>{esc(SUBTITLE)}</dc:description>
<meta property="dcterms:modified">{date.today().isoformat()}T00:00:00Z</meta>
{'<meta name="cover" content="cover-image"/>' if has_cover else ''}
</metadata>
<manifest>
{chr(10).join(manifest)}
</manifest>
<spine toc="ncx">
{chr(10).join(spine)}
</spine>
</package>
"""

container = """<?xml version="1.0" encoding="utf-8"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
<rootfiles><rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/></rootfiles>
</container>
"""

docs = {f"OEBPS/{href}": xhtml for _, href, _, xhtml in files}
docs["OEBPS/nav.xhtml"] = nav
if has_cover:
    docs["OEBPS/cover.xhtml"] = page("Cover", '<div style="text-align:center"><img src="cover.jpg" alt="Cover" style="max-width:100%"/></div>')
for name, xml in list(docs.items()) + [("OEBPS/content.opf", opf), ("OEBPS/toc.ncx", ncx)]:
    try:
        ElementTree.fromstring(xml.encode("utf-8"))
    except ElementTree.ParseError as err:
        raise SystemExit(f"{name} is not well-formed: {err}")

epub = os.path.join(out, "kafka_die_verwandlung.epub")
with zipfile.ZipFile(epub, "w") as z:
    z.writestr(zipfile.ZipInfo("mimetype"), "application/epub+zip", compress_type=zipfile.ZIP_STORED)
    z.writestr("META-INF/container.xml", container, compress_type=zipfile.ZIP_DEFLATED)
    z.writestr("OEBPS/content.opf", opf, compress_type=zipfile.ZIP_DEFLATED)
    z.writestr("OEBPS/toc.ncx", ncx, compress_type=zipfile.ZIP_DEFLATED)
    z.writestr("OEBPS/style.css", CSS, compress_type=zipfile.ZIP_DEFLATED)
    for name, xml in docs.items():
        z.writestr(name, xml, compress_type=zipfile.ZIP_DEFLATED)
    if has_cover:
        z.write(cover, "OEBPS/cover.jpg", compress_type=zipfile.ZIP_STORED)

notes = sum(len(s.get("notes", [])) for s in spec["stages"])
print(f"{total} stages, {sum(len(s['words']) for s in spec['stages'])} glossary words, {notes} notes, cover {'included' if has_cover else 'missing'}")
for w in warnings:
    print("  ", w)
print(epub)
