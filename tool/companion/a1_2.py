# Builds assets/content/companion/de_cert_a1/a1_2.json — the A1.2 study companion.
# Run: python -I tool/companion/a1_2.py   (rules: docs/study_companion_guide.md)
import json

OUT = r'C:\Projects\german_pronouns_articles\assets\content\companion\de_cert_a1\a1_2.json'


# ---- helpers ---------------------------------------------------------------
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
        s['hero'] = {'image': f'cp_a1_2_{id}'}
    s['quiz'] = quiz
    if listen:
        s['listenQuiz'] = listen
    s['learn'] = learn
    s['practise'] = practise
    s['canDo'] = can_do
    return s


Q = 'quest_a1_2_'
spreads = []

# ---- 1 · den, einen --------------------------------------------------------
spreads.append(spread(
    'akkusativ', 'den, einen', 'The thing you have, see or buy',
    'Only one article changes when a noun becomes the object: *der* turns into *den*. Learn that, and the rest stays as you know it.',
    Q + 'akkusativ',
    [
        table('Subject or object?', ['~', 'der', 'die', 'das', 'plural'], [
            ['who does it', 'der · ein', 'die · eine', 'das · ein', 'die'],
            ['what it’s done to', '*den* · *einen*', 'die · eine', 'das · ein', 'die'],
        ], 'Only the der column changes. Two new words: *den* and *einen*.', genders=True),
        cols(
            words('der → den', [
                ('Der Hund ist klein.', 'The dog is small.'),
                ('Ich sehe *den* Hund.', 'I see the dog.'),
                ('Ich habe *einen* Bruder.', 'I have a brother.'),
                ('Opa nimmt *den* Apfelkuchen.', 'Grandpa takes the apple cake.'),
            ], 1),
            words('die, das: no change', [
                ('Ich kaufe *eine* Lampe.', 'I buy a lamp.'),
                ('Lena sucht *die* Tasche.', 'Lena is looking for the bag.'),
                ('Wir haben *ein* Auto.', 'We have a car.'),
                ('Er isst *das* Brot.', 'He eats the bread.'),
            ], 1),
        ),
        slots('The article says who does what', [
            ([('Lena', 'who'), 'sieht', ('*den* Hund', 'what')], 'Lena sees the dog.'),
            ([('*Den* Hund', 'what'), 'sieht', ('Lena', 'who')], 'Lena sees the dog — still!'),
            ([('*Der* Hund', 'who'), 'sieht', ('Lena', 'what')], 'The dog sees Lena.'),
        ], hot=[1], note='Swap the places and the meaning stays: *den* marks the one it is done to.'),
        cols(
            arrow('Ask wer? and wen?', [
                ('Lena', 'sieht', '*den* Hund', None),
                ('Opa', 'nimmt', '*den* Kuchen', None),
                ('Ich', 'brauche', '*einen* Tisch', None),
            ], note='Whatever answers wen? takes den.'),
            box('watch', 'Verbs with a what',
                'haben, sehen, kaufen, nehmen, essen, trinken, suchen, brauchen — after these comes a thing, and a der-word becomes *den*: Ich brauche *einen* Stuhl.'),
        ),
        words('Words for the practice page', [
            ('brauchen', 'to need'), ('suchen', 'to look for'), ('der Tee', 'tea'),
            ('der Regenschirm', 'umbrella'),
        ], 4),
    ],
    [
        gaps('the', 'Write den, die or das.', [
            ('Ich sehe', 'Hund.', 'den'), ('Lena kauft', 'Lampe.', 'die'),
            ('Wir nehmen', 'Auto.', 'das'), ('Max isst', 'Apfel.', 'den'),
            ('Paul sucht', 'Tasche.', 'die'), ('Ich brauche', 'Tisch.', 'den'),
        ]),
        gaps('At the market', 'Look at the picture on the left page. Write einen, eine or ein.', [
            ('Er kauft', 'Lampe.', 'eine'), ('Er kauft', 'Stuhl.', 'einen'),
            ('Er hat', 'Ball.', 'einen'), ('Der Hund hat', 'Tasche.', 'eine'),
            ('Ich habe', 'Bruder.', 'einen'), ('Wir haben', 'Haus.', 'ein'),
        ]),
        circle('Who does what?', 'Circle the right word.', [
            ('', ['Der', 'Den'], 'Hund schläft.', 'Der'),
            ('Ich sehe', ['der', 'den'], 'Hund.', 'den'),
            ('', ['Der', 'Den'], 'Tee ist gut.', 'Der'),
            ('Lisa trinkt', ['der', 'den'], 'Tee.', 'den'),
            ('', ['Der', 'Den'], 'Apfelkuchen nimmt Opa.', 'Den'),
            ('', ['Ein', 'Einen'], 'Stuhl kostet zwanzig Euro.', 'Ein'),
        ]),
        gaps('Your shopping list', 'What do you need today? Write two things, with ein, eine or einen.', [
            ('Heute kaufe ich', '.'), ('Ich brauche', '.'),
        ], 'About you — check the article against the table.'),
    ],
    ['say what I have, see or buy, with the right article',
     'use den and einen for der-words',
     'tell from the article who does what'],
))

# ---- 2 · kein & nicht ------------------------------------------------------
spreads.append(spread(
    'negation', 'kein & nicht', 'Saying no: no money, not tired',
    'Two words do all the saying no. *kein* goes with a noun, *nicht* with everything else.',
    Q + 'negation',
    [
        table('kein: the no-article', ['~', 'der', 'die', 'das', 'plural'], [
            ['who does it', 'kein', 'keine', 'kein', 'keine'],
            ['what it’s done to', '*keinen*', 'keine', 'kein', 'keine'],
        ], 'kein is just ein with a k — with the same endings, and a plural too: *keine* Kinder.', genders=True),
        table('Yes → no', ['yes', 'no', '~in English'], [
            ['Ich habe *einen* Hund.', 'Ich habe *keinen* Hund.', 'I have no dog.'],
            ['Er hat Zeit.', 'Er hat *keine* Zeit.', 'He has no time.'],
            ['Sie ist müde.', 'Sie ist *nicht* müde.', 'She is not tired.'],
        ], '*ein* becomes *kein*; everything else takes *nicht*.'),
        cols(
            build('kein is k + ein', [
                ([('k', 'joint'), 'ein'], 'kein', 'der, das'),
                ([('k', 'joint'), 'ein', ('e', 'suffix')], 'keine', 'die, plural'),
                ([('k', 'joint'), 'ein', ('en', 'suffix')], 'keinen', 'der, object'),
            ]),
            flow('kein or nicht?', q('A noun after it?',
                                     q('ein or no article in the yes?', a('kein', 'keine Zeit'), a('nicht', 'nicht der Bus')),
                                     a('nicht', 'nicht müde'))),
        ),
        slots('Where nicht goes', [
            (['Ich', 'verstehe', 'das', '*nicht*'], 'at the end'),
            (['Sie', 'ist', '*nicht*', 'müde'], 'before a describing word'),
            (['Er', 'wohnt', '*nicht*', 'in Berlin'], 'before a place'),
        ], hot=[1]),
        words('Words for the practice page', [
            ('verstehen', 'to understand'), ('das Problem', 'problem'), 
            ('das Fleisch', 'meat'), ('teuer', 'expensive'),
            ('die Frage · die Fragen', 'question · questions'), ('laut', 'loud'),
        ], 4),
    ],
    [
        circle('kein or nicht?', 'Circle the right word.', [
            ('Ich habe', ['kein', 'nicht'], 'Auto.', 'kein'),
            ('Sie ist', ['keine', 'nicht'], 'müde.', 'nicht'),
            ('Die Frau hat', ['keinen', 'nicht'], 'Regenschirm.', 'keinen'),
            ('Ich verstehe das', ['kein', 'nicht'], '.', 'nicht'),
            ('Das Buch ist', ['kein', 'nicht'], 'teuer.', 'nicht'),
            ('Wir haben', ['keine', 'nicht'], 'Fragen.', 'keine'),
        ]),
        gaps('kein, keine or keinen?', 'Write the right form.', [
            ('Ich habe', 'Zeit.', 'keine'), ('Wir haben', 'Hund.', 'keinen'),
            ('Ich esse', 'Fleisch.', 'kein'), ('Sie hat', 'Geschwister.', 'keine'),
            ('Ich trinke', 'Kaffee.', 'keinen'), ('Das ist', 'Problem.', 'kein'),
        ]),
        write('Nein!', 'Answer every question with nein — and a whole sentence.', [
            ('Hast du einen Hund?', 'Nein, ich habe keinen Hund.'),
            ('Bist du müde?', 'Nein, ich bin nicht müde.'),
            ('Hast du Zeit?', 'Nein, ich habe keine Zeit.'),
            ('Ist das Brot teuer?', 'Nein, das Brot ist nicht teuer.'),
            ('Ist die Katze laut?', 'Nein, die Katze ist nicht laut.'),
        ], 1),
        gaps('Not me', 'Write two true sentences about yourself.', [
            ('Ich habe kein', '.'), ('Ich bin nicht', '.'),
        ], 'About you — kein before a das-word, nicht before a describing word.'),
    ],
    ['say I have no …, with kein, keine, keinen',
     'say not, with nicht in the right place',
     'answer a question with a full no'],
))

# ---- 3 · mein, dein, unser -------------------------------------------------
spreads.append(spread(
    'possessiv', 'mein, dein, unser …', 'Whose is it? my, your, his, our',
    'One word for each owner — and the ending comes from the thing, not the person.',
    Q + 'possessiv',
    [
        table('One word for each owner', ['who', 'der · das word', 'die word · plural', '~in English'], [
            ['ich', 'mein', 'meine', 'my'],
            ['du', 'dein', 'deine', 'your'],
            ['er · es', 'sein', 'seine', 'his · its'],
            ['sie', 'ihr', 'ihre', 'her'],
            ['wir', 'unser', 'unsere', 'our'],
            ['ihr', 'euer', '*eure*', 'your (all of you)'],
            ['sie · Sie', 'ihr · Ihr', 'ihre · Ihre', 'their · your (polite)'],
        ], 'The owner picks the word, the thing picks the ending: Lena → *ihr* Hund, *ihre* Tasche.'),
        merge('Two questions, one word', ('owner', 'thing'), [
            ('Lena', 'ihr', 'die Tasche', '-e', 'ihre Tasche', 'her bag'),
            ('Max', 'sein', 'der Hund', '–', 'sein Hund', 'his dog'),
            ('ich', 'mein', 'den Schlüssel', '-en', 'meinen Schlüssel', 'my key (object: remember einen)'),
        ], note='Who owns it gives the word; the thing gives the ending.'),
        cols(
            words('Who owns it?', [
                ('Das ist *mein* Vater.', 'That is my father.'),
                ('Max sucht *seine* Jacke.', 'Max is looking for his jacket.'),
                ('Lena und *ihr* Hund', 'Lena and her dog'),
                ('Herr Braun, ist das *Ihr* Koffer?', 'Mr Braun, is that your suitcase?'),
                ('Ich suche *meinen* Schlüssel.', 'I’m looking for my key.'),
            ], 1),
            box('watch', 'Two small traps',
                '*Ihr* with a big I is the polite your — for Herr Braun and Frau Weber; small *ihr* is her or their. And euer loses an e: *eure* Tochter, *eure* Kinder.'),
        ),
        words('Words for the practice page', [
            ('Herr · Frau', 'Mr · Mrs, Ms'), ('der Koffer', 'suitcase'), ('hier', 'here'),
        ], 3),
    ],
    [
        gaps('mein or meine?', 'Write mein or meine.', [
            ('Das ist', 'Vater.', 'mein'), ('', 'Mutter heißt Gisela.', 'Meine'),
            ('', 'Hund heißt Rocky.', 'Mein'), ('Das sind', 'Eltern.', 'meine'),
            ('Wo ist', 'Tasche?', 'meine'), ('Das ist', 'Haus.', 'mein'),
        ]),
        write('Whose is it?', 'Write the owner’s word and the thing.', [
            ('Lena · der Hund', 'ihr Hund'),
            ('Max · die Jacke', 'seine Jacke'),
            ('wir · das Auto', 'unser Auto'),
            ('ihr · die Lehrerin', 'eure Lehrerin'),
            ('Herr Braun · der Koffer', 'sein Koffer'),
            ('Anna und Tom · die Kinder', 'ihre Kinder'),
        ], 2),
        circle('Which one?', 'Circle the right word.', [
            ('Herr Braun, ist das', ['Ihr', 'sein'], 'Koffer?', 'Ihr'),
            ('Kinder, wo ist', ['eure', 'unsere'], 'Lehrerin?', 'eure'),
            ('Wir wohnen hier. Das ist', ['unser', 'euer'], 'Haus.', 'unser'),
            ('Ich suche', ['mein', 'meinen'], 'Schlüssel.', 'meinen'),
            ('Hast du', ['dein', 'deinen'], 'Handy?', 'dein'),
            ('Oma und', ['ihr', 'sein'], 'Hund trinken Kaffee.', 'ihr'),
        ]),
        gaps('My people', 'Write about two people in your life.', [
            ('Mein Freund heißt', '.'), ('Meine Freundin wohnt in', '.'),
        ], 'About you — check mein and meine against the table.'),
    ],
    ['say whose something is: mein, dein, sein, ihr …',
     'say our and your for more than one person',
     'ask a stranger politely: Ist das Ihr …?'],
))

# ---- 4 · mich, dich, ihn ---------------------------------------------------
spreads.append(spread(
    'pronomen', 'mich, dich, ihn', 'me, you, him: the person something happens to',
    'I see *him*, she loves *us*: the object people are a handful of small words — and only five are new.',
    Q + 'pronomen_akk',
    [
        table('Who does it — and to whom?', ['who does it', 'to whom', '~in English'], [
            ['ich', '*mich*', 'me'],
            ['du', '*dich*', 'you'],
            ['er', '*ihn*', 'him · it'],
            ['sie', 'sie', 'her · it'],
            ['es', 'es', 'it'],
            ['wir', '*uns*', 'us'],
            ['ihr', '*euch*', 'you (all of you)'],
            ['sie · Sie', 'sie · Sie', 'them · you (polite)'],
        ], 'Five new words: *mich, dich, ihn, uns, euch*. The rest stay as they are.'),
        cols(
            words('In a sentence', [
                ('Siehst du *mich*?', 'Can you see me?'),
                ('Ich liebe *dich*.', 'I love you.'),
                ('Ich kenne *ihn* nicht.', 'I don’t know him.'),
                ('Besuchst du *uns*?', 'Are you visiting us?'),
                ('Ich frage *euch* morgen.', 'I’ll ask you tomorrow.'),
            ], 1),
            arrow('ihn sits where den sits', [
                ('Lena', 'sieht', '*den* Hund', None),
                ('Sie', 'sieht', '*ihn*', None),
                ('Max', 'liebt', 'Lena', None),
                ('Er', 'liebt', '*sie*', None),
            ], note='er → *ihn*, der → *den*: the same n.'),
        ),
        {'kind': 'pairs', 'title': 'it follows the article', 'note': 'Things have a gender, so it can be *ihn* or *sie*.', 'rows': [
            {'a': 'der Schlüssel', 'b': 'Ich finde *ihn*.'},
            {'a': 'die Musik', 'b': 'Ich höre *sie*.'},
            {'a': 'das Buch', 'b': 'Ich lese *es*.'},
        ]},
        words('Words for the practice page', [
            ('kennen', 'to know (a person)'), ('lieben', 'to love'), ('besuchen', 'to visit'),
            ('finden', 'to find'), ('fragen', 'to ask'), ('schön', 'beautiful, nice'),
            ('toll', 'great'), ('weg', 'gone'),
        ], 4),
    ],
    [
        gaps('Who?', 'Write the word for the person in brackets.', [
            ('Ich bin hier! Siehst du', '? (ich)', 'mich'),
            ('Du bist toll. Ich liebe', '. (du)', 'dich'),
            ('Das ist Tom. Ich kenne', 'nicht. (er)', 'ihn'),
            ('Das ist Anna. Kennst du', '? (sie)', 'sie'),
            ('Wir sind in Berlin. Besuchst du', '? (wir)', 'uns'),
            ('Ihr seid hier? Ich frage', 'morgen. (ihr)', 'euch'),
        ]),
        circle('ihn, sie or es?', 'Circle the right word.', [
            ('Wo ist der Schlüssel? Ich finde', ['ihn', 'sie', 'es'], 'nicht.', 'ihn'),
            ('Die Musik ist toll. Ich höre', ['ihn', 'sie', 'es'], 'gern.', 'sie'),
            ('Das Buch ist gut. Ich lese', ['ihn', 'sie', 'es'], 'heute.', 'es'),
            ('Der Kuchen ist weg. Rocky hat', ['ihn', 'sie', 'es'], '.', 'ihn'),
            ('Die Lampe ist schön. Ich kaufe', ['ihn', 'sie', 'es'], '.', 'sie'),
            ('Wo ist mein Handy? Die Katze hat', ['ihn', 'sie', 'es'], '.', 'es'),
        ], 1),
        write('Say it shorter', 'Write the sentence again with mich, ihn, sie, es …', [
            ('Ich sehe den Hund.', 'Ich sehe ihn.'),
            ('Ich kaufe die Jacke.', 'Ich kaufe sie.'),
            ('Wir besuchen Oma und Opa.', 'Wir besuchen sie.'),
            ('Lena liebt Max.', 'Lena liebt ihn.'),
            ('Ich nehme das Fahrrad.', 'Ich nehme es.'),
        ], 1),
        gaps('Your people', 'Who do you love, who do you visit? Write two true sentences.', [
            ('Ich liebe', '.'), ('Morgen besuche ich', '.'),
        ], 'About you — a person, or mich, dich, ihn, sie, uns, euch.'),
    ],
    ['say me, you, him, us, you all',
     'say it for a thing — ihn, sie or es',
     'shorten a sentence with a pronoun'],
))

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
spreads.append(spread(
    'modalverben', 'können, müssen, möchten', 'What you can, must, want and would like to do',
    'Five small verbs that ask, offer, refuse and order — and they send the main verb to the very end.',
    Q + 'modalverben',
    [
        tiles('Five helpers', [
            ('können', 'can'), ('müssen', 'have to'), ('wollen', 'want'),
            ('möchten!', 'would like'), ('dürfen', 'may'),
        ], 5),
        table('ich and er are twins', ['who', 'können', 'müssen', 'wollen', 'möchten', 'dürfen'], [
            ['ich', '*kann*', '*muss*', '*will*', '*möchte*', '*darf*'],
            ['du', 'kannst', 'musst', 'willst', 'möchtest', 'darfst'],
            ['er · sie · es', '*kann*', '*muss*', '*will*', '*möchte*', '*darf*'],
            ['wir', 'können', 'müssen', 'wollen', 'möchten', 'dürfen'],
            ['ihr', 'könnt', 'müsst', 'wollt', 'möchtet', 'dürft'],
            ['sie · Sie', 'können', 'müssen', 'wollen', 'möchten', 'dürfen'],
        ], 'No ending for ich and er — and the plural looks like the infinitive.'),
        slots('The bracket', [
            (sl('Ich', 'muss!', 'heute lange', 'arbeiten!'), 'I have to work late today.'),
            (sl('Tom', 'will!', 'heute', 'Fußball spielen!'), 'Tom wants to play football today.'),
            (sl('Die Katze', 'darf!', 'nicht auf dem Tisch', 'schlafen!'), 'The cat may not sleep on the table.'),
            (sl('Kannst!', 'du', 'gut', 'kochen!'), 'Can you cook well?'),
        ], head=['', 'helper', '', 'the verb, at the end'],
            note='The helper takes place 2; the real verb waits at the end.'),
        box('tip', 'möchten in a shop',
            'In a shop or café always say *möchten*: Ich *möchte* einen Kaffee. *Ich will* sounds like a demand.'),
        words('Words for the practice page', [
            ('krank', 'ill'), ('schwimmen', 'to swim'), ('rauchen', 'to smoke'),
            ('immer', 'always'), ('leider', 'unfortunately'), ('zu Hause bleiben', 'to stay at home'),
            ('bitte', 'please'), ('jetzt', 'now'), ('sehr', 'very'),
        ], 3),
    ],
    [
        gaps('The right form', 'Write the helper in the right form.', [
            ('Ich', 'leider nicht kommen. (können)', 'kann'),
            ('Tom ist krank. Er', 'zu Hause bleiben. (müssen)', 'muss'),
            ('', 'du schwimmen? (können)', 'Kannst'),
            ('Wir', 'morgen nach Berlin fahren. (wollen)', 'wollen'),
            ('Hier', 'man nicht rauchen. (dürfen)', 'darf'),
            ('Rocky', 'immer Kuchen essen. (wollen)', 'will'),
        ]),
        write('Build the bracket', 'Write the sentence: helper second, the real verb at the end.', [
            ('ich · müssen · heute arbeiten', 'Ich muss heute arbeiten.'),
            ('du · können · gut kochen', 'Du kannst gut kochen.'),
            ('Lena · wollen · Deutsch lernen', 'Lena will Deutsch lernen.'),
            ('die Katze · dürfen · nicht auf dem Tisch schlafen', 'Die Katze darf nicht auf dem Tisch schlafen.'),
        ], 1),
        circle('Which helper?', 'Circle the right word.', [
            ('Hier', ['darf', 'muss'], 'man nicht rauchen.', 'darf'),
            ('', ['Kannst', 'Musst'], 'du schwimmen? – Ja, sehr gut!', 'Kannst'),
            ('Es ist acht Uhr. Ich', ['muss', 'darf'], 'jetzt arbeiten.', 'muss'),
            ('Guten Tag, ich', ['möchte', 'will'], 'einen Tee, bitte.', 'möchte'),
        ]),
        gaps('And you?', 'Write two true sentences.', [
            ('Ich kann gut', '.'), ('Heute muss ich', '.'),
        ], 'About you — the real verb goes at the end.'),
    ],
    ['say what I can, must, want and may do',
     'put the real verb at the end',
     'order politely with möchten'],
))

# ---- 6 · Wie spät ist es? ---------------------------------------------------
spreads.append(spread(
    'uhrzeit', 'Wie spät ist es?', 'Telling the time',
    'Hear halb acht and know it means 7:30 — and never turn up an hour late again.',
    Q + 'uhrzeit',
    [
        clock('Around the clock', [
            ('07:00', 'sieben Uhr'), ('08:15', 'Viertel nach acht'), ('09:30!', 'halb zehn'),
            ('10:45', 'Viertel vor elf'), ('10:05', 'fünf nach zehn'), ('07:50', 'zehn vor acht'),
            ('14:30!', 'halb drei'), ('13:00', 'ein Uhr'),
        ], dial=True, ncols=4, note='Minutes first: fünf nach zehn is 10:05.'),
        cols(
            box('watch', 'halb looks forward',
                '*halb zehn* is 9:30 — half way *to* ten. The hour after halb is the one you are heading for: halb acht = 7:30.'),
            table('Stations, tickets, the radio', ['~on the board', 'you hear'], [
                ['14:30', 'vierzehn Uhr dreißig'],
                ['09:15', 'neun Uhr fünfzehn'],
                ['20:45', 'zwanzig Uhr fünfundvierzig'],
                ['01:00', 'ein Uhr'],
            ], 'Read the digits as they are — never wrong.'),
        ),
        tiles('Which eight?', [
            ('morgens', 'in the morning'), ('mittags', 'at midday'), ('nachmittags', 'in the afternoon'),
            ('abends', 'in the evening'), ('nachts', 'at night'),
        ], 5, note='acht Uhr *morgens* or acht Uhr *abends* — in speech, the clock has only twelve hours.'),
        words('Asking and answering', [
            ('Wie spät ist es?', 'What time is it?'), ('Es ist halb drei.', 'It’s half past two.'),
            ('Um wie viel Uhr?', 'At what time?'), ('Um acht.', 'At eight.'),
            ('Der Film beginnt um neun.', 'The film starts at nine.'), ('die Minute', 'minute'),
        ], 2),
    ],
    [
        clocks_ex('What time is it?', 'Write the time in words.', [
            ('08:15', 'Viertel nach acht'), ('09:30', 'halb zehn'),
            ('10:45', 'Viertel vor elf'), ('06:30', 'halb sieben'),
        ]),
        clocks_ex('Draw the hands', 'Draw the short and the long hand.', [
            ('02:10', 'zehn nach zwei'), ('07:30', 'halb acht'),
            ('11:45', 'Viertel vor zwölf'), ('07:55', 'fünf vor acht'),
        ], draw=True),
        match('Board and clock', 'Draw a line from the board time to the clock time.', [
            ('14:30', 'halb drei'), ('20:15', 'Viertel nach acht'),
            ('18:45', 'Viertel vor sieben'), ('13:00', 'ein Uhr'),
        ], [2, 0, 3, 1]),
        gaps('Your day', 'Write two times from your day.', [
            ('Mein Tag beginnt um', '.'), ('Um', 'esse ich.'),
        ], 'About you — check halb against the clocks on the left.'),
    ],
    ['ask and say what time it is',
     'understand halb, Viertel, nach and vor',
     'read the times on a board'],
))

# ---- 7 · Tage, Monate & wann? -----------------------------------------------
spreads.append(spread(
    'datum', 'Tage, Monate & wann?', 'Days, months — and am, im, um',
    'Name any day or month, and say exactly when: um acht, am Montag, im Mai.',
    Q + 'datum',
    [
        tiles('Die Woche', [
            ('Mo', 'Montag'), ('Di', 'Dienstag'), ('Mi', 'Mittwoch'), ('Do', 'Donnerstag'),
            ('Fr', 'Freitag'), ('Sa!', 'Samstag'), ('So!', 'Sonntag'),
        ], 7, note='All der-words: *der* Montag.'),
        tiles('Das Jahr', [
            ('1', 'Januar'), ('2', 'Februar'), ('3', 'März'), ('4', 'April'), ('5', 'Mai'), ('6', 'Juni'),
            ('7', 'Juli'), ('8', 'August'), ('9', 'September'), ('10', 'Oktober'), ('11', 'November'), ('12', 'Dezember'),
        ], 6, note='der Frühling · der Sommer · der Herbst · der Winter'),
        table('um, am, im', ['', '~for', 'like this'], [
            ['*um*', 'clock time', 'um acht · um halb drei'],
            ['*am*', 'a day, a part of the day', 'am Montag · am Abend · am Wochenende'],
            ['*im*', 'a month, a season', 'im Mai · im Sommer'],
        ], 'Remember *am* = an dem, *im* = in dem from Wo?'),
        words('Words for the practice page', [
            ('der Frühling · der Sommer', 'spring · summer'), ('der Herbst · der Winter', 'autumn · winter'),
            ('das Wochenende', 'weekend'), ('die Woche', 'week'),
            ('der Geburtstag', 'birthday'), ('die Pizza', 'pizza'), ('das Geld', 'money'),
        ], 3),
    ],
    [
        write('What comes next?', 'Write the next day or month.', [
            ('Montag, Dienstag, …', 'Mittwoch'), ('Freitag, Samstag, …', 'Sonntag'),
            ('Januar, Februar, …', 'März'), ('Juni, Juli, …', 'August'),
            ('Oktober, November, …', 'Dezember'), ('Mittwoch, Donnerstag, …', 'Freitag'),
        ], 2),
        gaps('um, am or im?', 'Write um, am or im.', [
            ('Ich komme', 'Montag.', 'am'), ('Der Film beginnt', 'acht Uhr.', 'um'),
            ('', 'Juli fahren wir nach Spanien.', 'Im'), ('', 'Wochenende schlafe ich lange.', 'Am'),
            ('Mein Geburtstag ist', 'Mai.', 'im'), ('Wir essen', 'halb eins.', 'um'),
        ]),
        gaps('Anna calls Tom', 'Listen to Anna’s message and fill in the notes.', [
            ('Tag:', '', 'Samstag'), ('Kino: um', '', 'halb acht'),
            ('Pizza: um', '', 'sieben Uhr'), ('Geld:', 'Euro', 'zwanzig'),
        ]) | {'listen': True},
        gaps('Your year', 'Write two true sentences.', [
            ('Mein Geburtstag ist im', '.'), ('Am Wochenende', '.'),
        ], 'About you.'),
    ],
    ['name the days and the months',
     'say when with um, am and im',
     'take notes from a phone message'],
    listen=Q + 'hoeren_termine',
))

# ---- Review 1 · topics 1–7 ---------------------------------------------------
spreads.append({
    'id': 'review_1', 'review': True, 'title': 'Wiederholung', 'subtitle': 'Topics 1–7',
    'hook': 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    'quiz': Q + 'sprechen_kurzcheck',
    'learn': [],
    'left': [
        circle('den, kein, mein …', 'Circle the right word.', [
            ('Ich sehe', ['der', 'den'], 'Bus.', 'den'),
            ('Wir haben', ['kein', 'keinen'], 'Hund.', 'keinen'),
            ('Lena sucht', ['ihr', 'ihre'], 'Tasche.', 'ihre'),
            ('Ich finde den Schlüssel nicht. Hast du', ['ihn', 'sie'], '?', 'ihn'),
            ('Das ist', ['nicht', 'kein'], 'teuer.', 'nicht'),
            ('Herr Braun, ist das', ['Ihr', 'ihr'], 'Koffer?', 'Ihr'),
        ]),
        write('Nein!', 'Answer with nein and a whole sentence.', [
            ('Hast du ein Auto?', 'Nein, ich habe kein Auto.'),
            ('Ist der Kaffee gut?', 'Nein, der Kaffee ist nicht gut.'),
            ('Siehst du Max?', 'Nein, ich sehe ihn nicht.'),
        ], 1),
        clocks_ex('What time is it?', 'Write the time in words.', [
            ('03:30', 'halb vier'), ('12:15', 'Viertel nach zwölf'),
            ('05:45', 'Viertel vor sechs'), ('09:10', 'zehn nach neun'),
        ]),
    ],
    'practise': [
        gaps('Helpers', 'Write the helper in the right form.', [
            ('', 'du morgen kommen? (können)', 'Kannst'),
            ('Ich', 'heute lange arbeiten. (müssen)', 'muss'),
            ('Wir', 'zwei Kaffee, bitte. (möchten)', 'möchten'),
            ('Die Kinder', 'nicht im Park spielen. (dürfen)', 'dürfen'),
        ]),
        match('Question and answer', 'Draw a line from each question to its answer.', [
            ('Wie spät ist es?', 'Halb drei.'),
            ('Wann hast du Geburtstag?', 'Im Mai.'),
            ('Kommst du am Montag?', 'Nein, am Dienstag.'),
            ('Wo ist mein Handy?', 'Die Katze hat es.'),
            ('Möchten Sie einen Tee?', 'Nein, danke.'),
        ], [2, 4, 0, 3, 1]),
        write('Say it shorter', 'Write it again with ihn, sie or es.', [
            ('Ich kaufe den Tisch.', 'Ich kaufe ihn.'),
            ('Wir besuchen Lena.', 'Wir besuchen sie.'),
            ('Max nimmt das Brot.', 'Max nimmt es.'),
        ], 1),
    ],
    'canDo': [],
})

def tags_ex(title, instruction, items, unit=None):
    ex = {'title': title, 'instruction': instruction, 'kind': 'tags'}
    if unit:
        ex['unit'] = unit
    ex['items'] = [{'image': i, 'label': l, 'answer': a} for i, l, a in items]
    return ex


# ---- 8 · Mein Tag ------------------------------------------------------------
spreads.append(spread(
    'trennbare', 'Mein Tag', 'aufstehen, einkaufen, anrufen: verbs that split',
    'The verbs of an ordinary day come in two parts — and the front part waits at the end of the sentence.',
    Q + 'trennbare',
    [
        build('Two parts, one verb', [
            ([('auf', 'suffix'), 'stehen'], 'aufstehen', 'to get up'),
            ([('ein', 'suffix'), 'kaufen'], 'einkaufen', 'to go shopping'),
            ([('an', 'suffix'), 'rufen'], 'anrufen', 'to call (on the phone)'),
            ([('fern', 'suffix'), 'sehen'], 'fernsehen', 'to watch TV'),
            ([('mit', 'suffix'), 'bringen'], 'mitbringen', 'to bring along'),
            ([('ein', 'suffix'), 'schlafen'], 'einschlafen', 'to fall asleep'),
            ([('auf', 'suffix'), 'machen'], 'aufmachen', 'to open'),
            ([('zu', 'suffix'), 'machen'], 'zumachen', 'to close'),
        ], 'You hear the front part loud: AUFstehen, EINkaufen.'),
        slots('The front part goes to the end', [
            (sl('Ich', 'stehe!', 'um sieben', 'auf!'), 'I get up at seven.'),
            (sl('Lena', 'kauft!', 'heute', 'ein!'), 'Lena goes shopping today.'),
            (sl('Ich', 'rufe!', 'dich morgen', 'an!'), 'I’ll call you tomorrow.'),
            (sl('Ich', 'muss!', 'um sieben', 'aufstehen!'), 'With a helper, the verb stays whole.'),
        ], hot=[]),
        clock('Lena’s day', [
            ('06:30', 'Lena steht auf.'), ('12:30', 'Sie ruft Oma an.'),
            ('18:00', 'Sie kauft ein.'), ('22:00!', 'Sie sieht fern — und schläft ein.'),
        ], ncols=4),
        words('Words for the practice page', [
            ('das Licht', 'light'), ('kalt', 'cold'), ('dunkel', 'dark'),
            ('jeden Tag', 'every day'), ('sofort', 'at once'),
        ], 3),
    ],
    [
        write('Split it', 'Write the sentence. The front part goes to the end.', [
            ('aufstehen · ich · um sieben', 'Ich stehe um sieben auf.'),
            ('einkaufen · wir · am Samstag', 'Wir kaufen am Samstag ein.'),
            ('anrufen · Lena · ihre Oma', 'Lena ruft ihre Oma an.'),
            ('fernsehen · Opa · jeden Tag', 'Opa sieht jeden Tag fern.'),
            ('einschlafen · der Hund · sofort', 'Der Hund schläft sofort ein.'),
        ], 1),
        gaps('The front part', 'Write the missing front part.', [
            ('Ich rufe dich morgen', '.', 'an'), ('Es ist kalt. Machst du bitte das Fenster', '?', 'zu'),
            ('Ich bringe einen Kuchen', '.', 'mit'), ('Wann stehst du', '?', 'auf'),
            ('Wir kaufen heute', '.', 'ein'), ('Es ist dunkel. Machst du bitte das Licht', '?', 'an'),
        ]),
        write('With a helper', 'Write it again with the helper. The verb stays whole, at the end.', [
            ('Ich stehe um sieben auf. (müssen)', 'Ich muss um sieben aufstehen.'),
            ('Wir kaufen heute ein. (wollen)', 'Wir wollen heute einkaufen.'),
            ('Rufst du mich an? (können)', 'Kannst du mich anrufen?'),
        ], 1),
        gaps('Your day', 'Write two true sentences.', [
            ('Ich stehe um', 'auf.'), ('Am Abend', '.'),
        ], 'About you — the front part at the end.'),
    ],
    ['say what I do every day with verbs that split',
     'put the front part at the end',
     'keep the verb whole after a helper'],
))

# ---- 9 · für, ohne, gegen … ---------------------------------------------------
spreads.append(spread(
    'praepositionen', 'für, ohne, gegen …', 'Five little words that always take den',
    'Five short words, one rule: after them, a der-word becomes den — every time.',
    Q + 'praepositionen',
    [
        tiles('durch · für · gegen · ohne · um', [
            ('durch', 'through'), ('für!', 'for'), ('gegen', 'against'), ('ohne!', 'without'), ('um', 'around'),
        ], 5, note='Say it like a song, five beats.'),
        table('After them: den', ['~', 'der', 'die', 'das', 'plural'], [
            ['für', 'für *den* Mann', 'für die Frau', 'für das Kind', 'für die Kinder'],
            ['ohne', 'ohne *den* Hund', 'ohne die Tasche', 'ohne das Auto', 'ohne die Kinder'],
        ], 'Only the der column changes — like the object in topic 1. Also *einen, keinen, meinen*.', genders=True),
        cols(
            words('In a sentence', [
                ('Das Geschenk ist für dich.', 'The present is for you.'),
                ('Wir gehen durch den Park.', 'We walk through the park.'),
                ('Kaffee ohne Milch, bitte.', 'Coffee without milk, please.'),
                ('Wir sitzen um den Tisch.', 'We sit around the table.'),
                ('Ich habe nichts gegen den Plan.', 'I’ve nothing against the plan.'),
            ], 1),
            box('tip', 'Also mich, dich, ihn',
                'The same rule for people: für *mich*, ohne *dich*, gegen *ihn*. And *um acht* is the clock — no article at all.'),
        ),
        words('Words for the practice page', [
            ('das Geschenk', 'present'), ('die Milch', 'milk'), ('der Zucker', 'sugar'),
            ('der Plan', 'plan'), ('nichts', 'nothing'), ('laufen · er läuft', 'to run'),
        ], 3),
    ],
    [
        gaps('den, die or das?', 'Write the article.', [
            ('Das Geschenk ist für', 'Mann.', 'den'), ('Wir gehen durch', 'Park.', 'den'),
            ('Der Kuchen ist für', 'Mutter.', 'die'), ('Ohne', 'Regenschirm gehe ich nicht.', 'den'),
            ('Rocky läuft um', 'Tisch.', 'den'), ('Das ist ein Geschenk für', 'Kind.', 'das'),
        ]),
        circle('Which little word?', 'Circle the right word.', [
            ('Kaffee', ['ohne', 'für'], 'Zucker, bitte.', 'ohne'),
            ('Der Kaffee ist', ['für', 'gegen'], 'dich.', 'für'),
            ('Wir gehen', ['durch', 'ohne'], 'den Park.', 'durch'),
            ('Ich habe nichts', ['gegen', 'um'], 'den Plan.', 'gegen'),
            ('Der Hund läuft', ['um', 'für'], 'den Baum.', 'um'),
            ('Ich gehe nicht', ['ohne', 'durch'], 'meinen Regenschirm.', 'ohne'),
        ]),
        gaps('For you, without you', 'Write the right word: mich, dich, ihn …', [
            ('Das Geschenk ist für', '. (du)', 'dich'), ('Ohne', 'gehe ich nicht. (er)', 'ihn'),
            ('Ist der Kaffee für', '? (ich)', 'mich'), ('Wir spielen gegen', '. (ihr)', 'euch'),
        ]),
        gaps('Your way', 'Write two true sentences.', [
            ('Ich trinke Kaffee ohne', '.'), ('Ich kaufe ein Geschenk für', '.'),
        ], 'About you — a der-word takes den.'),
    ],
    ['remember the five little words',
     'use den after them',
     'say for me, without you, against him'],
))

# ---- 10 · Wohin? --------------------------------------------------------------
spreads.append(spread(
    'wohin', 'Wohin?', 'nach, zu, in — where you are going',
    'To Berlin, to the cinema, to the doctor, to grandma’s: three small words, and a picture tells you which.',
    Q + 'wohin',
    [
        cols(
            flow('nach, in or zu?', q('A town or a country?',
                                       a('nach', 'nach Berlin'),
                                       q('Going inside?', a('in', 'ins Kino'), a('zu', 'zum Arzt')))),
            build('Two words become one', [
                (['in', ('das', 'joint')], 'ins', 'ins Kino'),
                (['zu', ('dem', 'joint')], 'zum', 'zum Bahnhof'),
                (['zu', ('der', 'joint')], 'zur', 'zur Arbeit'),
            ], 'Like im and am.'),
        ),
        table('Wo? or Wohin?', ['Wo? you are there', 'Wohin? you are going there'], [
            ['Ich bin *im* Kino.', 'Ich gehe *ins* Kino.'],
            ['Ich bin *in der* Stadt.', 'Ich gehe *in die* Stadt.'],
            ['Ich bin *im* Park.', 'Ich gehe *in den* Park.'],
            ['Ich bin *beim* Arzt.', 'Ich gehe *zum* Arzt.'],
            ['Ich bin *zu* Hause.', 'Ich gehe *nach* Hause.'],
        ], 'Going somewhere, in takes den, die, das — the object again.'),
        box('watch', 'Countries with an article',
            '*nach* Spanien, *nach* Deutschland — but die Schweiz, die Türkei and die USA take *in die*: Wir fliegen *in die* Schweiz.'),
        words('Words for the practice page', [
            ('gehen', 'to go, walk'), ('fliegen', 'to fly'), ('der Zug', 'train'), ('das Gleis', 'platform'),
            ('die Arbeit', 'work'), ('der Supermarkt', 'supermarket'), ('spät', 'late'), ('die Abfahrt', 'departure'),
        ], 4),
    ],
    [
        gaps('nach, ins or zum?', 'Write the right word.', [
            ('Wir fahren morgen', 'Berlin.', 'nach'), ('Heute Abend gehen wir', 'Kino.', 'ins'),
            ('Ich bin krank. Ich muss', 'Arzt.', 'zum'), ('Es ist spät. Ich gehe', 'Hause.', 'nach'),
            ('Am Samstag fahre ich', 'Anna.', 'zu'), ('Wir fliegen im Juli', 'Spanien.', 'nach'),
        ]),
        circle('Wo? or Wohin?', 'Circle the right word.', [
            ('Ich bin', ['im', 'ins'], 'Kino.', 'im'), ('Ich gehe', ['im', 'ins'], 'Kino.', 'ins'),
            ('Wir sind', ['zu', 'nach'], 'Hause.', 'zu'), ('Wir gehen', ['zu', 'nach'], 'Hause.', 'nach'),
            ('Lena ist', ['beim', 'zum'], 'Arzt.', 'beim'), ('Lena geht', ['beim', 'zum'], 'Arzt.', 'zum'),
        ]),
        gaps('At the station', 'Listen to the announcement and fill in the notes.', [
            ('Zug nach München: Gleis', '', 'fünf'),
            ('Abfahrt: um', '', 'vierzehn Uhr dreißig'),
            ('Zug nach Hamburg: um', 'Uhr', 'fünfzehn'),
            ('Nach Berlin: nehmen Sie den', '', 'Bus'),
        ]) | {'listen': True},
    ],
    ['say where I am going: nach, in, zu',
     'tell Wo? from Wohin?',
     'understand an announcement at the station'],
    listen=Q + 'hoeren_bahnhof',
))

# ---- 11 · Im Café -------------------------------------------------------------
spreads.append(spread(
    'cafe', 'Im Café', 'Asking politely, ordering — and mir, dir, Ihnen',
    'Three polite chunks get you through every café, counter and phone call.',
    Q + 'hoeflich',
    [
        table('Three polite chunks', ['~you want', 'say', 'like this'], [
            ['a thing', 'Ich *hätte gern* …', 'Ich hätte gern einen Kaffee.'],
            ['someone to do something', '*Könnten Sie* …?', 'Könnten Sie mir helfen?'],
            ['to do something', 'Ich *würde gern* …', 'Ich würde gern bezahlen.'],
        ], '*Ich will* is a demand — never in a café.'),
        table('At the table', ['Kellner', 'Gast'], [
            ['Was möchten Sie?', 'Ich hätte gern ein Stück Kuchen.'],
            ['Und zu trinken?', 'Einen Kaffee mit Milch, bitte.'],
            ['Sonst noch etwas?', 'Nein, danke. Die Rechnung, bitte.'],
            ['Das macht vier Euro achtzig.', 'Fünf Euro. *Stimmt so.*'],
        ], 'Stimmt so: keep the change.'),
        cols(
            arrow('mir, dir, Ihnen', [
                ('Ich', 'helfe', '*dir*', None),
                ('Das Bild', 'gefällt', '*mir*', None),
                ('Ich', 'danke', '*Ihnen*', None),
            ], ask=('wer?', 'wem?'), note='After helfen, danken, gefallen.'),
            table('Who?', ['', 'to whom'], [
                ['ich', '*mir*'], ['du', '*dir*'], ['Sie', '*Ihnen*'],
            ], 'Wie geht es *dir*? — *Mir* geht es gut.'),
        ),
        words('Words for the practice page', [
            ('der Gast', 'guest'), ('die Rechnung', 'bill'), ('bezahlen', 'to pay'), ('helfen', 'to help'),
            ('das Glas', 'glass'), ('das Wasser', 'water'), ('gefallen', 'to please'), ('danken', 'to thank'),
        ], 4),
    ],
    [
        circle('Say it politely', 'Circle the polite one.', [
            ('Ich', ['hätte gern', 'will'], 'einen Kaffee.', 'hätte gern'),
            ('', ['Könnten Sie', 'Sie müssen'], 'mir helfen?', 'Könnten Sie'),
            ('Ich', ['würde gern', 'muss'], 'bezahlen.', 'würde gern'),
            ('', ['Könnte ich', 'Ich will'], 'die Rechnung haben?', 'Könnte ich'),
        ]),
        circle('In the café', 'Listen to the guest ordering. Circle what you hear.', [
            ('Der Gast nimmt', ['Apfelkuchen', 'Schokoladenkuchen'], '.', 'Apfelkuchen'),
            ('Er trinkt', ['einen Kaffee', 'einen Tee'], '.', 'einen Kaffee'),
            ('Mit', ['Milch und Zucker', 'Wasser'], '.', 'Milch und Zucker'),
            ('Das macht', ['4,80 €', '5,00 €'], '.', '4,80 €'),
        ]) | {'listen': True},
        gaps('mir, dir or Ihnen?', 'Write the word for the person in brackets.', [
            ('Wie geht es', '? (du)', 'dir'), ('', 'geht es gut, danke. (ich)', 'Mir'),
            ('Wie geht es', ', Frau Weber? (Sie)', 'Ihnen'), ('Kannst du', 'helfen? (ich)', 'mir'),
            ('Das Bild gefällt', '. (ich)', 'mir'), ('Ich danke', '! (Sie)', 'Ihnen'),
        ]),
        gaps('Your order', 'What would you like? Write it politely.', [
            ('Ich hätte gern', '.'),
        ], 'About you — einen before a der-word.'),
    ],
    ['order in a café politely',
     'ask someone to help me',
     'say mir, dir and Ihnen after helfen, danken, gefallen'],
    listen=Q + 'hoeren_cafe',
))

# ---- 12 · Einkaufen -----------------------------------------------------------
spreads.append(spread(
    'einkaufen', 'Einkaufen', 'Amounts, prices — and the big numbers',
    'A kilo of apples, a bottle of water, 585 Euro: market German is amounts and numbers.',
    Q + 'einkaufen_mengen',
    [
        table('Amount + thing — no “of”', ['~in English', 'in German'], [
            ['a kilo of apples', 'ein Kilo Äpfel'],
            ['500 g of cheese', '500 Gramm Käse · *ein Pfund* Käse'],
            ['a litre of milk', 'ein Liter Milch'],
            ['a bottle of water', 'eine Flasche Wasser'],
            ['a piece of cake', 'ein Stück Kuchen'],
            ['a cup of coffee', 'eine Tasse Kaffee'],
        ], 'Two bottles: zwei *Flaschen* — but zwei *Kilo*, drei *Stück*.'),
        build('Big numbers: read from the left', [
            (['sechs', ('hundert', 'suffix'), 'fünfzig'], 'sechshundertfünfzig', '650'),
            (['fünf', ('hundert', 'suffix'), 'fünfundachtzig'], 'fünfhundertfünfundachtzig', '585'),
            ([('tausend', 'suffix'), 'zwei', ('hundert', 'suffix')], 'tausendzweihundert', '1.200'),
            (['neunzehn', ('hundert', 'suffix'), 'achtundneunzig'], 'neunzehnhundertachtundneunzig', 'the year 1998'),
            (['zwei', ('tausend', 'suffix'), 'fünfundzwanzig'], 'zweitausendfünfundzwanzig', 'the year 2025'),
        ], 'All one word. Only the last two numbers flip.'),
        cols(
            table('At the market', ['seller', 'you'], [
                ['Was darf es sein?', 'Ich hätte gern ein Kilo Äpfel.'],
                ['Sonst noch etwas?', 'Ja, ein Pfund Käse.'],
                ['Ist das alles?', 'Ja, das ist alles.'],
                ['Das macht 4,50 €.', 'Hier, bitte.'],
            ]),
            box('watch', 'A full stop is not a decimal point',
                '1.200 is *tausendzweihundert*. A comma is the decimal point: 4,50 € is vier Euro fünfzig. And ein *Pfund* is 500 g.'),
        ),
        words('Words for the practice page', [
            ('kg · g', 'kilo · gram'), ('die Flasche, -n', 'bottle'), ('die Tasse, -n', 'cup'),
            ('der Liter', 'litre'), ('die Miete', 'rent'), ('alles', 'everything'), ('geboren', 'born'),
        ], 3),
    ],
    [
        tags_ex('At the market stall', 'Write the amount and the thing.', [
            ('cp_markt_aepfel', '1 kg', 'ein Kilo Äpfel'),
            ('cp_markt_kaese', '500 g', 'ein Pfund Käse'),
            ('cp_markt_eier', '10', 'zehn Eier'),
            ('cp_markt_kartoffeln', '2 kg', 'zwei Kilo Kartoffeln'),
        ]),
        write('Big numbers', 'Write them in words.', [
            ('585 €', 'fünfhundertfünfundachtzig Euro'),
            ('Miete: 980 €', 'neunhundertachtzig Euro'),
            ('1.200', 'tausendzweihundert'),
            ('geboren 1965', 'neunzehnhundertfünfundsechzig'),
        ], 2, not_german=False),
        match('At the market', 'Draw a line from the seller to your answer.', [
            ('Was darf es sein?', 'Ein Kilo Kartoffeln, bitte.'),
            ('Sonst noch etwas?', 'Nein, danke.'),
            ('Das macht drei Euro.', 'Hier, bitte.'),
            ('Ist das alles?', 'Ja, das ist alles.'),
        ], [2, 0, 3, 1]),
        gaps('Your shopping', 'Write what you buy this week.', [
            ('Ich kaufe', '.'), ('Das kostet', 'Euro.'),
        ], 'About you — no “of”: ein Kilo Äpfel.'),
    ],
    ['buy amounts: ein Kilo, eine Flasche, ein Stück',
     'say and understand prices',
     'read big numbers and years'],
))

# ---- 13 · Mach das! ------------------------------------------------------------
spreads.append(spread(
    'imperativ', 'Mach das!', 'Telling people what to do',
    'Komm! Kommt! Kommen Sie! — one verb, three people, and the verb goes first.',
    Q + 'imperativ',
    [
        table('One verb, three people', ['~to', 'kommen', 'nehmen', 'warten', 'sein'], [
            ['a friend (du)', '*Komm!*', '*Nimm!*', '*Warte!*', '*Sei* leise!'],
            ['friends (ihr)', '*Kommt!*', '*Nehmt!*', '*Wartet!*', '*Seid* leise!'],
            ['a stranger (Sie)', '*Kommen Sie!*', '*Nehmen Sie!*', '*Warten Sie!*', '*Seien Sie* leise!'],
        ], 'ihr: the ihr-form without ihr. Sie: the infinitive, then Sie.'),
        cols(
            build('du: drop du and -st', [
                (['komm', ('st', 'cut')], 'Komm!', 'du kommst'),
                (['nimm', ('st', 'cut')], 'Nimm!', 'du nimmst'),
                (['sprich', ('st', 'cut')], 'Sprich!', 'du sprichst'),
                (['schlaf', ('st', 'cut')], 'Schlaf!', 'du schläfst — the ä goes too'),
                (['iss', ('t', 'cut')], 'Iss!', 'du isst'),
            ], 'An e at the end is fine too: Warte! Mache!'),
            slots('The verb goes first', [
                (sl('Komm!', 'bitte', 'her!'), None),
                (sl('Nimm!', 'den Bus!'), None),
                (sl('Warten Sie!', 'bitte', 'hier!'), None),
            ]),
        ),
        cols(
            box('tip', 'bitte makes it friendly',
                'Komm *bitte*! Warten Sie *bitte*! Without bitte an order sounds sharp — except to a dog.'),
            box('culture', 'German dogs know the du-form',
                '*Sitz!* *Platz!* *Bleib!* *Aus!* Every German dog learns four imperatives — and ignores them in the park.'),
        ),
        words('Words for the practice page', [
            ('her', 'here (to me)'), ('leise', 'quietly'), ('langsam', 'slowly'), ('schnell', 'fast'),
            ('das Baby', 'baby'), ('Platz nehmen', 'to take a seat'), ('ins Bett', 'to bed'), ('Sitz!', 'Sit! (to a dog)'),
        ], 4),
    ],
    [
        gaps('To a friend', 'Write the du-form.', [
            ('', 'bitte her, Tom! (kommen)', 'Komm'), ('', 'den Bus, er ist schnell! (nehmen)', 'Nimm'),
            ('', 'dein Brot, Lena! (essen)', 'Iss'), ('', 'bitte langsam! (sprechen)', 'Sprich'),
            ('', 'gut, Max! (schlafen)', 'Schlaf'), ('', 'bitte leise, das Baby schläft! (sein)', 'Sei'),
        ]),
        write('Three people', 'Write it for a friend, for friends and for a stranger.', [
            ('warten', 'Warte! · Wartet! · Warten Sie!'),
            ('kommen', 'Komm! · Kommt! · Kommen Sie!'),
            ('nehmen', 'Nimm! · Nehmt! · Nehmen Sie!'),
        ], 1),
        circle('Who is it for?', 'Circle the right form.', [
            ('Kinder,', ['geht', 'geh'], 'jetzt bitte ins Bett!', 'geht'),
            ('Herr Braun,', ['nehmen Sie', 'nimm'], 'bitte Platz!', 'nehmen Sie'),
            ('Tom,', ['iss', 'esst'], 'dein Brot!', 'iss'),
            ('Rocky,', ['sitz', 'sitzt'], '!', 'sitz'),
        ]),
    ],
    ['tell a friend, friends and a stranger what to do',
     'make the du-form from du nimmst, du sprichst',
     'make an order friendly with bitte'],
))

# ---- 14 · Was war gestern? ----------------------------------------------------
spreads.append(spread(
    'war_hatte', 'Was war gestern?', 'war and hatte — your first past',
    'Two short words — war and hatte — and you can talk about yesterday, last week, your whole weekend.',
    Q + 'war_hatte',
    [
        table('sein → war, haben → hatte', ['who', 'war', 'hatte'], [
            ['ich', '*war*', '*hatte*'],
            ['du', 'warst', 'hattest'],
            ['er · sie · es', '*war*', '*hatte*'],
            ['wir', 'waren', 'hatten'],
            ['ihr', 'wart', 'hattet'],
            ['sie · Sie', 'waren', 'hatten'],
        ], 'ich and er are twins again — like the helpers in topic 5.'),
        slots('Yesterday comes first', [
            (sl('Gestern', 'war!', 'ich', 'krank.'), 'Yesterday I was ill.'),
            (sl('Ich', 'hatte!', 'Fieber', '— und keinen Tee.'), 'I had a temperature — and no tea.'),
            (sl('Letzte Woche', 'waren!', 'wir', 'in Wien.'), 'Last week we were in Vienna.'),
        ], hot=[1]),
        cols(
            box('watch', 'Say war, not bin gewesen',
                'In speech Germans say *ich war* and *ich hatte* — not ich bin gewesen, ich habe gehabt. These two are the exception.'),
            words('When?', [
                ('gestern', 'yesterday'), ('vorgestern', 'the day before yesterday'),
                ('letzte Woche', 'last week'), ('am Wochenende', 'at the weekend'),
            ], 1),
        ),
        words('Words for the practice page', [
            ('das Fieber', 'temperature'), ('der Urlaub', 'holiday'), ('das Wetter', 'weather'),
            ('die Party', 'party'), ('der Spaß', 'fun'), ('der Deutschkurs', 'German class'), ('schon', 'already, yet'),
        ], 3),
    ],
    [
        gaps('war', 'Write the right form of war.', [
            ('Gestern', 'ich krank.', 'war'), ('Wo', 'du am Wochenende?', 'warst'),
            ('Das Wetter', 'sehr schön.', 'war'), ('Wir', 'letzte Woche in Wien.', 'waren'),
            ('', 'ihr schon in Berlin?', 'Wart'), ('Wie', 'Ihr Urlaub, Frau Weber?', 'war'),
        ]),
        gaps('hatte', 'Write the right form of hatte.', [
            ('Ich', 'gestern keine Zeit.', 'hatte'), ('', 'du am Montag Deutschkurs?', 'Hattest'),
            ('Wir', 'viel Spaß auf der Party.', 'hatten'), ('Rocky', 'gestern Hunger.', 'hatte'),
        ]),
        circle('war or hatte?', 'Circle the right word.', [
            ('Gestern', ['war', 'hatte'], 'ich müde.', 'war'),
            ('Ich', ['war', 'hatte'], 'Fieber.', 'hatte'),
            ('Wir', ['waren', 'hatten'], 'im Kino.', 'waren'),
            ('Die Kinder', ['waren', 'hatten'], 'Hunger.', 'hatten'),
        ]),
        gaps('Your yesterday', 'Write two true sentences.', [
            ('Gestern war ich', '.'), ('Letzte Woche hatte ich', '.'),
        ], 'About you.'),
    ],
    ['say where I was and how I was',
     'say what I had',
     'use war and hatte, not bin gewesen'],
))

# ---- 15 · Ich habe gespielt ------------------------------------------------------
spreads.append(spread(
    'perfekt', 'Ich habe gespielt', 'Your first past tense with every verb',
    'What did you do yesterday? haben in second place, the past form at the very end — the bracket again.',
    Q + 'perfekt_intro',
    [
        slots('The bracket again', [
            (sl('Ich', 'habe!', 'gestern Pizza', 'gegessen!'), 'I ate pizza yesterday.'),
            (sl('Lena', 'hat!', 'lange', 'geschlafen!'), 'Lena slept for a long time.'),
            (sl('Wir', 'sind!', 'nach Berlin', 'gefahren!'), 'We went to Berlin.'),
            (sl('Was', 'hast!', 'du am Sonntag', 'gemacht!'), 'What did you do on Sunday?'),
        ], head=['', 'haben / sein', '', 'the past form, at the end']),
        cols(
            build('Making the past form', [
                ([('ge', 'suffix'), 'mach', ('t', 'suffix')], 'gemacht', 'machen'),
                ([('ge', 'suffix'), 'lern', ('t', 'suffix')], 'gelernt', 'lernen'),
                ([('ge', 'suffix'), 'arbeit', ('et', 'suffix')], 'gearbeitet', 'arbeiten'),
                ([('ge', 'suffix'), 'schlaf', ('en', 'suffix')], 'geschlafen', 'schlafen'),
                ([('ge', 'suffix'), 'gess', ('en', 'suffix')], 'gegessen', 'essen'),
                ([('ge', 'suffix'), 'trunk', ('en', 'suffix')], 'getrunken', 'trinken'),
            ], 'Most verbs: ge- … -t. Some: ge- … -en — learn those as words.'),
            flow('haben or sein?', q('fahren, gehen, fliegen, bleiben?',
                                     a('sein', 'ich bin gefahren'), a('haben', 'ich habe gegessen'))),
        ),
        box('watch', 'No ge- here',
            'Verbs ending in -ieren and verbs starting with ver- or be- take no ge-: Was ist *passiert*? Ich habe das nicht *verstanden*.'),
        words('More past forms', [
            ('gespielt', 'played'), ('gekauft', 'bought'), ('gesehen', 'seen'), ('gelesen', 'read'),
            ('gegangen', 'gone, walked'), ('geblieben', 'stayed'), ('passiert', 'happened'), ('verstanden', 'understood'),
        ], 4),
    ],
    [
        gaps('The past form', 'Write the past form of the verb in brackets.', [
            ('Ich habe Pizza', '. (essen)', 'gegessen'), ('Wir haben Fußball', '. (spielen)', 'gespielt'),
            ('Lena hat Deutsch', '. (lernen)', 'gelernt'), ('Der Hund hat heute lange', '. (schlafen)', 'geschlafen'),
            ('Hast du den Film', '? (sehen)', 'gesehen'), ('Ich habe zu viel Kaffee', '. (trinken)', 'getrunken'),
        ]),
        circle('haben or sein?', 'Circle the right helper.', [
            ('Ich', ['habe', 'bin'], 'nach Hamburg gefahren.', 'bin'),
            ('Wir', ['haben', 'sind'], 'Kuchen gegessen.', 'haben'),
            ('Lena', ['hat', 'ist'], 'zu Hause geblieben.', 'ist'),
            ('Was', ['hat', 'ist'], 'passiert?', 'ist'),
            ('Max', ['hat', 'ist'], 'ein Buch gelesen.', 'hat'),
        ]),
        write('Yesterday', 'Write it in the past.', [
            ('Ich arbeite lange.', 'Ich habe lange gearbeitet.'),
            ('Wir kaufen ein Auto.', 'Wir haben ein Auto gekauft.'),
            ('Tom fährt nach Wien.', 'Tom ist nach Wien gefahren.'),
        ], 1),
        gaps('Your weekend', 'Write two true sentences.', [
            ('Am Wochenende habe ich', '.'), ('Gestern bin ich', '.'),
        ], 'About you — the past form at the end.'),
    ],
    ['say what I did yesterday',
     'make the past form: gemacht, gegessen',
     'choose between haben and sein'],
))

# ---- 16 · Satzbau ---------------------------------------------------------------
spreads.append(spread(
    'satzbau', 'Satzbau', 'Verb in second place — und, aber, denn',
    'One rule builds every German sentence: the verb comes second. Four little words join two sentences without breaking it.',
    Q + 'satzbau',
    [
        slots('Anything first — the verb second', [
            (sl('', 'Ich', 'fahre!', 'morgen nach Berlin.'), None),
            (sl('', 'Morgen', 'fahre!', 'ich nach Berlin.'), None),
            (sl('', 'Am Abend', 'sehen!', 'wir fern.'), None),
            (sl('denn', 'ich', 'bin!', 'krank.'), None),
            (sl('aber', 'das', 'ist!', 'teuer.'), None),
        ], head=['joining word', 'first', 'verb', 'the rest'],
            note='Move the time to the front, and the subject jumps behind the verb.'),
        tiles('Joining words: place 0', [
            ('und', 'and'), ('oder', 'or'), ('aber', 'but'), ('denn!', 'because'),
        ], 4, note='They don’t count: the verb stays in its place.'),
        cols(
            box('watch', 'dann counts',
                '*dann* (then) takes the first place itself, so the verb follows it at once: Zuerst esse ich, *dann gehe* ich.'),
            words('In a sentence', [
                ('Ich trinke Kaffee und esse Brot.', 'I drink coffee and eat bread.'),
                ('Tee oder Kaffee?', 'Tea or coffee?'),
                ('Die Wohnung ist schön, aber teuer.', 'The flat is nice but expensive.'),
                ('Ich bleibe zu Hause, denn es regnet.', 'I’m staying home, because it’s raining.'),
            ], 1),
        ),
        words('Words for the practice page', [
            ('zuerst', 'first'), ('dann', 'then'), ('die Wohnung', 'flat'), ('es regnet', 'it’s raining'),
        ], 4),
    ],
    [
        write('Time first', 'Start with the word in brackets.', [
            ('Ich habe heute keine Zeit. (Heute)', 'Heute habe ich keine Zeit.'),
            ('Wir sehen am Abend fern. (Am Abend)', 'Am Abend sehen wir fern.'),
            ('Ich lerne am Montag Deutsch. (Am Montag)', 'Am Montag lerne ich Deutsch.'),
            ('Der Hund schläft jetzt. (Jetzt)', 'Jetzt schläft der Hund.'),
        ], 1),
        gaps('und, oder, aber or denn?', 'Write the joining word.', [
            ('Tee', 'Kaffee?', 'oder'), ('Die Wohnung ist schön,', 'teuer.', 'aber'),
            ('Ich komme nicht,', 'ich bin krank.', 'denn'), ('Ich trinke Kaffee', 'esse ein Brot.', 'und'),
            ('Sie ist müde,', 'sie arbeitet.', 'aber'), ('Wir bleiben zu Hause,', 'es regnet.', 'denn'),
        ]),
        circle('Where is the verb?', 'Circle the right sentence.', [
            ('', ['Morgen fahre ich', 'Morgen ich fahre'], 'nach Berlin.', 'Morgen fahre ich'),
            ('Zuerst esse ich,', ['dann gehe ich', 'dann ich gehe'], '.', 'dann gehe ich'),
            ('Ich komme nicht,', ['denn ich bin', 'denn bin ich'], 'krank.', 'denn ich bin'),
        ], 1),
        gaps('Your reasons', 'Finish the sentences.', [
            ('Ich lerne Deutsch, denn', '.'), ('Deutsch ist schön, aber', '.'),
        ], 'About you — after denn and aber, the verb is still second.'),
    ],
    ['put the verb in second place',
     'start a sentence with the time',
     'join sentences with und, oder, aber, denn'],
))

# ---- 17 · Körper & Befinden ----------------------------------------------------
spreads.append(spread(
    'koerper', 'Körper & Befinden', 'Your body, and how you feel',
    'Mein Kopf tut weh — the sentence that gets you help, a tablet, and a friendly Gute Besserung!',
    Q + 'koerper',
    [
        table('The body', ['der', 'die', 'das'], [
            ['der Kopf', 'die Hand', 'das Bein'],
            ['der Arm', 'die Nase', 'das Auge'],
            ['der Bauch', 'die Schulter', 'das Ohr'],
            ['der Rücken', '', 'das Knie'],
            ['der Hals · der Fuß · der Zahn', '', ''],
        ], 'Two: die Füße, die Augen, die Ohren.', genders=True),
        slots('Something hurts', [
            (sl('Mein Kopf', 'tut!', 'weh.'), 'My head hurts.'),
            (sl('Meine Füße', 'tun!', 'weh.'), 'My feet hurt.'),
            (sl('Tut', 'dein Knie', 'noch weh?'), 'Does your knee still hurt?'),
        ], note='One thing: *tut*. Two or more: *tun*.'),
        cols(
            build('Ich habe …schmerzen', [
                (['Kopf', ('schmerzen', 'suffix')], 'Kopfschmerzen', 'headache'),
                (['Bauch', ('schmerzen', 'suffix')], 'Bauchschmerzen', 'stomach ache'),
                (['Hals', ('schmerzen', 'suffix')], 'Halsschmerzen', 'sore throat'),
                (['Zahn', ('schmerzen', 'suffix')], 'Zahnschmerzen', 'toothache'),
            ]),
            words('How are you?', [
                ('Wie geht es dir?', 'How are you?'), ('Nicht so gut.', 'Not so good.'),
                ('Ich habe Fieber.', 'I have a temperature.'), ('Gute Besserung!', 'Get well soon!'),
            ], 1),
        ),
        words('Words for the practice page', [
            ('weh tun', 'to hurt'), ('die Tablette', 'tablet'), ('der Zahnarzt', 'dentist'), ('zu viel', 'too much'),
            ('die Apotheke', 'pharmacy'), ('die Augen · die Füße', 'eyes · feet'),
        ], 4),
    ],
    [
        tags_ex('Body words', 'Write the word with der, die or das.', [
            ('kopf', '', 'der Kopf'), ('hand', '', 'die Hand'), ('auge', '', 'das Auge'), ('nase', '', 'die Nase'),
            ('bein', '', 'das Bein'), ('ohr', '', 'das Ohr'), ('bauch', '', 'der Bauch'), ('zahn', '', 'der Zahn'),
        ]),
        gaps('tut or tun?', 'Write tut or tun.', [
            ('Mein Kopf', 'weh.', 'tut'), ('Meine Füße', 'weh.', 'tun'),
            ('Mein Bauch', 'weh — zu viel Schokolade!', 'tut'), ('Meine Augen', 'weh.', 'tun'),
        ]),
        gaps('mein or meine?', 'Write mein or meine.', [
            ('', 'Hand tut weh.', 'Meine'), ('', 'Rücken tut weh.', 'Mein'),
            ('', 'Ohr tut weh.', 'Mein'), ('', 'Schulter tut weh.', 'Meine'),
        ]),
        match('At the doctor’s', 'Draw a line from the question to the answer.', [
            ('Wie geht es Ihnen?', 'Nicht so gut.'),
            ('Was tut weh?', 'Mein Hals.'),
            ('Haben Sie Fieber?', 'Ja, ein bisschen.'),
            ('Gute Besserung!', 'Danke!'),
        ], [3, 1, 0, 2]),
    ],
    ['say what hurts: tut weh, tun weh',
     'name the parts of the body with der, die, das',
     'say how I feel at the doctor’s'],
))

# ---- Review 2 · topics 8–17 -------------------------------------------------------
spreads.append({
    'id': 'review_2', 'review': True, 'title': 'Wiederholung', 'subtitle': 'Topics 8–17',
    'hook': 'The second half of the book, all at once. No looking back until you have done both pages.',
    'quiz': Q + 'wortschatz',
    'learn': [],
    'left': [
        circle('Little words', 'Circle the right word.', [
            ('Ich gehe', ['ins', 'im'], 'Kino.', 'ins'),
            ('Wir fahren', ['nach', 'zu'], 'Berlin.', 'nach'),
            ('Kaffee', ['ohne', 'für'], 'Milch, bitte.', 'ohne'),
            ('Das Geschenk ist', ['für', 'gegen'], 'dich.', 'für'),
            ('Ich muss', ['zum', 'nach'], 'Arzt.', 'zum'),
            ('Wie geht es', ['dir', 'dich'], '?', 'dir'),
        ]),
        write('Split it', 'Write the sentence.', [
            ('aufstehen · ich · um sechs', 'Ich stehe um sechs auf.'),
            ('einkaufen · Lena · am Samstag', 'Lena kauft am Samstag ein.'),
            ('anrufen · du · mich · morgen?', 'Rufst du mich morgen an?'),
        ], 1),
        write('Big numbers', 'Write them in words.', [
            ('450 €', 'vierhundertfünfzig Euro'), ('1999', 'neunzehnhundertneunundneunzig'),
        ], 2),
    ],
    'practise': [
        gaps('Yesterday', 'Write the helper and keep the past form.', [
            ('Ich', 'Pizza gegessen.', 'habe'), ('Wir', 'nach Wien gefahren.', 'sind'),
            ('Gestern', 'ich krank.', 'war'), ('Wir', 'keine Zeit.', 'hatten'),
        ]),
        gaps('Be polite', 'Write the polite words.', [
            ('Ich', 'einen Tee.', 'hätte gern'), ('', 'Sie mir helfen?', 'Könnten'),
            ('Herr Braun,', 'Sie bitte Platz!', 'nehmen'),
        ]),
        match('Question and answer', 'Draw a line from each question to its answer.', [
            ('Was tut weh?', 'Mein Kopf.'),
            ('Wohin fährst du?', 'Nach Hamburg.'),
            ('Was hast du gestern gemacht?', 'Ich habe gelesen.'),
            ('Was darf es sein?', 'Ein Kilo Äpfel, bitte.'),
            ('Was macht das?', 'Vier Euro fünfzig.'),
        ], [3, 0, 4, 1, 2]),
    ],
    'canDo': [],
})

# ---- the book --------------------------------------------------------------
book = {
    'title': 'Im Alltag',
    'cover': 'cp_a1_2_cover',
    'welcome': [
        'This book is the paper half of A1.2. Every topic gets two facing pages: the **left page** teaches — tables, examples, the few rules that matter — and the **right page** is yours to write on.',
        'It carries on from A1.1. Words you learned there are not taught again; where a topic builds on something from A1.1, a small box brings it back.',
        'Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Paul', 'Mia', 'Tom', 'Anna', 'Lisa', 'Marco', 'Sophie', 'Rocky', 'Gisela', 'Heinz', 'Braun', 'Weber', 'Hamburg'],
    'spreads': spreads,
    'overview': {'title': 'A1.2 at a glance', 'blocks': [
        table('ich, mich, mein', ['who does it', 'to whom', 'whose · der, das', 'whose · die, plural', '~in English'], [
            ['ich', 'mich', 'mein', 'meine', 'I · me · my'],
            ['du', 'dich', 'dein', 'deine', 'you · you · your'],
            ['er', 'ihn', 'sein', 'seine', 'he · him · his'],
            ['sie', 'sie', 'ihr', 'ihre', 'she · her · her'],
            ['es', 'es', 'sein', 'seine', 'it · it · its'],
            ['wir', 'uns', 'unser', 'unsere', 'we · us · our'],
            ['ihr', 'euch', 'euer', 'eure', 'you all · you · your'],
            ['sie · Sie', 'sie · Sie', 'ihr · Ihr', 'ihre · Ihre', 'they · them · their · you (polite)'],
        ], 'One row per person: read it left to right.'),
        table('The articles', ['~', 'der', 'die', 'das', 'plural'], [
            ['who does it', 'der · ein · kein', 'die · eine · keine', 'das · ein · kein', 'die · – · keine'],
            ['what it’s done to', '*den* · *einen* · *keinen*', 'die · eine · keine', 'das · ein · kein', 'die · – · keine'],
        ], 'Only the der column moves: *-en* for the object.', genders=True),
        slots('Where the verbs go', [
            (sl('Ich', 'muss!', 'heute', 'arbeiten!'), 'a helper'),
            (sl('Ich', 'stehe!', 'um sieben', 'auf!'), 'a verb that splits'),
            (sl('Ich', 'habe!', 'Pizza', 'gegessen!'), 'the past'),
            (sl('Morgen', 'fahre!', 'ich', 'nach Berlin.'), 'time first'),
        ]),
        cols(
            table('When?', ['', 'for'], [
                ['um', 'acht Uhr · halb drei'], ['am', 'Montag · Abend · Wochenende'], ['im', 'Mai · Sommer'],
            ]),
            table('Where to?', ['', 'for'], [
                ['nach', 'Berlin · Spanien · Hause'], ['in', 'ins Kino · in den Park'], ['zu', 'zum Arzt · zu Anna'],
            ]),
        ),
    ]},
    'dictionary': {
        'title': 'Words in pictures',
        'note': 'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.',
        'words': [{'de': d, 'en': e, 'image': i} for d, e, i in [
            ('der Kopf', 'head', 'kopf'), ('der Arm', 'arm', 'arm'), ('die Hand', 'hand', 'hand'),
            ('das Bein', 'leg', 'bein'), ('der Fuß', 'foot', 'fuss'), ('das Auge', 'eye', 'auge'),
            ('das Ohr', 'ear', 'ohr'), ('die Nase', 'nose', 'nase'), ('der Mund', 'mouth', 'mund'),
            ('der Zahn', 'tooth', 'zahn'), ('der Bauch', 'stomach', 'bauch'), ('der Rücken', 'back', 'ruecken'),
            ('der Hals', 'throat, neck', 'hals'), ('das Fieber', 'temperature', 'fieber'),
            ('die Tablette', 'tablet', 'tablette'), ('die Apotheke', 'pharmacy', 'apotheke'),
            ('der Bahnhof', 'station', 'bahnhof'), ('das Kino', 'cinema', 'kino'), ('der Park', 'park', 'park'),
            ('der Supermarkt', 'supermarket', 'supermarkt'), ('die Schule', 'school', 'schule'),
            ('die Stadt', 'town', 'stadt'), ('die Wohnung', 'flat', 'wohnung'),
            ('der Regenschirm', 'umbrella', 'regenschirm'), ('der Regen', 'rain', 'regen'),
            ('der Koffer', 'suitcase', 'koffer'), ('das Geschenk', 'present', 'geschenk'),
            ('der Geburtstag', 'birthday', 'geburtstag'), ('der Kuchen', 'cake', 'kuchen'),
            ('die Rechnung', 'bill', 'rechnung'), ('das Geld', 'money', 'geld'), ('das Handy', 'mobile phone', 'handy'),
        ]],
    },
    'credits': [
        {'what': 'Illustrations', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
        {'what': 'Picture dictionary', 'source': 'From the languagequiz.org word cards, drawn with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

with open(OUT, 'w', encoding='utf-8', newline='\n') as f:
    json.dump(book, f, ensure_ascii=False, indent='\t')
    f.write('\n')
print('wrote', OUT, len(spreads), 'spreads')
