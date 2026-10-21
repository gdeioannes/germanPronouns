# Builds assets/content/companion/de_cert_a1/a2_1.json — the A2.1 study companion.
# Run: python -I tool/companion/a2_1.py   (rules: docs/study_companion_guide.md)
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_a2_1_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'a2_1.json')
Q = 'quest_a2_1_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    """words_in_cols: (word, column index), printed in the order given."""
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ---- 1 · Ich habe gemacht -------------------------------------------------------
spreads.append(spread(
    'perfekt_haben', 'Ich habe gemacht', 'Talking about the past with haben',
    'Germans tell yesterday in the Perfekt: haben in second place, the past form at the very end.',
    Q + 'perfekt_haben',
    [
        slots('The bracket', [
            (sl('Ich', 'habe!', 'gestern Fußball', 'gespielt!'), 'I played football yesterday.'),
            (sl('Wir', 'haben!', 'zu viel Kuchen', 'gegessen!'), 'We ate too much cake.'),
            (sl('Hast!', 'du', 'meinen Brief', 'gelesen!'), 'Have you read my letter?'),
        ], head=['', 'haben', '', 'the past form'],
            note='You met it in A1.2 — now with every verb.'),
        table('Three kinds of past form', ['ge- … -t', 'ge- … -en', 'new vowel, still -t'], [
            ['machen → *gemacht*', 'essen → *gegessen*', 'bringen → *gebracht*'],
            ['kaufen → *gekauft*', 'schreiben → *geschrieben*', 'denken → *gedacht*'],
            ['hören → *gehört*', 'finden → *gefunden*', 'kennen → *gekannt*'],
            ['arbeiten → *gearbeitet*', 'nehmen → *genommen*', 'wissen → *gewusst*'],
            ['spielen → *gespielt*', 'treffen → *getroffen*', ''],
        ], 'Learn every verb as a pair: essen – gegessen.'),
        cols(
            build('Verbs that split: ge- in the middle', [
                (['auf', ('ge', 'suffix'), 'räumt'], 'aufgeräumt', 'aufräumen'),
                (['ein', ('ge', 'suffix'), 'kauft'], 'eingekauft', 'einkaufen'),
                (['an', ('ge', 'suffix'), 'rufen'], 'angerufen', 'anrufen'),
                (['fern', ('ge', 'suffix'), 'sehen'], 'ferngesehen', 'fernsehen'),
            ]),
            box('watch', 'No ge- at all',
                'Verbs ending in -ieren, and verbs starting with be-, ver- or er-: *telefoniert*, *studiert*, *besucht*, *verstanden*, *erklärt*.'),
        ),
        words('Words for the practice page', [
            ('aufräumen · ich räume auf', 'to tidy up'), ('der Brief', 'letter'), ('die Zeitung', 'newspaper'),
            ('telefonieren', 'to phone'), ('besuchen', 'to visit'), ('das Zimmer', 'room'),
        ], 3),
    ],
    [
        gaps('The past form', 'Write the past form of the verb in brackets.', [
            ('Ich habe Fußball', '. (spielen)', 'gespielt'), ('Er hat einen Brief', '. (schreiben)', 'geschrieben'),
            ('Ich habe meine Schlüssel', '. (finden)', 'gefunden'), ('Ich habe dir einen Kaffee', '. (bringen)', 'gebracht'),
            ('Hast du Oma', '? (anrufen)', 'angerufen'), ('Wir haben lange', '. (telefonieren)', 'telefoniert'),
            ('Die Katze hat die Zeitung', '. (lesen)', 'gelesen'), ('Ich habe an dich', '. (denken)', 'gedacht'),
        ]),
        sort_ex('Sort them', 'Write each past form in its column.', ['ge- … -t', 'ge- … -en', 'ohne ge-'], [
            ('gemacht', 0), ('gegessen', 1), ('telefoniert', 2), ('gekauft', 0), ('geschrieben', 1),
            ('besucht', 2), ('gespielt', 0), ('gefunden', 1), ('verstanden', 2),
        ]),
        write('Yesterday', 'Write it in the past.', [
            ('Ich räume mein Zimmer auf.', 'Ich habe mein Zimmer aufgeräumt.'),
            ('Lena kauft ein.', 'Lena hat eingekauft.'),
            ('Wir sehen fern.', 'Wir haben ferngesehen.'),
            ('Max besucht Oma.', 'Max hat Oma besucht.'),
        ], 1),
        gaps('Your yesterday', 'Write two true sentences.', [
            ('Gestern habe ich', '.'), ('Am Wochenende habe ich', '.'),
        ], 'About you — the past form at the end.'),
    ],
    ['say what I did with haben and the past form',
     'make regular, irregular and mixed past forms',
     'put ge- in the middle of verbs that split'],
))

# ---- 2 · Ich bin gefahren --------------------------------------------------------
spreads.append(spread(
    'perfekt_sein', 'Ich bin gefahren', 'Moving and changing: the Perfekt with sein',
    'Went, came, stayed, fell asleep: verbs that move you or change you take sein.',
    Q + 'perfekt_sein',
    [
        flow('haben or sein?', q('Moving from A to B?',
                                  a('sein', 'ich bin gefahren'),
                                  q('A change: waking up, falling asleep, becoming?',
                                    a('sein', 'ich bin eingeschlafen'),
                                    q('sein, bleiben or passieren?', a('sein', 'ich bin geblieben'), a('haben', 'ich habe gegessen')))),
             note='Most verbs take haben; sein is the short list.'),
        table('The sein verbs', ['verb', 'Perfekt', '~in English'], [
            ['gehen · fahren', 'ist *gegangen* · ist *gefahren*', 'went, walked · went, drove'],
            ['kommen · fliegen', 'ist *gekommen* · ist *geflogen*', 'came · flew'],
            ['laufen · schwimmen', 'ist *gelaufen* · ist *geschwommen*', 'ran · swam'],
            ['aufstehen · einschlafen', 'ist *aufgestanden* · ist *eingeschlafen*', 'got up · fell asleep'],
            ['werden · umziehen', 'ist *geworden* · ist *umgezogen*', 'became · moved house'],
            ['bleiben · sein', 'ist *geblieben* · ist *gewesen*', 'stayed · been'],
        ]),
        box('watch', 'An object turns it into haben',
            'Ich *bin* nach Köln gefahren (I travelled). Ich *habe* das Auto gefahren (I drove the car): with a thing after it, the same verb takes haben.'),
        words('Words for the practice page', [
            ('der See', 'lake'), ('aufwachen · er wacht auf', 'to wake up'), ('werden', 'to become'),
            ('umziehen', 'to move house'), ('Köln', 'Cologne'), ('letztes Jahr', 'last year'),
        ], 3),
    ],
    [
        gaps('The past form', 'Write the past form of the verb in brackets.', [
            ('Ich bin nach Berlin', '. (fahren)', 'gefahren'), ('Wir sind ins Kino', '. (gehen)', 'gegangen'),
            ('Er ist um sieben Uhr', '. (aufstehen)', 'aufgestanden'), ('Wann bist du nach Hause', '? (kommen)', 'gekommen'),
            ('Sie ist Ärztin', '. (werden)', 'geworden'), ('Das Baby ist sofort', '. (einschlafen)', 'eingeschlafen'),
        ]),
        circle('haben or sein?', 'Circle the right helper.', [
            ('Wir', ['haben', 'sind'], 'im See geschwommen.', 'sind'),
            ('Ich', ['habe', 'bin'], 'einen Kuchen gekauft.', 'habe'),
            ('Lena', ['hat', 'ist'], 'nach Köln umgezogen.', 'ist'),
            ('Max', ['hat', 'ist'], 'das Auto gefahren.', 'hat'),
            ('Der Hund', ['hat', 'ist'], 'zum Park gelaufen.', 'ist'),
            ('Was', ['hat', 'ist'], 'passiert?', 'ist'),
        ]),
        write('Rocky’s Sunday', 'Write each sentence in the past.', [
            ('Rocky wacht um sechs auf.', 'Rocky ist um sechs aufgewacht.'),
            ('Er läuft in den Park.', 'Er ist in den Park gelaufen.'),
            ('Er schwimmt im See.', 'Er ist im See geschwommen.'),
            ('Er schläft auf dem Sofa ein.', 'Er ist auf dem Sofa eingeschlafen.'),
        ], 1),
        gaps('Your trip', 'Write two true sentences.', [
            ('Letztes Jahr bin ich nach', 'gefahren.'), ('Gestern bin ich um', 'aufgestanden.'),
        ], 'About you.'),
    ],
    ['say where I went and when I got up',
     'choose sein for moving and changing',
     'use haben when there is a thing after the verb'],
))

# ---- 3 · war, hatte, konnte -------------------------------------------------------
spreads.append(spread(
    'war_hatte', 'war, hatte, konnte', 'Setting the scene in the past',
    'Es war kalt, ich hatte keine Zeit, ich konnte nicht kommen — the short past that sets every scene and every excuse.',
    Q + 'war_hatte',
    [
        table('The short past', ['who', 'war', 'hatte', 'konnte', 'musste', 'wollte', 'durfte'], [
            ['ich', '*war*', '*hatte*', '*konnte*', '*musste*', '*wollte*', '*durfte*'],
            ['du', 'warst', 'hattest', 'konntest', 'musstest', 'wolltest', 'durftest'],
            ['er · sie · es', '*war*', '*hatte*', '*konnte*', '*musste*', '*wollte*', '*durfte*'],
            ['wir', 'waren', 'hatten', 'konnten', 'mussten', 'wollten', 'durften'],
            ['ihr', 'wart', 'hattet', 'konntet', 'musstet', 'wolltet', 'durftet'],
            ['sie · Sie', 'waren', 'hatten', 'konnten', 'mussten', 'wollten', 'durften'],
        ], 'ich and er are twins, as in every past.'),
        cols(
            build('The helpers: lose the dots, add -te', [
                (['konn', ('te', 'suffix')], 'konnte', 'können'),
                (['muss', ('te', 'suffix')], 'musste', 'müssen'),
                (['durf', ('te', 'suffix')], 'durfte', 'dürfen'),
                (['woll', ('te', 'suffix')], 'wollte', 'wollen'),
            ]),
            slots('The excuse', [
                (sl('Ich', 'konnte!', 'leider nicht', 'kommen!'), None),
                (sl('Ich', 'musste!', 'lange', 'arbeiten!'), None),
            ], note='The bracket stays.'),
        ),
        box('tip', 'Scene, then event',
            '*war* and *hatte* paint the scene, the Perfekt tells what happened: Es *war* kalt, also *habe* ich einen Mantel *gekauft*. Als Kind *hatte* ich einen Hund.'),
        words('Words for the practice page', [
            ('als Kind', 'as a child'), ('der Mantel', 'coat'), ('also', 'so'),
            ('das Essen', 'food, meal'), ('der Urlaub', 'holiday'), ('klein', 'small'),
        ], 3),
    ],
    [
        gaps('war or hatte', 'Write the right form.', [
            ('Gestern', 'ich krank. (sein)', 'war'), ('', 'du gestern zu Hause? (sein)', 'Warst'),
            ('Wir', 'viel Spaß. (haben)', 'hatten'), ('Wo', 'ihr im Sommer? (sein)', 'wart'),
            ('Meine Oma', 'einen Hund. (haben)', 'hatte'), ('', 'ihr Hunger? (haben)', 'Hattet'),
        ]),
        gaps('The helpers in the past', 'Write the past of the helper.', [
            ('Ich', 'gestern nicht kommen. (können)', 'konnte'), ('Ich', 'lange arbeiten. (müssen)', 'musste'),
            ('Als Kind', 'ich Ärztin werden. (wollen)', 'wollte'), ('Wir', 'nicht ins Kino gehen. (dürfen)', 'durften'),
            ('Rocky', 'den Kuchen nicht essen — aber er hat ihn gegessen. (dürfen)', 'durfte'),
        ]),
        write('Why weren’t you there?', 'Give two excuses, in the past.', [
            ('müssen · lange arbeiten', 'Ich musste lange arbeiten.'),
            ('können · keinen Bus finden', 'Ich konnte keinen Bus finden.'),
        ], 1),
        gaps('As a child', 'Write two true sentences.', [
            ('Als Kind war ich', '.'), ('Als Kind hatte ich', '.'),
        ], 'About you.'),
    ],
    ['say how it was with war and hatte',
     'make excuses with konnte and musste',
     'set the scene, then tell what happened'],
))

# ---- 4 · dem, der, den ------------------------------------------------------------
spreads.append(spread(
    'dativ_artikel', 'dem, der, den', 'To whom: the dative',
    'Give, help, thank: the person who receives gets dem, der or den — ask wem?',
    Q + 'dativ_artikel',
    [
        table('Three questions, three rows', ['~', 'der', 'die', 'das', 'plural'], [
            ['wer? who does it', 'der · ein', 'die · eine', 'das · ein', 'die'],
            ['wen? what it’s done to', 'den · einen', 'die · eine', 'das · ein', 'die'],
            ['wem? to whom', '*dem* · *einem*', '*der* · *einer*', '*dem* · *einem*', '*den* …-n'],
        ], 'Remember the first two rows from A1.2: the third is new.', genders=True),
        cols(
            arrow('Ask wem?', [
                ('Ich', 'helfe', '*der* Frau', None),
                ('Das Auto', 'gehört', '*dem* Lehrer', None),
                ('Wir', 'danken', '*dem* Kind', None),
                ('Sie', 'spielt mit', '*den* Kindern', None),
            ], ask=('wer?', 'wem?')),
            box('watch', 'Plural: den …-n',
                'In the plural the noun gets an -n too: den Kinder*n*, den Freunde*n*. Not when it already ends in -n or -s: den Frauen, den Autos.'),
        ),
        tiles('Verbs that always want wem?', [
            ('helfen', 'help'), ('danken', 'thank'), ('gefallen', 'please'), ('gehören', 'belong to'),
            ('antworten', 'answer'), ('gratulieren', 'congratulate'), ('schmecken', 'taste good to'),
        ], 4),
        words('Words for the practice page', [
            ('der Nachbar · die Nachbarn', 'neighbour · neighbours'), ('die Geschichte', 'story'), ('erzählen', 'to tell'),
            ('schenken', 'to give (a present)'), ('wem?', 'to whom?'), ('die Krawatte', 'tie'), ('die Blumen', 'flowers'), ('der Knochen', 'bone'),
        ], 3),
    ],
    [
        gaps('dem, der or den?', 'Write the article.', [
            ('Ich helfe', 'Frau.', 'der'), ('Wir danken', 'Kind.', 'dem'),
            ('Das Auto gehört', 'Lehrer.', 'dem'), ('Sie spielt mit', 'Kindern.', 'den'),
            ('Ich schenke', 'Vater eine Krawatte.', 'dem'), ('Er antwortet', 'Lehrerin.', 'der'),
            ('Wir helfen', 'Nachbarn.', 'den'), ('Der Kellner bringt', 'Gast die Rechnung.', 'dem'),
        ]),
        circle('wen? or wem?', 'Circle the right article.', [
            ('Ich sehe', ['den', 'dem'], 'Mann.', 'den'),
            ('Ich helfe', ['den', 'dem'], 'Mann.', 'dem'),
            ('Wir besuchen', ['die', 'der'], 'Oma.', 'die'),
            ('Wir gratulieren', ['die', 'der'], 'Oma.', 'der'),
        ]),
        write('Who gets what?', 'Look at the picture on the left page. Write who gives what to whom.', [
            ('der Mann · die Oma · ein Geschenk', 'Der Mann gibt der Oma ein Geschenk.'),
            ('das Mädchen · die Lehrerin · Blumen', 'Das Mädchen gibt der Lehrerin Blumen.'),
            ('der Junge · der Hund · einen Knochen', 'Der Junge gibt dem Hund einen Knochen.'),
        ], 1),
    ],
    ['ask wem? and answer with dem, der, den',
     'use helfen, danken, gehören with the dative',
     'say who gets what'],
))

# ---- 5 · mit, bei, von, zu … ------------------------------------------------------
spreads.append(spread(
    'dativ_praep', 'mit, bei, von, zu …', 'Seven little words that always take the dative',
    'aus – bei – mit – nach – seit – von – zu: sing it once, and you never guess the article after them again.',
    Q + 'dativ_praep',
    [
        tiles('The dative song', [
            ('aus', 'out of, from'), ('bei', 'at, with'), ('mit!', 'with, by'), ('nach', 'after, to'),
            ('seit', 'since, for'), ('von', 'from, of'), ('zu!', 'to'),
        ], 7),
        table('After them: dem, der, den', ['~', 'der', 'die', 'das', 'plural'], [
            ['mit', 'mit *dem* Bus', 'mit *der* Bahn', 'mit *dem* Auto', 'mit *den* Kindern'],
            ['bei', '*beim* Arzt', 'bei *der* Arbeit', '*beim* Bäcker', 'bei *meinen* Eltern'],
            ['von', '*vom* Markt', 'von *der* Post', '*vom* Kino', 'von *den* Nachbarn'],
        ], 'Always the third row of topic 4 — wem?', genders=True),
        cols(
            build('Two words become one', [
                (['bei', ('dem', 'joint')], 'beim', 'beim Arzt'),
                (['von', ('dem', 'joint')], 'vom', 'vom Markt'),
                (['zu', ('dem', 'joint')], 'zum', 'zum Bahnhof'),
                (['zu', ('der', 'joint')], 'zur', 'zur Post'),
            ]),
            box('watch', 'seit: and it’s still true',
                'Ich wohne *seit* drei Jahren in Berlin — I still live there, so German uses the present, not the past. Seit *Montag* bin ich krank.'),
        ),
        words('Words for the practice page', [
            ('der Bäcker', 'baker'), ('die Bahn', 'train, railway'), ('die Post', 'post office'),
            ('der Markt', 'market'), ('gerade', 'just'), ('das Jahr · seit einem Jahr', 'year · for a year'),
            ('mit meinem · mit meiner', 'with my (der, das · die)'),
        ], 3),
    ],
    [
        gaps('Which little word?', 'Write aus, bei, mit, nach, seit, von or zu.', [
            ('Ich komme', 'der Schweiz.', 'aus'), ('Ich wohne', 'meinen Eltern.', 'bei'),
            ('Ich fahre', 'dem Bus.', 'mit'), ('', 'der Arbeit gehe ich nach Hause.', 'Nach'),
            ('Ich lerne Deutsch', 'einem Jahr.', 'seit'), ('Das ist ein Geschenk', 'meiner Mutter.', 'von'),
        ]),
        gaps('dem, der or den?', 'Write the article.', [
            ('Wir fahren mit', 'Bahn.', 'der'), ('Ich wohne bei', 'Kindern.', 'den'),
            ('Er kommt gerade aus', 'Haus.', 'dem'), ('Sie spricht mit', 'Lehrer.', 'dem'),
        ]),
        circle('Short and sweet', 'Circle the right word.', [
            ('Ich gehe', ['zum', 'zur'], 'Arzt.', 'zum'), ('Wir fahren', ['zum', 'zur'], 'Post.', 'zur'),
            ('Ich kaufe Brot', ['beim', 'vom'], 'Bäcker.', 'beim'), ('Er kommt', ['vom', 'beim'], 'Markt.', 'vom'),
        ]),
        gaps('About you', 'Write two true sentences.', [
            ('Ich wohne seit', 'in'), ('Ich fahre mit', 'zur Arbeit.'),
        ], 'About you — seit with the present.'),
    ],
    ['know the seven dative words by heart',
     'use dem, der, den after them',
     'say beim, vom, zum, zur'],
))

# ---- 6 · mir, dir, ihm ----------------------------------------------------------------
spreads.append(spread(
    'pronomen_dativ', 'mir, dir, ihm', 'The person who receives — as a small word',
    'mir, dir, ihm, ihr: nine small words to help, thank, give — and to say what you like.',
    Q + 'pronomen_dativ',
    [
        table('wer? wen? wem?', ['wer?', 'wen?', 'wem?', '~in English'], [
            ['ich', 'mich', '*mir*', 'to me'],
            ['du', 'dich', '*dir*', 'to you'],
            ['er · es', 'ihn · es', '*ihm*', 'to him · to it'],
            ['sie', 'sie', '*ihr*', 'to her'],
            ['wir', 'uns', 'uns', 'to us'],
            ['ihr', 'euch', 'euch', 'to you (all)'],
            ['sie · Sie', 'sie · Sie', '*ihnen* · *Ihnen*', 'to them · to you (polite)'],
        ], 'The middle column is A1.2. uns and euch never change.'),
        cols(
            arrow('I like it — it pleases me', [
                ('Das Buch', 'gefällt', '*mir*', None),
                ('Die Suppe', 'schmeckt', '*ihm*', None),
                ('Der Schlüssel', 'gehört', '*ihr*', None),
                ('Die Jacke', 'passt', '*dir*', None),
            ], ask=('was?', 'wem?'), note='The thing does it; the person receives.'),
            box('tip', 'After the dative words too',
                'mit *mir*, bei *dir*, von *ihm*, zu *ihr*: after aus, bei, mit, nach, seit, von, zu — always these forms.'),
        ),
        words('Words for the practice page', [
            ('die Suppe', 'soup'), ('passen', 'to fit'), ('zeigen', 'to show'),
            ('der Weg', 'way'), ('das Futter', 'pet food'), ('der Rock', 'skirt'), ('helfen · du hilfst', 'to help'),
        ], 3),
    ],
    [
        gaps('To whom?', 'Write the word for the person in brackets.', [
            ('Kannst du', 'helfen? (ich)', 'mir'), ('Ich gebe', 'das Buch. (du)', 'dir'),
            ('Das Auto gehört', '. (er)', 'ihm'), ('Wie geht es', '? (sie, she)', 'ihr'),
            ('Können Sie', 'den Weg zeigen? (wir)', 'uns'), ('Wie geht es', ', Herr Braun? (Sie)', 'Ihnen'),
            ('Der Hund hat Hunger. Ich gebe', 'das Futter. (er)', 'ihm'), ('Das Geschenk gefällt', '. (sie, they)', 'ihnen'),
        ]),
        circle('mich or mir?', 'Circle the right word.', [
            ('Siehst du', ['mich', 'mir'], '?', 'mich'), ('Hilfst du', ['mich', 'mir'], '?', 'mir'),
            ('Ich liebe', ['dich', 'dir'], '.', 'dich'), ('Ich danke', ['dich', 'dir'], '.', 'dir'),
            ('Kommst du mit', ['mich', 'mir'], '?', 'mir'), ('Rufst du', ['mich', 'mir'], 'an?', 'mich'),
        ]),
        write('It pleases me', 'Write it the German way: the thing first.', [
            ('ich · das Buch · gefallen', 'Das Buch gefällt mir.'),
            ('er · die Suppe · schmecken', 'Die Suppe schmeckt ihm.'),
            ('du · die Jacke · passen', 'Die Jacke passt dir.'),
        ], 1),
        gaps('What you like', 'Write two true sentences.', [
            ('', 'gefällt mir.'), ('', 'schmeckt mir nicht.'),
        ], 'About you — the thing is the subject.'),
    ],
    ['say mir, dir, ihm, ihr, uns, euch, ihnen',
     'say what I like with gefallen and schmecken',
     'tell mich from mir'],
))

# ---- 7 · Ich gebe es dir ------------------------------------------------------------
spreads.append(spread(
    'dativ_akkusativ', 'Ich gebe es dir', 'Two objects: who gets what',
    'Wem? Was? Ask both questions and every giving sentence falls into place.',
    Q + 'dativ_akkusativ',
    [
        slots('Who first?', [
            (['Ich', {'de': 'gebe', 'hot': True}, ('dem Kind', 'wem?'), ('den Ball', 'was?')], 'Two nouns: the person first.'),
            (['Ich', {'de': 'gebe', 'hot': True}, ('ihn', 'was?'), ('dem Kind', 'wem?')], 'The thing as a small word jumps ahead.'),
            (['Ich', {'de': 'gebe', 'hot': True}, ('ihn', 'was?'), ('ihm', 'wem?')], 'Two small words: the thing first.'),
        ]),
        tiles('Verbs of giving: jemandem etwas', [
            ('geben', 'give'), ('schenken', 'give as a present'), ('bringen', 'bring'), ('schicken', 'send'),
            ('zeigen', 'show'), ('erklären', 'explain'), ('erzählen', 'tell'), ('leihen', 'lend'),
        ], 4, note='*jemandem* = to someone (wem?), *etwas* = something (was?).'),
        box('tip', 'Ask the two questions',
            'Wem gebe ich etwas? — *dem Kind*. Was gebe ich? — *den Ball*. The answers give you the cases: dem for wem?, den for was?'),
        words('Words for the practice page', [
            ('der Stift', 'pen'), ('der Garten', 'garden'), ('wünschen', 'to wish'),
            ('der Ball', 'ball'), ('die E-Mail', 'e-mail'), ('die Tochter', 'daughter'),
        ], 3),
    ],
    [
        write('Two nouns', 'Write the sentence: the person first, then the thing.', [
            ('Ich gebe · das Kind · den Ball', 'Ich gebe dem Kind den Ball.'),
            ('Wir schicken · der Freund · eine E-Mail', 'Wir schicken dem Freund eine E-Mail.'),
            ('Opa erzählt · die Kinder · eine Geschichte', 'Opa erzählt den Kindern eine Geschichte.'),
        ], 1),
        gaps('The thing as a small word', 'Write ihn, sie or es.', [
            ('Der Ball? Ich gebe', 'dem Kind.', 'ihn'), ('Die Blumen? Er schenkt', 'der Mutter.', 'sie'),
            ('Das Buch? Ich bringe', 'dir morgen.', 'es'), ('Den Garten? Sie zeigt', 'den Kindern.', 'ihn'),
        ]),
        circle('Which order?', 'Circle the right order.', [
            ('Ich gebe', ['es ihm', 'ihm es'], '.', 'es ihm'),
            ('Kannst du', ['mir den Stift', 'den Stift mir'], 'leihen?', 'mir den Stift'),
            ('Ich erkläre', ['es dir', 'dir es'], '.', 'es dir'),
        ], 1),
        gaps('A present', 'Write one true sentence.', [
            ('Zum Geburtstag schenke ich', '.'),
        ], 'About you — the person first, then the present.'),
    ],
    ['say who gets what with two objects',
     'put the person first with two nouns',
     'put es, ihn, sie in front of the person'],
))

# ---- Review 1 · topics 1–7 ------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–7', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        circle('haben or sein?', 'Circle the right helper.', [
            ('Ich', ['habe', 'bin'], 'Pizza gegessen.', 'habe'), ('Wir', ['haben', 'sind'], 'nach Rom gefahren.', 'sind'),
            ('Lena', ['hat', 'ist'], 'lange geschlafen.', 'hat'), ('Er', ['hat', 'ist'], 'zu Hause geblieben.', 'ist'),
        ]),
        gaps('The past form', 'Write the past form.', [
            ('Ich habe einen Brief', '. (schreiben)', 'geschrieben'), ('Wir sind um sechs', '. (aufstehen)', 'aufgestanden'),
            ('Hast du Oma', '? (besuchen)', 'besucht'), ('Ich', 'leider nicht kommen. (können)', 'konnte'),
        ]),
        circle('dem, der or den?', 'Circle the right article.', [
            ('Ich helfe', ['dem', 'der'], 'Frau.', 'der'), ('Wir fahren mit', ['dem', 'den'], 'Bus.', 'dem'),
            ('Das gehört', ['den', 'dem'], 'Kindern.', 'den'), ('Ich gehe', ['zum', 'zur'], 'Bäcker.', 'zum'),
        ]),
    ],
    [
        gaps('mir, dir, ihm …', 'Write the word for the person in brackets.', [
            ('Gefällt', 'das Bild? (du)', 'dir'), ('Ich helfe', 'gern. (ihr)', 'euch'),
            ('Die Suppe schmeckt', 'nicht. (er)', 'ihm'),
        ]),
        write('Who gets what?', 'Write the sentence.', [
            ('Ich schenke · die Mutter · Blumen', 'Ich schenke der Mutter Blumen.'),
            ('Das Buch? Ich gebe · es · er', 'Ich gebe es ihm.'),
        ], 1),
        match('Question and answer', 'Draw a line from each question to its answer.', [
            ('Was hast du gestern gemacht?', 'Ich habe gelesen.'),
            ('Wo warst du?', 'Bei meiner Oma.'),
            ('Warum bist du nicht gekommen?', 'Ich musste arbeiten.'),
            ('Wem gehört das Auto?', 'Dem Lehrer.'),
        ], [2, 0, 3, 1]),
    ],
))

# ---- 8 · Woher? Wo? Wohin? ----------------------------------------------------------
spreads.append(spread(
    'woher_wo_wohin', 'Woher? Wo? Wohin?', 'Where from, where, where to',
    'Every place has three little words: one for coming from it, one for being there, one for going there.',
    Q + 'woher_wo_wohin',
    [
        slots('From, at, to', [
            ([('aus dem Kino ←', 'woher?'), {'de': 'im Kino', 'tag': 'wo?', 'hot': True}, ('→ ins Kino', 'wohin?')], 'a place you go into'),
            ([('vom Arzt ←', 'woher?'), {'de': 'beim Arzt', 'tag': 'wo?', 'hot': True}, ('→ zum Arzt', 'wohin?')], 'a person, the doctor'),
            ([('aus Berlin ←', 'woher?'), {'de': 'in Berlin', 'tag': 'wo?', 'hot': True}, ('→ nach Berlin', 'wohin?')], 'a town'),
        ], note='You stand in the middle box: coming from the left, going to the right.'),
        table('One place, three questions', ['Woher? coming from', 'Wo? being there', 'Wohin? going there'], [
            ['*aus* dem Kino', '*im* Kino', '*ins* Kino'],
            ['*aus* der Schule', '*in der* Schule', '*in die* Schule'],
            ['*vom* Arzt', '*beim* Arzt', '*zum* Arzt'],
            ['*von* Anna', '*bei* Anna', '*zu* Anna'],
            ['*aus* Berlin', '*in* Berlin', '*nach* Berlin'],
            ['*aus der* Schweiz', '*in der* Schweiz', '*in die* Schweiz'],
            ['*von* zu Hause', '*zu* Hause', '*nach* Hause'],
        ], 'Read each row left to right: from → at → to.'),
        cols(
            table('Three sets', ['', 'from', 'at', 'to'], [
                ['places you go into', 'aus', 'in', 'in'],
                ['people, the doctor', 'von', 'bei', 'zu'],
                ['towns, countries', 'aus', 'in', 'nach'],
            ]),
            box('watch', 'zu Hause, nach Hause',
                'Ich bin *zu* Hause — I’m at home. Ich gehe *nach* Hause — I’m going home. English has one word; German has two.'),
        ),
        words('Asking the way', [
            ('Wie komme ich zum Bahnhof?', 'How do I get to the station?'), ('geradeaus', 'straight on'),
            ('links · rechts', 'left · right'), ('die Straße', 'street'), ('die Ampel', 'traffic lights'),
            ('das Café', 'café'),
        ], 3),
    ],
    [
        gaps('Woher, wo or wohin?', 'Write the place with the right little word.', [
            ('Heute Abend gehen wir', '. (das Kino)', 'ins Kino'), ('Ich bin noch', '. (das Kino)', 'im Kino'),
            ('Ich komme gerade', '. (das Café)', 'aus dem Café'), ('Ich habe Fieber, ich gehe', '. (der Arzt)', 'zum Arzt'),
            ('Sie kommt gerade', '. (der Arzt)', 'vom Arzt'), ('Wir sind am Samstag', '. (Anna)', 'bei Anna'),
            ('Nach der Schule gehe ich', '. (Anna)', 'zu Anna'), ('Die Kinder sind heute', '. (die Schule)', 'in der Schule'),
        ]),
        circle('Which one?', 'Circle the right word.', [
            ('Ich bin', ['zu', 'nach'], 'Hause.', 'zu'), ('Ich fahre', ['nach', 'in die'], 'Schweiz.', 'in die'),
            ('Er kommt', ['aus', 'von'], 'Berlin.', 'aus'), ('Ich wohne', ['bei', 'zu'], 'meinen Eltern.', 'bei'),
        ]),
        write('Where are they going?', 'Answer with the place in brackets.', [
            ('Wohin gehst du? (der Supermarkt)', 'In den Supermarkt.'),
            ('Wo ist Max? (der Supermarkt)', 'Im Supermarkt.'),
            ('Woher kommst du? (die Arbeit)', 'Von der Arbeit.'),
        ], 1),
    ],
    ['say where something is, where it goes and where it comes from',
     'tell zu Hause from nach Hause',
     'ask the way'],
))

# ---- 9 · seit, vor, für … ---------------------------------------------------------------
spreads.append(spread(
    'temporal', 'seit, vor, für …', 'Putting things on a timeline',
    'English “for” hides two German words, and “ago” comes first: one picture of time sorts them all.',
    Q + 'temporal_2',
    [
        timeline('Before, now, later', [
            ('vor zwei Jahren', 'two years ago', -2),
            ('seit zwei Jahren', 'for two years — and still', (-2, 0)),
            ('in einer Woche', 'a week from now', 1.5),
            ('für eine Woche', 'for one (planned) week', (2, 3)),
            ('ab Montag', 'from Monday on', (1, 4)),
        ], note='The dotted line is now.'),
        table('Which little word?', ['word', '~means', 'like this'], [
            ['seit', 'since, for — still true', 'Ich wohne *seit* zwei Jahren hier.'],
            ['vor', 'ago · before', '*vor* zwei Jahren · *vor* dem Frühstück'],
            ['nach', 'after', '*nach* dem Kurs'],
            ['in', 'from now', '*in* einer Woche'],
            ['für', 'for a planned time', '*für* eine Woche'],
            ['ab · zwischen · über', 'from … on · between · more than', 'ab Montag · zwischen acht und neun · über eine Stunde'],
        ]),
        box('watch', 'The extra -n',
            'After seit, vor and in the plural gets an -n: seit zwei Jahre*n*, vor drei Monate*n*, seit fünf Tage*n*. Not when it already has one: vor zwei Wochen.'),
        words('Words for the practice page', [
            ('die Stunde', 'hour'),
            ('warten · gewartet', 'to wait · waited'),
            ('abfahren · abgefahren', 'to leave · left'), ('der Kurs', 'course, class'), ('wieder', 'again'),
            ('die Woche · zwei Wochen', 'week · two weeks'), ('der Tag · vor zwei Tagen', 'day · two days ago'),
        ], 4),
    ],
    [
        gaps('Which word?', 'Write seit, vor, nach, in, für, ab or über.', [
            ('Ich wohne', 'zwei Jahren in Berlin.', 'seit'), ('', 'zwei Jahren war ich in Rom.', 'Vor'),
            ('', 'dem Kurs gehen wir essen.', 'Nach'), ('', 'einer Woche habe ich Urlaub.', 'In'),
            ('Ich fahre', 'eine Woche nach Wien.', 'für'), ('Wir haben', 'eine Stunde gewartet.', 'über'),
            ('', 'Montag arbeite ich wieder.', 'Ab'), ('Der Zug ist', 'einer Stunde abgefahren.', 'vor'),
        ]),
        write('In German', 'Write it in German.', [
            ('two years ago', 'vor zwei Jahren'), ('for two years (and still)', 'seit zwei Jahren'),
            ('in a week (from now)', 'in einer Woche'), ('for a week (planned)', 'für eine Woche'),
        ], 2, not_german=True),
        circle('seit or für?', 'Circle the right word.', [
            ('Ich lerne', ['seit', 'für'], 'einem Jahr Deutsch.', 'seit'),
            ('Wir fahren', ['seit', 'für'], 'zwei Wochen nach Spanien.', 'für'),
            ('', ['Seit', 'Für'], 'Montag bin ich krank.', 'Seit'),
        ], 1),
        gaps('Your timeline', 'Write two true sentences.', [
            ('Ich lerne seit', 'Deutsch.'), ('Vor', 'war ich in'),
        ], 'About you — seit with the present.'),
    ],
    ['say how long something has been true with seit',
     'say ago with vor',
     'tell seit, für and in apart'],
))

# ---- 10 · Das Wetter ----------------------------------------------------------------
spreads.append(spread(
    'wetter', 'Das Wetter', 'Weather and seasons',
    'Rain, sun, twenty degrees and getting colder: the easiest small talk in Germany.',
    Q + 'wetter',
    [
        pictures('What the weather does', [
            ('cpd_sonne', 'Die Sonne scheint.', None), ('cpd_regen', 'Es regnet.', None), ('cpd_schnee', 'Es schneit.', None),
            ('cpd_wind', 'Es ist windig.', None), ('cpd_wolke', 'Es ist bewölkt.', None), ('cpd_gewitter', 'Es donnert.', None),
        ], 6),
        table('It rains, it is sunny', ['es + verb', 'es ist + describing word'], [
            ['es *regnet*', 'es ist *sonnig*'],
            ['es *schneit*', 'es ist *windig*'],
            ['es *donnert*', 'es ist *bewölkt*'],
            ['die Sonne *scheint*', 'es ist *neblig* · kalt · warm · heiß'],
        ], 'Weather always starts with es.'),
        cols(
            words('Degrees and change', [
                ('Es sind zwanzig Grad.', 'It’s twenty degrees.'), ('Es sind minus drei Grad.', 'It’s minus three.'),
                ('Es wird wärmer.', 'It’s getting warmer.'), ('Es wird kälter.', 'It’s getting colder.'),
                ('Morgen wird es schön.', 'Tomorrow will be nice.'),
            ], 1),
            tiles('The weather map', [
                ('im Norden', 'in the north'), ('im Süden', 'in the south'),
                ('im Osten', 'in the east'), ('im Westen', 'in the west'),
            ], 2),
        ),
        box('culture', 'Germans and the weather',
            'Every forecast ends with advice: *Nehmen Sie einen Regenschirm mit!* And there is no bad weather, only the wrong clothes — *falsche Kleidung*.'),
        words('Words for the practice page', [
            ('die Sonne', 'sun'), ('der Regen', 'rain'), ('der Schnee', 'snow'), ('der Wind', 'wind'),
            ('die Wolke · die Wolken', 'cloud · clouds'), ('der Nebel', 'fog'), ('das Gewitter', 'thunderstorm'),
            ('der Vormittag · der Nachmittag', 'morning · afternoon'), ('stark · starker Wind', 'strong · strong wind'), ('etwa', 'about'), ('die Sonnenbrille', 'sunglasses'),
            ('die Kleidung · falsch', 'clothes · wrong'),
        ], 3),
    ],
    [
        write('One street, four weathers', 'Look at the picture on the left page. What is the weather for …', [
            ('the man with sunglasses', 'Die Sonne scheint.'),
            ('the woman with the umbrella', 'Es regnet.'),
            ('the child with the snowman', 'Es schneit.'),
            ('the man and his hat', 'Es ist windig.'),
        ], 2, not_german=True),
        gaps('The weather report', 'Listen to the forecast and fill in the notes.', [
            ('Hamburg, am Vormittag:', 'Grad', 'acht'),
            ('München, am Nachmittag: etwa', 'Grad', 'zwanzig'),
            ('Am Abend: starker', '', 'Wind'),
            ('Morgen: die', 'scheint', 'Sonne'),
        ]) | {'listen': True},
        circle('Getting warmer', 'Circle the right word.', [
            ('Im Winter', ['schneit', 'ist'], 'es.', 'schneit'),
            ('Heute ist es', ['sonnig', 'Sonne'], '.', 'sonnig'),
            ('Morgen', ['wird', 'ist'], 'es wärmer.', 'wird'),
            ('Es', ['sind', 'ist'], 'zwanzig Grad.', 'sind'),
        ]),
        gaps('Your weather', 'Write two true sentences.', [
            ('Heute', '.'), ('Bei mir im Winter', '.'),
        ], 'About you.'),
    ],
    ['say what the weather is like',
     'say the temperature and how it is changing',
     'understand a weather report'],
    listen=Q + 'hoeren_wetter',
))

# ---- 11 · größer als --------------------------------------------------------------------
spreads.append(spread(
    'komparativ', 'größer als', 'Comparing two things',
    'Train or car, tea or coffee: one ending, -er, and one little word, als.',
    Q + 'komparativ',
    [
        build('-er, and sometimes dots', [
            (['klein', ('er', 'suffix')], 'kleiner', 'klein'),
            (['schnell', ('er', 'suffix')], 'schneller', 'schnell'),
            (['ält', ('er', 'suffix')], 'älter', 'alt — a gets dots'),
            (['größ', ('er', 'suffix')], 'größer', 'groß — o gets dots'),
            (['jüng', ('er', 'suffix')], 'jünger', 'jung — u gets dots'),
            (['teur', ('er', 'suffix')], 'teurer', 'teuer — an e drops out'),
        ], 'Never “mehr interessant”: interessanter.'),
        cols(
            table('Four of their own', ['', 'more'], [
                ['gut', '*besser*'], ['viel', '*mehr*'], ['gern', '*lieber*'], ['hoch', '*höher*'],
            ]),
            slots('als or wie?', [
                (sl('Der Zug', 'ist', 'schneller', 'als!', 'der Bus.'), 'different: als'),
                (sl('Tom', 'ist', 'genauso alt', 'wie!', 'ich.'), 'the same: wie'),
            ]),
        ),
        words('Words for the practice page', [
            ('kurz · lang', 'short · long'), ('stark', 'strong'), ('interessant', 'interesting'),
            ('das Obst', 'fruit'), ('genauso', 'just as'), ('der Berg', 'mountain'),
            ('jung · alt', 'young · old'), ('die Tage', 'the days'), ('das Hotel', 'hotel'),
        ], 3),
    ],
    [
        gaps('-er', 'Write the comparing form.', [
            ('Ein Zug ist', 'als ein Bus. (schnell)', 'schneller'), ('Mein Bruder ist', 'als ich. (alt)', 'älter'),
            ('Berlin ist', 'als Bonn. (groß)', 'größer'), ('Heute ist es', 'als gestern. (warm)', 'wärmer'),
            ('Das Buch ist', 'als der Film. (gut)', 'besser'), ('Ich trinke', 'Tee als Kaffee. (gern)', 'lieber'),
            ('Im Winter sind die Tage', '. (kurz)', 'kürzer'), ('Das Hotel ist', 'als die Wohnung. (teuer)', 'teurer'),
        ]),
        circle('als or wie?', 'Circle the right word.', [
            ('Sie ist genauso alt', ['als', 'wie'], 'ich.', 'wie'),
            ('Rocky ist größer', ['als', 'wie'], 'die Katze.', 'als'),
            ('Tee ist so gut', ['als', 'wie'], 'Kaffee.', 'wie'),
            ('Ich esse mehr Obst', ['als', 'wie'], 'Kuchen.', 'als'),
        ]),
        write('Compare', 'Write a sentence with -er and als.', [
            ('der Zug · der Bus · schnell', 'Der Zug ist schneller als der Bus.'),
            ('der Hund · die Katze · groß', 'Der Hund ist größer als die Katze.'),
            ('der Berg · das Haus · hoch', 'Der Berg ist höher als das Haus.'),
        ], 1),
    ],
    ['compare two things with -er and als',
     'use besser, mehr, lieber, höher',
     'say “just as … as” with genauso … wie'],
))

# ---- 12 · welcher? dieser! ----------------------------------------------------------------
spreads.append(spread(
    'welcher_dieser', 'welcher? dieser!', 'Pointing at the one you mean',
    'Welchen? Diesen hier! — and the same endings carry mein into the dative: mit meinem Bruder.',
    Q + 'welcher_dieser',
    [
        build('Same ending as the article', [
            (['d', ('er', 'suffix')], 'der', 'the article'),
            (['dies', ('er', 'suffix')], 'dieser', 'this'),
            (['welch', ('er', 'suffix')], 'welcher', 'which'),
            (['d', ('em', 'suffix')], 'dem', 'wem? — the article'),
            (['dies', ('em', 'suffix')], 'diesem', 'wem? — this'),
            (['welch', ('em', 'suffix')], 'welchem', 'wem? — which'),
        ]),
        table('welcher and dieser end like der', ['~', 'der', 'die', 'das', 'plural'], [
            ['wer?', 'welch*er* · dies*er*', 'welch*e* · dies*e*', 'welch*es* · dies*es*', 'welch*e* · dies*e*'],
            ['wen?', 'welch*en* · dies*en*', 'welch*e* · dies*e*', 'welch*es* · dies*es*', 'welch*e* · dies*e*'],
            ['wem?', 'welch*em* · dies*em*', 'welch*er* · dies*er*', 'welch*em* · dies*em*', 'welch*en* · dies*en*'],
        ], 'Look at the ending of der, die, das, dem — it’s the same.', genders=True),
        table('mein in the dative', ['~', 'der', 'die', 'das', 'plural'], [
            ['mit …', 'mein*em* Bruder', 'mein*er* Schwester', 'mein*em* Kind', 'mein*en* Eltern'],
        ], 'dein, sein, ihr, unser too: bei *seiner* Oma, mit *unseren* Freunden.', genders=True),
        cols(
            box('tip', 'Four endings for every dative',
                '*-m, -r, -m, -n*: dem, der, dem, den · einem, einer, einem · meinem, meiner, meinem, meinen · welchem, welcher, welchem, welchen.'),
            words('Pointing in speech', [
                ('Welche Tasche? – Die da.', 'Which bag? – That one.'),
                ('Welches Buch? – Das hier.', 'Which book? – This one.'),
                ('Welchen Mantel? – Diesen.', 'Which coat? – This one.'),
            ], 1),
        ),
        words('Words for the practice page', [
            ('das Kleid', 'dress'), ('die Hose', 'trousers'), ('der Chef', 'boss'), ('nehmen', 'to take'),
            ('welch- · dies-', 'which · this'),
        ], 4),
    ],
    [
        gaps('welch- and dies-', 'Write the right ending.', [
            ('Welch', 'Film läuft heute? (der)', 'er'), ('Welch', 'Tasche ist deine? (die)', 'e'),
            ('Welch', 'Buch möchtest du? (das)', 'es'), ('Welch', 'Mantel nimmst du? (den)', 'en'),
            ('Mit welch', 'Bus fährst du? (dem)', 'em'), ('Wir wohnen in dies', 'Haus. (dem)', 'em'),
        ]),
        gaps('With my …', 'Write meinem, meiner or meinen.', [
            ('Ich fahre mit', 'Bruder.', 'meinem'), ('Ich fahre mit', 'Schwester.', 'meiner'),
            ('Ich wohne bei', 'Eltern.', 'meinen'), ('Das Geschenk ist von', 'Oma.', 'meiner'),
        ]),
        match('In the shop', 'Draw a line from the question to the answer.', [
            ('Welche Hose nimmst du?', 'Die da.'),
            ('Welchen Mantel möchtest du?', 'Diesen hier.'),
            ('Welches Kleid gefällt dir?', 'Das hier.'),
            ('Mit wem gehst du ins Kino?', 'Mit meiner Schwester.'),
        ], [3, 0, 2, 1]),
    ],
    ['ask welcher? and answer dieser',
     'use the same endings in the dative',
     'say mit meinem, mit meiner, mit meinen'],
))

# ---- 13 · man, jemand, nichts ----------------------------------------------------------
spreads.append(spread(
    'indefinit', 'man, jemand, nichts', 'People and things without names',
    'Signs, rules and gossip: someone, no one, something, nothing — and the German “you”, man.',
    Q + 'indefinitpronomen',
    [
        table('Yes and no', ['yes', 'no', '~in English'], [
            ['jemand', 'niemand', 'someone · no one'],
            ['etwas', 'nichts', 'something · nothing'],
            ['alle', 'niemand', 'everyone · no one'],
            ['alles', 'nichts', 'everything · nothing'],
        ], 'Learn each word with its opposite.'),
        cols(
            box('tip', 'man is not a man',
                '*man* means “you, people” in general: Hier darf *man* nicht parken. Wie sagt *man* das auf Deutsch? It takes the er-form: man *sagt*, man *kann*.'),
            build('etwas Neues', [
                (['etwas', ('Neu', 'joint'), ('es', 'suffix')], 'etwas Neues', 'something new'),
                (['nichts', ('Besonder', 'joint'), ('es', 'suffix')], 'nichts Besonderes', 'nothing special'),
                (['etwas', ('Schön', 'joint'), ('es', 'suffix')], 'etwas Schönes', 'something nice'),
            ], 'A capital letter and -es.'),
        ),
        box('watch', 'alle or alles?',
            '*alle* are people — they: Alle *sind* da. *alles* is things — it: Alles *ist* fertig.'),
        words('Words for the practice page', [
            ('parken', 'to park'), ('klingeln · geklingelt', 'to ring (a bell)'), ('die Brille', 'glasses'),
            ('in Ordnung', 'fine, all right'), ('die Sorge · keine Sorge', 'worry · don’t worry'), ('fertig', 'ready, done'),
            ('noch', 'still, yet'), ('kennen', 'to know (people)'),
        ], 4),
    ],
    [
        gaps('Who? What?', 'Write man, jemand, niemand, etwas, nichts, alle or alles.', [
            ('Hier darf', 'nicht rauchen.', 'man'), ('', 'hat an der Tür geklingelt.', 'Jemand'),
            ('Ich habe angerufen, aber', 'war zu Hause.', 'niemand'), ('Möchtest du', 'trinken?', 'etwas'),
            ('Ich habe heute noch', 'gegessen.', 'nichts'), ('Am Samstag kommen', 'zur Party.', 'alle'),
            ('Keine Sorge,', 'ist in Ordnung.', 'alles'), ('Hat', 'meine Brille gesehen?', 'jemand'),
        ]),
        circle('alle or alles?', 'Circle the right word.', [
            ('', ['Alle', 'Alles'], 'sind da.', 'Alle'), ('', ['Alle', 'Alles'], 'ist fertig.', 'Alles'),
            ('Ich habe', ['alle', 'alles'], 'verstanden.', 'alles'), ('', ['Alle', 'Alles'], 'Kinder spielen.', 'Alle'),
        ]),
        write('Say the opposite', 'Write the sentence with the opposite word.', [
            ('Jemand ist zu Hause.', 'Niemand ist zu Hause.'),
            ('Ich habe etwas gehört.', 'Ich habe nichts gehört.'),
            ('Gibt es etwas Neues?', 'Es gibt nichts Neues.'),
        ], 1),
    ],
    ['use man for rules and habits',
     'say someone, no one, something, nothing',
     'tell alle from alles'],
))

# ---- 14 · Mein Wochenende -----------------------------------------------------------------
spreads.append(spread(
    'wochenende', 'Mein Wochenende', 'Telling a story — and writing it down',
    'First, then, after that — and weil for the reason: everything you need to tell a friend about your weekend.',
    Q + 'schreiben_wochenende',
    [
        tiles('In order', [
            ('zuerst', 'first'), ('dann', 'then'), ('danach', 'after that'), ('am Ende', 'in the end'),
        ], 4, note='Each takes place 1 — the verb comes right after it.'),
        slots('weil sends the verb to the end', [
            (sl('Ich', 'bin!', 'mit dem Zug', 'gefahren,'), None),
            (sl('weil', 'ich', 'nicht gern', 'fliege!'), 'because I don’t like flying'),
            (sl('Deshalb', 'haben!', 'wir', 'Pause gemacht.'), 'deshalb counts: verb next'),
        ], note='After weil the verb is the last word.'),
        table('An e-mail to a friend', ['', '~'], [
            ['Liebe Anna, · Lieber Tom,', 'to a woman · to a man'],
            ['wie geht’s? Ich erzähle dir von meinem Wochenende.', ''],
            ['Zuerst … Dann … Danach …', 'the story, in the Perfekt'],
            ['Es war super, weil …', 'how it was, and why'],
            ['Viele Grüße · Dein Max / Deine Lena', 'the end'],
        ]),
        words('Words for the practice page', [
            ('die Reise', 'trip'), ('dauern', 'to last'), ('das Museum', 'museum'), ('die Altstadt', 'old town'),
            ('das Meer', 'sea'), ('glücklich', 'happy'), ('das Flugzeug', 'plane'), ('weil · deshalb', 'because · so'),
            ('die Freundin · bei einer Freundin', 'friend · at a friend’s'), ('Pause machen', 'to take a break'),
            ('wohnen · gewohnt', 'to stay · stayed'), ('am letzten Tag', 'on the last day'), ('ans Meer', 'to the sea'),
        ], 3),
    ],
    [
        circle('Sofia’s trip', 'Listen to Sofia. Circle what you hear.', [
            ('Sofia ist mit dem', ['Zug', 'Flugzeug'], 'nach Italien gefahren.', 'Zug'),
            ('In Rom hat sie', ['bei einer Freundin', 'im Hotel'], 'gewohnt.', 'bei einer Freundin'),
            ('Das Wetter war', ['sehr heiß', 'kalt'], '.', 'sehr heiß'),
            ('Am letzten Tag sind sie ans', ['Meer', 'Museum'], 'gefahren.', 'Meer'),
            ('Nach einer', ['Woche', 'Stunde'], 'ist sie nach Hause gekommen.', 'Woche'),
        ], 1) | {'listen': True},
        write('Why?', 'Join the two sentences with weil.', [
            ('Ich bleibe zu Hause. Ich bin krank.', 'Ich bleibe zu Hause, weil ich krank bin.'),
            ('Wir fahren mit dem Zug. Wir fliegen nicht gern.', 'Wir fahren mit dem Zug, weil wir nicht gern fliegen.'),
            ('Lena ist glücklich. Sie hat Urlaub.', 'Lena ist glücklich, weil sie Urlaub hat.'),
        ], 1),
        gaps('Your e-mail', 'Write to a friend about your weekend.', [
            ('Liebe', ','), ('am Wochenende bin ich nach', 'gefahren.'),
            ('Zuerst habe ich', '.'), ('Dann', '.'), ('Es war super, weil', '.'),
        ], 'About you — every verb in the past, and after weil the verb last.'),
    ],
    ['tell a story in order: zuerst, dann, danach',
     'give a reason with weil',
     'write a short e-mail about my weekend'],
    listen=Q + 'hoeren_reise',
))

# ---- Review 2 · topics 8–14 ------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 8–14', 'The second half of the book, all at once. No looking back until you have done both pages.',
    Q + 'wortschatz',
    [
        circle('Little words', 'Circle the right word.', [
            ('Ich gehe', ['ins', 'im'], 'Kino.', 'ins'), ('Er kommt', ['vom', 'zum'], 'Arzt.', 'vom'),
            ('Ich wohne', ['seit', 'vor'], 'einem Jahr hier.', 'seit'), ('', ['Vor', 'Seit'], 'zwei Tagen war ich krank.', 'Vor'),
            ('Ich bin', ['zu', 'nach'], 'Hause.', 'zu'), ('Es', ['regnet', 'ist Regen'], '.', 'regnet'),
        ]),
        gaps('Compare', 'Write the comparing form.', [
            ('Mein Bruder ist', 'als ich. (jung)', 'jünger'), ('Das ist', 'als gestern. (gut)', 'besser'),
            ('Ich trinke', 'Tee als Kaffee. (gern)', 'lieber'),
        ]),
    ],
    [
        gaps('Endings', 'Write the ending.', [
            ('Welch', 'Buch nimmst du? (das)', 'es'), ('Ich fahre mit mein', 'Schwester. (die)', 'er'),
            ('Wir wohnen in dies', 'Haus. (dem)', 'em'),
        ]),
        gaps('Who? What?', 'Write jemand, niemand, etwas or nichts.', [
            ('Hat', 'angerufen? – Nein,', 'jemand'), ('Ich habe', 'gegessen. Ich habe Hunger!', 'nichts'),
        ]),
        write('Why?', 'Join with weil.', [
            ('Ich nehme einen Regenschirm. Es regnet.', 'Ich nehme einen Regenschirm, weil es regnet.'),
        ], 1),
        match('Question and answer', 'Draw a line from each question to its answer.', [
            ('Wie ist das Wetter?', 'Es schneit.'),
            ('Seit wann lernst du Deutsch?', 'Seit einem Jahr.'),
            ('Woher kommst du gerade?', 'Aus dem Kino.'),
            ('Welche Jacke nimmst du?', 'Die da.'),
        ], [3, 2, 0, 1]),
    ],
))

book = {
    'title': 'Erlebnisse',
    'cover': 'cp_a2_1_cover',
    'welcome': [
        'This book is the paper half of A2.1. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It carries on from the A1 books. Words you learned there are not taught again; where a topic builds on something from A1, a small note brings it back.',
        'Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Paul', 'Mia', 'Tom', 'Anna', 'Lisa', 'Sofia', 'Giulia', 'Rocky', 'Braun', 'Weber', 'Hamburg', 'Rom', 'Bonn'],
    'spreads': spreads,
    'overview': {'title': 'A2.1 at a glance', 'blocks': [
        table('wer? wen? wem?', ['~', 'der', 'die', 'das', 'plural'], [
            ['wer?', 'der · ein · mein · dieser', 'die · eine · meine · diese', 'das · ein · mein · dieses', 'die · – · meine · diese'],
            ['wen?', '*den* · *einen* · *meinen* · *diesen*', 'die · eine · meine · diese', 'das · ein · mein · dieses', 'die · – · meine · diese'],
            ['wem?', '*dem* · *einem* · *meinem* · *diesem*', '*der* · *einer* · *meiner* · *dieser*', '*dem* · *einem* · *meinem* · *diesem*', '*den* · – · *meinen* · *diesen* …-n'],
        ], 'The dative always ends -m, -r, -m, -n.', genders=True),
        table('ich, mich, mir', ['wer?', 'wen?', 'wem?', 'whose'], [
            ['ich', 'mich', 'mir', 'mein'], ['du', 'dich', 'dir', 'dein'], ['er · es', 'ihn · es', 'ihm', 'sein'],
            ['sie', 'sie', 'ihr', 'ihr'], ['wir', 'uns', 'uns', 'unser'], ['ihr', 'euch', 'euch', 'euer'],
            ['sie · Sie', 'sie · Sie', 'ihnen · Ihnen', 'ihr · Ihr'],
        ]),
        slots('Where the verbs go', [
            (sl('Ich', 'habe!', 'gestern Fußball', 'gespielt.!'), 'the past: haben or sein'),
            (sl('Ich', 'konnte!', 'leider nicht', 'kommen.!'), 'a helper in the past'),
            (sl('…, weil', 'ich', 'krank', 'bin.!'), 'weil: the verb last'),
        ]),
        cols(
            table('Little words and their case', ['', 'case'], [
                ['aus · bei · mit · nach · seit · von · zu', 'wem? dem, der'],
                ['durch · für · gegen · ohne · um', 'wen? den, die'],
            ]),
            table('Time', ['', '~'], [
                ['vor zwei Jahren', 'ago'], ['seit zwei Jahren', 'for — and still'], ['in einer Woche', 'from now'], ['für eine Woche', 'planned'],
            ]),
        ),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.', [
            ('die Sonne', 'sun', 'cpd_sonne'), ('der Regen', 'rain', 'cpd_regen'), ('der Schnee', 'snow', 'cpd_schnee'),
            ('der Wind', 'wind', 'cpd_wind'), ('die Wolke', 'cloud', 'cpd_wolke'), ('das Gewitter', 'thunderstorm', 'cpd_gewitter'),
            ('der Regenschirm', 'umbrella', 'cpd_regenschirm'), ('die Sonnenbrille', 'sunglasses', 'cpd_sonnenbrille'),
            ('der Zug', 'train', 'cpd_zug'), ('das Flugzeug', 'plane', 'cpd_flugzeug'), ('das Meer', 'sea', 'cpd_meer'),
            ('der Berg', 'mountain', 'cpd_berg'), ('das Hotel', 'hotel', 'cpd_hotel'), ('das Museum', 'museum', 'cpd_museum'),
            ('der Mantel', 'coat', 'cpd_mantel'), ('das Kleid', 'dress', 'cpd_kleid'), ('die Hose', 'trousers', 'cpd_hose'),
            ('der Rock', 'skirt', 'cpd_rock'), ('die Krawatte', 'tie', 'cpd_krawatte'), ('die Brille', 'glasses', 'cpd_brille'),
            ('der Brief', 'letter', 'cpd_brief'), ('die Zeitung', 'newspaper', 'cpd_zeitung'), ('der Stift', 'pen', 'cpd_stift'),
            ('der Ball', 'ball', 'cpd_ball'), ('der Knochen', 'bone', 'cpd_knochen'), ('die Blumen', 'flowers', 'cpd_blumen'),
            ('die Suppe', 'soup', 'cpd_suppe'), ('das Obst', 'fruit', 'cpd_obst'), ('der Bäcker', 'baker', 'cpd_baecker'),
            ('die Post', 'post office', 'cpd_post'), ('der Markt', 'market', 'cpd_markt'), ('die Ampel', 'traffic lights', 'cpd_ampel'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

kit.write_book(OUT, book)
