# Builds assets/content/companion/de_cert_a1/b1_1.json — the B1.1 study companion.
# Run: python -I tool/companion/b1_1.py   (rules: docs/study_companion_guide.md)
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_b1_1_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'b1_1.json')
Q = 'quest_b1_1_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ---- 1 · Die Welt der Arbeit ----------------------------------------------------------
spreads.append(spread(
    'arbeit', 'Die Welt der Arbeit', 'Jobs, applications, colleagues — and Feierabend',
    'From the job advert to Feierabend: the words you need to find work and to talk about it.',
    Q + 'arbeit',
    [
        slots('From the advert to the contract', [
            ([('die Stellenanzeige →', '1 read'), ('die Bewerbung →', '2 send'), ('das Vorstellungsgespräch →', '3 talk'),
              {'de': 'der Arbeitsvertrag', 'tag': '4 sign', 'hot': True}], None),
        ], note='Bring a Lebenslauf (CV) with the Bewerbung.'),
        table('Money and time', ['', '~'], [
            ['das Gehalt · der Lohn', 'salary · wage'], ['brutto · netto', 'before · after tax'],
            ['Vollzeit · Teilzeit', 'full-time · part-time'], ['Überstunden machen', 'to work overtime'],
            ['kündigen', 'to hand in your notice'], ['in Rente gehen', 'to retire'],
        ]),
        cols(
            words('People at work', [
                ('der Kollege · die Kollegin', 'colleague'), ('der Chef · die Chefin', 'boss'),
                ('der Angestellte', 'employee'), ('die Besprechung', 'meeting'), ('der Termin', 'appointment'),
            ], 1),
            box('culture', 'Feierabend',
                '*Feier* (celebration) + *Abend*: the end of the working day is a small party. At five, colleagues say *Schönen Feierabend!*'),
        ),
        words('Words for the practice page', [
            ('sich bewerben', 'to apply'), ('die Stelle', 'job, position'), ('der Lebenslauf', 'CV'),
            ('die Arbeitszeit', 'working hours'), ('das Möbelhaus', 'furniture shop'), ('organisieren', 'to organise'),
            ('die Verkäuferin', 'shop assistant'), ('abholen', 'to pick up'), ('Spanisch · Englisch', 'Spanish · English'),
            ('die Firma', 'company'), ('zwanzig Stunden pro Woche', 'twenty hours a week'), ('bis', 'until'),
        ], 3),
    ],
    [
        gaps('The job hunt', 'Write the missing word.', [
            ('Ich suche eine neue', '.', 'Stelle'), ('Ich schicke meine', 'an die Firma.', 'Bewerbung'),
            ('Für die Bewerbung brauche ich einen', '.', 'Lebenslauf'), ('Um zehn Uhr haben wir eine', '.', 'Besprechung'),
            ('Mit 67 geht man in', '.', 'Rente'), ('Das', 'ist nicht sehr hoch.', 'Gehalt'),
        ]),
        circle('The interview', 'Listen to the job interview. Circle what you hear.', [
            ('Frau Wagner hat in einem', ['Möbelhaus', 'Büro'], 'gearbeitet.', 'Möbelhaus'),
            ('Sie spricht Deutsch,', ['Englisch', 'Französisch'], 'und ein bisschen Spanisch.', 'Englisch'),
            ('Die Stelle ist', ['Teilzeit', 'Vollzeit'], ', zwanzig Stunden pro Woche.', 'Teilzeit'),
            ('Sie arbeitet von acht bis', ['zwölf', 'vier'], 'Uhr.', 'zwölf'),
        ], 1) | {'listen': True},
        gaps('Your work', 'Write two true sentences.', [
            ('Ich arbeite als', '.'), ('Am liebsten würde ich', 'arbeiten.'),
        ], 'About you — or the job you would like.'),
    ],
    ['talk about my job and the working day',
     'name the steps of applying for a job',
     'understand a job interview'],
    listen=Q + 'hoeren_interview',
))

# ---- 2 · der große Mann ---------------------------------------------------------------
spreads.append(spread(
    'adj_bestimmt', 'der große Mann', 'Endings after der, die, das: -e or -en',
    'After der, die, das the describing word has only two endings — and the -e sits in one small window.',
    Q + 'adj_bestimmt',
    [
        table('The -e window', ['~', 'der', 'die', 'das', 'plural'], [
            ['wer?', 'der groß*e*', 'die groß*e*', 'das groß*e*', 'die groß*en*'],
            ['wen?', 'den groß*en*', 'die groß*e*', 'das groß*e*', 'die groß*en*'],
            ['wem?', 'dem groß*en*', 'der groß*en*', 'dem groß*en*', 'den groß*en*'],
        ], 'Five -e’s in the top left; everything else -en.', genders=True),
        build('The article already says it', [
            (['der', 'groß', ('e', 'suffix'), 'Mann'], 'der große Mann', 'wer?'),
            (['den', 'groß', ('en', 'suffix'), 'Mann'], 'den großen Mann', 'wen?'),
            (['dem', 'klein', ('en', 'suffix'), 'Kind'], 'dem kleinen Kind', 'wem?'),
            (['die', 'rot', ('en', 'suffix'), 'Schuhe'], 'die roten Schuhe', 'plural: always -en'),
        ]),
        box('tip', 'dieser, jeder, welcher too',
            'They show the case like der does, so the same two endings follow: *dieser* große Mann, *jede* junge Frau, *welches* neue Auto?'),
        words('Words for the practice page', [
            ('singen', 'to sing'), ('frisch', 'fresh'), ('gelb', 'yellow'), ('schwarz', 'black'), ('mögen · ich mag', 'to like'),
        ], 4),
    ],
    [
        gaps('-e or -en?', 'Write the ending.', [
            ('Der groß', 'Mann liest.', 'e'), ('Ich sehe den groß', 'Mann.', 'en'),
            ('Die jung', 'Frau singt.', 'e'), ('Das neu', 'Auto ist teuer.', 'e'),
            ('Ich mag die rot', 'Schuhe.', 'en'), ('Ich helfe dem klein', 'Kind.', 'en'),
            ('Der schwarz', 'Kaffee schmeckt gut.', 'e'), ('Ich nehme das frisch', 'Brot.', 'e'),
        ]),
        write('Describe it', 'Write the sentence with the describing word.', [
            ('Ich kaufe den Tisch. (alt)', 'Ich kaufe den alten Tisch.'),
            ('Die Blumen sind schön. (gelb)', 'Die gelben Blumen sind schön.'),
            ('Wir wohnen in dem Haus. (blau)', 'Wir wohnen in dem blauen Haus.'),
        ], 1),
    ],
    ['use -e and -en after der, die, das',
     'find the five -e’s in the window',
     'say the red shoes, the old table'],
))

# ---- 3 · ein großer Mann ---------------------------------------------------------------
spreads.append(spread(
    'adj_unbestimmt', 'ein großer Mann', 'Endings after ein: three repairs',
    'Where ein shows nothing, the describing word does the job: er – es – es, and the rest as after der.',
    Q + 'adj_unbestimmt',
    [
        build('Three repairs: er – es – es', [
            (['ein', 'groß', ('er', 'suffix'), 'Mann'], 'ein großer Mann', 'wer? — ein says nothing, -er says der'),
            (['ein', 'neu', ('es', 'suffix'), 'Haus'], 'ein neues Haus', 'wer? — -es says das'),
            (['ein', 'schön', ('es', 'suffix'), 'Kleid'], 'ein schönes Kleid', 'wen? — -es again'),
        ], 'Remember “one signal is enough” from A2.2.'),
        table('Everything else: as after der', ['~', 'der', 'die', 'das', 'plural'], [
            ['wer?', 'ein groß*er*', 'eine groß*e*', 'ein groß*es*', 'meine groß*en*'],
            ['wen?', 'einen groß*en*', 'eine groß*e*', 'ein groß*es*', 'meine groß*en*'],
            ['wem?', 'einem groß*en*', 'einer groß*en*', 'einem groß*en*', 'meinen groß*en*'],
        ], 'kein, mein, dein … take the same endings.', genders=True),
        words('Words for the practice page', [
            ('schwierig', 'difficult'), ('stark', 'strong'), ('die Idee', 'idea'), ('Bern', 'Bern'),
        ], 4),
    ],
    [
        gaps('The ending', 'Write the ending.', [
            ('Das ist ein groß', 'Mann.', 'er'), ('Ich habe einen klein', 'Hund.', 'en'),
            ('Sie trägt eine rot', 'Jacke.', 'e'), ('Wir haben ein neu', 'Haus.', 'es'),
            ('Das ist ein schwierig', 'Problem.', 'es'), ('Das ist eine gut', 'Idee.', 'e'),
            ('Ich trinke einen stark', 'Kaffee.', 'en'), ('Mein groß', 'Bruder wohnt in Bern.', 'er'),
        ]),
        sort_ex('Repaired or not?', 'Write each in its column: does the describing word carry -er or -es?', ['-er · -es', '-e · -en'], [
            ('ein großer Mann', 0), ('einen großen Mann', 1), ('ein neues Buch', 0), ('eine neue Lampe', 1),
            ('mit einem großen Auto', 1), ('ein schönes Kleid', 0),
        ]),
    ],
    ['use -er and -es after ein',
     'use the same endings after mein, kein',
     'describe things with ein'],
))

# ---- 4 · Frisches Brot -----------------------------------------------------------------
spreads.append(spread(
    'adj_nullartikel', 'Frisches Brot', 'No article at all: the describing word takes the article’s ending',
    'Menus, flat adverts and headlines drop the article — so the describing word wears its ending.',
    Q + 'adj_nullartikel',
    [
        build('Cut the d-, glue the rest', [
            ([('d', 'cut'), 'er', '→ stark', ('er', 'suffix')], 'starker Kaffee', 'der Kaffee'),
            ([('d', 'cut'), 'ie', '→ frisch', ('e', 'suffix')], 'frische Milch', 'die Milch'),
            ([('d', 'cut'), 'as', '→ frisch', ('es', 'suffix')], 'frisches Brot', 'das Brot'),
            ([('d', 'cut'), 'em', '→ schön', ('em', 'suffix')], 'bei schönem Wetter', 'dem Wetter'),
        ], 'Take the article, drop the d, put what is left on the describing word.'),
        table('Where there is no article', ['', 'like this'], [
            ['things you can’t count', 'starker Kaffee · kaltes Wasser'],
            ['plurals', 'nette Leute · kleine Kinder'],
            ['after numbers, viele, einige', 'drei kleine Kinder · viele nette Leute'],
            ['adverts and headlines', 'Schöne Wohnung mit großem Balkon'],
        ]),
        box('watch', 'Two markers in the dative plural',
            'mit nett*en* Leute*n*, mit klein*en* Kinder*n*: the describing word takes -en and the noun takes -n.'),
        words('Words for the practice page', [
            ('der Balkon', 'balcony'), ('kostenlos', 'free'), ('kennenlernen', 'to get to know'),
            ('vermieten · zu vermieten', 'to let · to let'), ('hell', 'bright'), ('der Sprachkurs', 'language course'),
            ('nett', 'nice'), ('mit Freunden', 'with friends'), ('kennengelernt', 'got to know'),
        ], 3),
    ],
    [
        gaps('The ending', 'Write the ending.', [
            ('Zum Frühstück trinke ich stark', 'Kaffee. (wen?)', 'en'), ('Frisch', 'Brot schmeckt am besten.', 'es'),
            ('Ich trinke Tee mit warm', 'Milch.', 'er'), ('Bei schön', 'Wetter sitzen wir im Garten.', 'em'),
            ('Schöne Wohnung mit groß', 'Balkon zu vermieten.', 'em'), ('Ich treffe mich mit gut', 'Freunden.', 'en'),
            ('Im Sprachkurs habe ich viele nett', 'Leute kennengelernt.', 'e'),
        ]),
        write('Write the advert', 'Write a flat advert with the words given.', [
            ('schön · Wohnung · mit · groß · Balkon', 'Schöne Wohnung mit großem Balkon'),
            ('hell · Zimmer · mit · neu · Küche', 'Helles Zimmer mit neuer Küche'),
        ], 1),
    ],
    ['use endings when there is no article',
     'read flat adverts and menus',
     'say mit netten Leuten'],
))

# ---- 5 · die größere Wohnung ------------------------------------------------------------
spreads.append(spread(
    'adj_komparativ', 'die größere Wohnung', 'More and most — in front of a noun',
    'The bigger flat, the cheapest ticket, the best idea: first -er or -st, then the normal ending.',
    Q + 'adj_komparativ',
    [
        build('Two endings in a row', [
            (['schnell', ('er', 'joint'), ('en', 'suffix')], 'den schnelleren Zug', 'faster + the ending'),
            (['größ', ('er', 'joint'), ('e', 'suffix')], 'eine größere Wohnung', 'bigger + the ending'),
            (['kürz', ('est', 'joint'), ('e', 'suffix')], 'der kürzeste Weg', 'shortest + the ending'),
            (['schnell', ('er', 'joint'), ('er', 'suffix')], 'ein schnellerer Zug', 'looks odd — it’s right'),
        ], 'First more (-er) or most (-st), then the ending from topics 2–4.'),
        table('Their own stems', ['', 'more', 'most'], [
            ['gut', 'besser', '*best*-'], ['viel', 'mehr', '*meist*-'], ['hoch', 'höher', '*höchst*-'],
            ['nah', 'näher', '*nächst*-'], ['groß', 'größer', '*größt*-'], ['teuer', 'teurer', 'teuerst-'],
        ]),
        words('Words for the practice page', [
            ('günstig', 'cheap, good value'), ('der Preis', 'price'), ('sich leisten', 'to afford'), ('die meisten', 'most (people)'),
            ('pro Woche', 'per week'), ('das Angebot', 'offer'),
        ], 3),
    ],
    [
        gaps('More or most', 'Make the word in brackets, then add the ending.', [
            ('Wir suchen eine', 'Wohnung. (groß + er)', 'größere'), ('Das ist der', 'Weg zum Bahnhof. (kurz + est)', 'kürzeste'),
            ('Hast du keinen', 'Preis gefunden? (günstig + er)', 'günstigeren'), ('Berlin ist die', 'Stadt Deutschlands. (groß + t)', 'größte'),
            ('Das war die', 'Idee des Abends. (gut → best)', 'beste'), ('Die', 'Leute arbeiten zwei Tage pro Woche zu Hause. (viel → meist)', 'meisten'),
        ]),
        write('Compare the flats', 'Write one sentence with -er and one with -st.', [
            ('the flat · big (bigger)', 'Ich möchte eine größere Wohnung.'),
            ('the offer · cheap (cheapest)', 'Das ist das günstigste Angebot.'),
        ], 1, not_german=True),
    ],
    ['say the bigger flat, the best idea',
     'put -er or -st and then the ending',
     'use besser, meist-, höchst-, nächst-'],
))

# ---- 6 · Die Deutschen, etwas Neues ------------------------------------------------------
spreads.append(spread(
    'adj_nomen', 'die Deutschen, etwas Neues', 'Describing words that become nouns',
    'der Angestellte, die Deutschen, etwas Neues: a describing word with a capital letter keeps its ending.',
    Q + 'adjektive_als_nomen',
    [
        build('Picture an invisible noun', [
            (['der', 'Angestellt', ('e', 'suffix'), ('(Mann)', 'cut')], 'der Angestellte', 'like der große Mann'),
            (['ein', 'Angestellt', ('er', 'suffix'), ('(Mann)', 'cut')], 'ein Angestellter', 'like ein großer Mann'),
            (['die', 'Deutsch', ('en', 'suffix'), ('(Leute)', 'cut')], 'die Deutschen', 'like die großen Leute'),
            (['etwas', 'Neu', ('es', 'suffix')], 'etwas Neues', 'something new'),
        ], 'The ending is the one the describing word would have before that noun.'),
        table('One word, three people', ['a man', 'a woman', 'people'], [
            ['der Deutsche · ein Deutscher', 'die Deutsche · eine Deutsche', 'die Deutschen · Deutsche'],
            ['der Verwandte', 'die Verwandte', 'die Verwandten'], ['der Erwachsene', 'die Erwachsene', 'die Erwachsenen'],
        ]),
        box('tip', 'alles Gute!',
            'Neuter ones name ideas: *das Gute, das Wichtigste, alles Gute* (all the best). After etwas, nichts, viel: -es — *nichts Besonderes*.'),
        words('Words for the practice page', [
            ('angestellt', 'employed'), ('erwachsen', 'grown-up'), ('verwandt', 'related'), ('bekannt', 'known'),
            ('arbeitslos', 'unemployed'), ('die Hochzeit', 'wedding'), ('die Hälfte', 'half'), ('verheiratet', 'married'),
            ('die Bank', 'bank'), ('bekommen', 'to get'), ('zahlen', 'to pay'), ('nur', 'only'), ('in unserem Team', 'in our team'),
            ('das Wichtigste', 'the most important thing'), ('die Gesundheit', 'health'),
        ], 4),
    ],
    [
        gaps('Make it a noun', 'Write the word in brackets as a noun, with its ending.', [
            ('Mein Bruder ist', 'bei einer Bank. (angestellt)', 'Angestellter'),
            ('Alle', 'bekommen dreißig Tage Urlaub. (angestellt)', 'Angestellten'),
            ('', 'zahlen zehn Euro, Kinder nur die Hälfte. (erwachsen)', 'Erwachsene'),
            ('Sie ist mit einem', 'verheiratet. (deutsch)', 'Deutschen'),
            ('Zu meiner Hochzeit kommen alle', '. (verwandt)', 'Verwandten'),
            ('Der', 'in unserem Team heißt Paul. (neu)', 'Neue'),
        ]),
        match('Something, nothing', 'Draw a line from the question to the answer.', [
            ('Gibt es etwas Neues?', 'Nein, nichts Besonderes.'),
            ('Was wünschst du mir?', 'Alles Gute!'),
            ('Was ist das Wichtigste?', 'Die Gesundheit.'),
        ], [1, 2, 0]),
    ],
    ['say der Angestellte, die Deutschen',
     'use the right ending for the hidden noun',
     'say etwas Neues, nichts Besonderes'],
))

# ---- 7 · Ich würde gern … ------------------------------------------------------------------
spreads.append(spread(
    'konj2_wuerde', 'Ich würde gern …', 'Wishes, polite requests, advice — with würde',
    'One little word, würde, and you can wish, ask politely, give advice and imagine “what if”.',
    Q + 'konj2_wuerde',
    [
        slots('würde + the verb at the end', [
            (sl('Ich', 'würde!', 'gern mehr', 'reisen.!'), 'a wish'),
            (sl('Würden!', 'Sie', 'mir bitte das Salz', 'reichen?!'), 'a polite request'),
            (sl('An deiner Stelle', 'würde!', 'ich das nicht', 'machen.!'), 'advice'),
        ], note='The bracket of every helper verb.'),
        flow('würde or one word?', q('haben, sein, a helper verb?',
                                     a('one word', 'hätte · wäre · könnte'), a('würde + verb', 'ich würde reisen')),
             note='Topic 8 shows the one-word forms.'),
        table('würde', ['ich', 'du', 'er · sie · es', 'wir', 'ihr', 'sie · Sie'], [
            ['würde', 'würdest', 'würde', 'würden', 'würdet', 'würden'],
        ]),
        words('Words for the practice page', [
            ('an deiner Stelle', 'if I were you'), ('reichen', 'to pass'), ('annehmen', 'to accept'),
            ('mitkommen', 'to come along'), ('der Tanzkurs', 'dance class'), ('klettern', 'to climb'),
            ('öfter', 'more often'), ('der Krimi', 'crime novel'), ('grillen', 'to barbecue'), ('der Job', 'job'), ('treffen · er trifft', 'to meet'),
        ], 3),
    ],
    [
        gaps('würde', 'Write würde in the right form.', [
            ('Ich', 'gern mehr reisen.', 'würde'), ('', 'du mir kurz helfen?', 'Würdest'),
            ('Wir', 'gern ein Haus kaufen.', 'würden'), ('', 'ihr gern mitkommen?', 'Würdet'),
            ('An deiner Stelle', 'ich den Job nicht nehmen.', 'würde'),
        ]),
        circle('What would they like?', 'Listen to the radio survey. Circle what you hear.', [
            ('Die junge Frau würde gern einen', ['Tanzkurs', 'Kochkurs'], 'machen.', 'Tanzkurs'),
            ('Der Mann würde gern mehr', ['reisen', 'lesen'], '.', 'reisen'),
            ('Der Student trifft am liebsten', ['Freunde', 'seine Eltern'], '.', 'Freunde'),
        ], 1) | {'listen': True},
        gaps('Your wishes', 'Write two true sentences.', [
            ('Ich würde gern', '.'), ('An deiner Stelle würde ich', '.'),
        ], 'About you — würde second, the verb last.'),
    ],
    ['say what I would like to do',
     'ask politely with Würden Sie …?',
     'give advice: An deiner Stelle würde ich …'],
    listen=Q + 'hoeren_umfrage',
))

# ---- 8 · Wenn ich Zeit hätte … --------------------------------------------------------------
spreads.append(spread(
    'konj2_haette', 'Wenn ich Zeit hätte …', 'hätte, wäre, könnte — and “what if”',
    'Wenn ich Zeit hätte, würde ich kommen: two dots turn the past into a dream.',
    Q + 'konj2_haette',
    [
        build('The past + two dots', [
            (['h', ('ä', 'suffix'), 'tte'], 'hätte', 'hatte → would have'),
            (['w', ('ä', 'suffix'), 're'], 'wäre', 'war → would be'),
            (['k', ('ö', 'suffix'), 'nnte'], 'könnte', 'konnte → could'),
            (['m', ('ü', 'suffix'), 'sste'], 'müsste', 'musste → ought to'),
        ], 'Also dürfte, wüsste. sollte and wollte stay as they are.'),
        slots('If … then …', [
            (sl('Wenn', 'ich', 'Zeit', 'hätte,!', 'würde!', 'ich kommen.'), 'If I had time, I would come.'),
            (sl('Wenn', 'er', 'reich', 'wäre,!', 'könnte!', 'er reisen.'), 'If he were rich, he could travel.'),
        ], note='Both halves dream: the verbs meet at the comma.'),
        box('tip', 'A sigh: nur, doch',
            '*Wenn ich nur mehr Zeit hätte!* — If only I had more time! *Wäre ich doch zu Hause geblieben!*'),
        words('Words for the practice page', [
            ('reich', 'rich'), ('froh', 'glad'), ('eigentlich', 'really, actually'), ('der Akku', 'battery'),
            ('leer', 'empty, flat'), ('benutzen', 'to use'), ('wirklich', 'really'),
        ], 3),
    ],
    [
        gaps('Two dots', 'Write the dream form of the verb in brackets.', [
            ('Ich', 'gern mehr Zeit. (haben)', 'hätte'), ('Das', 'wirklich schön. (sein)', 'wäre'),
            ('', 'du mir kurz helfen? (können)', 'Könntest'), ('Wir', 'jetzt eigentlich gehen. (müssen)', 'müssten'),
            ('Wenn ich reich', ', würde ich reisen. (sein)', 'wäre'), ('Mein Akku ist leer.', 'ich Ihr Telefon benutzen? (dürfen)', 'Dürfte'),
        ]),
        write('What if?', 'Write a wenn-sentence.', [
            ('Ich habe keine Zeit. Ich komme nicht.', 'Wenn ich Zeit hätte, würde ich kommen.'),
            ('Ich bin nicht reich. Ich kann nicht reisen.', 'Wenn ich reich wäre, könnte ich reisen.'),
        ], 1),
        gaps('Your dream', 'Finish the sentence.', [
            ('Wenn ich mehr Zeit hätte,', '.'),
        ], 'About you — würde or könnte after the comma.'),
    ],
    ['use hätte, wäre, könnte',
     'say what would happen if …',
     'make a wish with nur or doch'],
))

# ---- Review 1 · topics 1–8 -------------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–8', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        gaps('Endings', 'Write the ending.', [
            ('Der neu', 'Kollege ist nett.', 'e'), ('Ich habe einen neu', 'Chef.', 'en'),
            ('Das ist ein groß', 'Problem.', 'es'), ('Wir trinken stark', 'Kaffee. (wen?)', 'en'),
            ('Das ist die', 'Idee. (best)', 'beste'), ('Alle', 'kommen. (verwandt)', 'Verwandten'),
        ]),
    ],
    [
        gaps('Dreams and wishes', 'Write würde, hätte, wäre or könnte.', [
            ('Ich', 'gern mehr reisen.', 'würde'), ('Wenn ich Zeit', ', würde ich kommen.', 'hätte'),
            ('Das', 'schön!', 'wäre'), ('', 'Sie mir helfen?', 'Könnten'),
        ]),
        write('At work', 'Write the German word with der, die or das.', [
            ('application', 'die Bewerbung'), ('salary', 'das Gehalt'), ('CV', 'der Lebenslauf'), ('end of the working day', 'der Feierabend'),
        ], 2, not_german=True),
    ],
))

# ---- 9 · Ich werde … -----------------------------------------------------------------------
spreads.append(spread(
    'futur', 'Ich werde …', 'The future — and the three jobs of werden',
    'werden + a verb at the end: promises, predictions and good guesses.',
    Q + 'futur',
    [
        flow('Which werden?', q('Is there a verb at the end (regnen)?',
                                a('future', 'Es wird regnen.'),
                                q('A past form at the end (gebaut)?', a('passive', 'Es wird gebaut.'), a('become', 'Er wird Arzt.'))),
             note='werden has three jobs; look at what comes after it.'),
        table('werden', ['ich', 'du', 'er · sie · es', 'wir', 'ihr', 'sie · Sie'], [
            ['werde', '*wirst*', '*wird*', 'werden', 'werdet', 'werden'],
        ]),
        slots('A promise, a prediction, a guess', [
            (sl('Ich', 'werde!', 'dich nie', 'vergessen.!'), 'a promise'),
            (sl('Morgen', 'wird!', 'es', 'regnen.!'), 'a prediction'),
            (sl('Er', 'wird!', 'wohl im Büro', 'sein.!'), 'a guess about now: wohl'),
        ]),
        box('tip', 'Plans: just the present',
            'For a fixed plan Germans use the present: *Morgen gehe ich ins Kino.* werden is for promises, predictions and guesses.'),
        words('Words for the practice page', [
            ('vergessen', 'to forget'), ('heiraten', 'to marry'), ('umziehen', 'to move house'), ('wohl', 'probably'),
            ('erklären', 'to explain'), ('bald', 'soon'), ('nächstes Jahr', 'next year'),
        ], 3),
    ],
    [
        gaps('werden', 'Write werden in the right form.', [
            ('Morgen', 'es regnen.', 'wird'), ('Ich', 'dich nie vergessen.', 'werde'),
            ('', 'du zur Party kommen?', 'Wirst'), ('Wir', 'bald umziehen.', 'werden'),
            ('Sie', 'nächstes Jahr heiraten.', 'wird'), ('', 'ihr uns im Sommer besuchen?', 'Werdet'),
        ]),
        circle('Which job?', 'Circle what werden does here.', [
            ('Es wird regnen. —', ['future', 'become'], '', 'future'), ('Er wird Arzt. —', ['future', 'become'], '', 'become'),
            ('Das Haus wird gebaut. —', ['passive', 'future'], '', 'passive'),
        ], 1),
        gaps('Your promise', 'Write one promise.', [('Ich werde', '.')], 'About you — the verb at the end.'),
    ],
    ['talk about the future with werden',
     'make a promise and a prediction',
     'tell the three jobs of werden apart'],
))

# ---- 10 · der Kollege, mit dem … ---------------------------------------------------------------
spreads.append(spread(
    'relativ', 'der Kollege, mit dem …', 'Who, whom, with whom: describing in one sentence',
    'Der Kollege, der neben mir sitzt; der Kollege, mit dem ich arbeite: the case comes from inside the clause.',
    Q + 'relativ',
    [
        table('Same as the article — one new word', ['~', 'der', 'die', 'das', 'plural'], [
            ['wer?', 'der', 'die', 'das', 'die'], ['wen?', 'den', 'die', 'das', 'die'],
            ['wem?', 'dem', 'der', 'dem', '*denen*'],
        ], 'Only denen is new.', genders=True),
        slots('Ask inside the clause', [
            (sl('der Kollege,', 'der!', 'neben mir', 'sitzt'), 'he sits → wer?'),
            (sl('der Kollege,', 'den!', 'ich gut', 'kenne'), 'I know him → wen?'),
            (sl('der Kollege,', 'dem!', 'ich', 'helfe'), 'I help him → wem?'),
            (sl('der Kollege,', 'mit dem!', 'ich', 'arbeite'), 'mit → wem?'),
            (sl('die Freunde,', 'mit denen!', 'ich', 'reise'), 'mit → wem?, plural'),
        ]),
        box('tip', 'The little word goes first',
            'Never at the end, as in English: das Thema, *über das* wir sprechen. For places you can say *wo*: das Café, *wo* wir uns kennengelernt haben.'),
        words('Words for the practice page', [
            ('zusammenarbeiten', 'to work together'), ('vertrauen', 'to trust'), ('das Thema', 'topic'),
            ('grüßen', 'to greet'), ('spannend', 'exciting'), ('bestellen', 'to order'), ('danken · gedankt', 'to thank'),
        ], 3),
    ],
    [
        gaps('Which word?', 'Write der, die, das, den, dem or denen.', [
            ('Das ist der Mann,', 'dort steht.', 'der'), ('Das ist der Mann,', 'ich gut kenne.', 'den'),
            ('Das Buch,', 'ich lese, ist spannend.', 'das'), ('Das ist das Kind,', 'ich helfe.', 'dem'),
            ('Das ist der Nachbar,', 'ich gedankt habe.', 'dem'), ('Die Freunde,', 'ich vertraue, wohnen in Bonn.', 'denen'),
        ]),
        gaps('With the little word', 'Write the little word and the pronoun.', [
            ('Das ist der Kollege,', 'ich zusammenarbeite. (mit)', 'mit dem'), ('Das ist die Wohnung,', 'wir wohnen. (in)', 'in der'),
            ('Das ist der Mann,', 'ich warte. (auf)', 'auf den'), ('Das ist das Thema,', 'wir sprechen. (über)', 'über das'),
        ]),
    ],
    ['describe people and things with der, den, dem, denen',
     'put the little word first: mit dem, auf den',
     'find the case inside the clause'],
))

# ---- 11 · wegen des Wetters --------------------------------------------------------------------
spreads.append(spread(
    'genitiv', 'wegen des Wetters', 'Whose: the genitive',
    'Die Farbe des Hauses, wegen des Wetters: the genitive is how written German says “of the”.',
    Q + 'genitiv',
    [
        table('The fourth row: wessen?', ['~', 'der', 'die', 'das', 'plural'], [
            ['wer?', 'der Mann', 'die Frau', 'das Kind', 'die Kinder'],
            ['wessen?', '*des* Mann*es*', '*der* Frau', '*des* Kind*es*', '*der* Kinder'],
        ], 'der- and das-words take -s or -es too; die-words and plurals don’t change.', genders=True),
        build('of the …', [
            (['das Auto', ('meines', 'joint'), 'Vater', ('s', 'suffix')], 'das Auto meines Vaters', 'my father’s car'),
            (['die Farbe', ('des', 'joint'), 'Haus', ('es', 'suffix')], 'die Farbe des Hauses', 'the colour of the house'),
            (['die Tasche', ('der', 'joint'), 'Lehrerin'], 'die Tasche der Lehrerin', 'no -s for die-words'),
        ]),
        cols(
            tiles('Little words with the genitive', [
                ('wegen', 'because of'), ('während', 'during'), ('trotz', 'despite'), ('statt', 'instead of'),
            ], 2),
            box('tip', 'In speech: von',
                'das Auto *von* meinem Bruder = das Auto meines Bruders. von is casual; you will read the genitive everywhere.'),
        ),
        words('Words for the practice page', [
            ('der Titel', 'title'), ('die Meinung', 'opinion'), ('der Anfang · das Ende', 'beginning · end'),
            ('weinen · geweint', 'to cry'), ('das Konzert', 'concert'), ('der Regen', 'rain'), ('draußen', 'outside'),
            ('die Besprechungen', 'meetings'), ('spazieren gehen', 'to go for a walk'),
        ], 3),
    ],
    [
        gaps('Whose?', 'Write it with the genitive.', [
            ('Das ist das Auto', '. (mein Vater)', 'meines Vaters'), ('Die Farbe', 'gefällt mir nicht. (das Haus)', 'des Hauses'),
            ('Das ist die Tasche', '. (die Lehrerin)', 'der Lehrerin'), ('Am Ende', 'haben alle geweint. (der Film)', 'des Films'),
            ('Die Eltern', 'warten draußen. (die Kinder)', 'der Kinder'), ('Am Anfang', 'haben wir viele Besprechungen. (die Woche)', 'der Woche'),
        ]),
        gaps('Because of, during', 'Write the genitive after the little word.', [
            ('Wegen', 'bleiben wir zu Hause. (das Wetter)', 'des Wetters'), ('Während', 'war es sehr laut. (das Konzert)', 'des Konzerts'),
            ('Trotz', 'gehen wir spazieren. (der Regen)', 'des Regens'),
        ]),
    ],
    ['say whose with des and der',
     'use wegen, während, trotz',
     'read the genitive in written German'],
))

# ---- 12 · als, wenn, obwohl ---------------------------------------------------------------------
spreads.append(spread(
    'konjunktionen', 'als, wenn, obwohl', 'One time or every time — and “although”',
    'English “when” splits in two: als for one moment in the past, wenn for everything else.',
    Q + 'konjunktionen',
    [
        flow('als or wenn?', q('One time, in the past?', a('als', 'Als ich ein Kind war …'), a('wenn', 'Wenn ich Zeit habe …')),
             note='Can you say “every time” or “if”? Then it’s wenn.'),
        table('One time — every time', ['als (one photo)', 'wenn (a film on repeat, or if)'], [
            ['Als ich achtzehn wurde, …', 'Wenn ich Zeit habe, …'],
            ['Als wir in Rom waren, …', 'Immer wenn wir bei Oma waren, …'],
            ['Als der Film begann, …', 'Wenn du morgen anrufst, …'],
        ]),
        slots('obwohl and trotzdem: one meaning, two orders', [
            (sl('Obwohl', 'es kalt', 'ist,!', 'gehen!', 'wir spazieren.'), 'obwohl: verb last'),
            (sl('Es ist kalt.', 'Trotzdem', 'gehen!', 'wir spazieren.'), 'trotzdem: verb next'),
        ], note='Like weil and deshalb.'),
        words('Words for the practice page', [
            ('obwohl', 'although'), ('trotzdem', 'all the same'), ('der Führerschein', 'driving licence'),
            ('Köln', 'Cologne'), ('immer wenn', 'whenever'), ('beginnen · begann', 'to begin · began'), ('wir wohnten', 'we lived'), ('weiter', 'on, further'),
        ], 3),
    ],
    [
        gaps('als, wenn or obwohl?', 'Write the right word.', [
            ('', 'ich Zeit habe, lese ich.', 'Wenn'), ('', 'ich ein Kind war, wohnten wir in Köln.', 'Als'),
            ('Wir gehen spazieren,', 'es kalt ist.', 'obwohl'), ('', 'du morgen anrufst, bin ich zu Hause.', 'Wenn'),
            ('Immer', 'wir bei Oma waren, gab es Kuchen.', 'wenn'), ('', 'ich achtzehn wurde, machte ich den Führerschein.', 'Als'),
        ]),
        write('Say it with trotzdem', 'Write it again with trotzdem.', [
            ('Obwohl es regnet, gehen wir spazieren.', 'Es regnet. Trotzdem gehen wir spazieren.'),
            ('Obwohl er müde ist, arbeitet er weiter.', 'Er ist müde. Trotzdem arbeitet er weiter.'),
        ], 1),
        gaps('Your childhood', 'Write one true sentence.', [('Als ich ein Kind war,', '.')], 'About you.'),
    ],
    ['tell als from wenn',
     'say although with obwohl',
     'turn obwohl into trotzdem'],
))

# ---- 13 · falls, da, trotzdem -------------------------------------------------------------------
spreads.append(spread(
    'falls_da', 'falls, da …', 'In case, as — and the verb tells you which word',
    'falls for in case, da for a known reason — and one look at the verb tells you which kind of word you need.',
    Q + 'falls_da_trotzdem',
    [
        flow('Which kind of word?', q('Does the verb go to the end?',
                                      a('falls · da · weil · obwohl · wenn', '…, falls es regnet.'),
                                      a('trotzdem · deshalb', 'Trotzdem gehen wir.'))),
        table('Pairs', ['verb last', 'verb next', '~'], [
            ['weil', 'deshalb', 'because — so'], ['obwohl', 'trotzdem', 'although — all the same'],
            ['da', '', 'as, since (a known reason)'], ['falls', '', 'in case, if'],
        ]),
        box('tip', 'Only falls means “in case”',
            'Nimm einen Schirm mit, *falls* es regnet. For “if”, wenn works too; for “in case”, only falls.'),
        words('Words for the practice page', [
            ('der Schirm', 'umbrella'), ('die Verspätung', 'delay'), ('langweilig', 'boring'), ('vorbeikommen', 'to drop by'),
            ('später', 'later'), ('bis zum Ende', 'until the end'), ('wir gingen', 'we went'), ('es regnete', 'it rained'),
        ], 4),
    ],
    [
        gaps('Which word?', 'Write falls, da, obwohl, trotzdem or deshalb.', [
            ('Nimm einen Schirm mit,', 'es später regnet.', 'falls'), ('', 'ich kein Auto habe, fahre ich mit dem Rad.', 'Da'),
            ('Der Film war langweilig. Wir sind', 'bis zum Ende geblieben.', 'trotzdem'),
            ('Wir gingen spazieren,', 'es stark regnete.', 'obwohl'), ('Ich bin sehr müde,', 'gehe ich früh ins Bett.', 'deshalb'),
            ('', 'Sie noch Fragen haben, schreiben Sie mir.', 'Falls'),
        ]),
        circle('Where is the verb?', 'Circle the right order.', [
            ('Es regnet.', ['Trotzdem gehen wir', 'Trotzdem wir gehen'], 'spazieren.', 'Trotzdem gehen wir'),
            ('Da', ['ich kein Auto habe', 'habe ich kein Auto'], ', fahre ich Rad.', 'ich kein Auto habe'),
        ], 1),
    ],
    ['plan for the unexpected with falls',
     'give a known reason with da',
     'choose the word by where the verb goes'],
))

# ---- 14 · zu + Infinitiv ---------------------------------------------------------------------
spreads.append(spread(
    'infinitiv_zu', 'Ich habe vor, … zu …', 'zu + the verb: plans, tries, forgets',
    'Ich versuche, früh aufzustehen: zu + the verb at the very end — and inside a verb that splits.',
    Q + 'infinitiv_zu',
    [
        build('zu, and inside verbs that split', [
            (['zu', 'lernen'], 'zu lernen', 'Ich habe vor, Deutsch zu lernen.'),
            (['auf', ('zu', 'suffix'), 'stehen'], 'aufzustehen', 'Ich versuche, früh aufzustehen.'),
            (['an', ('zu', 'suffix'), 'rufen'], 'anzurufen', 'Ich habe vergessen anzurufen.'),
        ]),
        table('What brings zu', ['', 'for example'], [
            ['verbs', 'vorhaben, versuchen, anfangen, aufhören, vergessen, hoffen'],
            ['noun + haben', 'Lust haben, Zeit haben, Angst haben'],
            ['es ist + describing word', 'es ist wichtig, schön, schwer, verboten'],
        ]),
        cols(
            box('watch', 'No zu after helper verbs',
                'Ich *will* schlafen. Ich *gehe* einkaufen. Ich *lerne* schwimmen. — no zu after the helpers, gehen, lernen, lassen, sehen, hören.'),
            slots('um … zu: in order to', [
                (sl('Ich lerne Deutsch,', 'um', 'hier', 'zu arbeiten.!'), None),
            ]),
        ),
        words('Words for the practice page', [
            ('vorhaben', 'to plan'), ('versuchen', 'to try'), ('Lust haben', 'to feel like'), ('üben', 'to practise'),
            ('ausgehen', 'to go out'), ('brauchen nicht … zu', 'need not'),
        ], 3),
    ],
    [
        gaps('zu + the verb', 'Write the verb in brackets with zu.', [
            ('Ich habe vor, Deutsch', '. (lernen)', 'zu lernen'), ('Sie versucht, früh', '. (aufstehen)', 'aufzustehen'),
            ('Wir haben keine Zeit', '. (kochen)', 'zu kochen'), ('Es ist wichtig, jeden Tag', '. (üben)', 'zu üben'),
            ('Hast du Lust', '? (ausgehen)', 'auszugehen'), ('Ich habe vergessen', '. (anrufen)', 'anzurufen'),
        ]),
        circle('zu or not?', 'Circle the right form.', [
            ('Ich will', ['schlafen', 'zu schlafen'], '.', 'schlafen'), ('Ich versuche', ['schlafen', 'zu schlafen'], '.', 'zu schlafen'),
            ('Du brauchst nicht', ['kommen', 'zu kommen'], '.', 'zu kommen'), ('Ich gehe', ['einkaufen', 'einzukaufen'], '.', 'einkaufen'),
        ]),
        gaps('Your plans', 'Write one true sentence.', [('Ich habe vor,', '.')], 'About you — zu + the verb last.'),
    ],
    ['say what I plan, try and forget with zu',
     'put zu inside verbs that split',
     'know when there is no zu'],
))

# ---- 15 · es gibt, es lohnt sich ------------------------------------------------------------------
spreads.append(spread(
    'es', 'es gibt, es lohnt sich', 'Little es-chunks you learn whole',
    'Mir ist kalt, es lohnt sich, es kommt darauf an: learn these chunks whole and you sound like a native.',
    Q + 'es',
    [
        slots('The person comes first', [
            (sl('Mir', 'ist!', 'kalt.'), 'I’m cold.'), (sl('Mir', 'ist!', 'schlecht.'), 'I feel sick.'),
            (sl('Es', 'tut!', 'mir leid.'), 'I’m sorry.'), (sl('In der Stadt', 'gibt!', 'es viele Cafés.'), 'there are'),
        ], note='mir, not ich: the feeling happens to you.'),
        table('Chunks for any discussion', ['', '~'], [
            ['Es gibt einen Park.', 'there is'], ['Es lohnt sich (nicht).', 'it’s (not) worth it'],
            ['Es kommt darauf an.', 'it depends'], ['Es geht um …', 'it’s about'],
            ['Es macht nichts.', 'it doesn’t matter'], ['Es ist schade, dass …', 'it’s a pity that'],
        ]),
        box('watch', 'es gibt is always gibt',
            'Es *gibt* einen Park, es *gibt* viele Cafés — singular, whatever follows. The thing after it takes den, einen.'),
        words('Words for the practice page', [
            ('sich lohnen', 'to be worth it'), ('regnen', 'to rain'), ('schmecken', 'to taste good'), ('spät', 'late'),
        ], 4),
    ],
    [
        gaps('The chunk', 'Write the missing word.', [
            ('In der Stadt', 'es viele Cafés.', 'gibt'), ('Wie', 'es dir?', 'geht'),
            ('Der Kurs ist teuer, aber es lohnt', '.', 'sich'), ('Es tut mir', ', ich habe keine Zeit.', 'leid'),
            ('Mach bitte das Fenster zu,', 'ist kalt!', 'mir'), ('Kommst du? – Es kommt', 'an.', 'darauf'),
        ]),
        write('What do you say?', 'Write the German chunk.', [
            ('You are cold.', 'Mir ist kalt.'), ('You are sorry.', 'Es tut mir leid.'),
            ('It doesn’t matter.', 'Es macht nichts.'), ('It depends.', 'Es kommt darauf an.'),
        ], 2, not_german=True),
    ],
    ['say how I feel: mir ist kalt',
     'use es gibt, es lohnt sich, es kommt darauf an',
     'answer with a ready-made chunk'],
))

# ---- 16 · worauf? darauf! ------------------------------------------------------------------------
spreads.append(spread(
    'verben_praep', 'worauf? darauf!', 'Verbs with their little word — things and people',
    'warten auf, Angst haben vor: point back at a thing with darauf — but at a person with auf ihn.',
    Q + 'verben_praep',
    [
        flow('A thing or a person?', q('A thing or an idea?',
                                       a('wo(r)- · da(r)-', 'Worauf? — Darauf.'), a('the word + wen/wem', 'Auf wen? — Auf sie.'))),
        table('New at B1', ['verb', '+', '~'], [
            ['sich bewerben', 'um + den', 'apply for'], ['Angst haben', 'vor + dem', 'be afraid of'],
            ['teilnehmen', 'an + dem', 'take part in'], ['sich beschweren', 'über + den', 'complain about'],
            ['sich kümmern', 'um + den', 'look after'],
        ], 'Remember warten auf, denken an, sich freuen auf from A2.2.'),
        build('da- points back like “it”', [
            (['da', 'für'], 'dafür', 'for it'), (['da', ('r', 'joint'), 'über'], 'darüber', 'about it'),
            (['da', 'vor'], 'davor', 'of it'), (['da', ('r', 'joint'), 'an'], 'daran', 'of it, on it'),
        ]),
        words('Words for the practice page', [
            ('die Politik', 'politics'), ('der Lärm', 'noise'), ('die Ferien', 'holidays'), ('die Schwester', 'sister'),
            ('zwanzig Minuten', 'twenty minutes'), ('beworben', 'applied'),
        ], 4),
    ],
    [
        gaps('The little word', 'Write the little word.', [
            ('Ich warte seit zwanzig Minuten', 'den Bus.', 'auf'), ('Hast du dich schon', 'die Stelle beworben?', 'um'),
            ('Meine Schwester interessiert sich', 'Politik.', 'für'), ('Der Nachbar hat sich', 'den Lärm beschwert.', 'über'),
            ('Er hat Angst', 'dem Hund.', 'vor'),
        ]),
        circle('A thing or a person?', 'Circle the right question.', [
            ('', ['Worauf', 'Auf wen'], 'wartest du? – Auf meine Schwester.', 'Auf wen'),
            ('', ['Worauf', 'Auf wen'], 'freust du dich? – Auf die Ferien.', 'Worauf'),
            ('', ['Wofür', 'Für wen'], 'interessierst du dich? – Für Politik.', 'Wofür'),
        ], 1),
    ],
    ['use verbs with their little word',
     'ask worauf? for things, auf wen? for people',
     'point back with darauf, dafür, darüber'],
))

# ---- 17 · Die E-Mail ------------------------------------------------------------------------------
spreads.append(spread(
    'email', 'Die E-Mail', 'Formal and informal — and polite questions',
    'One frame for a friend, one for an office: learn both by heart and you only have to fill in the middle.',
    Q + 'email_redemittel',
    [
        table('Two frames', ['to a friend (du)', 'to an office (Sie)'], [
            ['Liebe Anna, · Lieber Tom,', 'Sehr geehrte Damen und Herren,'],
            ['Danke für deine Mail!', 'Vielen Dank für Ihre Antwort.'],
            ['Hättest du Lust, …?', 'Könnten Sie mir bitte …? · Wäre es möglich, …?'],
            ['Ich freue mich auf deine Antwort.', 'Vielen Dank im Voraus.'],
            ['Liebe Grüße · Dein Tom', 'Mit freundlichen Grüßen · Tomás Ruiz'],
        ], 'Never mix them: one du in a formal e-mail stands out.'),
        slots('A polite question inside', [
            (sl('Wann', 'fährt!', 'der Zug ab?'), 'the question'),
            (sl('Könnten Sie mir sagen,', 'wann', 'der Zug', 'abfährt?!'), 'wrapped: verb last'),
            (sl('Könnten Sie mir sagen,', 'ob', 'das Museum geöffnet', 'ist?!'), 'yes/no: ob'),
        ], note='Remember A2.2: wrapped questions send the verb to the end.'),
        box('tip', 'Three points, three paragraphs',
            'A message answers a few points. One short paragraph for each, with *Zuerst … · Außerdem … · Zum Schluss …* — nothing gets lost.'),
        words('Words for the practice page', [
            ('die Unterlagen', 'documents'), ('sich entschuldigen', 'to apologise'), ('das Kursangebot', 'courses on offer'),
            ('geöffnet', 'open'), ('der Fahrkartenautomat', 'ticket machine'), ('funktionieren', 'to work'),
            ('Ihren Deutschkurs', 'your German course'), ('die Hilfe', 'help'),
        ], 3),
    ],
    [
        gaps('The frame', 'Write the missing words.', [
            ('', 'Damen und Herren, ich interessiere mich für Ihren Deutschkurs.', 'Sehr geehrte'),
            ('', 'Anna, danke für deine Mail!', 'Liebe'),
            ('', 'Sie mir bitte die Unterlagen schicken?', 'Könnten'),
            ('Vielen Dank', 'für Ihre Hilfe.', 'im Voraus'),
            ('Mit', 'Grüßen, Tomás Ruiz', 'freundlichen'),
        ]),
        write('Ask politely', 'Wrap the question: Können Sie mir sagen, …?', [
            ('Wann fährt der Zug nach Köln ab?', 'Können Sie mir sagen, wann der Zug nach Köln abfährt?'),
            ('Ist das Museum am Montag geöffnet?', 'Können Sie mir sagen, ob das Museum am Montag geöffnet ist?'),
            ('Wie funktioniert der Fahrkartenautomat?', 'Können Sie mir sagen, wie der Fahrkartenautomat funktioniert?'),
        ], 1),
    ],
    ['write a formal and an informal e-mail',
     'ask politely with a wrapped question',
     'answer every point in its own paragraph'],
))

# ---- Review 2 · topics 9–17 -------------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 9–17', 'The second half of the book, all at once. No looking back until you have done both pages.',
    Q + 'wortschatz',
    [
        gaps('Small words', 'Write the missing word.', [
            ('Morgen', 'es regnen.', 'wird'), ('Das ist der Kollege,', 'ich arbeite. (mit)', 'mit dem'),
            ('Wegen', 'bleiben wir zu Hause. (das Wetter)', 'des Wetters'), ('', 'ich ein Kind war, wohnten wir in Köln.', 'Als'),
        ]),
        circle('Which one?', 'Circle the right word.', [
            ('Nimm einen Schirm mit,', ['falls', 'trotzdem'], 'es regnet.', 'falls'), ('Ich habe vor,', ['zu reisen', 'reisen'], '.', 'zu reisen'),
        ]),
    ],
    [
        gaps('Chunks', 'Write the missing word.', [
            ('', 'ist kalt.', 'Mir'), ('Es', 'darauf an.', 'kommt'), ('', 'wartest du? – Auf den Bus.', 'Worauf'),
        ]),
        write('Ask politely', 'Wrap the question.', [
            ('Wo ist die Apotheke?', 'Können Sie mir sagen, wo die Apotheke ist?'),
        ], 1),
        match('Question and answer', 'Draw a line from each question to its answer.', [
            ('Was wirst du morgen machen?', 'Ich werde arbeiten.'),
            ('Wofür interessierst du dich?', 'Für Politik.'),
            ('Lohnt es sich?', 'Ja, es lohnt sich.'),
            ('Wessen Auto ist das?', 'Das Auto meines Vaters.'),
        ], [2, 3, 0, 1]),
    ],
))

book = {
    'title': 'Meinungen & Wünsche',
    'cover': 'cp_b1_1_cover',
    'welcome': [
        'This book is the paper half of B1.1. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It carries on from the A books. Words you learned there are not taught again; where a topic builds on something from before, a small note brings it back.',
        'Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Paul', 'Mia', 'Tom', 'Anna', 'Lisa', 'Maria', 'Rocky', 'Braun', 'Weber', 'Wagner', 'Brandt',
              'Tomás', 'Ruiz', 'Hamburg', 'Rom', 'Bonn', 'Berlin', 'Leipzig'],
    'spreads': spreads,
    'overview': {'title': 'B1.1 at a glance', 'blocks': [
        table('Endings before a noun', ['~', 'der', 'die', 'das', 'plural'], [
            ['after der', 'der groß*e* · den groß*en*', 'die groß*e*', 'das groß*e*', 'die groß*en*'],
            ['after ein', 'ein groß*er* · einen groß*en*', 'eine groß*e*', 'ein groß*es*', 'meine groß*en*'],
            ['no article', 'stark*er* Kaffee', 'frisch*e* Milch', 'frisch*es* Brot', 'nett*e* Leute'],
        ], 'Dative after any article: -en.', genders=True),
        slots('Dreams and plans', [
            (sl('Ich', 'würde!', 'gern', 'reisen.!'), 'würde + verb'),
            (sl('Wenn', 'ich Zeit', 'hätte,!', 'würde!', 'ich kommen.'), 'if …'),
            (sl('Morgen', 'wird!', 'es', 'regnen.!'), 'future'),
        ]),
        cols(
            table('Verb last — verb next', ['verb last', 'verb next'], [
                ['weil', 'deshalb'], ['obwohl', 'trotzdem'], ['da · falls · als · wenn', ''],
            ]),
            table('der, den, dem, denen', ['', 'der', 'die', 'das', 'plural'], [
                ['wer?', 'der', 'die', 'das', 'die'], ['wen?', 'den', 'die', 'das', 'die'], ['wem?', 'dem', 'der', 'dem', 'denen'],
            ], genders=True),
        ),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.', [
            ('der Lebenslauf', 'CV', 'cpd_lebenslauf'), ('der Vertrag', 'contract', 'cpd_vertrag'), ('der Schreibtisch', 'desk', 'cpd_schreibtisch'),
            ('der Drucker', 'printer', 'cpd_drucker'), ('der Ordner', 'folder', 'cpd_ordner'), ('der Laptop', 'laptop', 'cpd_laptop'),
            ('die Kaffeemaschine', 'coffee machine', 'cpd_kaffeemaschine'), ('der Bildschirm', 'screen', 'cpd_bildschirm'),
            ('die Brille', 'glasses', 'cpd_brille'), ('der Kalender', 'calendar', 'cpd_kalender'), ('das Telefon', 'phone', 'cpd_telefon'),
            ('der Akku', 'battery', 'cpd_akku'), ('der Balkon', 'balcony', 'cpd_balkon'), ('die Milch', 'milk', 'cpd_milch'),
            ('das Brot', 'bread', 'cpd_brot'), ('der Kaffee', 'coffee', 'cpd_kaffee'), ('die Hochzeit', 'wedding', 'cpd_hochzeit'),
            ('der Führerschein', 'driving licence', 'cpd_fuehrerschein'), ('der Schirm', 'umbrella', 'cpd_regenschirm'),
            ('der Krimi', 'crime novel', 'cpd_krimi'), ('die Gitarre', 'guitar', 'cpd_gitarre'), ('der Grill', 'barbecue', 'cpd_grill'),
            ('das Konzert', 'concert', 'cpd_konzert'), ('der Fahrkartenautomat', 'ticket machine', 'cpd_fahrkartenautomat'),
            ('der Zug', 'train', 'cpd_zug'), ('die Rente', 'pension', 'cpd_rente'), ('das Geld', 'money', 'cpd_geld'),
            ('die Bank', 'bank', 'cpd_bank'), ('der Anzug', 'suit', 'cpd_anzug'), ('die Krawatte', 'tie', 'cpd_krawatte'),
            ('der Kuchen', 'cake', 'cpd_kuchen'), ('die Uhr', 'clock, watch', 'cpd_uhr'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

kit.write_book(OUT, book)
