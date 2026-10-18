"""Where the pages of a printed book go.

    python tool/book-fill.py static/books/de_cert_a1_a1.pdf

Prints the page count, the pages per section (front, each part, back), how
much of each page is used, the white space left before each unit heading,
and the pages that are under 60 % full, so a layout change can be checked
against the plan in docs/book_shrink_plan.md without opening every proof.
"""

import re
import sys

import fitz  # PyMuPDF


def fill(page):
    h = page.rect.height
    boxes = [b for b in page.get_text('blocks') if b[4].strip() and 0.05 * h < b[3] < 0.95 * h]
    ys = [b[3] for b in boxes]
    for img in page.get_images(full=True):
        try:
            r = page.get_image_bbox(img)
            if r.y1 < 0.95 * h:
                ys.append(r.y1)
        except Exception:
            pass
    return max(ys, default=0) / h


def main(path):
    doc = fitz.open(path)
    fills = [fill(p) for p in doc]
    heads = [p.get_text().split('\n')[2:3] for p in doc]
    starts = [i for i, p in enumerate(doc) if re.search(r'UNIT \d', p.get_text())]
    waste = sum(1 - fills[s - 1] for s in starts if s > 0)
    sections = {}
    for i, p in enumerate(doc):
        lines = [l for l in p.get_text().split('\n') if l.strip()]
        key = next((l for l in lines[:3] if l.startswith('Part ') or l.startswith('Key')), 'front')
        sections[key] = sections.get(key, 0) + 1
    print(f'{doc.page_count} pages')
    for k, v in sections.items():
        print(f'  {v:4}  {k}')
    print(f'{len(starts)} unit starts; white space before them: {waste:.1f} pages')
    low = [(i + 1, round(f, 2)) for i, f in enumerate(fills) if f < 0.6]
    print(f'{len(low)} pages under 60 % full: {low}')


if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else 'static/books/de_cert_a1_a1.pdf')
