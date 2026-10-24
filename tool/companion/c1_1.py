# Builds assets/content/companion/de_cert_a1/c1_1.json — the C1.1 study companion.
# Run: python -I tool/companion/c1_1.py   (rules: docs/study_companion_guide.md)
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, merge, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_c1_1_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'c1_1.json')
Q = 'quest_c1_1_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ==== Part 1 · The language of research ==================================================

# ---- 1 · Bildung & Wissenschaft ----------------------------------------------------------
spreads.append(spread(
    'bildung', 'Bildung & Wissenschaft', 'The words of a study, from idea to result',
    'Every study runs the same way — assume, investigate, evaluate, conclude — and every step has a verb and a noun.',
    Q + 'bildung',
    [
        build('The research cycle: verb → noun', [
            (['annehmen'], 'die Annahme', 'assumption'), (['untersuchen'], 'die Untersuchung', 'investigation'),
            (['durchführen'], 'die Durchführung', 'carrying out'), (['auswerten'], 'die Auswertung', 'evaluation'),
            (['nachweisen'], 'der Nachweis', 'proof'),
        ], 'Learn them in pairs: texts switch between the two all the time.'),
        tiles('How strong is the claim? Weak → strong', [
            ('die Vermutung', 'supposition'), ('die Annahme', 'assumption'), ('die These', 'claim'),
            ('der Beleg', 'evidence'), ('der Nachweis!', 'proof'),
        ], 5, note='widerlegen = to show it is false.'),
        words('Words for the practice page', [
                        ('die Schlussfolgerung', 'conclusion'),
            ('das Gehirn', 'brain'), ('aktivieren', 'to activate'),
            ('ausschütten · schüttet aus', 'to release'),             ('die Forschung', 'research'), ('steht am Anfang', 'is at the beginning'),
            ('überraschend', 'surprising'), ('das Team', 'team'),             ('mehrere Bereiche', 'several areas'), ('gleichzeitig', 'at the same time'), ('ähnlich wie beim Essen', 'like when eating'), ('zu einer überraschenden Schlussfolgerung', 'to a surprising conclusion'), ('folgern', 'to conclude'), ('des Gehirns', 'of the brain'),         ], 4),
    ],
    [
        gaps('Verb or noun?', 'Write the noun of the verb in brackets.', [
            ('Nach der', 'der Studie … (durchführen)', 'Durchführung'),
            ('… und der', 'der Daten … (auswerten)', 'Auswertung'),
            ('… kam das Team zu einer überraschenden', '. (folgern)', 'Schlussfolgerung'),
        ]),
        circle('Why music moves us', 'Listen to the text. Circle what you hear.', [
            ('Musik aktiviert mehrere Bereiche des', ['Gehirns', 'Körpers'], 'gleichzeitig.', 'Gehirns'),
            ('Das Gehirn schüttet', ['Dopamin', 'Zucker'], 'aus — ähnlich wie beim Essen.', 'Dopamin'),
            ('Die Forschung steht erst am', ['Anfang', 'Ende'], '.', 'Anfang'),
        ], 1) | {'listen': True},
    ],
    ['name the steps of a study with verb and noun',
     'rank a claim: Vermutung, These, Beleg, Nachweis',
     'follow a popular-science text'],
    listen=Q + 'lesen_wissenschaft',
))

# ---- 2 · Nominalisierung ------------------------------------------------------------------
spreads.append(spread(
    'nominalisierung', 'die schnelle Reaktion der Firma', 'Folding a clause into a noun phrase',
    'Weil die Firma schnell reagierte → wegen der schnellen Reaktion der Firma. Five moves fold any sentence.',
    Q + 'nominalisierung',
    [
        slots('Five moves: where each part lands', [
            ([('weil', '5'), ('die Firma', '2'), ('schnell', '4'), {'de': 'reagierte', 'tag': '1', 'hot': True}], 'the clause'),
            ([('wegen', '5 · preposition'), ('der schnellen', '4 · adjective'), {'de': 'Reaktion', 'tag': '1 · noun', 'hot': True},
              ('der Firma', '2 · genitive')], 'the phrase'),
        ], note='3 · an object becomes a genitive or a compound: die Senkung der Steuern = die Steuersenkung.'),
        table('Which noun?', ['verb', 'noun'], [
            ['entscheiden · lösen', 'die Entscheidung · die Lösung'], ['ankommen · abfahren', 'die Ankunft · die Abfahrt'],
            ['verlieren · wachsen', 'der Verlust · das Wachstum'], ['vorschlagen · ergeben', 'der Vorschlag · das Ergebnis'],
        ], 'No noun? The infinitive always works: das Warten.'),
        box('tip', 'Two genitives are the limit',
            '*die Untersuchung der Wirkung des Medikaments* is correct but heavy. Better: *die Untersuchung zur Wirkung des Medikaments*.'),
        words('Words for the practice page', [
            ('reagieren · reagierte', 'to react'), ('der Schaden', 'damage'), ('blieb klein', 'stayed small'), ('die Regierung', 'government'),
            ('die Steuern senken', 'to cut taxes'), ('die Kommission', 'commission'), ('das Gesetz ändern', 'to change the law'),
            ('der Zug · des Zuges', 'train'), ('sich verzögern', 'to be delayed'), ('das Projekt', 'project'), ('erfolgreich', 'successful'),
            ('folgen · folgte', 'to follow'), ('sich einigen auf', 'to agree on'), ('der Plan', 'plan'), ('das Team', 'team'), ('verzögerte sich', 'was delayed'), ('die Änderung des Gesetzes', 'the change in the law'), ('des erfolgreichen Projekts', 'of the successful project'),
        ], 4),
    ],
    [
        gaps('Fold it', 'Write the noun phrase.', [
            ('Weil die Firma schnell reagierte, blieb der Schaden klein. →', 'blieb der Schaden klein.', 'Wegen der schnellen Reaktion der Firma'),
            ('Die Regierung senkt die Steuern. → die', 'durch die Regierung', 'Senkung der Steuern'),
            ('Der Zug kam später an. → Die', 'verzögerte sich.', 'Ankunft des Zuges'),
            ('Sie einigen sich auf einen Plan. → die', '', 'Einigung auf einen Plan'),
        ]),
        write('Unfold it', 'Write it as a sentence with a verb.', [
            ('der Vorschlag der Kommission zur Änderung des Gesetzes', 'Die Kommission schlägt vor, das Gesetz zu ändern.'),
            ('nach der erfolgreichen Durchführung des Projekts durch das Team', 'nachdem das Team das Projekt erfolgreich durchgeführt hatte'),
        ], 1),
    ],
    ['fold a clause into a noun phrase in five moves',
     'find the right noun for a verb',
     'keep a chain to two genitives'],
))

# ---- 3 · Verbalisierung --------------------------------------------------------------------
spreads.append(spread(
    'verbalisierung', 'Trotz der Warnung → obwohl gewarnt wurde', 'Unfolding a noun phrase into a clause',
    'Reading dense German means doing this silently: find the little word, find its conjunction, put the verb back — last.',
    Q + 'verbalisierung',
    [
        cols(
            table('Preposition → conjunction', ['phrase', 'clause'], [
                ['wegen · aufgrund', 'weil · da'], ['trotz', 'obwohl'], ['nach · vor', 'nachdem · bevor'], ['bei', 'als · wenn'],
            ]),
            table('… and the rest', ['phrase', 'clause'], [
                ['durch · mittels', 'indem'], ['zu · zwecks', 'um … zu · damit'], ['im Falle', 'falls'], ['ohne', 'ohne dass'],
            ]),
        ),
        flow('Which tense?', q('Is it a past story with nachdem?',
                               a('Plusquamperfekt', 'nach seiner Ankunft → nachdem er angekommen war'),
                               a('the tense of the main clause', 'bei Regen → wenn es regnet'))),
        words('Words for the practice page', [
            ('die Warnung', 'warning'), ('die Behörden', 'authorities'), ('gewarnt', 'warned'), ('losfahren · fuhren los', 'to set off'),
            ('die Luftqualität', 'air quality'), ('verbessern · die Verbesserung', 'to improve'), ('gesperrt', 'closed'), ('der Abflug', 'departure'),
            ('abfliegen · abflog', 'to take off'), ('der Erhalt', 'receipt'), ('erhalten', 'to receive'), ('die Nachricht', 'message'),
            ('die Vorschriften', 'regulations'), ('die Nichtbeachtung', 'not following'), ('beachtet werden', 'be followed'),
            ('tägliches Üben', 'daily practice'), ('üben', 'to practise'), ('besser', 'better'), ('man übt', 'one practises'), ('ihrer', 'her'),
            ('der Brand', 'fire'), ('ausbricht', 'breaks out'), ('das Gebäude', 'building'), ('verlassen', 'to leave'),
        ], 4),
    ],
    [
        gaps('Unfold it', 'Write the conjunction.', [
            ('Trotz der Warnung der Behörden fuhren viele los. →', 'die Behörden gewarnt hatten, fuhren viele los.', 'Obwohl'),
            ('Zur Verbesserung der Luftqualität wurde die Straße gesperrt. →', 'die Luftqualität zu verbessern, …', 'Um'),
            ('Durch tägliches Üben wird man besser. → Man wird besser,', 'man täglich übt.', 'indem'),
            ('Im Falle eines Brandes verlassen Sie das Gebäude. →', 'ein Brand ausbricht, …', 'Falls'),
        ]),
        gaps('Put the verb back', 'Write the verb in brackets in the right tense — last.', [
            ('nach Erhalt Ihrer Nachricht → nachdem wir Ihre Nachricht', '(erhalten)', 'erhalten hatten'),
            ('vor dem Abflug → bevor das Flugzeug', '(abfliegen)', 'abflog'),
            ('bei Nichtbeachtung der Vorschriften → wenn die Vorschriften nicht', '(beachten, passive)', 'beachtet werden'),
        ]),
    ],
    ['unfold a noun phrase into a clause',
     'match each little word to its conjunction',
     'put back the subject, the tense and the verb at the end'],
))

# ---- 4 · anlässlich, mangels, zwecks ------------------------------------------------------
spreads.append(spread(
    'genitiv', 'angesichts der Lage', 'Little words of contracts and letters',
    'anlässlich, mangels, zwecks, ungeachtet, angesichts, bezüglich: each folds a clause into two words — and marks the register at once.',
    Q + 'genitiv_schriftsprache',
    [
        table('The written set', ['word', '~', 'like this'], [
            ['anlässlich', 'on the occasion of', 'anlässlich des Jubiläums'], ['mangels', 'for lack of', 'mangels Beweisen'],
            ['zwecks', 'for the purpose of', 'zwecks Überprüfung'], ['ungeachtet', 'regardless of', 'ungeachtet der Kritik'],
            ['seitens', 'on the part of', 'seitens der Regierung'], ['angesichts', 'in view of', 'angesichts der Lage'],
            ['bezüglich · hinsichtlich', 'regarding', 'bezüglich Ihrer Anfrage'],
        ]),
        slots('Three “according to”s, three grammars', [
            (sl('laut!', 'Bericht'), 'bare noun, or + dative / genitive'),
            (sl('gemäß!', 'den Vorschriften'), '+ dative'),
            (sl('dem Bericht', 'zufolge!'), 'after the noun, + dative'),
        ]),
        words('Words for the practice page', [
            ('das Jubiläum', 'anniversary'), ('die Beweise', 'evidence'), ('die Überprüfung', 'check'), ('die Kritik', 'criticism'),
            ('verabschiedet', 'passed'), ('die Lage', 'situation'), ('die Anfrage', 'enquiry'), ('die Leitung', 'management'),
            ('die Einwände', 'objections'), ('die Zahlen', 'figures'), ('der Zeitplan', 'schedule'), ('die Ausstellung', 'exhibition'),
            ('eröffnet', 'opened'), ('freigesprochen', 'acquitted'), ('der Angeklagte', 'defendant'), ('die Vorschriften', 'regulations'),
            ('der Bericht', 'report'), ('senden', 'to send'), ('gestiegen', 'risen'), ('mitteilen · teilen mit', 'to inform'), ('die Kosten', 'costs'), ('Folgendes', 'the following'),
        ], 4),
    ],
    [
        gaps('Which little word?', 'Write anlässlich, mangels, zwecks, ungeachtet, angesichts or bezüglich.', [
            ('', 'des Jubiläums wurde eine Ausstellung eröffnet.', 'Anlässlich'),
            ('', 'Beweisen wurde der Angeklagte freigesprochen.', 'Mangels'),
            ('', 'der Kritik wurde das Gesetz verabschiedet.', 'Ungeachtet'),
            ('', 'der Lage gab es keine Einwände.', 'Angesichts'),
            ('', 'Ihrer Anfrage teilen wir Ihnen Folgendes mit.', 'Bezüglich'),
            ('Bitte senden Sie die Unterlagen', 'Überprüfung.', 'zwecks'),
        ]),
        gaps('According to', 'Write laut, gemäß or zufolge.', [
            ('', 'Bericht sind die Kosten gestiegen.', 'Laut'), ('Dem Bericht', 'sind die Kosten gestiegen.', 'zufolge'),
            ('', 'den Vorschriften ist das verboten.', 'Gemäß'),
        ]),
    ],
    ['use anlässlich, mangels, zwecks, angesichts',
     'open a formal letter with bezüglich',
     'tell laut, gemäß and zufolge apart'],
))

# ---- 5 · sich einer Sache bewusst ---------------------------------------------------------
spreads.append(spread(
    'kasus', 'sich der Risiken bewusst', 'Describing words that take a case',
    'No little word at all: sich des Problems bewusst, mir behilflich, zwei Meter lang — the case comes first, the describing word last.',
    Q + 'adjektive_praep_kasus',
    [
        table('Which case?', ['case', 'describing words', 'like this'], [
            ['genitive', 'bewusst · sicher · würdig · schuldig · müde · fähig', 'Er ist sich *des Problems* bewusst.'],
            ['dative', 'behilflich · dankbar · bekannt · fremd · ähnlich · überlegen', 'Kann ich *Ihnen* behilflich sein?'],
            ['accusative (measure)', 'lang · alt · breit · wert · entfernt', 'Der Tisch ist *zwei Meter* lang.'],
        ]),
        slots('The case first, the describing word last', [
            (sl('Sie ist sich', 'ihrer Verantwortung', 'bewusst.!'), 'genitive'),
            (sl('Sie ist', 'dem Team', 'dankbar.!'), 'dative'),
        ]),
        table('Nouns of academic prose', ['noun', 'little word'], [
            ['die Forderung · die Suche', 'nach'], ['der Zweifel', 'an + Dat'], ['der Verweis · die Auswirkung · der Anspruch', 'auf'],
            ['der Beitrag · das Verhältnis', 'zu'],
        ]),
        words('Words for the practice page', [
            ('die Risiken', 'risks'), ('der Sieg · des Sieges', 'victory'),
            ('der Preis · des Preises', 'prize'), ('das Werk', 'work'), ('der Diebstahl · des Diebstahls', 'theft'),
            ('schuldig gesprochen', 'found guilty'), ('das Warten', 'waiting'),             ('die Mutter', 'mother'),             ('die Änderung', 'change'), ('die Studie', 'study'),             ('die Reformen', 'reforms'), ('die Auswirkungen', 'effects'), ('die Diskussion', 'discussion'),
        ], 4),
    ],
    [
        gaps('The case', 'Write the words in brackets in the right case.', [
            ('Die Leitung ist sich', 'bewusst. (die Risiken)', 'der Risiken'),
            ('Sie war sich', 'sicher. (der Sieg)', 'des Sieges'),
            ('Das Werk ist', 'würdig. (der Preis)', 'des Preises'),
            ('Ich bin', 'müde. (das Warten)', 'des Wartens'),
            ('Kann ich', 'behilflich sein? (Sie)', 'Ihnen'),
            ('Sie ist', 'sehr ähnlich. (ihre Mutter)', 'ihrer Mutter'),
        ]),
        gaps('Nouns and their little word', 'Write the missing little word.', [
            ('der Verweis', 'die Studie', 'auf'), ('die Forderung', 'Reformen', 'nach'),
            ('Zweifel', 'den Auswirkungen', 'an'), ('ein Beitrag', 'der Diskussion', 'zur'),
        ]),
    ],
    ['use bewusst, sicher, würdig with the genitive',
     'use behilflich, dankbar, ähnlich with the dative',
     'learn the nouns of academic prose with their little word'],
))

# ---- 6 · zur Anwendung kommen --------------------------------------------------------------
spreads.append(spread(
    'fvg', 'zur Anwendung kommen', 'Noun + light verb in specialist German',
    'anwenden → zur Anwendung bringen or kommen. The noun carries the meaning; the light verb says who acts.',
    Q + 'funktionsverbgefuege',
    [
        flow('bringen or kommen?', q('Does someone act on it?',
                                     a('bringen · stellen · nehmen · ziehen', 'Wir bringen das Verfahren zur Anwendung.'),
                                     a('kommen · stehen · treten', 'Das Verfahren kommt zur Anwendung.'))),
        table('One noun, two sides', ['someone acts', 'it happens · it is so'], [
            ['zur Verfügung stellen', 'zur Verfügung stehen'], ['zum Abschluss bringen', 'zum Abschluss kommen'],
            ['in Kraft setzen', 'in Kraft treten'], ['zur Sprache bringen', 'zur Sprache kommen'],
        ]),
        slots('The light verb moves, the noun stays', [
            (sl('Die Verordnung', 'ist!', 'am 1. Januar', 'in Kraft', 'getreten.!'), 'treten → ist getreten'),
            (sl('Wir bitten Sie,', 'unseren Vorschlag', 'in Erwägung', 'zu ziehen.!'), 'zu before the light verb'),
        ]),
        words('Words for the practice page', [
            ('die Verordnung', 'regulation'), ('die Vereine · den Vereinen', 'clubs'), ('die Räume', 'rooms'), ('das Verfahren', 'procedure'),
            ('Bezug nehmen auf', 'to refer to'), ('das Schreiben', 'letter'), ('vom 12. Mai', 'of 12 May'), ('Kritik üben an', 'to criticise'),
            ('der Vorschlag', 'proposal'), ('in Erwägung ziehen', 'to consider'), ('zum Ausdruck bringen', 'to express'),
            ('der Dank', 'thanks'), ('unter Beweis stellen', 'to prove'), ('das Können', 'ability'), ('das Projekt', 'project'),
            ('die Stadt', 'city'),
        ], 4),
    ],
    [
        gaps('The light verb' , 'Write the light verb in the right form.', [
            ('Die Stadt', 'den Vereinen Räume zur Verfügung.', 'stellt'),
            ('Das neue Verfahren', 'ab Montag zur Anwendung.', 'kommt'),
            ('Die Verordnung ist am 1. Januar in Kraft', '.', 'getreten'),
            ('Ich', 'Bezug auf Ihr Schreiben vom 12. Mai.', 'nehme'),
            ('Wir bitten Sie, unseren Vorschlag in Erwägung zu', '.', 'ziehen'),
            ('Wir möchten unseren Dank zum Ausdruck', '.', 'bringen'),
        ]),
        match('Noun and verb', 'Draw a line from the noun to its light verb.', [
            ('in Kraft', 'treten'), ('Kritik', 'üben'), ('unter Beweis', 'stellen'), ('zum Abschluss', 'bringen'),
        ], [2, 3, 0, 1]),
    ],
    ['choose bringen or kommen, stellen or stehen',
     'put the light verb in the Perfekt with its own helper',
     'use one or two in a formal letter'],
))

# ---- 7 · Tempuswahl -------------------------------------------------------------------------
spreads.append(spread(
    'tempus', 'Da klopft es.', 'Choosing a tense on purpose',
    'You know all six tenses. Now the choice: Präteritum for the story, Perfekt for what still counts, Präsens for the moment of drama.',
    Q + 'tempuswahl',
    [
        timeline('One story, several tenses', [
            ('Er hatte das Haus schon verlassen.', 'one step back: Plusquamperfekt', -3),
            ('Sie ging nach Hause.', 'the main line: Präteritum', -1.5),
            ('Die Preise sind gestiegen.', 'the past that still counts: Perfekt', -0.5),
            ('Wasser kocht bei 100 Grad.', 'always true: Präsens', 0),
            ('Bis Freitag werden wir fertig sein.', 'the future', 2.5),
        ]),
        table('Each change means something', ['change', 'effect', 'like this'], [
            ['Präteritum → Präsens', 'drama, the climax', 'Sie lag wach. *Da klopft es.*'],
            ['Präteritum → Perfekt', 'the narrator steps into now', 'Wir befragten 300 Personen. Das Ergebnis *hat* uns überrascht.'],
        ]),
        box('watch', 'Not English aspect',
            '*Ich habe ihn gestern gesehen* is normal German. The choice is spoken (Perfekt) or written (Präteritum) — not finished or not.'),
        words('Words for the practice page', [
            ('der Saal', 'hall'), ('voll', 'full'), ('der Redner', 'speaker'), ('stundenlang', 'for hours'), ('wach liegen', 'to lie awake'),
            ('den Atem anhalten', 'to hold one’s breath'), ('still', 'quiet'), ('befragen · befragten', 'to survey'),
            ('die Personen', 'people'), ('das Jahresende', 'end of the year'), ('niemanden überraschen', 'surprise nobody'),
            ('klopfen', 'to knock'), ('begann', 'began'), ('gewartet', 'waited'), ('verlassen', 'left'), ('Mitternacht', 'midnight'),
            ('plötzlich', 'suddenly'), ('lag', 'lay'),
        ], 4),
    ],
    [
        circle('Which tense?', 'Circle the form that fits.', [
            ('Der Saal war voll, als der Redner begann; die meisten', ['hatten', 'haben'], 'stundenlang gewartet.', 'hatten'),
            ('Wir befragten 300 Personen. Das Ergebnis', ['hat', 'hatte'], 'uns überrascht.', 'hat'),
            ('Mitternacht. Plötzlich', ['klopft', 'klopfte'], 'es.', 'klopft'),
            ('Bis zum Jahresende', ['werden', 'sind'], 'die Kosten gestiegen sein.', 'werden'),
        ], 1),
        gaps('Back into the story', 'Write the verb in the Präteritum: the drama is over.', [
            ('Sie lag wach. Da klopft es. Sie hält den Atem an. Dann', 'es wieder still. (werden)', 'wurde'),
        ]),
    ],
    ['keep a story in one tense',
     'step back with the Plusquamperfekt',
     'switch to the Präsens for drama — and back'],
))

# ---- Review 1 · topics 1–7 -----------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–7', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        gaps('Fold and unfold', 'Write the missing word.', [
            ('weil die Firma schnell reagierte →', 'der schnellen Reaktion der Firma', 'wegen'),
            ('trotz der Warnung →', 'die Behörden gewarnt hatten', 'obwohl'),
            ('nach seiner Ankunft → nachdem er angekommen', '', 'war'),
        ]),
        gaps('Research words', 'Write the noun of the verb in brackets.', [
            ('die', '(auswerten)', 'Auswertung'), ('der', '(nachweisen)', 'Nachweis'), ('die', '(untersuchen)', 'Untersuchung'),
        ]),
    ],
    [
        gaps('Register', 'Write the missing word.', [
            ('', 'Ihrer Anfrage teilen wir Ihnen Folgendes mit.', 'Bezüglich'),
            ('Die Leitung ist sich', 'Risiken bewusst.', 'der'),
            ('Das neue Verfahren', 'ab Montag zur Anwendung.', 'kommt'),
            ('Mitternacht. Plötzlich', 'es. (klopfen)', 'klopft'),
        ]),
    ],
))

# ==== Part 2 · Passive substitutes and participles =======================================

# ---- 8 · Passiversatz ----------------------------------------------------------------------
spreads.append(spread(
    'passiversatz', 'Er bekam das Buch geschenkt', 'The full set of passive substitutes',
    'Five ways round the werden-passive, each with its own focus: the rule, the possibility, the person, the product, the outrage.',
    Q + 'passiversatz',
    [
        table('Five substitutes, five focuses', ['focus', 'form', 'like this'], [
            ['must', 'sein + zu', 'Das Formular *ist auszufüllen*.'], ['can', 'sich lassen · -bar', 'Das Gerät *lässt sich* leicht bedienen.'],
            ['the person who gets it', 'bekommen + past form', 'Er *bekam* das Buch *geschenkt*.'],
            ['how a thing behaves', 'sich + verb', 'Das Buch *verkauft sich* gut.'], ['ought to (spoken)', 'gehören + past form', 'Das *gehört verboten*.'],
        ]),
        arrow('bekommen: the dative becomes the subject', [
            ('Ihm', 'wurde … geschenkt', 'das Buch', 'normal passive: dative stays'),
            ('Er', 'bekam … geschenkt', 'das Buch', 'he is now the subject'),
        ], ('wer?', 'was?')),
        words('Words for the practice page', [
            ('der Support', 'support'), ('melden', 'to report'), ('bedienen', 'to operate'), ('das Gerät', 'device'),
            ('die Teilnehmer', 'participants'), ('zuschicken · zugeschickt', 'to send'), ('erklärt', 'explained'), ('die Regeln', 'rules'),
            ('die Tür öffnet sich', 'the door opens'), ('automatisch', 'automatically'), ('der Roman liest sich leicht', 'the novel reads easily'),
            ('die Software installiert sich', 'the software installs itself'), ('flüssig', 'fluently'), ('von allein', 'by itself'),
            ('die Rückfragen', 'questions'), ('klären', 'to clear up'), ('telefonisch', 'by phone'), ('per E-Mail', 'by e-mail'),
            ('überreicht', 'handed over'), ('die Mitarbeitenden', 'staff'), ('die Zugangsdaten', 'login details'), ('installieren', 'to install'), ('in wenigen Minuten', 'in a few minutes'), ('der Preis', 'prize'), ('die Ergebnisse', 'results'), ('sofort', 'at once'),
        ], 4),
    ],
    [
        gaps('Build the substitute', 'Write the missing words.', [
            ('Alle Probleme sind sofort dem Support', '. (melden, must)', 'zu melden'),
            ('Das Gerät', 'sich einfach bedienen. (can)', 'lässt'),
            ('Die Teilnehmer', 'die Ergebnisse per E-Mail zugeschickt. (bekommen, past)', 'bekamen'),
            ('Das Buch', 'sich gut. (verkaufen)', 'verkauft'),
            ('Der Roman', 'sich leicht. (lesen)', 'liest'),
            ('Die Unterlagen sind bis Freitag', '. (einreichen, must)', 'einzureichen'),
        ]),
        write('With bekommen', 'Make the person the subject.', [
            ('Ihr wurde der Preis überreicht.', 'Sie bekam den Preis überreicht.'),
            ('Uns wurden die Regeln erklärt.', 'Wir bekamen die Regeln erklärt.'),
        ], 1),
    ],
    ['choose the substitute by its focus',
     'make the person the subject with bekommen',
     'say how a thing behaves: verkauft sich, liest sich'],
))

# ---- 9 · -bar, -lich -------------------------------------------------------------------------
spreads.append(spread(
    'bar_lich', 'überschaubar, nachvollziehbar', 'One word for a whole clause',
    'Die Kosten sind überschaubar does the work of “the costs can be kept track of”. -bar builds them; -lich is a closed club.',
    Q + 'bar_lich',
    [
        build('-bar: any verb with an object', [
            (['überschau', ('bar', 'suffix')], 'überschaubar', 'manageable'), (['nachvollzieh', ('bar', 'suffix')], 'nachvollziehbar', 'easy to follow'),
            (['abruf', ('bar', 'suffix')], 'abrufbar', 'retrievable'), (['spür', ('bar', 'suffix')], 'spürbar', 'noticeable'),
            (['vertret', ('bar', 'suffix')], 'vertretbar', 'justifiable'), (['halt', ('bar', 'suffix')], 'haltbar', 'tenable, durable'),
        ]),
        tiles('-lich: learn them as words', [
            ('verständlich', 'understandable'), ('verzeihlich', 'forgivable'), ('erschwinglich', 'affordable'),
            ('unvermeidlich', 'unavoidable'), ('unentbehrlich', 'indispensable'), ('unglaublich', 'unbelievable'),
        ], 6, note='Never “verstehbar” or “leslich”.'),
        words('Words for the practice page', [
            ('die Argumentation', 'line of argument'), ('die These', 'claim'), ('kaum', 'hardly'), ('die Termine', 'dates'),
            ('die Daten', 'data'), ('jederzeit', 'at any time'), ('der Fehler', 'mistake'), ('die Reaktion', 'reaction'),
            ('der Abend', 'evening'), ('die Wirkung', 'effect'), ('die Preise', 'prices'), ('der Vorschlag', 'proposal'),
            ('die Folgen', 'consequences'), ('das Problem', 'problem'), ('der Text', 'text'), ('überschauen', 'to oversee'), ('nachvollziehen', 'to follow'), ('abrufen', 'to retrieve'), ('verzeihen', 'to forgive'), ('spüren', 'to feel'), ('erschwingen', 'to afford'), ('vorstellbar', 'imaginable'),
        ], 4),
    ],
    [
        gaps('-bar or -lich?', 'Write the describing word of the verb in brackets.', [
            ('Die Kosten sind', '. (überschauen)', 'überschaubar'),
            ('Die Argumentation ist', ', die These allerdings kaum haltbar. (nachvollziehen)', 'nachvollziehbar'),
            ('Die Daten sind jederzeit', '. (abrufen)', 'abrufbar'),
            ('Der Fehler ist', ', die Reaktion verständlich. (verzeihen)', 'verzeihlich'),
            ('Die Wirkung war sofort', '. (spüren)', 'spürbar'),
            ('Die Preise sind', '. (erschwingen)', 'erschwinglich'),
        ]),
        write('The opposite', 'Write the opposite with un-.', [
            ('lösbar', 'unlösbar'), ('vorstellbar', 'unvorstellbar'), ('verständlich', 'unverständlich'),
        ], 3),
    ],
    ['build -bar describing words',
     'know the -lich set by heart',
     'judge a text: nachvollziehbar, vertretbar, haltbar'],
))

# ---- 10 · der zu prüfende Antrag -----------------------------------------------------------
spreads.append(spread(
    'partizipialattribut', 'der noch zu prüfende Antrag', 'Participles before the noun — and the zu-form',
    'die seit Jahren steigenden Mieten, die geplante Reform, der zu prüfende Antrag: three participles, three meanings.',
    Q + 'partizipialattribute',
    [
        table('Three participles', ['form', 'meaning', 'like this'], [
            ['-end', 'doing it', 'die seit Jahren *steigenden* Mieten'], ['ge- (with haben)', 'done to it', 'die *geplante* Reform'],
            ['ge- (with sein)', 'done by it, finished', 'die *angekommene* Delegation'], ['zu … -end', 'must be done', 'der *zu prüfende* Antrag'],
        ]),
        slots('Unpack: article → noun → back to the middle', [
            ([('der', 'article'), ('noch', 'the middle'), {'de': 'zu prüfende', 'tag': 'must be checked', 'hot': True}, ('Antrag', 'noun')],
             '= der Antrag, der noch geprüft werden muss'),
        ]),
        box('watch', 'Not every past form works',
            'No *die teilgenommenen Personen*: teilnehmen has haben and no object. Say *die teilnehmenden Personen*.'),
        words('Words for the practice page', [
            ('die Mieten', 'rents'), ('die Reform', 'reform'), ('die Delegation', 'delegation'), ('der Antrag', 'application'),
            ('prüfen', 'to check'), ('die Umfrage', 'survey'), ('durchführen · durchgeführt', 'to carry out'), ('die Folgen', 'consequences'),
            ('erwarten', 'to expect'), ('die Umsätze', 'sales'), ('erzielen · erzielt', 'to achieve'), ('vor zwei Jahren', 'two years ago'),
            ('die Unterlagen', 'documents'), ('einreichen', 'to hand in'), ('die Parteien', 'parties'), ('die zu erwartenden Folgen', 'the expected consequences'), ('die erzielten Umsätze', 'the sales achieved'), ('die Personen', 'people'),
        ], 4),
    ],
    [
        gaps('The participle', 'Write the verb in brackets as a participle, with its ending.', [
            ('die seit Jahren', 'Mieten (steigen)', 'steigenden'),
            ('die vor zwei Jahren', 'Umfrage (durchführen)', 'durchgeführte'),
            ('die gestern', 'Delegation (ankommen)', 'angekommene'),
            ('der noch', 'Antrag (prüfen, must)', 'zu prüfende'),
            ('die', 'Folgen (erwarten, can)', 'zu erwartenden'),
        ]),
        write('Unpack it', 'Write it as a relative clause.', [
            ('die zu erwartenden Folgen', 'die Folgen, die zu erwarten sind'),
            ('die erzielten Umsätze', 'die Umsätze, die erzielt wurden'),
        ], 1),
    ],
    ['read a participle before the noun',
     'tell -end, ge- and zu … -end apart',
     'unpack it into a relative clause'],
))

# ---- 11 · In Berlin angekommen, … -----------------------------------------------------------
spreads.append(spread(
    'partizipialsatz', 'In Berlin angekommen, suchte er ein Hotel', 'Participial clauses',
    'Take a clause, drop the conjunction and the subject, keep the participle: Lächelnd verließ sie den Raum.',
    Q + 'partizipialsatz',
    [
        flow('-end or ge-?', q('Is it happening at the same time?',
                               a('-end', 'Lächelnd verließ sie den Raum. = während sie lächelte'),
                               a('ge-', 'In Berlin angekommen, suchte er … = als er angekommen war'))),
        slots('Same subject — always', [
            (sl('Von der Reise erschöpft,', 'ging!', 'er', 'ins Bett.'), 'he was tired, he went'),
        ], note='Not: Lächelnd öffnete sich die Tür — the door can’t smile.'),
        table('Unfold it', ['participle', 'clause'], [
            ['In Berlin angekommen, …', 'Als er in Berlin angekommen war, …'], ['Gut vorbereitet, …', 'Weil sie gut vorbereitet war, …'],
            ['Schweigend …', 'Während sie schwiegen, …'],
        ], 'A group of words may take a comma; one word never does.'),
        words('Words for the practice page', [
            ('lächeln', 'to smile'), ('der Raum', 'room'), ('erschöpft', 'exhausted'), ('die Reise', 'journey'), ('schweigen', 'to be silent'),
            ('zuhören', 'to listen'), ('zögern', 'to hesitate'), ('strahlen · strahlend', 'to beam'), ('entgegennehmen · nahm entgegen', 'to accept'), ('hörten zu', 'listened'), ('applaudierte', 'applauded'), ('saß', 'sat'),
            ('beeindrucken · beeindruckt', 'to impress'), ('das Publikum', 'audience'), ('applaudieren', 'to applaud'),
            ('verlassen', 'to abandon'), ('allein', 'alone'), ('der Bahnhof', 'station'),             ('vorbereitet', 'prepared'),             ('die Tür', 'door'), ('öffnete', 'opened'), ('nahm', 'took'), ('der Preis', 'prize'), ('das Ergebnis', 'result'),
         ], 4),
    ],
    [
        gaps('-end or ge-?', 'Write the verb in brackets as a participle.', [
            ('', 'verließ sie den Raum. (lächeln)', 'Lächelnd'),
            ('In Berlin', ', suchte er ein Hotel. (ankommen)', 'angekommen'),
            ('', 'hörten alle zu. (schweigen)', 'Schweigend'),
            ('Vom Ergebnis', ', applaudierte das Publikum. (beeindrucken)', 'beeindruckt'),
            ('', 'öffnete er die Tür. (zögern)', 'Zögernd'),
            ('Von allen', ', saß er allein am Bahnhof. (verlassen)', 'verlassen'),
        ]),
        write('Unfold it', 'Write it with als, weil or während.', [
            ('Gut vorbereitet, bestand sie die Prüfung.', 'Weil sie gut vorbereitet war, bestand sie die Prüfung.'),
            ('Strahlend nahm sie den Preis entgegen.', 'Während sie strahlte, nahm sie den Preis entgegen.'),
        ], 1),
    ],
    ['shorten a clause to a participle',
     'keep the same subject',
     'unfold a participle back into a clause'],
))

# ---- 12 · Attribute --------------------------------------------------------------------------
spreads.append(spread(
    'attribute', 'mit Dr. Weber, der Leiterin des Instituts', 'Long noun phrases: find the head',
    'die kürzlich veröffentlichten Ergebnisse der Studie des Instituts zum Klima: find the head noun, then hang the rest on it.',
    Q + 'attribute',
    [
        slots('Find the head noun', [
            ([('die', ''), ('kürzlich veröffentlichten', 'left: describing'), {'de': 'Ergebnisse', 'tag': 'the head', 'hot': True},
              ('der Studie', 'right: whose'), ('des Instituts', 'whose'), ('zum Klima', 'about what')], None),
        ]),
        table('The extra name takes the same case', ['', 'like this'], [
            ['nominative', 'Dr. Weber, *die* Leiterin des Instituts, …'], ['dative', 'mit Dr. Weber, *der* Leiterin des Instituts'],
            ['accusative', 'Wir trafen Herrn Braun, *den* Leiter der Abteilung.'],
        ]),
        box('tip', 'Shorten a chain',
            '*die Ergebnisse der Studie des Instituts* → *die Ergebnisse der Institutsstudie*. Two genitives in a row is the limit.'),
        words('Words for the practice page', [
            ('kürzlich', 'recently'), ('veröffentlicht', 'published'), ('das Institut', 'institute'), ('die Leiterin · der Leiter', 'head'),
            ('die Abteilung', 'department'), ('die Stellvertreterin', 'deputy'), ('trafen', 'met'), ('sprachen', 'spoke'),
            ('die Auswertung', 'evaluation'), ('die Befragung', 'survey'), ('die Studierenden', 'students'), ('der Studiengang', 'degree course'), ('eingeführt · der eingeführte', 'introduced'),
            ('die Fakultät', 'faculty'), ('eingeführt', 'introduced'), ('die Ergebnisse', 'results'), ('die Untersuchung', 'investigation'),
            ('mehrere Monate', 'several months'), ('dauerte', 'took'), ('die Kosten', 'costs'), ('das Verfahren', 'procedure'),
            ('hinsichtlich', 'regarding'), ('der Klärungsbedarf', 'need to clarify'), ('die Universitätsleitung', 'university management'),
            ('seitens', 'on the part of'), ('die Einwände', 'objections'), ('erhoben', 'raised'), ('bestehen', 'to exist'),
        ], 4),
    ],
    [
        gaps('Same case', 'Write der, die, den or dem.', [
            ('Wir sprachen mit Dr. Weber,', 'Leiterin des Instituts.', 'der'),
            ('Wir trafen Herrn Braun,', 'Leiter der Abteilung.', 'den'),
            ('Dr. Weber,', 'Leiterin des Instituts, ist heute nicht da.', 'die'),
        ]),
        gaps('Heard it?', 'Listen to the dictation and write the missing words.', [
            ('Die Auswertung der Ergebnisse der', 'dauerte mehrere Monate.', 'Untersuchung'),
            ('Hinsichtlich der Kosten des', 'besteht noch Klärungsbedarf.', 'Verfahrens'),
            ('Seitens der', 'wurden keine Einwände erhoben.', 'Universitätsleitung'),
        ]) | {'listen': True},
        write('Find the head', 'Write the head noun of the phrase.', [
            ('der im letzten Jahr eingeführte Studiengang der Fakultät', 'Studiengang'),
            ('die Auswertung der Befragung der Studierenden', 'Auswertung'),
        ], 1),
    ],
    ['find the head noun in a long phrase',
     'give the extra name the same case',
     'shorten a chain with a compound'],
    listen=Q + 'diktat_nominalstil',
))

# ---- 13 · Eine Grafik beschreiben ------------------------------------------------------------
spreads.append(spread(
    'grafik', 'von 40 auf 60 Prozent gestiegen', 'Describing a graph',
    'Frame it, name the striking point, describe the movement, compare, sum up — and say von, auf and um right.',
    Q + 'sprechen_grafik',
    [
        slots('von … auf … um', [
            ([('Der Anteil ist', ''), {'de': 'von 40', 'tag': 'from', 'hot': True}, {'de': 'auf 60 Prozent', 'tag': 'to', 'hot': True},
              ('gestiegen.', '')], None),
            ([('Das entspricht einem Anstieg', ''), {'de': 'um 20 Prozentpunkte.', 'tag': 'by', 'hot': True}], None),
        ], note='From 40 to 50 % is ten Prozentpunkte — and 25 Prozent.'),
        slots('Five moves', [
            ([('Die Grafik gibt Auskunft über …', 'frame'), ('Auffällig ist, dass …', 'striking')], None),
            ([('Der Anteil ist gestiegen.', 'movement'), ('Im Vergleich dazu …', 'compare')], None),
            ([ {'de': 'Zusammenfassend lässt sich sagen, dass …', 'tag': 'sum up', 'hot': True}], None),
        ]),
        table('Movement words', ['up', 'down', 'neither'], [
            ['steigen · der Anstieg', 'sinken · der Rückgang', 'konstant bleiben'], ['sich verdoppeln', 'sich halbieren', 'stagnieren · schwanken'],
        ]),
        words('Words for the practice page', [
            ('der Anteil', 'share'),             ('die Stipendien', 'scholarships'),             ('die Mieten', 'rents'), ('ein Grund dafür', 'one reason for it'), ('liegen in', 'to lie in'),
            ('nahezu', 'almost'),             ('das Studium', 'studies'), ('entspricht', 'corresponds'), ('sich beziehen auf', 'to cover'), ('erreichte', 'reached'), ('die gestiegenen Mieten', 'the higher rents'), ('entsprechen', 'to correspond to'),             ('die Zahl', 'number'),
        ], 4),
    ],
    [
        gaps('von, auf or um?', 'Write von, auf or um.', [
            ('Der Anteil ist', '40', 'von'), ('…', '60 Prozent gestiegen.', 'auf'),
            ('Das entspricht einem Anstieg', 'zwanzig Prozentpunkte.', 'um'),
        ]),
        circle('Students and money', 'Listen to the graph description. Circle what you hear.', [
            ('Die Daten beziehen sich auf die Jahre 2010 bis', ['2020', '2015'], '.', '2020'),
            ('Den höchsten Wert erreichte der Anteil im Jahr', ['2019', '2018'], '.', '2019'),
            ('Die Zahl der Stipendien ist nahezu', ['konstant', 'verdoppelt'], 'geblieben.', 'konstant'),
            ('Ein Grund dafür könnte in den gestiegenen', ['Mieten', 'Preisen'], 'liegen.', 'Mieten'),
        ], 1) | {'listen': True},
    ],
    ['frame a graph and name its striking point',
     'describe a movement with von, auf and um',
     'tell Prozent from Prozentpunkte'],
    listen=Q + 'sprechen_grafik',
))

# ---- Review 2 · topics 8–13 ----------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 8–13', 'Substitutes and participles, all at once. No looking back until you have done both pages.',
    Q + 'bigtext_hinweise',
    [
        gaps('Substitutes', 'Write the missing word.', [
            ('Alle Probleme sind sofort dem Support zu', '.', 'melden'),
            ('Das Programm', 'sich in wenigen Minuten installieren.', 'lässt'),
            ('Neue Mitarbeitende', 'die Zugangsdaten per Post zugeschickt.', 'bekommen'),
            ('Die Kosten sind', '. (überschauen)', 'überschaubar'),
        ]),
    ],
    [
        gaps('Participles and phrases', 'Write the missing word.', [
            ('der noch', 'Antrag (prüfen, must)', 'zu prüfende'),
            ('In Berlin', ', suchte er ein Hotel. (ankommen)', 'angekommen'),
            ('Wir sprachen mit Dr. Weber,', 'Leiterin des Instituts.', 'der'),
            ('Der Anteil ist', '40 auf 60 Prozent gestiegen.', 'von'),
        ]),
    ],
))

# ==== Part 3 · Connecting an argument ====================================================

# ---- 14 · sofern, zumal, insofern ---------------------------------------------------------
spreads.append(spread(
    'konnektoren', 'zumal es günstig ist', 'Four precise little words',
    'sofern sets a condition, zumal adds a stronger reason, insofern … als limits, geschweige denn goes one step further.',
    Q + 'konnektoren',
    [
        table('What each one does', ['word', 'does', 'like this'], [
            ['sofern', 'a condition (formal wenn)', 'Ich helfe dir, *sofern* ich Zeit habe.'],
            ['soweit', 'as far as', '*Soweit* ich weiß, ist er verreist.'],
            ['zumal', 'one more, stronger reason', 'Wir nehmen das Angebot an, *zumal* es günstig ist.'],
            ['insofern … als', 'in that respect', 'Die Studie ist wichtig, *insofern als* sie die Frage zuerst stellt.'],
            ['geschweige denn', 'let alone', 'Er kann kaum lesen, *geschweige denn* schreiben.'],
        ]),
        build('Rising formality', [
            (['wenn', ('falls', 'joint')], 'sofern', 'a condition'), (['weil', ('da', 'joint')], 'zumal', 'a reason'),
        ], 'All of them send the verb to the end — except Insofern hast du recht.'),
        words('Words for the practice page', [
            ('die Einwände', 'objections'), ('der Vertrag', 'contract'), ('gelten · gilt', 'to apply'), ('ab Montag', 'from Monday'),
            ('das Angebot', 'offer'), ('günstig', 'cheap'), ('verreist', 'away'), ('die Pflichtlektüre', 'required reading'),
            ('die Studierenden', 'students'), ('die Mittel', 'funds'), ('bewilligt', 'approved'), ('mit Staus rechnen', 'to expect traffic jams'),
            ('die Lehrkräfte', 'teachers'), ('geschult', 'trained'), ('die Tablets', 'tablets'), ('der Unterricht', 'teaching'),
            ('bereichern', 'to enrich'), ('die Konzentration', 'concentration'), ('leiden', 'to suffer'), ('die Ablenkung', 'distraction'),
            ('die Ressourcen', 'resources'), ('das Papier', 'paper'), ('längere Texte', 'longer texts'), ('der Kaffee', 'coffee'),
            ('das Essen', 'meal'), ('die Zeit', 'time'), ('ständiger', 'constant'), ('gelingen', 'to work'), ('kaum', 'hardly'),
        ], 4),
    ],
    [
        gaps('Which word?', 'Write sofern, soweit, zumal or geschweige denn.', [
            ('', 'keine Einwände bestehen, gilt der Vertrag ab Montag.', 'Sofern'),
            ('', 'ich weiß, ist er verreist.', 'Soweit'),
            ('Wir sollten das Angebot annehmen,', 'es günstig ist.', 'zumal'),
            ('Viele Studierende schaffen kaum die Pflichtlektüre,', 'mehr.', 'geschweige denn'),
        ]),
        circle('Tablets in school', 'Listen to the discussion. Circle what you hear.', [
            ('Tablets können den Unterricht bereichern,', ['sofern', 'weil'], 'die Lehrkräfte gut geschult sind.', 'sofern'),
            ('Frau Roth: Die', ['Konzentration', 'Motivation'], 'leidet unter ständiger Ablenkung.', 'Konzentration'),
            ('Das mag bei Ihnen gelingen,', ['zumal', 'sofern'], 'Sie die Ressourcen dafür haben.', 'zumal'),
            ('Für längere Texte bleibt sie beim', ['Papier', 'Tablet'], '.', 'Papier'),
        ], 1) | {'listen': True},
    ],
    ['set a formal condition with sofern',
     'add a stronger reason with zumal',
     'say let alone with geschweige denn'],
    listen=Q + 'hoeren_podiumsdiskussion',
))

# ---- 15 · gleichwohl, mithin, freilich -----------------------------------------------------
spreads.append(spread(
    'adverbien', 'gleichwohl, freilich, mithin', 'The connecting words of written German',
    'trotzdem → dennoch → gleichwohl: speech on the left, academic prose on the right.',
    Q + 'konjunktionaladverbien',
    [
        table('The register ladder', ['meaning', 'spoken', 'written', 'academic'], [
            ['although', 'trotzdem', 'dennoch', 'gleichwohl'], ['so', 'deshalb', 'folglich', 'mithin'],
            ['by contrast', 'dagegen', 'hingegen', 'indes'],
        ]),
        table('Four with a twist', ['word', '~'], [
            ['freilich', 'admittedly — concedes'], ['immerhin', 'at least — salvages'], ['demnach', 'according to that — from a source'],
        ]),
        slots('Verb right after it', [
            (sl('Die Annahme ist widerlegt;', 'mithin', 'muss!', 'das Modell', 'geändert werden.'), 'never: mithin das Modell muss'),
        ]),
        words('Words for the practice page', [
            ('lückenhaft', 'patchy'), ('der Trend', 'trend'), ('zeigt sich', 'shows'),
            ('schwach', 'weak'), ('das Vorjahr', 'previous year'), ('die Theorie', 'theory'), ('überzeugen · überzeugt', 'to convince'),
            ('die Praxis', 'practice'), ('schwierig', 'difficult'), ('die Bedingungen', 'conditions'), ('erfüllt', 'met'),
            ('der Beginn', 'start'), ('im Wege stehen', 'to stand in the way'), ('der Verbrauch', 'consumption'),
            ('die Maßnahmen', 'measures'), ('wirken', 'to work'), ('die Langeweile', 'boredom'),             ('die Kreativität', 'creativity'), ('die Dusche', 'shower'), ('das Smartphone', 'smartphone'),
            ('die Lösung', 'solution'), ('einfallen · fällt ein', 'to occur to'), ('kaum entsteht eine freie Minute', 'hardly is there a free minute'), ('greifen zu', 'to reach for'), ('eigene Gedanken', 'one’s own thoughts'), ('quälend', 'tormenting'),         ], 4),
    ],
    [
        gaps('Which word?', 'Write gleichwohl, immerhin, hingegen, mithin or demnach.', [
            ('Die Daten sind lückenhaft;', 'zeigt sich ein Trend.', 'gleichwohl'),
            ('Das Ergebnis ist schwach;', 'ist es besser als im Vorjahr.', 'immerhin'),
            ('Die Theorie überzeugt; die Praxis', 'bleibt schwierig.', 'hingegen'),
            ('Alle Bedingungen sind erfüllt;', 'steht dem Beginn nichts im Wege.', 'mithin'),
            ('Laut Studie sinkt der Verbrauch;', 'wirken die Maßnahmen.', 'demnach'),
        ]),
        circle('In praise of boredom', 'Listen to the essay. Circle what you hear.', [
            ('Kaum entsteht eine freie Minute, greifen wir zum', ['Smartphone', 'Buch'], '.', 'Smartphone'),
            ('Langeweile schafft Raum für eigene Gedanken und für', ['Kreativität', 'Ruhe'], '.', 'Kreativität'),
            ('Die Lösung fällt uns oft unter der', ['Dusche', 'Decke'], 'ein.', 'Dusche'),
            ('Langeweile kann', ['freilich', 'mithin'], 'auch quälend sein.', 'freilich'),
        ], 1) | {'listen': True},
    ],
    ['climb the register: trotzdem, dennoch, gleichwohl',
     'conclude with folglich, somit, mithin',
     'put the verb straight after the connector'],
    listen=Q + 'lesen_essay',
))

# ---- 16 · Adverbialsätze I ---------------------------------------------------------------------
spreads.append(spread(
    'adverbial_1', 'Sollte es regnen, bleiben wir', 'Time, cause, purpose, condition — in three columns',
    'Every link can be a clause, an adverb or a noun phrase. Good prose takes turns between the three.',
    Q + 'adverbialsaetze',
    [
        table('Three columns', ['', 'clause (verb last)', 'adverb (verb 2nd)', 'noun phrase'], [
            ['time', 'nachdem · bevor', 'danach · davor', 'nach · vor + Dat'],
            ['cause', 'weil · da', 'deshalb · folglich', 'wegen · aufgrund'],
            ['purpose', 'damit · um … zu', 'dazu · zu diesem Zweck', 'zu · zwecks'],
            ['condition', 'wenn · falls · sofern', 'sonst · andernfalls', 'bei · im Falle'],
        ]),
        slots('A condition with no wenn', [
            (sl('Regnet!', 'es,', 'bleiben!', 'wir zu Hause.'), 'verb first — not a question'),
            (sl('Sollte!', 'es regnen,', 'bleiben!', 'wir zu Hause.'), 'sollte = should it'),
        ]),
        merge('One idea, three ways', ('clause', 'noun phrase'), [
            ('Nachdem wir gegessen hatten', 'nachdem', 'nach dem Essen', 'nach', 'Wir aßen; danach gingen wir.', 'adverb'),
        ]),
        words('Words for the practice page', [
            ('die Qualität', 'quality'), ('verbessern', 'to improve'), ('die Verbesserung', 'improvement'), ('das Beispiel', 'example'),
            ('benutzen', 'to use'), ('der Schirm', 'umbrella'), ('nass', 'wet'), ('aßen', 'ate'), ('erklären', 'to explain'),
            ('verstehen', 'to understand'),
        ], 4),
    ],
    [
        gaps('Clause, adverb or phrase', 'Write the missing word.', [
            ('Nachdem wir gegessen hatten, gingen wir. = Wir aßen;', 'gingen wir.', 'danach'),
            ('Da es regnete, blieben wir. = Es regnete;', 'blieben wir.', 'folglich'),
            ('Um die Qualität zu verbessern, … =', 'Verbesserung der Qualität …', 'Zur'),
            ('Wenn es regnet, bleiben wir. =', 'Regen bleiben wir.', 'Bei'),
            ('Nimm einen Schirm,', 'wirst du nass.', 'sonst'),
        ]),
        write('No wenn', 'Start with the verb.', [
            ('Wenn es regnet, bleiben wir zu Hause.', 'Regnet es, bleiben wir zu Hause.'),
            ('Falls es regnen sollte, bleiben wir zu Hause.', 'Sollte es regnen, bleiben wir zu Hause.'),
        ], 1),
    ],
    ['say time, cause, purpose and condition three ways',
     'start a condition with the verb',
     'take turns between the columns'],
))

# ---- 17 · Adverbialsätze II -----------------------------------------------------------------------
spreads.append(spread(
    'adverbial_2', 'Es kam anders, als wir dachten', 'Although, so that, by, whereas, as if',
    'Five more links, three columns each — and the trap that catches everyone: älter als, not älter wie.',
    Q + 'adverbialsaetze_2',
    [
        table('Three more columns', ['', 'clause', 'adverb', 'noun phrase'], [
            ['although', 'obwohl · wenngleich', 'dennoch · gleichwohl', 'trotz · ungeachtet'], ['so that', 'sodass', 'folglich · infolgedessen', 'infolge'],
            ['by', 'indem', 'dadurch', 'durch · mithilfe'], ['whereas', 'während · wohingegen', 'hingegen', 'im Gegensatz zu'],
        ]),
        flow('wie or als?', q('Are the two the same?',
                              a('wie', 'so alt wie ich · wie erwartet'), a('als', 'älter als ich · anders, als wir dachten')),
             note='“älter wie” is dialect — marked wrong in writing.'),
        words('Words for the practice page', [
            ('geringeres Heizen', 'heating less'), ('heizen', 'to heat'), ('der Abschied', 'goodbye'), ('sich verabschieden', 'to say goodbye'),
            ('gesperrt', 'closed'), ('der Norden', 'the north'), ('der Süden', 'the south'), ('nass', 'wet'), ('trocken', 'dry'),
            ('erwartet', 'expected'), ('dachten', 'thought'), ('tut, als wüsste er nichts', 'acts as if he knew nothing'),
            ('Energie sparen', 'to save energy'), ('so stark', 'so heavily'),
        ], 4),
    ],
    [
        gaps('Which word?', 'Write the missing word.', [
            ('Obwohl es regnete, gingen wir. =', 'des Regens gingen wir.', 'Trotz'),
            ('Es regnete so stark,', 'die Straße gesperrt wurde.', 'dass'),
            ('Man spart Energie,', 'man weniger heizt.', 'indem'),
            ('', 'der Norden nass ist, ist der Süden trocken.', 'Während'),
            ('Es kam anders,', 'wir erwartet hatten.', 'als'),
            ('Er ist so alt', 'ich.', 'wie'),
        ]),
        write('Say it as a phrase', 'Write it with a little word and a noun.', [
            ('Er ging, ohne sich zu verabschieden.', 'Er ging ohne Abschied.'),
            ('Man spart Energie, indem man weniger heizt.', 'Man spart Energie durch geringeres Heizen.'),
        ], 1),
    ],
    ['say although, so that, by and whereas three ways',
     'tell wie from als',
     'choose the column that keeps the rhythm'],
))

# ---- 18 · weder … noch --------------------------------------------------------------------------
spreads.append(spread(
    'zweiteilig', 'Weder hat die Firma reagiert, noch …', 'Two-part connectors and the verb',
    'zwar, weder, einerseits take the first place — the verb comes next. aber, oder, sondern stand outside and change nothing.',
    Q + 'konnektoren_zweiteilig',
    [
        slots('First place or outside?', [
            (sl('Weder!', 'hat!', 'die Firma reagiert,', 'noch!', 'hat!', 'sie geantwortet.'), None),
            (sl('Füllen Sie es aus,', 'oder', 'Ihr Antrag', 'wird!', 'nicht bearbeitet.'), None),
        ], note='zwar, weder, noch, einerseits take the first place; aber, oder, sondern stand outside.'),
        table('The pairs', ['pair', '~'], [
            ['zum einen … zum anderen', 'two reasons, no contrast'], ['einerseits … andererseits', 'two sides weighed'],
            ['teils … teils · mal … mal', 'partly … partly · sometimes … sometimes'], ['sowohl … als auch', 'both … and — plural verb'],
        ]),
        box('watch', 'aber can’t come first', 'Not *aber lässt sie Fragen offen* — say *sie lässt aber Fragen offen*, or start with *jedoch*.'),
        words('Words for the practice page', [
            ('reagiert', 'reacted'), ('zurückgeschickt', 'sent back'), ('die Verhandlungen', 'negotiations'), ('dauern', 'to last'),
            ('die Chance', 'chance'), ('die Einigung', 'agreement'), ('gering', 'small'), ('das Land', 'state'), ('beteiligen sich', 'take part'),
            ('das Personal', 'staff'), ('veraltet', 'outdated'), ('die Räume', 'rooms'), ('es fehlt an', 'there is a lack of'),
            ('bearbeitet', 'processed'), ('der Antrag', 'application'), ('die Stadt', 'city'), ('geringer', 'smaller'), ('ich irre mich', 'I am wrong'), ('länger', 'longer'),
        ], 4),
    ],
    [
        gaps('The other half', 'Write the missing half.', [
            ('Weder hat die Firma reagiert,', 'hat sie die Unterlagen zurückgeschickt.', 'noch'),
            ('Je länger die Verhandlungen dauern,', 'geringer wird die Chance auf eine Einigung.', 'desto'),
            ('Sowohl die Stadt', 'das Land beteiligen sich an den Kosten.', 'als auch'),
            ('Zum einen fehlt es an Personal,', 'sind die Räume veraltet.', 'zum anderen'),
        ]),
        circle('The verb', 'Circle the right word order.', [
            ('Zwar', ['ist die Wohnung', 'die Wohnung ist'], 'teuer, aber sie ist schön.', 'ist die Wohnung'),
            ('Sie hat recht, oder', ['ich irre mich', 'irre ich mich'], '.', 'ich irre mich'),
        ], 1),
    ],
    ['put the verb after zwar, weder, einerseits',
     'leave the order alone after aber, oder, sondern',
     'choose zum einen or einerseits'],
))

# ---- 19 · Strukturiert darstellen ---------------------------------------------------------------
spreads.append(spread(
    'darstellen', 'Im Folgenden möchte ich …', 'Presenting a topic in structure',
    'Announce the plan, keep to it, close twice. Listeners follow a talk by the plan you give them.',
    Q + 'sprechen_darstellen',
    [
        slots('The plan — then keep to it', [
            ([('Ich werde zunächst …', 'announce'), ('anschließend …', ''), ('und abschließend …', '')], None),
            ([{'de': 'Damit komme ich zum Schluss.', 'tag': 'close', 'hot': True}], None),
        ]),
        table('The four moves inside', ['move', 'phrase'], [
            ['example', 'Dies lässt sich am Beispiel … verdeutlichen.'], ['inference', 'Daraus ergibt sich, dass …'],
            ['comparison', 'Im Vergleich dazu …'], ['addition', 'Hinzu kommt, dass …'],
        ]),
        words('Words for the practice page', [
            ('eingehen auf', 'to go into'), ('festhalten', 'to state'), ('die Aufmerksamkeit', 'attention'), ('die Sitzung', 'session'),
            ('die Sprache', 'language'), ('das Denken', 'thinking'), ('beeinflussen', 'to influence'), ('das Werkzeug', 'tool'),
            ('die Wahrnehmung', 'perception'), ('die Beispiele', 'examples'), ('der Einfluss', 'influence'), ('real', 'real'),
            ('geringer', 'smaller'), ('die Methoden', 'methods'), ('der zweite Teil', 'the second part'), ('nahelegen · legen nahe', 'to suggest'),
            ('drei', 'three'), ('die Aspekte', 'aspects'), ('die skandinavischen Länder', 'the Scandinavian countries'), ('inwiefern', 'to what extent'), ('lediglich', 'merely'),
        ], 4),
    ],
    [
        gaps('The phrases', 'Write the missing word.', [
            ('Im', 'möchte ich auf drei Aspekte eingehen.', 'Folgenden'),
            ('Dies lässt sich am', 'der skandinavischen Länder verdeutlichen.', 'Beispiel'),
            ('Daraus', 'sich, dass viele ihr Studium später abschließen.', 'ergibt'),
            ('', 'kommt, dass die Mieten gestiegen sind.', 'Hinzu'),
            ('Zusammenfassend lässt sich', ', dass es keine einfache Lösung gibt.', 'festhalten'),
        ]),
        circle('A lecture', 'Listen to the lecture. Circle what you hear.', [
            ('Die Frage ist, inwiefern unsere Sprache unser', ['Denken', 'Handeln'], 'beeinflusst.', 'Denken'),
            ('Lange nahm man an, Sprache sei lediglich ein', ['Werkzeug', 'Spiegel'], '.', 'Werkzeug'),
            ('Der Redner nennt', ['drei', 'zwei'], 'Beispiele.', 'drei'),
            ('Er hält den Einfluss für real, aber für', ['geringer', 'größer'], ', als oft behauptet wird.', 'geringer'),
        ], 1) | {'listen': True},
    ],
    ['announce the structure of a talk',
     'give an example, an inference, a comparison',
     'close with a summary'],
    listen=Q + 'hoeren_vorlesung',
))

# ---- 20 · Zusammenfassung -------------------------------------------------------------------------
spreads.append(spread(
    'zusammenfassung', 'Der Autor vertritt die Auffassung, …', 'Writing a summary',
    'Four moves and nothing else: topic, central claim, evidence, conclusion. Every claim belongs to the source — none to you.',
    Q + 'schreiben_zusammenfassung',
    [
        slots('Four moves', [
            ([('Der Beitrag befasst sich mit …', 'topic'), ('Der Autor vertritt die Auffassung, …', 'claim')], None),
            ([('Als Beleg führt er an, dass …', 'evidence'), {'de': 'Er kommt zu dem Schluss, dass …', 'tag': 'conclusion', 'hot': True}], None),
        ]),
        flow('Who says so?', q('Is the claim the author’s?',
                               a('Konjunktiv I or a source phrase', 'Der Effekt sei überschätzt worden, so die Verfasserin.'),
                               a('your own view — leave it out', 'It belongs in a different text.'))),
        box('tip', 'Nominalise to tighten, not to impress',
            '*Nach Einführung der Regelung ging die Zahl der Unfälle zurück* — good. Three genitives in a row — turn one back into a verb.'),
        words('Words for the practice page', [
            ('der Beitrag', 'article'), ('der Begriff', 'term'), ('sich befassen mit', 'to deal with'), ('die Auffassung vertreten', 'to hold the view'),
            ('anführen', 'to cite'), ('der Schluss', 'conclusion'), ('die Verfasserin', 'author'), ('überschätzt', 'overestimated'),
            ('die Aufmerksamkeitsökonomie', 'attention economy'), ('der Ökonom', 'economist'), ('zurückgehen auf', 'to go back to'),
            ('die Unterbrechung', 'interruption'), ('zurückkehren', 'to return'), ('die Aufgabe', 'task'), ('über zwanzig Minuten', 'over twenty minutes'),
            ('das Telefon', 'phone'), ('der Nebenraum', 'next room'), ('entfernen', 'to remove'), ('die Sekunden', 'seconds'),
            ('der Fachkräftemangel', 'shortage of skilled workers'), ('das Handwerk', 'trades'), ('des Ökonomen', 'of the economist'), ('im Schnitt', 'on average'),
        ], 4),
    ],
    [
        gaps('Attention, please', 'Listen to the talk and fill in the notes.', [
            ('Der Begriff geht auf den Ökonomen Herbert', 'zurück.', 'Simon'),
            ('Im Jahr 2020: im Schnitt nur', 'Sekunden an einer Aufgabe.', '47'),
            ('Zur Aufgabe zurückkehren: über', 'Minuten.', 'zwanzig'),
            ('Sein Rat: das Telefon aus dem Raum', '.', 'entfernen'),
        ]) | {'listen': True},
        gaps('Your summary', 'Summarise the talk in four sentences — every claim is the speaker’s.', [
            ('Der Vortrag befasst sich mit', '.'), ('Der Redner vertritt die Auffassung,', '.'),
            ('Als Beleg führt er an, dass', '.'), ('Er kommt zu dem Schluss, dass', '.'),
        ], 'About you.'),
    ],
    ['summarise in four moves',
     'keep every claim with its source',
     'nominalise only where it tightens'],
    listen=Q + 'hoeren_vortrag_detail',
))

# ---- Review 3 · topics 14–20 ---------------------------------------------------------------
spreads.append(review(
    'review_3', 'Topics 14–20', 'The last part, all at once. No looking back until you have done both pages.',
    Q + 'sprechen_dialog',
    [
        gaps('Linking', 'Write the missing word.', [
            ('Wir sollten das Angebot annehmen,', 'es günstig ist.', 'zumal'),
            ('Die Daten sind lückenhaft;', 'zeigt sich ein Trend.', 'gleichwohl'),
            ('', 'es regnen, bleiben wir zu Hause.', 'Sollte'),
            ('Es kam anders,', 'wir erwartet hatten.', 'als'),
        ]),
    ],
    [
        gaps('Pairs and phrases', 'Write the missing word.', [
            ('Weder hat die Firma reagiert,', 'hat sie geantwortet.', 'noch'),
            ('Daraus', 'sich, dass es keine einfache Lösung gibt.', 'ergibt'),
            ('Der Autor vertritt die', ', der Effekt sei überschätzt worden.', 'Auffassung'),
        ]),
    ],
))

book = {
    'title': 'Verdichten & Verbinden',
    'cover': 'cp_c1_1_cover',
    'welcome': [
        'This book is the paper half of C1.1. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It has three parts. The first is the language of research: packing sentences into nouns and unpacking them again. The second is the passive substitutes and participles of formal German. The third is about connecting an argument — and presenting and summarising one.',
        'It carries on from the earlier books. Words you learned there are not taught again. Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Paul', 'Mia', 'Tom', 'Anna', 'Weber', 'Braun', 'Lang', 'Roth', 'Herbert', 'Simon', 'Berlin', 'Dr',
              'Dopamin', 'Prozent', 'Prozentpunkte', 'Montag', 'März', 'Mai', 'Januar', 'Freitag', 'Herrn'],
    'spreads': spreads,
    'overview': {'title': 'C1.1 at a glance', 'blocks': [
        table('Fold and unfold', ['clause', 'noun phrase'], [
            ['weil · da', 'wegen · aufgrund'], ['obwohl', 'trotz · ungeachtet'], ['nachdem · bevor', 'nach · vor'], ['als · wenn', 'bei'],
            ['indem', 'durch · mithilfe'], ['um … zu · damit', 'zu · zwecks'], ['falls', 'im Falle'], ['sodass', 'infolge (the cause)'],
        ]),
        table('Passive substitutes', ['focus', 'form'], [
            ['must', 'ist auszufüllen'], ['can', 'lässt sich lösen · lösbar'], ['the person', 'bekam … geschenkt'],
            ['how it behaves', 'verkauft sich'], ['must, before the noun', 'der zu prüfende Antrag'],
        ]),
        table('The register ladder', ['', 'spoken', 'written', 'academic'], [
            ['although', 'trotzdem', 'dennoch', 'gleichwohl'], ['so', 'deshalb', 'folglich', 'mithin'],
            ['condition', 'wenn', 'falls', 'sofern'], ['and also', 'außerdem', 'zudem', 'überdies'],
        ]),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.', [
            ('der Infusionsständer', 'drip stand', 'cpd_infusionsstaender'), ('die Sauerstoffflasche', 'oxygen bottle', 'cpd_sauerstoffflasche'),
            ('die Wärmflasche', 'hot-water bottle', 'cpd_waermflasche'), ('der Rollstuhl', 'wheelchair', 'cpd_rollstuhl'),
            ('die Krücke', 'crutch', 'cpd_kruecke'), ('das Stethoskop', 'stethoscope', 'cpd_stethoskop'),
            ('das Klemmbrett', 'clipboard', 'cpd_klemmbrett'), ('das Kopfkissen', 'pillow', 'cpd_kopfkissen'),
            ('die Schnabeltasse', 'sippy cup', 'cpd_schnabeltasse'), ('der Treteimer', 'pedal bin', 'cpd_treteimer'),
            ('der Scheinwerfer', 'spotlight', 'cpd_scheinwerfer'), ('die Perücke', 'wig', 'cpd_peruecke'),
            ('die Maske', 'mask', 'cpd_maske'), ('der Vorhang', 'curtain', 'cpd_vorhang'),
            ('die Trommel', 'drum', 'cpd_trommel'), ('das Notenpult', 'music stand', 'cpd_notenpult'),
            ('der Kleiderständer', 'clothes rail', 'cpd_kleiderstaender'), ('das Steckenpferd', 'hobby horse', 'cpd_steckenpferd'),
            ('die Nebelmaschine', 'smoke machine', 'cpd_nebelmaschine'), ('der Schminktisch', 'make-up table', 'cpd_schminktisch'),
            ('das Mikroskop', 'microscope', 'cpd_mikroskop'), ('das Reagenzglas', 'test tube', 'cpd_reagenzglas'),
            ('der Globus', 'globe', 'cpd_globus'), ('die Lupe', 'magnifying glass', 'cpd_lupe'),
            ('die Tafel', 'blackboard', 'cpd_tafel'), ('das Lehrbuch', 'textbook', 'cpd_lehrbuch'),
            ('die Urkunde', 'certificate', 'cpd_urkunde'), ('der Doktorhut', 'mortarboard', 'cpd_doktorhut'),
            ('das Tablet', 'tablet', 'cpd_tablet'), ('die Sanduhr', 'hourglass', 'cpd_sanduhr'),
            ('der Kopfhörer', 'headphones', 'cpd_kopfhoerer'), ('das Handy', 'mobile phone', 'cpd_handy'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

kit.write_book(OUT, book)
