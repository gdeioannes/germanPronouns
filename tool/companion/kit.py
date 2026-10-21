# Shared building blocks for the study-companion content scripts
# (tool/companion/<level>.py). Each helper returns the JSON shape that
# src/lib/domain/companion.ts describes. Rules: docs/study_companion_guide.md.
import json

# Hero pictures are cp_<level>_<spread id>; a book script sets this first.
HERO_PREFIX = 'cp_'


def words(title, items, cols=None):
    # words and hooks print plain: *focus* marks render only in tables and boxes.
    b = {'kind': 'words', 'title': title, 'items': [{'de': d.replace('*', ''), 'en': e} for d, e in items]}
    if cols:
        b['cols'] = cols
    return b


def table(title, head, rows, note=None, genders=False):
    b = {'kind': 'table', 'title': title, **({'genders': True} if genders else {}),
         'head': [{'text': h[1:], 'en': True} if h.startswith('~') else {'text': h} for h in head],
         'rows': rows}
    if note:
        b['note'] = note
    return b


def slots(title, rows, head=None, hot=None, note=None):
    """rows: (cells, en); a cell is 'de' or ('de', 'tag')."""
    b = {'kind': 'slots', 'title': title}
    if note:
        b['note'] = note
    if head:
        b['head'] = head
    if hot:
        b['hot'] = hot
    b['rows'] = []
    for cells, en in rows:
        r = {'cells': [c if isinstance(c, dict) else {'de': c} if isinstance(c, str) else {'de': c[0], 'tag': c[1]}
                       for c in cells]}
        if en:
            r['en'] = en
        b['rows'].append(r)
    return b


def build(title, rows, note=None):
    """rows: (parts, result, en); a part is 'text' or ('text', role)."""
    b = {'kind': 'build', 'title': title}
    if note:
        b['note'] = note
    b['rows'] = [{'parts': [{'text': p} if isinstance(p, str) else {'text': p[0], 'role': p[1]} for p in parts],
                  'result': res, 'en': en} for parts, res, en in rows]
    return b


def arrow(title, rows, ask=('wer?', 'wen?'), note=None):
    b = {'kind': 'arrow', 'title': title}
    if note:
        b['note'] = note
    b['ask'] = list(ask)
    b['rows'] = [{'who': w, 'verb': v, 'whom': o, **({'en': en} if en else {})} for w, v, o, en in rows]
    return b


def merge(title, labels, rows, note=None):
    b = {'kind': 'merge', 'title': title}
    if note:
        b['note'] = note
    b['labels'] = list(labels)
    b['rows'] = [{'a': a, 'aTo': at, 'b': bb, 'bTo': bt, 'result': r, **({'en': en} if en else {})}
                 for a, at, bb, bt, r, en in rows]
    return b


def flow(title, root, note=None):
    b = {'kind': 'flow', 'title': title}
    if note:
        b['note'] = note
    b['root'] = root
    return b


def q(text, yes, no):
    return {'q': text, 'yes': yes, 'no': no}


def a(answer, example=None):
    return {'answer': answer, **({'example': example} if example else {})}


def box(tone, title, text):
    return {'kind': 'box', 'tone': tone, 'title': title, 'text': text}


def cols(*blocks):
    return {'kind': 'columns', 'blocks': list(blocks)}


def gaps(title, instruction, items, note=None):
    ex = {'title': title, 'instruction': instruction, 'kind': 'gaps', 'items': []}
    for it in items:
        g = {'before': it[0]}
        if len(it) > 1 and it[1] is not None:
            g['after'] = it[1]
        if len(it) > 2:
            g['answer'] = it[2]
        ex['items'].append(g)
    if note:
        ex['note'] = note
    return ex


def circle(title, instruction, items, ncols=2):
    return {'title': title, 'instruction': instruction, 'kind': 'circle', 'cols': ncols,
            'items': [{'before': b, 'options': o, 'after': a, 'answer': ans} for b, o, a, ans in items]}


def write(title, instruction, items, ncols=None, not_german=False):
    ex = {'title': title, 'instruction': instruction, 'kind': 'write',
          'items': [{'prompt': p, 'answer': a} for p, a in items]}
    if ncols:
        ex['cols'] = ncols
    if not_german:
        ex['notGerman'] = True
    return ex


def match(title, instruction, pairs, order):
    """pairs: (left, right) in true order; order: how the right column is printed (indexes into pairs)."""
    right = [pairs[i][1] for i in order]
    return {'title': title, 'instruction': instruction, 'kind': 'match',
            'left': [l for l, _ in pairs], 'right': right,
            'answers': [order.index(i) for i in range(len(pairs))]}


def spread(id, title, subtitle, hook, quiz, learn, practise, can_do, hero=True, listen=None):
    s = {'id': id, 'title': title, 'subtitle': subtitle, 'hook': hook.replace('*', '')}
    if hero:
        s['hero'] = {'image': f'{HERO_PREFIX}{id}'}
    s['quiz'] = quiz
    if listen:
        s['listenQuiz'] = listen
    s['learn'] = learn
    s['practise'] = practise
    s['canDo'] = can_do
    return s



def clock(title, clocks, dial=False, ncols=None, note=None):
    b = {'kind': 'clock', 'title': title}
    if note:
        b['note'] = note
    if dial:
        b['dial'] = True
    if ncols:
        b['cols'] = ncols
    b['clocks'] = [{'time': t, 'de': d, **({'mark': True} if t.endswith('!') else {})} for t, d in clocks]
    for c in b['clocks']:
        c['time'] = c['time'].rstrip('!')
    return b


def clocks_ex(title, instruction, items, draw=False):
    ex = {'title': title, 'instruction': instruction, 'kind': 'clocks'}
    if draw:
        ex['draw'] = True
    ex['items'] = [{'time': t, 'de': d} for t, d in items]
    return ex


def tiles(title, items, ncols=6, small=True, note=None):
    b = {'kind': 'tiles', 'title': title}
    if note:
        b['note'] = note
    b['cols'] = ncols
    if small:
        b['small'] = True
    b['tiles'] = [{'big': big, 'word': w, **({'mark': True} if big.endswith('!') else {})} for big, w in items]
    for t in b['tiles']:
        t['big'] = t['big'].rstrip('!')
    return b


def sl(*cells):
    """A slots row: a cell ending in ! is framed."""
    return [{'de': c.rstrip('!'), 'hot': True} if c.endswith('!') else c for c in cells]


# ---- 5 · können, müssen, möchten ------------------------------------------


def tags_ex(title, instruction, items, unit=None):
    ex = {'title': title, 'instruction': instruction, 'kind': 'tags'}
    if unit:
        ex['unit'] = unit
    ex['items'] = [{'image': i, 'label': l, 'answer': a} for i, l, a in items]
    return ex



def pictures(title, items, ncols=6, note=None):
    """items: (picture id, German, English or None) — labelled pictures that teach by showing."""
    b = {'kind': 'pictures', 'title': title}
    if note:
        b['note'] = note
    b['cols'] = ncols
    b['items'] = [{'image': i, 'de': d, **({'en': e} if e else {})} for i, d, e in items]
    return b


def timeline(title, marks, note=None):
    """marks: (de, en, at) for a point, or (de, en, (from, to)) for a span; 0 is now, -4 … 4."""
    b = {'kind': 'timeline', 'title': title}
    if note:
        b['note'] = note
    b['marks'] = []
    for de, en, where in marks:
        m = {'de': de, 'en': en}
        if isinstance(where, tuple):
            m['from'], m['to'] = where
        else:
            m['at'] = where
        b['marks'].append(m)
    return b


def review(id, subtitle, hook, quiz, left, practise):
    return {'id': id, 'review': True, 'title': 'Wiederholung', 'subtitle': subtitle, 'hook': hook,
            'quiz': quiz, 'learn': [], 'left': left, 'practise': practise, 'canDo': []}


def dictionary(note, entries):
    """entries: (de, en, picture id)."""
    return {'title': 'Words in pictures', 'note': note,
            'words': [{'de': d, 'en': e, 'image': i} for d, e, i in entries]}


def write_book(path, book):
    with open(path, 'w', encoding='utf-8', newline=chr(10)) as f:
        json.dump(book, f, ensure_ascii=False, indent=chr(9))
        f.write(chr(10))
    print('wrote', path, len(book['spreads']), 'spreads')
