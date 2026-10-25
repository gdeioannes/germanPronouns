# Builds assets/content/companion/de_cert_a1/c2_2.json — the C2.2 study companion.
# Run: python -I tool/companion/c2_2.py   (rules: docs/study_companion_guide.md)
# Extra exercises that fill the practice pages: extras_c2_2.py (fitted by fit_extras.py).
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, merge, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_c2_2_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'c2_2.json')
Q = 'quest_c2_2_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ==== Part 1 · Between the lines ==========================================================

# ---- 1 · Philosophie ---------------------------------------------------------------------
spreads.append(spread(
    'philosophie', 'Pflicht oder Neigung?', 'The words of a German debate',
    'Kant and Weber gave German its words for freedom, duty and dignity — and newspapers still use them every day.',
    Q + 'philosophie',
    [
        table('Kant’s pairs', ['', '', '~'], [
            ['die Pflicht', 'die Neigung', 'duty · inclination'], ['der Zweck', 'das Mittel', 'end · means'],
            ['die Vernunft', 'der Verstand', 'reason · understanding'], ['die Mündigkeit', 'die Unmündigkeit', 'autonomy · immaturity'],
            ['die Würde', 'der Preis', 'dignity · price'],
        ]),
        table('Abstract is not feminine', ['ending', 'gender', 'like this'], [
            ['-heit · -keit · -ung · -schaft · -tät', 'die', 'die Freiheit · die Verantwortung'],
            ['-ismus', 'der', 'der Determinismus'], ['infinitive as a noun', 'das', 'das Handeln · das Sein'],
            ['no ending', 'der · das', 'der Wille · der Sinn · das Gewissen · das Bewusstsein'],
        ]),
        words('Words for the practice page', [
            ('die Aufklärung', 'Enlightenment'), ('der Ausgang', 'way out'), ('aus seiner selbstverschuldeten Unmündigkeit', 'from his self-incurred immaturity'),
            ('die Erkenntnis', 'knowledge'),
            ('Verantwortung tragen', 'to bear responsibility'), ('in Abrede stellen', 'to deny'), ('in Frage stellen', 'to question'),
            ('das Amt', 'office'), ('annimmt', 'accepts'), ('Fortschritte gemacht', 'made progress'), ('die Fehler', 'mistakes'), ('der Vorgänger', 'predecessor'), ('die Wissenschaft', 'science'),
            ('klüger', 'wiser'), ('niemand', 'nobody'), ('der Mensch · des Menschen', 'man · of man'), ('heiligt', 'justifies'),
        ], 4),
    ],
    [
        gaps('The right word', 'Write the missing noun.', [
            ('Aufklärung ist der Ausgang des Menschen aus seiner selbstverschuldeten', '.', 'Unmündigkeit'),
            ('Was einen Preis hat, kann man ersetzen; der Mensch aber hat eine', '.', 'Würde'),
            ('Der Zweck heiligt nicht die', '.', 'Mittel'),
            ('Wer ein Amt annimmt, muss die', 'für die Fehler seiner Vorgänger tragen.', 'Verantwortung'),
        ]),
        circle('Denied or doubted?', 'Circle the right phrase.', [
            ('Niemand stellt in', ['Abrede', 'Frage'], ', dass die Wissenschaft Fortschritte gemacht hat.', 'Abrede'),
            ('Wir stellen in', ['Frage', 'Abrede'], ', ob sie uns klüger gemacht hat. (nur ein Zweifel)', 'Frage'),
        ], 1),
        sort_ex('der, die or das?', 'Write each word in its column.', ['der', 'die', 'das'], [
            ('Wille', 0), ('Freiheit', 1), ('Gewissen', 2), ('Determinismus', 0), ('Erkenntnis', 1), ('Bewusstsein', 2),
        ]),
    ],
    ['use Kant’s pairs: Pflicht and Neigung, Zweck and Mittel',
     'tell in Abrede stellen from in Frage stellen',
     'give abstract nouns the right article'],
))

# ---- 2 · Fokus ---------------------------------------------------------------------------
spreads.append(spread(
    'fokus', 'Ausgerechnet heute', 'One small word moves the spotlight',
    'Selbst der Chef wusste nichts: a focus word stands right before what it points at — move it, and the sentence means something else.',
    Q + 'fokus',
    [
        table('Focus words', ['word', '~', 'like this'], [
            ['selbst · sogar', 'even', 'Selbst der Chef wusste nichts.'], ['nicht einmal', 'not even', 'Nicht einmal die Opposition …'],
            ['noch + comparative', 'even', 'noch kälter'], ['ausgerechnet', 'of all …', 'ausgerechnet heute'],
            ['erst', 'only (time)', 'erst halb acht'], ['nur · lediglich', 'only (amount)', 'nur fünf Euro'],
            ['schon · allein', 'the mere', 'Schon der Gedanke …'], ['erst recht', 'all the more', 'und jetzt erst recht'],
        ]),
        slots('Where selbst stands', [
            (sl('Selbst! der Chef', 'wusste nichts.'), 'even the boss'),
            (sl('Der Chef selbst!', 'wusste nichts.'), 'the boss himself'),
        ]),
        box('watch', 'erst or nur?', 'Time is *erst*: Es ist erst drei Uhr. An amount is *nur*: Ich habe nur zwei Seiten.'),
        words('Words for the practice page', [
            ('der Chef', 'boss'), ('die Zeitung', 'newspaper'), ('erfahren', 'to find out'), ('der Winter', 'winter'),
            ('die Wahl', 'election'), ('der Strom fiel aus', 'the power failed'), ('in der halben Stadt', 'in half the city'),
            ('die Prüfung', 'exam'), ('am Prüfungstag', 'on exam day'), ('nervös', 'nervous'), ('die Zahlen', 'figures'), ('vorsichtig', 'careful'),
            ('der Minister', 'minister'), ('eingeräumt', 'admitted'), ('persönlich', 'in person'), ('die Opposition', 'opposition'), ('der Vorschlag', 'proposal'), ('lehnte ab', 'rejected'), ('nahm an', 'accepted'), ('der Rat', 'council'), ('der zweite', 'the second'),
        ], 4),
    ],
    [
        gaps('The focus word', 'Write selbst, noch, ausgerechnet, erst, nur or erst recht.', [
            ('Der zweite Winter war', 'kälter als der erste.', 'noch'),
            ('', 'am Tag der Wahl fiel in der halben Stadt der Strom aus.', 'Ausgerechnet'),
            ('Es ist', 'drei Uhr. (time)', 'erst'),
            ('Ich habe', 'zwei Seiten geschafft – nicht mehr.', 'nur'),
            ('Schon der Gedanke an die Prüfung macht ihn nervös – und am Prüfungstag', '.', 'erst recht'),
            ('Der Minister', 'hat es eingeräumt – er persönlich.', 'selbst'),
        ]),
        circle('selbst or sogar?', 'Circle the word that works here.', [
            ('Sie hat es', ['sogar', 'selbst'], 'angenommen.', 'sogar'),
            ('Nicht', ['einmal', 'noch'], 'die Opposition wusste es.', 'einmal'),
        ], 1),
        write('Put it first', 'Start with the first proposal to make a contrast.', [
            ('Der Rat lehnte den ersten Vorschlag ab; den zweiten nahm er an.', 'Den ersten Vorschlag lehnte der Rat ab; den zweiten nahm er an.'),
        ]),
    ],
    ['point at a word with selbst, sogar, ausgerechnet',
     'tell erst from nur',
     'put a word first for contrast'],
))

# ---- 3 · Anspielung ----------------------------------------------------------------------
spreads.append(spread(
    'anspielung', 'Es ist schon spät', 'What Germans mean but never say',
    'If the literal meaning is pointless in the situation, look for what the sentence does: a request, a goodbye, a reproach.',
    Q + 'anspielung',
    [
        table('What it says, what it does', ['said', 'done'], [
            ['Ganz schön frisch hier.', 'a request: close the window'], ['Es ist schon spät.', 'time to go'],
            ['Ich will Sie nicht länger aufhalten.', 'the talk is over'], ['Wir melden uns.', 'often a no'],
            ['Sie sind ja früh dran. (at half past nine)', 'a reproach'], ['Bei allem Respekt …', 'an objection follows'],
        ]),
        table('Litotes: the opposite, denied', ['said', 'meant'], [
            ['nicht unerheblich', 'considerable'], ['nicht unbegabt', 'talented'], ['nicht ganz ungefährlich', 'dangerous'],
            ['alles andere als leicht', 'very hard'], ['noch Luft nach oben', 'weak'],
        ]),
        words('Words for the practice page', [
            ('die Uhr', 'clock'), ('demonstrativ', 'pointedly'), ('die Kosten', 'costs'), ('der Umbau', 'conversion'),
                        ('die Großmutter', 'grandmother'), ('das Küchenfenster', 'kitchen window'), ('um neun', 'at nine'),
            ('halb im Scherz', 'half in jest'), ('die Luft', 'air'), ('sich gewöhnt an', 'gets used to'), ('dem Lüften gedient', 'served for airing'), ('die Stille', 'silence'), ('das Warten', 'waiting'),
        ], 4),
    ],
    [
        gaps('What it does', 'Write Bitte, Vorwurf, Absage or Einwand.', [
            ('„Ganz schön frisch hier.“ →', '', 'Bitte'),
            ('„Sie sind ja früh dran.“ (zu einer Person, die zu spät kommt) →', '', 'Vorwurf'),
            ('„Wir melden uns.“ →', '', 'Absage'),
            ('„Bei allem Respekt …“ →', '', 'Einwand'),
        ]),
        circle('The window at nine', 'Listen to the story. Circle what you hear.', [
            ('Jeden Abend um neun öffnete die Großmutter das', ['Küchenfenster', 'Schlafzimmerfenster'], '.', 'Küchenfenster'),
            ('„Damit die Luft sich nicht an die', ['Stille', 'Kälte'], 'gewöhnt.“', 'Stille'),
            ('Sie sagte es', ['halb im Scherz', 'ganz ernst'], '.', 'halb im Scherz'),
            ('Das Fenster hatte nicht dem Lüften gedient, sondern dem', ['Warten', 'Großvater'], '.', 'Warten'),
        ], 1) | {'listen': True},
    ],
    ['hear what a sentence does, not only what it says',
     'read a litotes as strong, not mild',
     'hear a hint in a story'],
    listen=Q + 'lesen_capstone',
))

# ---- 4 · Paraphrase ----------------------------------------------------------------------
spreads.append(spread(
    'paraphrase', 'in Angriff nehmen', 'The same thing, one step up',
    'Swap the plain word for the weightier phrase — and check that the meaning, the register and the grammar still fit.',
    Q + 'paraphrase',
    [
        table('Plain → weightier', ['plain', 'weightier'], [
            ['wichtig', 'von Bedeutung'], ['viele', 'zahlreiche · eine Vielzahl von'], ['alle', 'sämtliche'],
            ['überhaupt kein', 'keinerlei + noun'], ['sofort', 'umgehend'],
        ]),
        table('Verb → phrase', ['plain', 'weightier'], [
            ['anfangen mit', 'in Angriff nehmen'], ['als Erster anfangen', 'den Anfang machen'],
            ['berücksichtigen', 'einer Sache Rechnung tragen'], ['benutzen', 'sich einer Sache bedienen'],
        ]),
        flow('ums Leben kommen or sterben?', q('An accident, a disaster or violence?',
                                              a('ums Leben kommen', 'Er kam bei einem Unfall ums Leben.'), a('sterben', 'Sie starb nach langer Krankheit.'))),
        words('Words for the practice page', [
            ('die Stadt', 'city'), ('fängt an', 'begins'), ('die Argumente', 'arguments'), ('die Sanierung', 'renovation'), ('die Brücke', 'bridge'), ('im Frühjahr', 'in spring'),
            ('die Bedenken', 'concerns'), ('die Unterlagen', 'documents'), ('einzureichen', 'to be handed in'),
            ('die Einwendungen', 'objections'), ('eingegangen', 'come in'), ('die Ministerin', 'minister'),
            ('der Unfall', 'accident'), ('die Krankheit', 'illness'), ('drei Menschen', 'three people'),
            ('dem ist', 'of that is'),
        ], 4),
    ],
    [
        gaps('One step up', 'Write the weightier word.', [
            ('Alle Unterlagen sind sofort einzureichen. →', 'Unterlagen sind umgehend einzureichen.', 'Sämtliche'),
            ('Die Stadt fängt im Frühjahr mit der Sanierung an. → Sie nimmt die Sanierung in', '.', 'Angriff'),
            ('Man muss das berücksichtigen. → Dem ist', 'zu tragen.', 'Rechnung'),
            ('Es kamen überhaupt keine neuen Argumente. → Es kamen', 'neuen Argumente.', 'keinerlei'),
        ]),
        circle('Does it fit?', 'Circle the right phrase.', [
            ('Drei Menschen', ['kamen ums Leben', 'starben ums Leben'], 'bei dem Unfall.', 'kamen ums Leben'),
            ('Eine Vielzahl von Einwendungen', ['ist', 'sind'], 'eingegangen.', 'ist'),
            ('Die Ministerin', ['machte den Anfang', 'nahm den Anfang'], '.', 'machte den Anfang'),
        ], 1),
    ],
    ['raise the register with one phrase',
     'check meaning, register and grammar',
     'use ums Leben kommen only for accidents'],
))

# ---- 5 · Wortspiel -----------------------------------------------------------------------
spreads.append(spread(
    'wortspiel', 'die Steuer, das Steuer', 'Double meanings',
    'German headlines live on words that mean two things. If a headline sounds odd, read it twice — the second reading is the joke.',
    Q + 'wortspiel',
    [
        table('The article decides', ['der · die · das', '~'], [
            ['der Leiter · die Leiter', 'head · ladder'], ['der See · die See', 'lake · sea'], ['das Steuer · die Steuer', 'wheel · tax'],
            ['der Kiefer · die Kiefer', 'jaw · pine'], ['der Verdienst · das Verdienst', 'earnings · merit'],
            ['der Band · das Band · die Band', 'volume · ribbon · music group'],
        ]),
        table('One word, two things', ['word', '~'], [
            ['der Zug', 'train · chess move'], ['das Gericht', 'court · dish'], ['der Hahn', 'tap · rooster'],
            ['die Birne', 'pear · light bulb'], ['der Flügel', 'wing · grand piano'], ['das Schloss', 'lock · palace'],
        ]),
        words('Words for the practice page', [
            ('die Regierung', 'government'), ('senken', 'to cut'), ('der Staat', 'state'), ('die Werkstatt', 'workshop'), ('gering', 'small'),
            ('der Weltmeister', 'world champion'), ('verpasst · verpasste', 'misses · missed'), ('der entscheidende Zug · entscheidenden', 'the decisive move'), ('alte Schiffe', 'old ships'), ('tief', 'deep'), ('das Rad am Schiff', 'the wheel on a ship'), ('im Schach', 'at chess'), ('am Bahnsteig', 'on the platform'), ('abgefahren', 'gone'),
            ('die Chance', 'chance'), ('die Schiffe', 'ships'),
        ], 4),
    ],
    [
        gaps('der, die or das?', 'Write the article.', [
            ('Die Regierung will', 'Steuer senken – weniger Geld für den Staat.', 'die'),
            ('Am Steuer des Autos sitzt niemand. Wer hält', 'Steuer?', 'das'),
            ('Wir schwimmen im See.', 'See ist tief.', 'Der'),
            ('', 'Verdienst in der Werkstatt war gering – wenig Geld.', 'Der'),
        ]),
        match('Two meanings', 'Draw a line from the headline to its second reading.', [
            ('Weltmeister verpasst entscheidenden Zug', 'im Schach und am Bahnsteig'),
            ('Der Zug ist abgefahren.', 'eine verpasste Chance'),
            ('Neue Steuer für alte Schiffe', 'Geld für den Staat oder das Rad am Schiff?'),
        ], [2, 0, 1]),
    ],
    ['tell der See from die See',
     'hear the second reading of a headline',
     'spot a sentence that can mean two things'],
))

# ---- 6 · Redewendungen -------------------------------------------------------------------
spreads.append(spread(
    'redewendungen', 'auf die lange Bank schieben', 'The idioms of commentary',
    'An idiom is frozen: keep every noun and ending, move only the verb. And read the judgement hidden in it.',
    Q + 'redewendungen',
    [
        table('Idiom and judgement', ['idiom', '~', 'the writer thinks …'], [
            ['etwas auf die lange Bank schieben', 'to shelve', 'they are stalling'],
            ['das Kind mit dem Bade ausschütten', 'to overreact', 'too much'],
            ['jemandem einen Bärendienst erweisen', 'to do a disservice', 'the help backfired'],
            ['jemandem den Rang ablaufen', 'to outstrip', 'they lost'],
            ['ins Hintertreffen geraten', 'to fall behind', 'too slow'],
            ['etwas im Schilde führen', 'to be up to something', 'be careful'],
            ['jemandem das Wasser reichen', 'to match', '(mostly with nicht)'],
        ]),
        merge('The person is dative', ['person', 'frozen part'], [
            ('jemandem', 'uns', 'den Rang ablaufen', 'den Rang abgelaufen', 'Sie hat uns den Rang abgelaufen.', 'the person is dative'),
        ]),
        box('watch', 'Frozen means frozen', '*mit dem Bade* — never with “Badewasser”. *im Schilde* — never “im Schild”.'),
        words('Words for the practice page', [
            ('die Konkurrenz', 'competition'), ('längst', 'long ago'), ('die Reform', 'reform'), ('das Verbot', 'ban'),
            ('mit dem pauschalen Verbot', 'with the blanket ban'), ('der Gesetzgeber', 'legislator'), ('das Lob', 'praise'), ('die Kollegin', 'colleague'),
            ('die Erfahrung', 'experience'), ('das Team', 'team'), ('die Verwaltung', 'administration'),
            ('die Digitalisierung', 'digitalisation'), ('weiß', 'knows'), ('geschoben', 'pushed'), ('erwiesen', 'done'),
        ], 4),
    ],
    [
        gaps('The frozen word', 'Write the missing word.', [
            ('Die Konkurrenz hat uns längst den', 'abgelaufen.', 'Rang'),
            ('Niemand weiß, was er im', 'führt.', 'Schilde'),
            ('Die Reform wurde auf die lange', 'geschoben.', 'Bank'),
            ('Mit dem pauschalen Verbot schüttet der Gesetzgeber das Kind mit dem', 'aus.', 'Bade'),
            ('An Erfahrung kann ihr im Team niemand das', 'reichen.', 'Wasser'),
        ]),
        circle('What does the writer think?', 'Circle the judgement.', [
            ('Mit seinem Lob hat er der Kollegin einen Bärendienst erwiesen.', ['the help backfired', 'it was kind'], '', 'the help backfired'),
            ('Die Verwaltung ist ins Hintertreffen geraten.', ['too slow', 'very good'], '', 'too slow'),
        ], 1),
    ],
    ['keep an idiom’s frozen form',
     'put the person in the dative',
     'read the judgement in an idiom'],
))

# ---- 7 · Fremdwörter ---------------------------------------------------------------------
spreads.append(spread(
    'fremdwoerter', 'de facto, eruieren, obsolet', 'Latin words in serious German',
    'Each one says something the everyday word doesn’t quite say. Use one where it sharpens the sentence — not five.',
    Q + 'fremdwoerter',
    [
        build('-ieren: no ge-', [
            (['eruier', ('t', 'suffix')], 'eruiert', 'not: geeruiert'),
            (['konzedier', ('t', 'suffix')], 'konzediert', 'not: gekonzediert'),
        ]),
        table('Latin phrases never change', ['phrase', 'in German', '~'], [
            ['de facto · de jure', 'tatsächlich · rechtlich', 'in fact · in law'], ['a priori', 'von vornherein', 'from the start'],
            ['a posteriori', 'im Nachhinein', 'in retrospect'], ['per se', 'an sich', 'as such'],
        ]),
        table('False friends', ['German', 'means', 'not'], [
            ['eventuell', 'possibly', 'eventually = schließlich'], ['konsequent', 'consistent', 'consequent'],
            ['sensibel', 'sensitive', 'sensible = vernünftig'], ['ambivalent', 'torn two ways', 'indifferent = gleichgültig'],
        ]),
        words('Words for the practice page', [
            ('eruieren', 'to find out'), ('konzedieren', 'to concede'), ('die Ursache', 'cause'), ('des Ausfalls', 'of the outage'), ('bislang', 'so far'), ('die Autorin', 'author'),
            ('die Stichprobe', 'sample'), ('der Präsident', 'president'), ('das Parlament', 'parliament'), ('entscheidet', 'decides'),
            ('marginal', 'negligible'), ('die Unterschiede', 'differences'), ('kontraproduktiv', 'counter-productive'),
            ('der Boykott', 'boycott'), ('die Phase', 'stage'), ('umgesetzt', 'implemented'), ('ohne Ausnahme', 'without exception'), ('etwas später', 'a bit later'),
            ('das Ergebnis', 'result'),
        ], 4),
    ],
    [
        gaps('Latin, German grammar', 'Write the word in brackets in the right form.', [
            ('Die Ursache des Ausfalls konnte bislang nicht', 'werden. (eruieren)', 'eruiert'),
            ('Die Autorin', ', dass ihre Stichprobe klein ist. (konzedieren)', 'konzediert'),
            ('', 'ist der Präsident Chef, de facto entscheidet das Parlament.', 'De jure'),
            ('Die Unterschiede sind', 'und ändern nichts am Ergebnis.', 'marginal'),
        ]),
        circle('False friends', 'Circle the right word.', [
            ('Wir kommen', ['eventuell', 'schließlich'], 'etwas später. (possibly)', 'eventuell'),
            ('Die Regierung hat die Reform', ['konsequent', 'sensibel'], 'umgesetzt – Schritt für Schritt, ohne Ausnahme.', 'konsequent'),
            ('Ein Boykott wäre in dieser Phase', ['kontraproduktiv', 'ambivalent'], '.', 'kontraproduktiv'),
        ], 1),
    ],
    ['use -ieren verbs without ge-',
     'use Latin phrases like de facto unchanged',
     'avoid false friends like eventuell'],
))

# ---- Review 1 · topics 1–7 -----------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–7', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        gaps('The right word', 'Write the missing word.', [
            ('Der Zweck heiligt nicht die', '.', 'Mittel'), ('Es ist', 'drei Uhr. (time)', 'erst'),
            ('Die Kosten waren nicht', '. (= considerable)', 'unerheblich'), ('Sämtliche Unterlagen sind', 'einzureichen. (sofort)', 'umgehend'),
        ]),
    ],
    [
        gaps('Words that mean two things', 'Write the missing word.', [
            ('Die Regierung will', 'Steuer senken.', 'die'), ('Die Reform wurde auf die lange', 'geschoben.', 'Bank'),
            ('Die Ursache konnte nicht', 'werden. (eruieren)', 'eruiert'),
        ]),
    ],
))

# ==== Part 2 · Official and academic German ===============================================

# ---- 8 · Wissenschaftssprache ------------------------------------------------------------
spreads.append(spread(
    'wissenschaft', 'Es ist davon auszugehen', 'Writing like a published paper',
    'Not „Ich glaube, die Zahlen steigen“ but „Es ist davon auszugehen, dass die Zahlen steigen“: remove the I, add es or the passive, hedge the verb.',
    Q + 'wissenschaftssprache',
    [
        table('Assume, infer, conclude', ['move', 'phrase'], [
            ['assume', 'Es ist davon auszugehen, dass …'], ['infer', 'Daraus ergibt sich, dass … · Daraus folgt, dass …'],
            ['suggest', 'Die Befunde legen nahe, dass …'], ['conclude', 'Die Studie kommt zu dem Ergebnis, dass …'],
            ['hedge', 'Es ist nicht auszuschließen, dass … · bedarf weiterer Untersuchung'],
        ]),
        table('Each phrase with its case', ['phrase', 'case'], [
            ['im Hinblick auf · in Bezug auf', 'Akk'], ['hinsichtlich · unter Berücksichtigung · vor dem Hintergrund', 'Gen'],
            ['im Gegensatz zu · im Vergleich zu', 'Dat'],
        ]),
        slots('The talk turns on three signposts', [
            ([('Lange Zeit …', 'the old view'), ('… gilt heute als überholt.', 'dismissed'), {'de': 'Vielmehr …', 'tag': 'the new view', 'hot': True}], None),
        ]),
        words('Words for the practice page', [
            ('die Befunde', 'findings'), ('der Effekt', 'effect'), ('altersabhängig', 'age-dependent'), ('die Maßnahmen', 'measures'),
            ('erforderlich', 'required'), ('die Risiken', 'risks'), ('kritisch zu bewerten', 'to be judged critically'),
            ('das Gedächtnis', 'memory'), ('das Archiv', 'archive'), ('die Erinnerung', 'memory'), ('der Erzähler', 'storyteller'),
            ('instabil', 'unstable'), ('die Vorstellung', 'idea'), ('treffender', 'more apt'), ('lebhaft', 'vivid'), ('vertrauen', 'to trust'),
        ], 4),
    ],
    [
        gaps('The academic phrase', 'Write the missing word.', [
            ('Es ist davon', ', dass die Zahlen steigen.', 'auszugehen'),
            ('Daraus', 'sich, dass Maßnahmen erforderlich sind.', 'ergibt'),
            ('Die Befunde legen', ', dass der Effekt altersabhängig ist.', 'nahe'),
            ('Im Hinblick', 'die Kosten ist der Plan kritisch zu bewerten.', 'auf'),
            ('', 'der Risiken ist der Plan kritisch zu bewerten. (hinsichtlich or im Hinblick auf?)', 'Hinsichtlich'),
        ]),
        circle('A lecture on memory', 'Listen to the lecture. Circle what you hear.', [
            ('Lange Zeit stellte man sich das Gedächtnis wie ein', ['Archiv', 'Buch'], 'vor.', 'Archiv'),
            ('Diese Vorstellung gilt heute als', ['überholt', 'bewiesen'], '.', 'überholt'),
            ('Treffender wäre wohl der Vergleich mit einem', ['Erzähler', 'Computer'], '.', 'Erzähler'),
            ('Wir sollten einer Erinnerung nicht vertrauen, nur weil sie', ['lebhaft', 'alt'], 'ist.', 'lebhaft'),
        ], 1) | {'listen': True},
    ],
    ['turn I think into academic German',
     'use each phrase with its case',
     'follow the old view, the dismissal and vielmehr'],
    listen=Q + 'hoeren_fachvortrag',
))

# ---- 9 · Präpositionen der Schriftsprache ---------------------------------------------------
spreads.append(spread(
    'praepositionen', 'kraft, binnen, vorbehaltlich', 'The prepositions of contracts and notices',
    'Each of them packs a whole clause: vorbehaltlich = wenn, ungeachtet = obwohl, infolge = weil. Unpack it to read, pack it to write.',
    Q + 'praepositionen_schriftsprache',
    [
        table('Preposition, case, clause', ['preposition', 'case', 'means'], [
            ['kraft seines Amtes', 'Gen', 'weil es sein Amt ist'], ['binnen eines Monats', 'Gen · Dat', 'bevor ein Monat vergangen ist'],
            ['infolge des Sturms', 'Gen', 'weil es einen Sturm gab'], ['zwecks Prüfung', 'Gen', 'um zu prüfen'],
            ['mittels eines Formulars', 'Gen', 'indem man ein Formular nutzt'], ['vorbehaltlich der Zustimmung', 'Gen', 'wenn man zustimmt'],
            ['ungeachtet der Einwände', 'Gen', 'obwohl es Einwände gibt'], ['gemäß den Vorschriften', 'Dat', 'so wie es die Regel will'],
            ['entgegen den Erwartungen', 'Dat', 'anders als erwartet'],
        ]),
        slots('zufolge comes after the noun', [
            (sl('dem Bericht', 'zufolge!'), 'according to the report'),
        ]),
        box('watch', 'Dative, not genitive', '*gemäß den Vorschriften* · *entgegen den Erwartungen* — and *laut* names a source, *gemäß* a rule.'),
        words('Words for the practice page', [
            ('der Vorsitzende', 'chair'), ('die Versammlung', 'meeting'), ('berief ein', 'called'), ('das Gutachten', 'expert report'),
            ('die Brücke', 'bridge'), ('sicher', 'safe'), ('der Einspruch', 'objection'), ('einzulegen', 'to be lodged'),
            ('das Formular', 'form'), ('der Sturm', 'storm'), ('der Strom fiel aus', 'the power failed'), ('die Regierung', 'government'),
            ('die Kritik', 'criticism'), ('des Aufsichtsrats', 'of the supervisory board'), ('tritt in Kraft', 'comes into force'),
            ('die Regelung', 'rule'), ('die Einwände', 'objections'),
        ], 4),
    ],
    [
        gaps('The written preposition', 'Write kraft, binnen, infolge, vorbehaltlich or zufolge.', [
            ('', 'seines Amtes berief der Vorsitzende die Versammlung ein.', 'Kraft'),
            ('Dem Gutachten', 'ist die Brücke nicht mehr sicher.', 'zufolge'),
            ('Der Einspruch ist', 'zwei Wochen einzulegen.', 'binnen'),
            ('', 'des Sturms fiel der Strom aus.', 'Infolge'),
            ('', 'der Zustimmung des Aufsichtsrats tritt die Regelung in Kraft.', 'Vorbehaltlich'),
        ]),
        circle('Dative or genitive?', 'Circle the right form.', [
            ('gemäß', ['den Vorschriften', 'der Vorschriften'], '', 'den Vorschriften'),
            ('entgegen', ['den Erwartungen', 'der Erwartungen'], '', 'den Erwartungen'),
            ('ungeachtet', ['der Kritik', 'die Kritik'], '', 'der Kritik'),
        ], 3),
        write('Unpack it', 'Write it with weil or obwohl.', [
            ('ungeachtet der Einwände →', 'obwohl es Einwände gibt'),
            ('infolge des Sturms →', 'weil es einen Sturm gab'),
        ], 1),
    ],
    ['read kraft, binnen, infolge, vorbehaltlich',
     'use gemäß and entgegen with the dative',
     'unpack a preposition into a clause'],
))

# ---- 10 · Nominalstil ----------------------------------------------------------------------
spreads.append(spread(
    'nominalstil', 'nach Auswertung der Daten', 'Packing a clause into a noun — and back',
    'nachdem man die Daten ausgewertet hatte → nach Auswertung der Daten: the core move of official and academic German.',
    Q + 'nominalstil',
    [
        slots('Three moves, one noun phrase', [
            ([('der Rat beschließt', 'verb'), {'de': 'der Beschluss des Rates', 'tag': 'noun + genitive', 'hot': True}], None),
            ([('weil die Kosten steigen', 'conjunction'), {'de': 'wegen steigender Kosten', 'tag': 'preposition', 'hot': True}], None),
            ([('schnell reagieren', 'adverb'), {'de': 'die schnelle Reaktion', 'tag': 'adjective', 'hot': True}], None),
        ]),
        table('Conjunction ↔ preposition', ['clause', 'noun phrase'], [
            ['nachdem …', 'nach + Dat'], ['wenn …', 'bei + Dat'], ['weil …', 'wegen + Gen'], ['obwohl …', 'trotz + Gen'],
            ['um … zu', 'zur · zum'],
        ]),
        table('The weak verb', ['verb', 'for', 'like this'], [
            ['erfolgen', 'a process', 'Die Zahlung erfolgt binnen zwei Wochen.'], ['stattfinden', 'an event', 'Die Versammlung findet am Freitag statt.'],
        ]),
        words('Words for the practice page', [
            ('der Rat', 'council'), ('das Projekt', 'project'), ('verschiebt', 'postpones'), ('die Verschiebung', 'postponement'),
            ('die Kosten', 'costs'), ('senken', 'to cut'), ('die Senkung', 'cut'), ('das Werk · des Werks', 'plant'), ('der Konzern', 'group'),
            ('die Schließung', 'closure'), ('die Gebühr', 'fee'), ('gezahlt', 'paid'), ('die Nichtzahlung', 'non-payment'), ('die Sitzung', 'session'),
            ('die Auswertung', 'evaluation'), ('die Daten', 'data'), ('ausgewertet', 'evaluated'), ('geschlossen', 'closed'),
            ('stiegen', 'rose'), ('die Zahlung', 'payment'),
        ], 4),
    ],
    [
        gaps('Pack it', 'Write the noun phrase.', [
            ('nachdem man die Daten ausgewertet hatte → nach', 'der Daten', 'Auswertung'),
            ('wenn die Gebühr nicht gezahlt wird → bei', 'der Gebühr', 'Nichtzahlung'),
            ('um die Kosten zu senken →', 'Senkung der Kosten', 'zur'),
            ('weil die Kosten stiegen →', 'steigender Kosten', 'wegen'),
        ]),
        write('Unpack it', 'Write it as a clause.', [
            ('nach der Schließung des Werks durch den Konzern', 'nachdem der Konzern das Werk geschlossen hatte'),
            ('die Verschiebung des Projekts durch den Rat', 'Der Rat verschiebt das Projekt.'),
        ]),
        circle('erfolgen or stattfinden?', 'Circle the right verb.', [
            ('Die Sitzung', ['fand', 'erfolgte'], 'am Montag statt.', 'fand'),
            ('Die Zahlung', ['erfolgt', 'findet'], 'binnen zwei Wochen.', 'erfolgt'),
        ], 1),
    ],
    ['pack a clause into a noun phrase',
     'unpack a noun phrase into a clause',
     'choose erfolgen or stattfinden'],
))

# ---- 11 · Behördensprache ------------------------------------------------------------------
spreads.append(spread(
    'behoerde', 'ist zu entrichten', 'Reading an official letter',
    'Three questions for every letter: What am I accused of? What must I do by when? What happens if I don’t?',
    Q + 'behoerdensprache',
    [
        table('Which fine is which', ['offence', 'penalty', 'decided by'], [
            ['die Ordnungswidrigkeit (parking)', 'das Verwarnungsgeld · die Geldbuße', 'the authority: der Bußgeldbescheid'],
            ['die Straftat (crime)', 'die Geldstrafe', 'a court'],
            ['an order not followed', 'das Zwangsgeld', 'not a punishment: pressure'],
        ]),
        table('Officialese → plain German', ['written', 'meant'], [
            ['ist zu entrichten', 'Sie müssen zahlen'], ['ist untersagt', 'ist verboten'], ['unverzüglich', 'sofort'],
            ['zur Kenntnisnahme', 'bitte lesen'], ['bei Zuwiderhandlung', 'wenn man die Regel bricht'], ['anbei', 'im Umschlag'],
        ]),
        slots('Anhörung first, Bescheid later', [
            ([('die Anhörung', 'you may answer'), ('der Bescheid', 'the decision'), {'de': 'der Einspruch', 'tag': 'two weeks after Zustellung', 'hot': True}], None),
        ]),
        words('Words for the practice page', [
            ('der Betrag', 'amount'), ('bis zum 15. Mai', 'by 15 May'), ('das Befahren', 'driving on'), ('des Weges', 'of the path'),
            ('die Frist', 'deadline'), ('die Zustellung', 'delivery'), ('fristgerecht', 'in time'), ('der Säumniszuschlag', 'late fee'),
            ('das Schreiben', 'letter'), ('freiwillig', 'voluntary'), ('die Feuerwehrzufahrt', 'fire lane'), ('geparkt', 'parked'),
            ('der Bogen', 'form'), ('zurücksenden', 'to send back'), ('überweisen', 'to transfer'), ('der Bußgeldkatalog', 'list of fines'), ('melden Sie sich', 'get in touch'),
        ], 4),
    ],
    [
        gaps('In plain German', 'Write the plain word.', [
            ('Der Betrag ist bis zum 15. Mai zu entrichten. → Sie müssen bis zum 15. Mai', '.', 'zahlen'),
            ('Das Befahren des Weges ist untersagt. → Das Fahren auf dem Weg ist', '.', 'verboten'),
            ('Bitte melden Sie sich unverzüglich. → Bitte melden Sie sich', '.', 'sofort'),
        ]),
        circle('The parking letter', 'Listen to the letter. Circle what you hear.', [
            ('Frau Petrova soll in einer', ['Feuerwehrzufahrt', 'Garage'], 'geparkt haben.', 'Feuerwehrzufahrt'),
            ('Der Bußgeldkatalog sieht eine', ['Geldbuße', 'Geldstrafe'], 'von 100 Euro vor.', 'Geldbuße'),
            ('Den Bogen soll sie binnen einer', ['Woche', 'Stunde'], 'zurücksenden.', 'Woche'),
            ('Dieses Schreiben ist', ['kein Bescheid', 'ein Bescheid'], '. Bitte überweisen Sie nichts.', 'kein Bescheid'),
        ], 1) | {'listen': True},
    ],
    ['tell Geldbuße from Geldstrafe',
     'translate officialese into plain German',
     'answer the three questions of an official letter'],
    listen=Q + 'lesen_amtliches_schreiben',
))

# ---- 12 · Appositionen ---------------------------------------------------------------------
spreads.append(spread(
    'appositionen', 'mit Dr. Weber, der Leiterin', 'The apposition copies the case',
    'English “with Dr Weber, the head” shows no case. German does: mit Dr. Weber, der Leiterin — dative, like Dr. Weber.',
    Q + 'appositionen',
    [
        table('Copy the case from the left', ['case', 'like this'], [
            ['Nom', 'Dr. Weber, die Leiterin des Instituts, sprach.'], ['Akk', 'Wir trafen Herrn Klein, unseren neuen Nachbarn.'],
            ['Dat', 'mit Dr. Weber, der Leiterin des Instituts'], ['Gen', 'wegen des Streiks, eines der längsten'],
        ]),
        merge('mit + apposition', ['name', 'apposition'], [
            ('mit + Dat', 'mit Dr. Weber', 'die Leiterin', 'der Leiterin', 'mit Dr. Weber, der Leiterin', 'the article copies the dative'),
        ]),
        table('Close apposition: no commas', ['', 'like this'], [
            ['title, no article', 'das Schloss König Ludwigs'], ['with an article', 'die Geschichte der Stadt München'],
            ['dates', 'am Freitag, dem 7. Juni'], ['als', 'Man begegnete ihm als Experten.'],
        ]),
        words('Words for the practice page', [
            ('die Leiterin', 'head'), ('das Institut', 'institute'), ('der Nachbar', 'neighbour'), ('der Streik', 'strike'),
            ('die Journalistin', 'journalist'), ('gratulieren', 'to congratulate'), ('der Preis', 'prize'),
            ('die Jury', 'jury'), ('ehrte', 'honoured'), ('der Regisseur', 'director'), ('der Hauptpreis', 'main prize'),
            ('die Hauptstadt', 'capital'), ('die Tagung', 'conference'), ('der Experte · den Experten', 'expert'),
            ('die Anmeldefrist', 'registration deadline'), ('endet', 'ends'), ('sprachen', 'spoke'), ('jung', 'young'),
        ], 4),
    ],
    [
        gaps('The same case', 'Write the words in brackets in the right case.', [
            ('Wir gratulieren Frau Sölle,', ', zum Preis. (die beste Journalistin)', 'der besten Journalistin'),
            ('Die Jury ehrte Tom Berger,', ', mit dem Hauptpreis. (der junge Regisseur)', 'den jungen Regisseur'),
            ('Die Tagung findet in Berlin,', ', statt. (die deutsche Hauptstadt)', 'der deutschen Hauptstadt'),
            ('Wir sprachen mit Dr. Weber,', '. (die Leiterin des Instituts)', 'der Leiterin des Instituts'),
        ]),
        circle('Which form?', 'Circle the right form.', [
            ('das Schloss', ['König Ludwigs', 'König Ludwig'], '', 'König Ludwigs'),
            ('Man begegnete ihm als', ['Experten', 'Experte'], '.', 'Experten'),
            ('Am Freitag,', ['dem', 'der'], '7. Juni, endet die Anmeldefrist.', 'dem'),
        ], 1),
    ],
    ['copy the case into the apposition',
     'write titles and names: König Ludwigs',
     'agree an als-phrase with its noun'],
))

# ---- 13 · Modalverben ----------------------------------------------------------------------
spreads.append(spread(
    'modalverben', 'Er soll es gewusst haben', 'The whole system of modal verbs',
    'Er muss arbeiten is a duty. Er muss gearbeitet haben is a conclusion. Er soll gearbeitet haben is a rumour.',
    Q + 'modalverben_system',
    [
        tiles('How sure is the speaker?', [
            ('muss!', 'sure'), ('müsste · sollte', 'ought to'), ('dürfte', 'probably'), ('kann · könnte', 'possibly'), ('kann nicht', 'impossible'),
        ], 5),
        table('Passing on a claim', ['', 'means', 'like this'], [
            ['er soll …', 'people say he …', 'Der Intendant soll Premieren abgesagt haben.'],
            ['er will …', 'he claims he …', 'Der Angeklagte will bei seiner Schwester gewesen sein.'],
        ]),
        flow('Duty or guess?', q('Is there a perfect infinitive (gesehen haben, gewesen sein)?',
                                 a('a guess about the past', 'Er muss krank gewesen sein.'), a('a duty, or a guess about now', 'Er muss arbeiten.'))),
        words('Words for the practice page', [
            ('der Intendant', 'theatre director'), ('die Premieren', 'premieres'), ('abgesagt', 'cancelled'), ('der Angeklagte', 'defendant'),
            ('die Schwester', 'sister'), ('geregnet', 'rained'), ('in der Nacht', 'in the night'), ('nass', 'wet'),
            ('die Verspätung', 'delay'), ('mehrere', 'several'), ('angeblich', 'supposedly'), ('es steht zu erwarten', 'it is to be expected'),
            ('die Mieten', 'rents'), ('dürften', 'will probably'), ('informiert', 'informed'), ('gewesen', 'been'),
        ], 4),
    ],
    [
        gaps('The modal verb', 'Write muss, dürfte, soll or will.', [
            ('Die Straße ist nass. Es', 'in der Nacht geregnet haben.', 'muss'),
            ('Der Bus', 'Verspätung haben. (probably)', 'dürfte'),
            ('Der Intendant', 'mehrere Premieren abgesagt haben. (people say)', 'soll'),
            ('Der Angeklagte', 'bei seiner Schwester gewesen sein. (he claims)', 'will'),
        ]),
        write('Say it with a phrase', 'Write it without the modal verb.', [
            ('Die Mieten dürften steigen.', 'Es steht zu erwarten, dass die Mieten steigen.'),
            ('Er soll informiert gewesen sein.', 'Er war angeblich informiert.'),
        ]),
    ],
    ['grade certainty from muss to kann nicht',
     'pass on a claim with soll and will',
     'guess about the past with the perfect infinitive'],
))

# ---- 14 · Passiv ---------------------------------------------------------------------------
spreads.append(spread(
    'passiv', 'Das lässt sich lösen', 'Action, result, duty or possibility',
    'Die Tür wurde geschlossen: someone closed it. Die Tür war geschlossen: it was shut. English says “was closed” for both.',
    Q + 'passiv_meisterschaft',
    [
        table('What is in focus?', ['focus', 'form', 'like this'], [
            ['the action', 'werden + Partizip II', 'Das Museum wurde am 3. Mai eröffnet.'], ['the result', 'sein + Partizip II', 'Montags ist das Museum geschlossen.'],
            ['a duty', 'ist zu + infinitive', 'Der Antrag ist bis Freitag einzureichen.'], ['a possibility', 'lässt sich · -bar', 'Das Problem lässt sich beheben.'],
            ['the receiver', 'bekommen + Partizip II', 'Sie bekam den Preis überreicht.'], ['the product', 'reflexive', 'Der Roman liest sich leicht.'],
            ['the activity', 'es wird …', 'Auf der Hochzeit wurde getanzt.'],
        ]),
        flow('werden or sein?', q('Can you add gerade or a date for the action?',
                                  a('werden', 'Die Fassade wird gerade renoviert.'), a('sein', 'Die Strecke war gesperrt.'))),
        box('watch', 'worden, not geworden', 'In the perfect passive: *Er ist festgenommen worden.*'),
        words('Words for the practice page', [
            ('die Fassade', 'façade'), ('renoviert', 'renovated'), ('die Strecke', 'line'), ('der Antrag', 'application'),
            ('eingereicht', 'handed in'), ('das Problem', 'problem'), ('beheben', 'to fix'),
            ('überreicht', 'presented'), ('der Roman', 'novel'), ('die Hochzeit', 'wedding'),
            ('getanzt', 'danced'), ('bis in den frühen Morgen', 'until the early morning'), ('das Gerät', 'device'),
            ('repariert', 'repaired'), ('reparierbar', 'repairable'), ('festgenommen', 'arrested'),
        ], 4),
    ],
    [
        gaps('The right form', 'Write wird, ist, lässt, worden or es.', [
            ('Die Fassade', 'gerade renoviert.', 'wird'),
            ('Montags', 'das Museum geschlossen.', 'ist'),
            ('Das Problem', 'sich beheben.', 'lässt'),
            ('Er ist gestern festgenommen', '.', 'worden'),
            ('', 'wurde bis in den frühen Morgen getanzt.', 'Es'),
        ]),
        write('Say it another way', 'Write it with the word in brackets.', [
            ('Der Antrag muss bis Freitag eingereicht werden. (ist … zu)', 'Der Antrag ist bis Freitag einzureichen.'),
            ('Das Gerät kann repariert werden. (-bar)', 'Das Gerät ist reparierbar.'),
        ]),
    ],
    ['tell the action from the result',
     'say a duty with ist zu and a possibility with lässt sich',
     'write worden in the perfect passive'],
))

# ---- 15 · Adverbialsätze -------------------------------------------------------------------
spreads.append(spread(
    'adverbial', 'Kaum war er da, …', 'One idea, three shapes',
    'Obwohl es regnete … · Es regnete; trotzdem … · Trotz des Regens …: argue in clauses, narrate in main sentences, compress in phrases.',
    Q + 'adverbialsaetze_umformen',
    [
        slots('Where the verb goes', [
            (sl('…, denn', 'er', 'war!', 'krank.'), 'denn: verb second'),
            (sl('…, da', 'er krank', 'war!.'), 'da · weil: verb last'),
            (sl('…; deshalb', 'blieb!', 'er.'), 'deshalb: verb next'),
        ]),
        table('Same subject → infinitive', ['clause', 'infinitive'], [
            ['damit ich bestehe', 'um zu bestehen'], ['ohne dass er fragt', 'ohne zu fragen'], ['so leise, dass niemand ihn verstand', 'zu leise, um verstanden zu werden'],
        ], 'A new subject keeps the clause: Er sprach langsam, damit man ihn verstand.'),
        table('Special shapes', ['', 'like this'], [
            ['wenn without wenn', 'Sollten Sie Fragen haben, …'], ['sudden', 'Kaum war er angekommen, da rief er an.'],
        ]),
        words('Words for the practice page', [
            ('krank', 'ill'), ('blieb', 'stayed'), ('zu Hause', 'at home'), ('regnete', 'rained'), ('der Regen', 'rain'),
            ('das Konzert', 'concert'), ('fand statt', 'took place'), ('bestehen', 'to pass'), ('jeden Abend', 'every evening'),
            ('lernte', 'studied'), ('das Büro', 'office'), ('wenden Sie sich an', 'contact'),
            ('betreten', 'entered'), ('verstummte', 'fell silent'), ('das Gespräch', 'conversation'), ('der Raum', 'room'),
        ], 4),
    ],
    [
        gaps('The other shape', 'Write the missing word.', [
            ('Obwohl es regnete, fand das Konzert statt. →', 'des Regens fand das Konzert statt.', 'Trotz'),
            ('Er war krank;', 'blieb er zu Hause.', 'deshalb'),
            ('Sie lernte jeden Abend,', 'die Prüfung zu bestehen.', 'um'),
            ('', 'Sie Fragen haben, wenden Sie sich an unser Büro.', 'Sollten'),
            ('Kaum hatte sie den Raum betreten,', 'verstummte das Gespräch.', 'da'),
        ]),
        circle('Verb second or last?', 'Circle the right order.', [
            ('Er blieb zu Hause, denn', ['er war krank', 'war er krank'], '.', 'er war krank'),
            ('Er war krank; deshalb', ['blieb er', 'er blieb'], 'zu Hause.', 'blieb er'),
        ], 1),
    ],
    ['say because and although in three shapes',
     'use um … zu only with the same subject',
     'write Sollten Sie … and Kaum …, da …'],
))

# ---- Review 2 · topics 8–15 ----------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 8–15', 'Official and academic German, all at once. No looking back until both pages are done.',
    Q + 'bigtext_lesen',
    [
        gaps('The formal word', 'Write the missing word.', [
            ('Es ist davon', ', dass die Zahlen steigen.', 'auszugehen'), ('Dem Gutachten', 'ist die Brücke nicht sicher.', 'zufolge'),
            ('nachdem man die Daten ausgewertet hatte → nach', 'der Daten', 'Auswertung'),
            ('Der Betrag ist bis zum 15. Mai zu', '.', 'entrichten'),
        ]),
    ],
    [
        gaps('Case, mood and shape', 'Write the missing word.', [
            ('Wir sprachen mit Dr. Weber,', 'Leiterin des Instituts.', 'der'), ('Der Bus', 'Verspätung haben. (probably)', 'dürfte'),
            ('Das Problem', 'sich beheben.', 'lässt'), ('', 'des Regens fand das Konzert statt.', 'Trotz'),
        ]),
    ],
))

# ==== Part 3 · Argument, literature and the wider language ===============================

# ---- 16 · Streitgespräch -------------------------------------------------------------------
spreads.append(spread(
    'streit', 'Da irren Sie sich gewaltig', 'Holding your ground in a debate',
    'Flat in content, polite in form: the Sie and the mit Verlaub keep it civil — and the Konjunktiv takes the floor back.',
    Q + 'sprechen_streitgespraech',
    [
        table('Contradict, attack the argument, take the floor', ['move', 'phrase'], [
            ['contradict', 'Da irren Sie sich gewaltig. · Genau das Gegenteil ist der Fall.'],
            ['politely hard', 'Das ist, mit Verlaub, eine Behauptung ohne jeden Beleg.'],
            ['cause and effect', 'Sie verwechseln Ursache und Wirkung.'], ['circular', 'Ihr Argument ist ein Zirkelschluss.'],
            ['reject a hint', 'Ich lasse mir nicht unterstellen, dass …'],
            ['take the floor', 'Wenn Sie mich ausreden ließen, … · Dürfte ich meinen Gedanken zu Ende führen?'],
        ]),
        slots('Concede, then the but', [
            (sl('Das bestreite ich gar nicht.', 'Aber!', 'daraus folgt nicht, dass …'), 'the conclusion is what counts'),
        ]),
        words('Words for the practice page', [
            ('die Behauptung', 'claim'), ('der Beleg', 'evidence'), ('die Regel', 'rule'), ('der Mangel', 'shortage'),
            ('die Mieten', 'rents'), ('treibt', 'drives up'), ('die Technik', 'technology'), ('das Tempo', 'pace'),
            ('die Branchen', 'sectors'), ('die Weiterbildung', 'further training'), ('der Übergang', 'transition'),
            ('die Stellen', 'jobs'), ('bezahlt', 'pays'), ('der Skeptiker', 'sceptic'), ('beunruhigt', 'worries'),
            ('bremsen', 'to slow down'), ('optimistisch', 'optimistic'), ('die Bedingung', 'condition'),
        ], 4),
    ],
    [
        gaps('The debate phrase', 'Write the missing word.', [
            ('Da irren Sie sich', '.', 'gewaltig'),
            ('Das ist, mit', ', eine Behauptung ohne jeden Beleg.', 'Verlaub'),
            ('Sie verwechseln Ursache und', '.', 'Wirkung'),
            ('Wenn Sie mich ausreden', ', käme ich genau auf diesen Punkt.', 'ließen'),
        ]),
        circle('A panel on work', 'Listen to the panel. Circle what you hear.', [
            ('Nicht die Technik an sich beunruhigt ihn, sondern das', ['Tempo', 'Geld'], '.', 'Tempo'),
            ('Söll ist optimistisch, aber nur unter einer', ['Bedingung', 'Regel'], '.', 'Bedingung'),
            ('Einig sind sie sich: Es geht vor allem um den', ['Übergang', 'Lohn'], '.', 'Übergang'),
            ('Die nächste Runde ist in vier', ['Wochen', 'Tagen'], '.', 'Wochen'),
        ], 1) | {'listen': True},
    ],
    ['contradict flatly and stay polite',
     'name the fault in an argument',
     'take the floor back with the Konjunktiv'],
    listen=Q + 'hoeren_capstone',
))

# ---- 17 · Erörterung -----------------------------------------------------------------------
spreads.append(spread(
    'eroerterung', 'Der gewichtigste Einwand', 'Arguing something abstract',
    'Frame the question, give the strongest objection its best case, and end only where your argument ends.',
    Q + 'schreiben_eroerterung',
    [
        slots('The shape of an Erörterung', [
            ([('Zu klären ist nicht, ob …, sondern …', 'frame'), ('Der gewichtigste Einwand lautet, …', 'objection')], None),
            ([('Dieser Einwand trifft insoweit zu, als …', 'concede'), {'de': 'Daraus folgt keineswegs …, wohl aber …', 'tag': 'conclude', 'hot': True}], None),
        ]),
        table('The essayist’s moves', ['move', 'phrase'], [
            ['concede', 'Man mag das für einen Gewinn halten …'], ['the hinge', 'Doch gerade darin liegt …'],
            ['redefine', 'X ist keine bloße …, sondern vielmehr …'], ['limit yourself', 'Nichts davon ist ein Plädoyer für …'],
        ]),
        box('watch', 'nicht …, sondern …', 'The first half is the view the author *rejects*. The answer is in the sondern-half.'),
        words('Words for the practice page', [
            ('der Staat', 'state'), ('eingreifen', 'to intervene'), ('die Bedingungen', 'conditions'), ('zumutbar', 'reasonable'),
            ('der Eingriff', 'intervention'), ('eine solche Pflicht', 'such a duty'), ('die Begründungslast', 'burden of proof'), ('die Autonomie', 'autonomy'), ('aushöhlt', 'hollows out'),
            ('das Vergessen', 'forgetting'), ('die Schwäche', 'weakness'), ('des Gedächtnisses', 'of memory'), ('das Zeitalter der totalen Speicherung', 'the age of total storage'),
            ('eine unterschätzte Gefahr', 'an underestimated danger'), ('das Recht', 'right'), ('die Zukunft', 'future'), ('die Pause', 'rest'), ('die Musik', 'music'),
        ], 4),
    ],
    [
        gaps('Argue it', 'Write the missing word.', [
            ('Zu klären ist nicht, ob der Staat eingreifen darf,', 'unter welchen Bedingungen.', 'sondern'),
            ('Der gewichtigste', 'lautet, dass eine solche Pflicht die Autonomie aushöhlt.', 'Einwand'),
            ('Daraus folgt keineswegs eine Pflicht,', 'aber eine Begründungslast.', 'wohl'),
        ]),
        circle('An essay on forgetting', 'Listen to the essay. Circle what you hear.', [
            ('Wir leben im Zeitalter der totalen', ['Speicherung', 'Freiheit'], '.', 'Speicherung'),
            ('Doch gerade darin liegt eine unterschätzte', ['Gefahr', 'Chance'], '.', 'Gefahr'),
            ('Das Vergessen ist keine bloße', ['Schwäche', 'Leistung'], 'des Gedächtnisses.', 'Schwäche'),
            ('Das Recht auf Vergessen ist am Ende ein Recht auf', ['Zukunft', 'Ruhe'], '.', 'Zukunft'),
        ], 1) | {'listen': True},
        gaps('About you', 'Write the strongest objection to an idea you believe in.', [('Der gewichtigste Einwand lautet,', '.')], 'About you.'),
    ],
    ['frame an abstract question',
     'state the strongest objection fairly',
     'read nicht …, sondern … the right way round'],
    listen=Q + 'lesen_essay',
))

# ---- 18 · D-A-CH -----------------------------------------------------------------------------
spreads.append(spread(
    'dach', 'Marillen im Jänner', 'Standard German in Austria and Switzerland',
    'Velo and Jänner are not dialect: they are written standard German — in newspapers, laws and school books.',
    Q + 'dach_varianten',
    [
        table('Three countries, one thing', ['Germany', 'Austria', 'Switzerland'], [
            ['der Januar', 'der Jänner', 'der Januar'], ['die Tomaten', 'die Paradeiser', 'die Tomaten'], ['die Kartoffeln', 'die Erdäpfel', 'die Kartoffeln'],
            ['die Aprikosen', 'die Marillen', 'die Aprikosen'], ['die Sahne', 'das Obers', 'der Rahm'], ['das Fahrrad', 'das Fahrrad', 'das Velo'],
            ['die Fahrkarte', 'die Fahrkarte', 'das Billett'], ['das Abitur', 'die Matura', 'die Matur'],
            ['dieses Jahr', 'heuer', 'dieses Jahr'], ['parken', 'parken', 'parkieren'],
        ]),
        table('Grammar and spelling', ['', 'like this'], [
            ['sein with sitzen · stehen · liegen', 'Wir sind vor dem Eingang gestanden.'], ['Swiss: ss for ß', 'Strasse · Grüsse · gross'],
        ]),
        box('watch', 'Same word, other meaning', '*der Sessel* in Austria is an ordinary chair. *der Estrich* in Switzerland is the attic.'),
        words('Words for the practice page', [
            ('besonders viele', 'particularly many'), ('der Mai', 'May'), ('der Eingang', 'entrance'), ('das Billett', 'ticket'),
            ('gilt', 'is valid'), ('die zweite Klasse', 'second class'), ('der Nationalrat', 'National Council'),
            ('tritt zusammen', 'meets'), ('das Trottoir', 'pavement'), ('parkiert', 'parked'), ('der Stuhl', 'chair'),
            ('der Dachboden', 'attic'), ('gestanden', 'stood'),
        ], 4),
    ],
    [
        gaps('Austrian or Swiss', 'Write the word in brackets as an Austrian or a Swiss text would.', [
            ('', 'gibt es besonders viele Marillen. (dieses Jahr – AT)', 'Heuer'),
            ('Der Nationalrat tritt im', 'wieder zusammen. (Januar – AT)', 'Jänner'),
            ('Das', 'darf nicht auf dem Trottoir parkiert werden. (Fahrrad – CH)', 'Velo'),
            ('Das', 'gilt nur für die zweite Klasse. (Fahrkarte – CH)', 'Billett'),
        ]),
        match('Which country?', 'Draw a line from the word to the German word.', [
            ('die Erdäpfel', 'die Kartoffeln'), ('die Paradeiser', 'die Tomaten'), ('die Matura', 'das Abitur'), ('parkieren', 'parken'),
        ], [2, 0, 3, 1]),
        write('Swiss spelling', 'Write it as in Switzerland.', [('die Straße', 'die Strasse'), ('Grüße', 'Grüsse')], 2),
    ],
    ['read Austrian words like Jänner and Marillen',
     'read Swiss words like Velo and Billett',
     'know that they are standard, not dialect'],
))

# ---- 19 · Rezension ------------------------------------------------------------------------
spreads.append(spread(
    'rezension', 'lässt sich als … deuten', 'Writing about a book like a critic',
    'Quote, then interpret — never one without the other. And keep the narrator apart from the author.',
    Q + 'rezension_redemittel',
    [
        table('The review, step by step', ['step', 'phrase'], [
            ['introduce', 'In ihrem Roman „…“ erzählt die Autorin …'], ['theme', 'Der Roman setzt sich mit … auseinander.'],
            ['plot', 'Die Handlung setzt ein, als …'], ['perspective', 'Erzählt wird aus der Sicht …'],
            ['quote + interpret', 'Die Wendung „…“ lässt sich als … deuten.'], ['image', 'Das Motiv steht für … · Das Bild verweist auf …'],
            ['praise · doubt', 'Besonders gelungen ist … · Weniger überzeugend ist hingegen …'],
            ['verdict', 'Insgesamt erweist sich der Roman als …'],
        ]),
        flow('handeln von or es handelt sich um?', q('Is the book the subject of the sentence?',
                                                    a('handeln von', 'Der Roman handelt von einem Mann.'), a('es handelt sich um', 'Es handelt sich um einen Roman über …'))),
        words('Words for the practice page', [
            ('der Koffer', 'suitcase'), ('der Kleiderschrank', 'wardrobe'), ('einunddreißig', 'thirty-one'), ('die Wetterfahne', 'weathervane'),
            ('das Gepäckstück', 'piece of luggage'), ('die Reise', 'journey'), ('aufbewahrt', 'kept'), ('der Keller', 'cellar'),
            ('der Anhänger', 'tag'), ('abgeschnitten', 'cut off'), ('die Herkunft', 'origin'), ('die Familie', 'family'),
            ('die Brüchigkeit', 'fragility'), ('der Schluss', 'ending'), ('die Figur des Bruders', 'the brother'), ('das Erinnern', 'remembering'),
            ('eine kluge Studie', 'a clever study'), ('antreten', 'to set out on'), ('den leeren Koffer', 'the empty suitcase'), ('das Motiv des Koffers', 'the suitcase motif'), ('die Studie', 'study'),
        ], 4),
    ],
    [
        gaps('The critic’s phrase', 'Write the missing word.', [
            ('Der Roman setzt sich mit der Frage', ', was Herkunft bedeutet.', 'auseinander'),
            ('Die Wendung „ein Haus aus Papier“ lässt sich als Bild für die Brüchigkeit der Familie', '.', 'deuten'),
            ('Besonders', 'ist der Schluss; weniger überzeugend ist hingegen die Figur des Bruders.', 'gelungen'),
            ('Insgesamt erweist sich der Roman als kluge', 'über das Erinnern.', 'Studie'),
        ]),
        circle('The suitcase', 'Listen to the reading. Circle what you hear.', [
            ('Der Koffer stand seit', ['einunddreißig', 'dreizehn'], 'Jahren auf dem Kleiderschrank.', 'einunddreißig'),
            ('Der Koffer war kein Gepäckstück mehr, sondern eine', ['Wetterfahne', 'Erinnerung'], '.', 'Wetterfahne'),
            ('Er hatte nicht eine Reise aufbewahrt, sondern den', ['Mann', 'Brief'], ', der sie hätte antreten können.', 'Mann'),
            ('Den leeren Koffer trug er in den', ['Keller', 'Flur'], '.', 'Keller'),
        ], 1) | {'listen': True},
        gaps('Your reading', 'Finish the sentence.', [('Das Motiv des Koffers steht für', '.')], 'About you.'),
    ],
    ['introduce and summarise a novel',
     'quote and interpret in one move',
     'weigh praise against doubt and give a verdict'],
    listen=Q + 'hoeren_lesung',
))

# ---- 20 · Lyrik -----------------------------------------------------------------------------
spreads.append(spread(
    'lyrik', 'In Hamburg lebten zwei Ameisen', 'Why a comic poem is funny',
    'A huge plan, a tiny result: Australia, and they give up in Altona — next door to Hamburg. That gap is the joke.',
    Q + 'lesen_lyrik',
    [
        table('Ringelnatz: Die Ameisen (aabbcc)', ['line', 'rhyme'], [
            ['In Hamburg lebten zwei Ameisen,', 'a'], ['Die wollten nach Australien reisen.', 'a'],
            ['Bei Altona auf der Chaussee', 'b'], ['Da taten ihnen die Beine weh,', 'b'],
            ['Und da verzichteten sie weise', 'c'], ['Denn auf den letzten Teil der Reise.', 'c'],
        ]),
        table('One word does the work', ['word', 'device', 'effect'], [
            ['weise', 'irony', 'a defeat called a wise choice'], ['den letzten Teil', 'understatement', 'the last part is almost all of it'],
            ['raffinier- / te Tier', 'a word split', 'the rhyme decides, not the meaning'],
        ]),
        slots('Three sentences of interpretation', [
            ([('Das Gedicht lebt von …', 'the device'), ('Die Form unterstreicht …', 'the form'), {'de': 'So lässt sich das Gedicht als … deuten.', 'tag': 'the reading', 'hot': True}], None),
        ]),
        words('Words for the practice page', [
            ('die Ameisen', 'ants'), ('reisen', 'to travel'), ('die Beine', 'legs'), ('verzichteten', 'gave up'),
            ('weise', 'wisely'), ('die Reise', 'journey'), ('das Wiesel', 'weasel'), ('der Kiesel', 'pebble'),
            ('das Mondkalb', 'mooncalf'), ('verriet', 'gave away'), ('um des Reimes willen', 'for the sake of the rhyme'),
            ('der Reim', 'rhyme'), ('die Ironie', 'irony'), ('die Untertreibung', 'understatement'), ('die Strophe', 'stanza'),
            ('der Paarreim', 'rhyming couplet'), ('der Klang', 'sound'), ('der Inhalt', 'content'),
        ], 4),
    ],
    [
        circle('Two poems', 'Listen to the poems and the comment. Circle what you hear.', [
            ('Die Ameisen wollten nach', ['Australien', 'Amerika'], 'reisen.', 'Australien'),
            ('Bei Altona taten ihnen die', ['Beine', 'Füße'], 'weh.', 'Beine'),
            ('Ein Wiesel saß auf einem', ['Kiesel', 'Stein'], '.', 'Kiesel'),
            ('Das Tier tat’s um des', ['Reimes', 'Spaßes'], 'willen.', 'Reimes'),
        ], 1) | {'listen': True},
        gaps('Name it', 'Write Ironie, Untertreibung or Paarreim.', [
            ('„weise“ – aber die Ameisen sind nicht weise →', '', 'Ironie'),
            ('„den letzten Teil der Reise“ →', '', 'Untertreibung'),
            ('Ameisen – reisen, Chaussee – weh →', '', 'Paarreim'),
        ]),
        gaps('Your interpretation', 'Finish the sentence.', [('So lässt sich das Gedicht als', 'deuten.')], 'About you.'),
    ],
    ['find the gap between plan and result',
     'name irony, understatement and the rhyme scheme',
     'interpret a poem in three sentences'],
    listen=Q + 'lesen_lyrik',
))

# ---- Review 3 · topics 16–20 ---------------------------------------------------------------
spreads.append(review(
    'review_3', 'Topics 16–20', 'The last part of the last book, all at once. No looking back until you have done both pages.',
    Q + 'sprechen_dialog',
    [
        gaps('Argue', 'Write the missing word.', [
            ('Da irren Sie sich', '.', 'gewaltig'), ('Sie verwechseln Ursache und', '.', 'Wirkung'),
            ('Der gewichtigste', 'lautet, dass …', 'Einwand'),
        ]),
    ],
    [
        gaps('Read and interpret', 'Write the missing word.', [
            ('', 'gibt es viele Marillen. (dieses Jahr – AT)', 'Heuer'),
            ('Die Wendung „…“ lässt sich als Bild', 'die Brüchigkeit deuten.', 'für'),
            ('„weise“ – aber die Ameisen sind nicht weise →', '', 'Ironie'),
        ]),
    ],
))

book = {
    'title': 'Zwischen den Zeilen',
    'cover': 'cp_c2_2_cover',
    'welcome': [
        'This book is the paper half of C2.2, the last level. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It has three parts. The first is about meaning between the lines: focus, hints, paraphrase, wordplay, idioms and Latin words. The second is official and academic German: written prepositions, nominal style, officialese, appositions, modal verbs, the passive and the shapes of a clause. The third is about argument and literature: debate, the Erörterung, German in Austria and Switzerland, the review and the comic poem.',
        'It carries on from the earlier books. Words you learned there are not taught again. Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Kant', 'Weber', 'Klein', 'Sölle', 'Tom', 'Berger', 'Ludwig', 'Ludwigs', 'München', 'Berlin', 'Hamburg', 'Altona',
              'Australien', 'Petrova', 'Söll', 'Kaya', 'Ringelnatz', 'Morgenstern', 'Anton', 'Ruth', 'Kanada', 'Dr', 'Herr', 'Herrn',
              'Frau', 'Euro', 'AT', 'CH'],
    'spreads': spreads,
    'overview': {'title': 'C2.2 at a glance', 'blocks': [
        table('Focus words', ['', 'like this'], [
            ['even', 'selbst · sogar · noch kälter'], ['of all …', 'ausgerechnet heute'], ['only (time · amount)', 'erst drei Uhr · nur fünf Euro'],
        ]),
        table('Written prepositions', ['preposition', 'case'], [
            ['kraft · infolge · binnen · vorbehaltlich · ungeachtet', 'Gen'], ['gemäß · entgegen · zufolge (after the noun)', 'Dat'],
        ]),
        table('How sure?', ['', 'like this'], [
            ['sure', 'Er muss krank gewesen sein.'], ['probably', 'Der Bus dürfte Verspätung haben.'],
            ['people say', 'Er soll es gewusst haben.'], ['he claims', 'Er will nichts gewusst haben.'],
        ]),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from the antique shop and the harbour. Cover the German, look at the picture, say the word **with its article**.', [
            ('der Sekretär', 'writing bureau', 'cpd_sekretaer'), ('der Paravent', 'folding screen', 'cpd_paravent'), ('die Standuhr', 'grandfather clock', 'cpd_standuhr'),
            ('die Ritterrüstung', 'suit of armour', 'cpd_ritterruestung'), ('der Ohrensessel', 'wingback armchair', 'cpd_ohrensessel'),
            ('das Schaukelpferd', 'rocking horse', 'cpd_schaukelpferd'), ('das Spinnrad', 'spinning wheel', 'cpd_spinnrad'),
            ('das Grammophon', 'gramophone', 'cpd_grammophon'), ('die Nähmaschine', 'sewing machine', 'cpd_naehmaschine'),
            ('das Fernrohr', 'telescope', 'cpd_fernrohr'), ('die Harfe', 'harp', 'cpd_harfe'), ('der Fächer', 'hand fan', 'cpd_faecher'),
            ('die Truhe', 'chest', 'cpd_truhe'), ('das Schachbrett', 'chessboard', 'cpd_schachbrett'), ('das Butterfass', 'butter churn', 'cpd_butterfass'),
            ('der Mörser', 'mortar', 'cpd_moerser'), ('das Akkordeon', 'accordion', 'cpd_akkordeon'), ('der Vogelkäfig', 'birdcage', 'cpd_vogelkaefig'),
            ('das Hufeisen', 'horseshoe', 'cpd_hufeisen'), ('die Kaffeemühle', 'coffee grinder', 'cpd_kaffeemuehle'),
            ('die Petroleumlampe', 'oil lamp', 'cpd_petroleumlampe'), ('der Leuchtturm', 'lighthouse', 'cpd_leuchtturm'),
            ('der Kutter', 'fishing boat', 'cpd_kutter'), ('der Anker', 'anchor', 'cpd_anker'), ('der Rettungsring', 'life ring', 'cpd_rettungsring'),
            ('der Poller', 'bollard', 'cpd_poller'), ('die Seilwinde', 'winch', 'cpd_seilwinde'), ('die Schiffsglocke', 'ship’s bell', 'cpd_schiffsglocke'),
            ('das Steuerrad', 'ship’s wheel', 'cpd_steuerrad'), ('der Hummerkorb', 'lobster pot', 'cpd_hummerkorb'), ('die Boje', 'buoy', 'cpd_boje'),
            ('das Fass', 'barrel', 'cpd_fass'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
        {'what': 'Poems', 'source': 'Joachim Ringelnatz, „Die Ameisen“; Christian Morgenstern, „Das ästhetische Wiesel“', 'licence': 'public domain'},
    ],
}

kit.write_book(OUT, book)
