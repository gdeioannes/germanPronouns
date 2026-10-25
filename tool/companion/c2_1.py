# Builds assets/content/companion/de_cert_a1/c2_1.json — the C2.1 study companion.
# Run: python -I tool/companion/c2_1.py   (rules: docs/study_companion_guide.md)
# Extra exercises that fill the practice pages: extras_c2_1.py (fitted by fit_extras.py).
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, merge, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_c2_1_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'c2_1.json')
Q = 'quest_c2_1_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ==== Part 1 · Choosing the word ==========================================================

# ---- 1 · Wirtschaft & Recht --------------------------------------------------------------
spreads.append(spread(
    'wirtschaft', 'Wirtschaft & Recht', 'Turnover, profit, appeal, settlement',
    'The business and court pages use words that look alike and are not: Umsatz is not Gewinn, and a Vergleich in court is not a comparison.',
    Q + 'wirtschaft',
    [
        slots('Three nested circles', [
            ([('der Umsatz: 10 Mio.', 'all that comes in'), ('der Gewinn: 1 Mio.', 'what is left'),
              {'de': 'die Rendite: 5 %', 'tag': 'profit as % of capital', 'hot': True}], None),
        ]),
        table('In court', ['noun', 'its verb', '~'], [
            ['der Einspruch', 'einlegen', 'objection to an official decision'], ['die Berufung', 'einlegen · in Berufung gehen', 'appeal'],
            ['die Klage', 'einreichen', 'lawsuit'], ['der Vergleich', 'schließen', 'settlement — not a comparison'],
            ['das Urteil', 'fällen · wird rechtskräftig', 'judgment · becomes final'],
        ]),
        table('In the economy', ['noun', 'its verb'], [
            ['die Insolvenz', 'anmelden'], ['der Leitzins', 'anheben · senken'], ['die Nachfrage', 'ankurbeln · dämpfen'],
            ['das Gesetz', 'verabschieden'], ['die Verordnung', 'erlassen'],
        ]),
        words('Words for the practice page', [
            ('die Zentralbank', 'central bank'), ('der Zinssatz', 'interest rate'), ('die Firmen', 'firms'), ('der Bescheid', 'official decision'),
            ('das Gericht', 'court'), ('schließlich', 'in the end'), ('trotz steigenden Umsatzes', 'despite rising turnover'),
            ('sank', 'fell'), ('mehrere', 'several'), ('das Parlament', 'parliament'), ('die Regierung', 'government'),
            ('meldeten an', 'registered'),
            ('legte ein', 'lodged'),
            ('hob an', 'raised'),
        ], 4),
    ],
    [
        gaps('The fixed verb', 'Write the verb the noun takes.', [
            ('Mehrere Firmen meldeten Insolvenz', '.', 'an'),
            ('Gegen den Bescheid legte sie Einspruch', '.', 'ein'),
            ('Vor Gericht schloss man schließlich einen', '.', 'Vergleich'),
            ('Die Zentralbank hob den Leitzins', ', um die Nachfrage zu dämpfen.', 'an'),
            ('Das Parlament hat das Gesetz', '.', 'verabschiedet'),
        ]),
        circle('Umsatz, Gewinn or Rendite?', 'Circle the right word.', [
            ('Trotz steigenden', ['Umsatzes', 'Gewinns'], 'sank der Gewinn.', 'Umsatzes'),
            ('Die', ['Rendite', 'Umsatz'], 'lag bei fünf Prozent.', 'Rendite'),
        ], 1),
    ],
    ['tell Umsatz, Gewinn and Rendite apart',
     'use each legal noun with its verb',
     'read a business report'],
))

# ---- 2 · Register ---------------------------------------------------------------------------
spreads.append(spread(
    'register', 'kriegen – bekommen – erhalten', 'Three levels of the same word',
    'Neither level is better; the wrong one in the wrong place is the error — and mixing two in one sentence is the one a listener hears first.',
    Q + 'register',
    [
        table('Three levels', ['spoken', 'neutral', 'formal'], [
            ['kriegen', 'bekommen', 'erhalten'], ['gucken', 'sehen', 'betrachten'], ['klauen', 'stehlen', 'entwenden'],
            ['checken', 'prüfen', 'überprüfen'], ['Kohle', 'Geld', 'Mittel'], ['sauer', 'verärgert', 'ungehalten'],
            ['hinkriegen', 'schaffen', 'bewerkstelligen'],
        ]),
        flow('Which level does a word belong to?', q('Is it long, Latin or with be-, ver-, er-, ent-?',
                                                       a('formal', 'erhalten · überprüfen · benötigen'), a('neutral or spoken', 'kriegen · checken · brauchen'))),
        words('Words for the practice page', [
            ('der Typ', 'guy'), ('der Mitarbeiter', 'employee'), ('die Stelle', 'post'), ('gestrichen', 'cut'), ('das Schreiben', 'letter'),
            ('der Job', 'job'), ('weg', 'gone'), ('die Brücke', 'bridge'), ('die Fußgängerbrücke', 'footbridge'), ('gesperrt', 'closed'),
            ('die Mängel', 'defects'), ('die Abnahme', 'acceptance check'), ('festgestellt', 'found'), ('ein Witz', 'a joke'),
            ('die Kosten', 'costs'), ('explodiert', 'exploded'), ('der Zeitplan', 'schedule'), ('ehrgeizig', 'ambitious'),
            ('gekriegt', 'got'),
            ('geklaut', 'nicked'),
            ('die Stadtverwaltung', 'city administration'),
            ('die Rentnerin', 'pensioner'),
            ('der Baubeginn', 'start of building'),
            ('geradezu', 'downright'),
        ], 4),
    ],
    [
        gaps('Move it up', 'Write the formal word.', [
            ('Er hat den Brief gekriegt. → Er hat das Schreiben', '.', 'erhalten'),
            ('Der Typ ist sauer. → Der Mitarbeiter ist', '.', 'verärgert'),
            ('Jemand hat das Rad geklaut. → Das Rad wurde', '.', 'entwendet'),
            ('Wir müssen das checken. → Wir müssen das', '.', 'überprüfen'),
        ]),
        gaps('Heard it?', 'Listen to the dictation and write the missing words.', [
            ('Die Stadtverwaltung erklärte, man', 'die Mängel erst bei der Abnahme festgestellt.', 'habe'),
            ('„Die Brücke ist doch ein', '“, sagt eine Rentnerin.', 'Witz'),
            ('Die Kosten sind seit Baubeginn geradezu', '.', 'explodiert'),
        ]) | {'listen': True},
    ],
    ['move a word between spoken, neutral and formal',
     'keep one level in one sentence',
     'hear a quotation by its drop in register'],
    listen=Q + 'diktat_register',
))

# ---- 3 · Kollokationen ---------------------------------------------------------------------
spreads.append(spread(
    'kollokationen', 'eine herbe Niederlage erleiden', 'The word that goes with the word',
    'Getting the verb wrong is understood but heard; getting it right is what fluency sounds like.',
    Q + 'kollokationen',
    [
        table('The noun picks its verb', ['verb', 'nouns'], [
            ['ergreifen', 'Maßnahmen · die Initiative · die Gelegenheit'], ['leisten', 'Widerstand · einen Beitrag · Hilfe'],
            ['erleiden', 'eine Niederlage · einen Verlust'], ['hegen', 'Zweifel · Hoffnung'], ['eingehen', 'ein Risiko · einen Kompromiss'],
        ]),
        table('… and its describing word', ['noun', 'describing word'], [
            ['der Grund', 'triftig'], ['das Argument', 'stichhaltig · schlagend'], ['der Verlust', 'herb · schwer'],
        ]),
        build('Learn three words as one', [
            (['eine herbe', 'Niederlage', 'erleiden'], 'eine herbe Niederlage erleiden', 'suffer a bitter defeat'),
            (['scharfe', 'Kritik', 'üben'], 'scharfe Kritik üben', 'criticise sharply'),
        ]),
        words('Words for the practice page', [
            ('die Opposition', 'opposition'), ('die Bürger', 'citizens'), ('die Krise', 'crisis'), ('sich zuspitzen', 'to come to a head'),
            ('die Zeit drängt', 'time is short'), ('der Vorwurf wiegt schwer', 'the charge is serious'), ('die Mannschaft', 'team'),
            ('der Verein', 'club'), ('die Regierung', 'government'), ('dennoch', 'nevertheless'),
            ('ein triftiger Grund', 'a good reason'),
            ('ein stichhaltiges Argument', 'a sound argument'),
            ('ein herber Verlust', 'a bitter loss'),
            ('eine hitzige Debatte', 'a heated debate'),
        ], 4),
    ],
    [
        gaps('The fixed verb', 'Write the verb the noun takes.', [
            ('Die Regierung', 'Maßnahmen.', 'ergriff'), ('Die Opposition', 'scharfe Kritik.', 'übte'),
            ('Die Bürger', 'Zweifel.', 'hegten'), ('Die Mannschaft', 'eine herbe Niederlage.', 'erlitt'),
            ('Wir müssen ein Risiko', '.', 'eingehen'),
        ]),
        circle('The describing word', 'Circle the word that goes with the noun.', [
            ('ein', ['triftiger', 'großer'], 'Grund', 'triftiger'), ('ein', ['stichhaltiges', 'schweres'], 'Argument', 'stichhaltiges'),
            ('ein', ['herber', 'triftiger'], 'Verlust', 'herber'), ('eine', ['hitzige', 'strikte'], 'Debatte', 'hitzige'),
        ], 2),
    ],
    ['use the verb each noun takes',
     'use the describing word each noun takes',
     'learn noun, verb and describing word together'],
))

# ---- 4 · Konnotation -----------------------------------------------------------------------
spreads.append(spread(
    'konnotation', 'sparsam oder geizig?', 'Same thing, three temperatures',
    'His friends call him sparsam, his enemies geizig. The word you choose shows which side you are on.',
    Q + 'konnotation',
    [
        table('Warm – neutral – cold', ['+', '0', '−'], [
            ['sparsam', '—', 'geizig'], ['rüstig', 'alt', 'vergreist'], ['wissbegierig', 'neugierig', 'aufdringlich'],
            ['standhaft', '—', 'stur'], ['gründlich', '—', 'pedantisch'], ['der Duft', 'der Geruch', 'der Gestank'],
        ]),
        flow('Which word do you choose?', q('Do you like the person?', a('the warm word', 'sparsam · standhaft · gründlich'), a('the cold word', 'geizig · stur · pedantisch'))),
        table('Public language', ['what is meant', 'what is said'], [
            ['Kürzung', 'Reform'], ['Problem', 'Herausforderung'], ['entlassen', 'freisetzen'],
        ], 'A text that uses these has taken a side without an opinion sentence.'),
        words('Words for the practice page', [
            ('die Freunde', 'friends'), ('die Feinde', 'enemies'), ('nennen', 'to call'), ('vernünftig', 'sensible'),
            ('mit 88', 'at 88'), ('erstaunlich', 'astonishingly'), ('der Vorstand', 'board'), ('gilt als', 'is considered'),
            ('die Gewerkschaften', 'unions'), ('sprechen von', 'to speak of'), ('die Küche', 'kitchen'), ('aus der Küche', 'from the kitchen'),
            ('ein herrlicher Duft', 'a lovely smell'),
        ], 4),
    ],
    [
        gaps('Warm or cold?', 'Write the word with the temperature in brackets.', [
            ('Seine Freunde nennen ihn sparsam, seine Feinde', '. (−)', 'geizig'),
            ('Mit 88 ist sie erstaunlich', '. (+)', 'rüstig'),
            ('Aus der Küche kam ein herrlicher', '. (+)', 'Duft'),
            ('Die Regierung spricht von einer Reform, die Gewerkschaften von', '. (−)', 'Kürzungen'),
        ]),
        sort_ex('+, 0 or −?', 'Write each word in its column.', ['+', '0', '−'], [
            ('standhaft', 0), ('stur', 2), ('neugierig', 1), ('gründlich', 0), ('pedantisch', 2), ('der Geruch', 1),
        ]),
    ],
    ['hear the temperature of a word',
     'choose the warm, neutral or cold word on purpose',
     'spot framing in public language'],
))

# ---- 5 · Abtönung --------------------------------------------------------------------------
spreads.append(spread(
    'abtoenung', 'durchaus, keineswegs, geradezu', 'Setting the temperature of a judgement',
    'Der Plan ist durchaus vernünftig, aber keineswegs ausgereift — and nicht gerade billig. One shading word per claim.',
    Q + 'abtoenung',
    [
        tiles('Strong no → strong yes', [
            ('keineswegs', 'by no means'), ('nicht gerade', 'not exactly'), ('einigermaßen', 'reasonably'),
            ('durchaus', 'certainly'), ('ausgesprochen', 'decidedly'), ('geradezu!', 'downright'),
        ], 6),
        flow('durchaus: yes or no?', q('Is nicht right after it?', a('no: not at all', 'Das ist durchaus nicht sicher.'), a('yes: certainly', 'Das ist durchaus berechtigt.'))),
        table('Watch these', ['word', '~'], [
            ['durchaus', 'certainly (against a doubt) — not “throughout”'], ['durchaus nicht', 'not at all'],
            ['geradezu', 'downright — not *gerade*'], ['immerhin · zumindest', 'at least'], ['schlechthin', 'par excellence — after the noun'],
        ]),
        words('Words for the practice page', [
            ('der Plan', 'plan'), ('vernünftig', 'sensible'), ('ausgereift', 'fully developed'), ('billig', 'cheap'),
            ('die Aufführung', 'performance'), ('gelungen', 'successful'), ('das Finale', 'finale'), ('triumphal', 'triumphant'),
            ('das Ergebnis', 'result'), ('bescheiden', 'modest'), ('der Anfang', 'start'), ('absurd', 'absurd'), ('sicher', 'certain'),
        ], 4),
    ],
    [
        gaps('Shade it', 'Write the shading word: the English in brackets helps.', [
            ('Der Plan ist', 'vernünftig. (certainly)', 'durchaus'),
            ('Er ist aber', 'ausgereift. (by no means)', 'keineswegs'),
            ('Die Aufführung war', 'gelungen. (decidedly)', 'ausgesprochen'),
            ('Das Finale war', 'triumphal. (downright)', 'geradezu'),
            ('Das Ergebnis ist bescheiden;', 'ist es ein Anfang. (immerhin or keineswegs?)', 'immerhin'),
        ]),
    ],
    ['grade a claim with durchaus, keineswegs, geradezu',
     'tell durchaus from durchaus nicht',
     'use one shading word per claim'],
))

# ---- 6 · Sprichwörter ----------------------------------------------------------------------
spreads.append(spread(
    'sprichwoerter', 'Wer anderen eine Grube gräbt …', 'Proverbs in pieces',
    'Journalists cut proverbs off, twist them in headlines and shrink them to one word. You have to hear the whole one in the fragment.',
    Q + 'sprichwoerter',
    [
        table('The whole proverb', ['proverb', '~'], [
            ['Wer anderen eine Grube gräbt, fällt selbst hinein.', 'the schemer falls into his own trap'],
            ['Wer im Glashaus sitzt, sollte nicht mit Steinen werfen.', 'don’t criticise what you do yourself'],
            ['Lügen haben kurze Beine.', 'lies are found out'], ['Eine Schwalbe macht noch keinen Sommer.', 'one good sign is not a trend'],
            ['Hochmut kommt vor dem Fall.', 'pride before a fall'], ['Viele Köche verderben den Brei.', 'too many cooks'],
        ]),
        flow('How is it used?', q('Is the whole proverb there?',
                                  a('rare — sounds folksy', 'Viele Köche verderben den Brei.'),
                                  a('cut, twisted or one word', 'Viele Köche, kein Brei · im Glashaus sitzen'))),
        words('Words for the practice page', [
            ('die Intrige', 'scheme'), ('stolpern', 'to stumble'), ('eben', 'you see'), ('die Partei', 'party'),
            ('das Thema', 'topic'), ('das Quartal', 'quarter'), ('erfreulich', 'pleasing'), ('stark', 'strong'),
            ('das Kabinett', 'cabinet'), ('der Haushalt', 'budget'), ('zustande bringen', 'to manage to produce'),
            ('er stolperte', 'he tripped'),
            ('ein starkes Quartal', 'a strong quarter'),
        ], 4),
    ],
    [
        gaps('Finish the proverb', 'Write the missing word.', [
            ('Er stolperte über seine eigene Intrige – wer anderen eine', 'gräbt, eben.', 'Grube'),
            ('Beim Thema sitzt die Partei selbst im', '.', 'Glashaus'),
            ('Ein starkes Quartal ist erfreulich, aber eine', 'macht noch keinen Sommer.', 'Schwalbe'),
            ('Lügen haben kurze', '.', 'Beine'),
            ('Viele Köche, kein', ': Das Kabinett bringt keinen Haushalt zustande.', 'Brei'),
        ]),
    ],
    ['recognise a proverb from a fragment',
     'understand a twisted headline',
     'use one proverb, not three'],
))

# ---- 7 · Komparation advanced ----------------------------------------------------------
spreads.append(spread(
    'komparation', 'eine der größten Städte Europas', 'Comparing to the exact degree',
    'einer der besten — der bei weitem beste — der mit Abstand beste: choose how sure you are.',
    Q + 'komparation_advanced',
    [
        slots('one of the …: genitive plural', [
            (sl('Berlin ist', 'eine der', 'größten!', 'Städte Europas.'), 'not: größte'),
        ]),
        table('Degree words', ['', 'like this'], [
            ['by far', 'bei weitem · mit Abstand der beste'], ['far more', 'weitaus · wesentlich · erheblich teurer'],
            ['nowhere near', 'bei weitem nicht so gut wie'], ['twice as', 'doppelt so teuer wie'], ['highly', 'höchst · äußerst interessant'],
            ['ever', 'immer größer'],
        ]),
        words('Words for the practice page', [
            ('Europa · Europas', 'Europe'), ('teuer', 'expensive'), ('die Lage', 'situation'), ('ernst', 'serious'),
            ('angenommen', 'assumed'), ('schwierig', 'difficult'), ('beunruhigend', 'worrying'), ('der Befund', 'finding'),
            ('wenig · die wenigen', 'few'), ('das Beispiel', 'example'), ('der Vorschlag', 'proposal'), ('zweitgrößte', 'second-largest'),
            ('ernster', 'more serious'),
            ('ein beunruhigender Befund', 'a worrying finding'),
            ('der mit Abstand beste', 'by far the best'),
        ], 4),
    ],
    [
        gaps('The degree', 'Write the missing word.', [
            ('Berlin ist eine der', 'Städte Europas. (groß)', 'größten'),
            ('Die Lage ist', 'ernster als angenommen. (weitaus or immer?)', 'weitaus'),
            ('Das war der mit', 'beste Vorschlag.', 'Abstand'),
            ('Hamburg ist die', 'Stadt Deutschlands. (zwei + groß)', 'zweitgrößte'),
            ('Ein', 'beunruhigender Befund. (höchst or bei weitem?)', 'höchst'),
        ]),
    ],
    ['say one of the best with the genitive plural',
     'grade: by far, far more, nowhere near',
     'say twice as and highly'],
))

# ---- Review 1 · topics 1–7 -----------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–7', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        gaps('The right word', 'Write the missing word.', [
            ('Mehrere Firmen meldeten Insolvenz', '.', 'an'), ('Er hat das Schreiben', '. (formal: kriegen)', 'erhalten'),
            ('Die Regierung', 'Maßnahmen.', 'ergriff'), ('Seine Feinde nennen ihn', '. (− sparsam)', 'geizig'),
        ]),
    ],
    [
        gaps('Degree and allusion', 'Write the missing word.', [
            ('Der Plan ist', 'ausgereift. (by no means)', 'keineswegs'),
            ('Eine Schwalbe macht noch keinen', '.', 'Sommer'),
            ('Berlin ist eine der', 'Städte Europas.', 'größten'),
        ]),
    ],
))

# ==== Part 2 · Grammar at full stretch ====================================================

# ---- 8 · Valenz -----------------------------------------------------------------------------
spreads.append(spread(
    'valenz', 'der Opfer gedenken', 'What a verb demands',
    'Man beschuldigte ihn des Betrugs: no “von” — the bare genitive. Formal prose is full of these frames.',
    Q + 'valenz',
    [
        table('Unusual frames', ['frame', 'verbs', 'like this'], [
            ['+ genitive', 'gedenken · bedürfen · sich erfreuen · sich enthalten', 'Das bedarf einer Erklärung.'],
            ['person (Akk) + thing (Gen)', 'beschuldigen · verdächtigen · berauben', 'Man beschuldigte ihn des Diebstahls.'],
            ['dative only', 'widersprechen · begegnen · ausweichen · schaden', 'Er widersprach dem Vorschlag.'],
            ['two accusatives', 'lehren · kosten · nennen', 'Das kostete ihn den Posten.'],
        ]),
        arrow('Accuse whom of what?', [
            ('Man', 'beschuldigte', 'ihn des Betrugs', 'person: accusative · thing: genitive'),
        ], ('wen?', 'wessen?')),
        table('Same verb, other frame, other meaning', ['', '~'], [
            ['bestehen auf + Dat', 'insist on'], ['bestehen aus', 'consist of'], ['bestehen in', 'consist in'],
        ]),
        words('Words for the practice page', [
            ('die Opfer', 'victims'), ('die Erklärung', 'explanation'), ('die Beliebtheit', 'popularity'), ('der Betrug', 'fraud'),
            ('das Amt', 'office'), ('entheben', 'to remove from'), ('der Diebstahl', 'theft'), ('der Posten', 'post'),
            ('das Zweifeln', 'doubting'), ('die Regel', 'rule'), ('drei Punkte', 'three points'), ('die Fairness', 'fairness'),
            ('die Stimme', 'vote'), ('die Frage', 'question'), ('die Partei', 'party'), ('die Stadt', 'city'),
            ('gedachte', 'commemorated'),
            ('aus drei Punkten', 'of three points'),
            ('der Sinn', 'point'),
        ], 4),
    ],
    [
        gaps('The case the verb demands', 'Write the words in brackets in the right case.', [
            ('Die Stadt gedachte', '. (die Opfer)', 'der Opfer'),
            ('Das Projekt bedarf', '. (eine Erklärung)', 'einer Erklärung'),
            ('Man beschuldigte ihn', '. (der Betrug)', 'des Betrugs'),
            ('Er widersprach', '. (der Vorschlag)', 'dem Vorschlag'),
            ('Die Partei erfreut sich', '. (große Beliebtheit)', 'großer Beliebtheit'),
        ]),
        gaps('bestehen', 'Write auf, aus or in.', [
            ('Er besteht', 'der Regel.', 'auf'), ('Die Regel besteht', 'drei Punkten.', 'aus'), ('Ihr Sinn besteht', 'der Fairness.', 'in'),
        ]),
    ],
    ['use verbs with the genitive: gedenken, bedürfen',
     'accuse someone of something: des Betrugs',
     'read a verb’s frame for its meaning'],
))

# ---- 9 · Komposita -------------------------------------------------------------------------
spreads.append(spread(
    'komposita', 'die Geschwindigkeits­begrenzung', 'Compounds: read from the right',
    'The last part is the head — it gives the gender and the meaning. The joint in between (-s-, -n-, -er-) is history, not grammar.',
    Q + 'komposita',
    [
        build('The joint', [
            (['Prüfung', ('s', 'joint'), 'ordnung'], 'die Prüfungsordnung', '-s- after -ung, -ion …'),
            (['Sonne', ('n', 'joint'), 'brille'], 'die Sonnenbrille', '-n- after -e'),
            (['Kind', ('er', 'joint'), 'garten'], 'der Kindergarten', '-er- plural'),
            (['Buch', 'handlung'], 'die Buchhandlung', 'nothing'),
        ]),
        slots('Decode from the right', [
            ([('Bundes', 'of the federation'), ('verfassungs', 'for the constitution'), {'de': 'gericht', 'tag': 'a court: the head', 'hot': True}], None),
        ]),
        box('watch', 'Not a genitive', 'The -s- in *Liebesbrief* is a joint: Liebe is feminine and has no genitive -s.'),
        words('Words for the practice page', [
            ('die Geschwindigkeit', 'speed'), ('die Begrenzung', 'limit'), ('die Bundesstraße', 'main road'), ('ganzjährig', 'all year'),
            ('das Bilderbuch', 'picture book'), ('das Bücherregal', 'bookshelf'), ('die Haustür', 'front door'), ('die Straßenbahn', 'tram'),
            ('der Bahnhof', 'station'), ('der Markt', 'market'), ('die Arbeit', 'work'), ('die Universität', 'university'),
        ], 4),
    ],
    [
        gaps('Build the compound', 'Write it as one word, with the right joint.', [
            ('die Begrenzung der Geschwindigkeit → die', '', 'Geschwindigkeitsbegrenzung'),
            ('der Markt für Arbeit → der', '', 'Arbeitsmarkt'),
            ('die Stadt mit der Universität → die', '', 'Universitätsstadt'),
            ('die Buchhandlung am Bahnhof → die', '', 'Bahnhofsbuchhandlung'),
            ('der Garten für Kinder → der', '', 'Kindergarten'),
        ]),
    ],
    ['find the head of a compound and its gender',
     'choose the joint: -s-, -n-, -er- or nothing',
     'decode a long compound from the right'],
))

# ---- 10 · -haft, -würdig, -gerecht ---------------------------------------------------------
spreads.append(spread(
    'adjektive', 'glaubwürdig, termingerecht', 'Suffixes with a precise meaning',
    'Each suffix means one thing, so a new word like klimagerecht is readable on sight.',
    Q + 'adjektivbildung',
    [
        build('One suffix, one meaning', [
            (['Meister', ('haft', 'suffix')], 'meisterhaft', '-haft: having the nature of'),
            (['Regel', ('mäßig', 'suffix')], 'regelmäßig', '-mäßig: in line with'),
            (['einzig', ('artig', 'suffix')], 'einzigartig', '-artig: of the kind'),
            (['lern', ('fähig', 'suffix')], 'lernfähig', '-fähig: able to'),
            (['glaub', ('würdig', 'suffix')], 'glaubwürdig', '-würdig: deserving'),
            (['Termin', ('gerecht', 'suffix')], 'termingerecht', '-gerecht: suited to'),
        ]),
        box('watch', 'Drifted', '*merkwürdig* means strange, *fragwürdig* questionable. And *sorgenfrei* (carefree) is not *sorglos* (careless).'),
        words('Words for the practice page', [
            ('die Aufführung', 'performance'), ('der Schluss', 'ending'), ('rätselhaft', 'puzzling'), ('die Wohnung', 'flat'),
            ('renoviert', 'renovated'), ('verhältnismäßig', 'relatively'), ('günstig', 'cheap'), ('der Anbieter', 'provider'),
            ('zahlungsfähig', 'solvent'), ('fachgerecht', 'properly'), ('konkurrenzfähig', 'competitive'), ('der Preis', 'price'),
            ('einzigartig · eine einzigartige', 'unique'),
            ('ein konkurrenzfähiger', 'a competitive'),
            ('merkwürdig · ein merkwürdiger', 'strange'),
            ('der Zufall', 'coincidence'),
            ('seltsam', 'odd'),
            ('sorglos', 'careless'),
            ('sorgenfrei', 'carefree'),
        ], 4),
    ],
    [
        gaps('Which suffix?', 'Write the describing word of the word in brackets.', [
            ('Eine', ', geradezu einzigartige Aufführung. (Meister)', 'meisterhafte'),
            ('Die Wohnung wurde fachgerecht und', 'renoviert. (Termin)', 'termingerecht'),
            ('Ein', ', konkurrenzfähiger Anbieter. (glauben)', 'glaubwürdiger'),
            ('Wir treffen uns', '. (Regel)', 'regelmäßig'),
        ]),
        circle('Not what it looks like', 'Circle the right word.', [
            ('Das ist ein', ['merkwürdiger', 'glaubwürdiger'], 'Zufall – sehr seltsam.', 'merkwürdiger'),
            ('Er geht', ['sorglos', 'sorgenfrei'], 'mit Geld um – leider.', 'sorglos'),
        ], 1),
    ],
    ['build describing words with -haft, -fähig, -würdig, -gerecht',
     'read a new word from its suffix',
     'remember merkwürdig and fragwürdig'],
))

# ---- 11 · Präfixe ----------------------------------------------------------------------------
spreads.append(spread(
    'praefixe', 'sich verrechnen, ersteigern, entkalken', 'What a prefix does to a verb',
    'ver- often means wrongly, zer- to pieces, er- by doing it, ent- away. Read the prefix and you read the verb.',
    Q + 'praefixe_semantik',
    [
        build('Prefix + verb', [
            ([('ver', 'joint'), 'rechnen'], 'sich verrechnen', 'ver-: wrongly'), ([('zer', 'joint'), 'reißen'], 'zerreißen', 'zer-: to pieces'),
            ([('er', 'joint'), 'kämpfen'], 'erkämpfen', 'er-: get by doing'), ([('ent', 'joint'), 'kalken'], 'entkalken', 'ent-: remove'),
            ([('be', 'joint'), 'antworten'], 'beantworten', 'be-: takes an object'),
        ]),
        table('über-, um-: split or not?', ['split: literal', 'fixed: figurative'], [
            ['Er setzt uns ans Ufer über. (ferries)', 'Er übersetzt den Text. (translates)'],
            ['Er hat den Pfosten umgefahren. (knocked down)', 'Er hat die Stadt umfahren. (drove round)'],
        ]),
        words('Words for the practice page', [
            ('die Steuererklärung', 'tax return'), ('tausend Euro', 'a thousand euros'), ('der Sieg', 'victory'), ('die Nachspielzeit', 'injury time'),
            ('die Ministerin', 'minister'), ('der Ausschuss', 'committee'), ('ausführlich', 'in detail'), ('der Fährmann', 'ferryman'),
            ('die Reisenden', 'travellers'), ('das Ufer', 'bank'), ('der Wasserkocher', 'kettle'), ('die Versteigerung', 'auction'),
            ('steigern', 'to bid'),
            ('das Präteritum', 'simple past'),
        ], 4),
    ],
    [
        gaps('Prefix it', 'Write the verb in the form the sentence needs.', [
            ('Bei der Steuererklärung habe ich mich um tausend Euro', '. (rechnen, ver-)', 'verrechnet'),
            ('Die Mannschaft hat sich den Sieg in der Nachspielzeit', '. (kämpfen, er-)', 'erkämpft'),
            ('Du musst den Wasserkocher', '. (kalken, ent-)', 'entkalken'),
            ('Die Ministerin', 'alle Fragen ausführlich. (antworten, be-, Präteritum)', 'beantwortete'),
            ('Er hat das Bild auf einer Versteigerung', '. (steigern, er-)', 'ersteigert'),
        ]),
    ],
    ['read ver-, zer-, er-, ent-, be-',
     'use be- with a direct object',
     'tell über- and um- split or fixed'],
))

# ---- 12 · Konjunktiv II Nuancen ---------------------------------------------------------
spreads.append(spread(
    'konj2', 'Um ein Haar wäre ich gestürzt', 'The Konjunktiv II in its finer shades',
    'Near-misses, regret, politeness and the elevated Wäre da nicht …: the Konjunktiv II does what English does with modals and tone.',
    Q + 'konj2_nuancen',
    [
        slots('hätte before the two infinitives — even in a clause', [
            (sl('Klar ist, dass', 'er', 'es', 'hätte!', 'wissen müssen.!'), 'not: wissen müssen hätte'),
        ]),
        table('Five shades', ['shade', 'like this'], [
            ['near-miss', 'Um ein Haar *wäre* ich gestürzt. (I didn’t fall)'], ['regret', '*Hätte* ich doch nur früher auf dich gehört!'],
            ['politeness', 'Ich *hätte* da eine Frage. · *Wäre* es möglich …?'], ['too … to', 'zu komplex, als dass man es erklären *könnte*'],
            ['were it not for', '*Wären* da nicht die Kosten, …'],
        ]),
        words('Words for the practice page', [
            ('um ein Haar', 'by a hair'), ('beinahe', 'almost'), ('stürzen', 'to fall'), ('der letzte Zug', 'the last train'),
            ('die Risiken', 'risks'), ('rückblickend', 'looking back'), ('der Vorstand', 'board'), ('die Reform', 'reform'),
            ('retten', 'to save'), ('die Firma', 'company'), ('komplex', 'complex'), ('gehört', 'listened'),
        ], 4),
    ],
    [
        gaps('The verb form', 'Write the Konjunktiv II form.', [
            ('Um ein Haar', 'wir den letzten Zug verpasst.', 'hätten'),
            ('Ich', 'beinahe gestürzt.', 'wäre'),
            ('Rückblickend ist klar, dass der Vorstand die Risiken früher', 'erkennen müssen.', 'hätte'),
            ('', 'ich doch nur früher auf dich gehört!', 'Hätte'),
            ('Die Reform kam zu spät, als dass sie die Firma noch hätte retten', '.', 'können'),
        ]),
    ],
    ['say a near-miss: um ein Haar wäre …',
     'put hätte before the two infinitives',
     'use the elevated Wäre da nicht …'],
))

# ---- 13 · Konnektoren -----------------------------------------------------------------------
spreads.append(spread(
    'konnektoren', 'indes, wiewohl, mithin', 'Elevated connectors and their word order',
    'Their meaning is easy — however, although, therefore. Their word order is the test.',
    Q + 'konnektoren_nuancen',
    [
        table('Three word-order classes', ['class', 'words', 'verb'], [
            ['subordinators', 'wiewohl · obschon · zumal · insofern als', 'last'], ['adverbs', 'indes · gleichwohl · mithin · somit', 'next (or in the middle)'],
            ['outside', 'aber · doch · allein', 'unchanged'],
        ]),
        slots('Same idea, two orders', [
            (sl('Wiewohl', 'er die Risiken', 'kannte,!', 'unterschrieb!', 'er.'), 'subordinator'),
            (sl('Er kannte die Risiken;', 'gleichwohl', 'unterschrieb!', 'er.'), 'adverb'),
        ], note='Not: …, gleichwohl er unterschrieb.'),
        words('Words for the practice page', [
            ('die Risiken', 'risks'), ('unterschrieb', 'signed'), ('der Vertrag', 'contract'), ('die Betroffenen', 'those affected'),
            ('bis heute', 'to this day'), ('der Beschuldigte', 'the accused'), ('zur Tatzeit', 'at the time of the crime'), ('im Ausland', 'abroad'),
            ('begangen', 'committed'), ('das Angebot', 'offer'), ('die Konditionen', 'terms'), ('versprach', 'promised'),
        ], 4),
    ],
    [
        gaps('Which connector?', 'Write wiewohl, indes, zumal or mithin.', [
            ('', 'er die Risiken kannte, unterschrieb er den Vertrag.', 'Wiewohl'),
            ('Der Minister versprach Hilfe; die Betroffenen warten', 'bis heute.', 'indes'),
            ('Wir sollten das Angebot annehmen,', 'die Konditionen kaum besser werden.', 'zumal'),
            ('Er war zur Tatzeit im Ausland; er kann die Tat', 'nicht begangen haben.', 'mithin'),
        ]),
        circle('Word order', 'Circle the right order.', [
            ('Er kannte die Risiken; gleichwohl', ['unterschrieb er', 'er unterschrieb'], '.', 'unterschrieb er'),
        ], 1),
    ],
    ['use indes, wiewohl, zumal, mithin',
     'put the verb where each class wants it',
     'tell a subordinator from an adverb'],
))

# ---- 14 · Umformung -----------------------------------------------------------------------------
spreads.append(spread(
    'umformung', 'am Vortag, tags darauf', 'Same meaning, another grammar',
    'Rewrite — and check four things: meaning, tense, agent, register. Lose one and the rewrite fails.',
    Q + 'umformung_2',
    [
        table('Direct → reported: the time words move too', ['direct', 'reported later'], [
            ['gestern', 'am Vortag · tags zuvor'], ['morgen', 'am nächsten Tag · tags darauf'], ['heute', 'an jenem Tag'],
        ]),
        merge('Connector ↔ little word', ('connector', 'noun phrase'), [
            ('weil …', 'wegen', 'die Nachfrage sank', 'der gesunkenen Nachfrage', 'wegen der gesunkenen Nachfrage', 'cause'),
            ('bevor …', 'vor', 'er ging', 'seinem Aufbruch', 'vor seinem Aufbruch', 'not: vor seinem Gehen'),
        ]),
        flow('Keep the force', q('Does ist zu … mean must here?',
                                 a('muss … werden', 'Das Formular ist auszufüllen. = muss ausgefüllt werden'),
                                 a('lässt sich · kann … werden', 'Der Fehler ist leicht zu beheben. = lässt sich leicht beheben'))),
        words('Words for the practice page', [
            ('der Vertrag', 'contract'), ('unterschrieben', 'signed'), ('die Nachfrage', 'demand'), ('gesunken', 'fallen'),
            ('das Gebäude', 'building'), ('saniert', 'renovated'), ('der Aufbruch', 'departure'), ('die Stadt', 'city'),
            ('der Fehler', 'error'), ('beheben', 'to fix'),
        ], 4),
    ],
    [
        write('Rephrase', 'Write it in the other form.', [
            ('„Wir haben den Vertrag gestern unterschrieben.“ → Man …', 'Man habe den Vertrag am Vortag unterschrieben.'),
            ('Weil die Nachfrage stark gesunken war, … → Wegen …', 'Wegen der stark gesunkenen Nachfrage …'),
            ('Die Stadt hat das Gebäude saniert. → Das Gebäude …', 'Das Gebäude ist von der Stadt saniert worden.'),
            ('Das Problem kann gelöst werden. → Das Problem …', 'Das Problem lässt sich lösen.'),
        ], 1),
    ],
    ['move between direct and reported speech',
     'swap a connector for a noun phrase',
     'keep meaning, tense, agent and register'],
))

# ---- Review 2 · topics 8–14 ----------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 8–14', 'Grammar at full stretch, all at once. No looking back until you have done both pages.',
    Q + 'bigtext_vorstand',
    [
        gaps('Frames and forms', 'Write the missing word.', [
            ('Man beschuldigte ihn', 'Betrugs.', 'des'), ('die Begrenzung der Geschwindigkeit → die', '', 'Geschwindigkeitsbegrenzung'),
            ('Ein', 'Anbieter. (glauben, -würdig)', 'glaubwürdiger'), ('Ich habe mich um tausend Euro', '. (rechnen, ver-)', 'verrechnet'),
        ]),
    ],
    [
        gaps('Shades and order', 'Write the missing word.', [
            ('Um ein Haar', 'ich gestürzt.', 'wäre'), ('', 'er die Risiken kannte, unterschrieb er.', 'Wiewohl'),
            ('„gestern“ → am', '', 'Vortag'),
        ]),
    ],
))

# ==== Part 3 · Texts and voices ===========================================================

# ---- 15 · Konjunktiv I im Journalismus ------------------------------------------------------
spreads.append(spread(
    'konj1', 'so Wendt, hätten …', 'Who is speaking? The verb tells you',
    'One introducing verb, then the Konjunktiv I carries the whole report. Indicative = the paper’s own voice.',
    Q + 'konj1_lit',
    [
        flow('Source or author?', q('Is the verb in the Konjunktiv (sei, habe, könne, hätten)?',
                                    a('a source speaks', 'Die Beschleunigung sei an eine Grenze gestoßen.'),
                                    a('the author speaks', 'Beide haben recht.'))),
        table('No backshift — only the mood moves', ['direct', 'reported'], [
            ['ist', 'sei'], ['war · ist gewesen', 'sei gewesen'], ['wird', 'werde'], ['haben (plural)', 'hätten — I looks like the indicative'],
        ]),
        box('watch', 'Not hätte where habe works', '*er hätte* where *er habe* is available sounds as if the writer doubted the claim.'),
        words('Words for the practice page', [
            ('die Innenministerin', 'interior minister'), ('beherrschbar', 'under control'), ('die Kräfte', 'forces'), ('bündeln', 'to pool'),
            ('die Langsamkeit', 'slowness'), ('neu entdeckt', 'rediscovered'), ('die Notwehr', 'self-defence'), ('die Nostalgie', 'nostalgia'),
            ('der Ökonom', 'economist'), ('die Wohlhabenden', 'the well-off'), ('knapp', 'scarce'), ('die Gewerkschaft', 'union'),
            ('die Zugeständnisse', 'concessions'), ('die Beschäftigten', 'employees'), ('bereit', 'willing'),
            ('gebündelt', 'pooled'),
            ('teilte mit', 'announced'),
            ('erneut', 'again'),
            ('die Bewegung', 'movement'),
            ('das Phänomen', 'phenomenon'),
        ], 4),
    ],
    [
        gaps('Report it', 'Write the verb in the Konjunktiv I — or II where I looks like the indicative.', [
            ('Die Ministerin erklärte, die Lage', 'ernst, aber beherrschbar. (sein)', 'sei'),
            ('Man', 'alle Kräfte gebündelt. (haben)', 'habe'),
            ('Die Gewerkschaft teilte mit, die Beschäftigten', 'genug Zugeständnisse gemacht. (haben)', 'hätten'),
            ('Sie', 'die Maßnahmen erneut überprüfen. (werden)', 'werde'),
        ]),
        circle('Slowness', 'Listen to the article. Circle what you hear.', [
            ('Immer mehr Menschen, so Wendt,', ['hätten', 'haben'], 'den Wert der Langsamkeit neu entdeckt.', 'hätten'),
            ('Die neue Langsamkeit sei weniger Nostalgie als', ['Notwehr', 'Mode'], '.', 'Notwehr'),
            ('Berger hält die Bewegung für ein Phänomen der', ['Wohlhabenden', 'Jugend'], '.', 'Wohlhabenden'),
            ('Langsamkeit lasse sich gut verkaufen, weil sie', ['knapp', 'teuer'], 'geworden sei.', 'knapp'),
        ], 1) | {'listen': True},
    ],
    ['keep a report in the Konjunktiv I',
     'switch to hätten where the Konjunktiv I looks normal',
     'tell a source’s claim from the author’s verdict'],
    listen=Q + 'lesen_artikel',
))

# ---- 16 · Stilmittel ----------------------------------------------------------------------
spreads.append(spread(
    'stilmittel', 'Die Stadt schläft nie', 'Rhetorical devices: name it, say what it does',
    'Die Ampeln schalten, gewissenhaft wie Beamte: a simile. Die Häuser haben ihre Augen geschlossen: a personification.',
    Q + 'stilmittel',
    [
        table('Name and effect', ['device', 'like this', 'it …'], [
            ['Metapher', 'Die Koalition ist ein Kartenhaus.', 'compresses an image'], ['Vergleich', 'zäh wie Kaugummi', 'compares openly — with wie'],
            ['Personifikation', 'Die Märkte strafen ab.', 'brings things to life'], ['Anapher', 'Wir brauchen Mut. Wir brauchen Geduld.', 'binds and stresses'],
            ['Antithese', 'Er versprach Aufbruch und lieferte Stillstand.', 'sharpens a contrast'], ['Litotes', 'nicht unerheblich (= erheblich)', 'understates — and stresses'],
            ['Euphemismus', 'negatives Wachstum', 'softens'],
        ]),
        flow('Metapher or Vergleich?', q('Is there a wie or als ob?', a('Vergleich', 'laut wie ein Jahrmarkt'), a('Metapher', 'ein Bienenstock'))),
        words('Words for the practice page', [
            ('die Ampeln', 'traffic lights'), ('gewissenhaft', 'conscientious'), ('die Beamten', 'officials'), ('die Stille', 'silence'),
            ('das Tuch', 'cloth'), ('die Insel', 'island'), ('das Meer', 'sea'), ('die Dunkelheit', 'darkness'),
            ('das Aquarium', 'aquarium'), ('die Schienen', 'rails'), ('die Großstadt', 'big city'), ('der Dienstag', 'Tuesday'),
            ('die Risiken', 'risks'), ('ganz', 'entirely'), ('die Häuser', 'houses'), ('die Augen', 'eyes'),
            ('der Arbeiter', 'worker'),
            ('ein ganz gewöhnlicher Dienstag', 'a quite ordinary Tuesday'),
        ], 4),
    ],
    [
        gaps('Name it', 'Write the device: Metapher, Vergleich, Personifikation, Anapher, Antithese or Litotes.', [
            ('Die Häuser haben ihre Augen geschlossen. →', '', 'Personifikation'),
            ('Die Stille liegt wie ein Tuch über den Straßen. →', '', 'Vergleich'),
            ('Jedes Licht ist eine kleine Insel in einem Meer aus Dunkelheit. →', '', 'Metapher'),
            ('Die Risiken waren nicht ganz unerheblich. →', '', 'Litotes'),
        ]),
        circle('The city before dawn', 'Listen to the feature. Circle what you hear.', [
            ('Wer glaubt, eine Großstadt', ['schlafe', 'schläft'], 'nie, der irrt.', 'schlafe'),
            ('Die Ampeln schalten, gewissenhaft wie', ['Beamte', 'Soldaten'], '.', 'Beamte'),
            ('Die erste Straßenbahn ist hell wie ein', ['Aquarium', 'Bahnhof'], 'auf Schienen.', 'Aquarium'),
            ('Für den Arbeiter ist es ein ganz gewöhnlicher', ['Dienstag', 'Morgen'], '.', 'Dienstag'),
        ], 1) | {'listen': True},
    ],
    ['name a rhetorical device',
     'say what it does in the text',
     'tell a metaphor from a simile'],
    listen=Q + 'hoeren_feature',
))

# ---- 17 · Eine Rede -------------------------------------------------------------------------
spreads.append(spread(
    'rede', 'Wir brauchen Mut. Wir brauchen einander.', 'Giving a speech',
    'Open with an image, build with three, close with the same image. And pause before the key word.',
    Q + 'sprechen_rede',
    [
        slots('The ring', [
            ([('Stellen Sie sich eine Stadt vor, …', 'open: an image'), ('Wir brauchen … Wir brauchen …', 'build')], None),
            ([('Nicht …, sondern …', 'contrast'), {'de': 'Stellen Sie sich diese Stadt also noch einmal vor.', 'tag': 'close: the image again', 'hot': True}], None),
        ]),
        table('Devices in a speech', ['device', 'like this'], [
            ['rhetorical question', 'Wer von uns hätte das für möglich gehalten?'], ['anaphora', 'Wir brauchen Mut. Wir brauchen Ausdauer.'],
            ['antithesis', 'Nicht die Technik entscheidet, sondern der Mensch.'], ['climax', 'Es geht um Zeit, um Geld – und um unsere Kinder.'],
            ['concession', 'Gewiss, der Weg ist weit; doch er ist der einzige.'],
        ]),
        words('Words for the practice page', [
            ('der Mut', 'courage'), ('die Ausdauer', 'stamina'), ('einander', 'each other'), ('die Technik', 'technology'),
            ('entscheiden', 'to decide'), ('die Zukunft', 'future'), ('der Weg', 'path'), ('weit', 'long'), ('gewiss', 'certainly'),
            ('für möglich gehalten', 'thought possible'), ('die Aufmerksamkeit', 'attention'), ('der Mensch', 'people'),
        ], 4),
    ],
    [
        gaps('The device', 'Write the missing word.', [
            ('Wir brauchen Mut. Wir brauchen Ausdauer. Wir brauchen', '.', 'einander'),
            ('Nicht die Technik entscheidet über unsere Zukunft,', 'der Mensch.', 'sondern'),
            ('', ', der Weg ist weit; doch er ist der einzige.', 'Gewiss'),
            ('Wer von uns hätte das für möglich', '?', 'gehalten'),
        ]) | {'listen': True},
    ],
    ['open and close a speech with the same image',
     'build with anaphora, antithesis and climax',
     'pause before the key word'],
    listen=Q + 'sprechen_rede',
))

# ---- 18 · Moderieren ------------------------------------------------------------------------
spreads.append(spread(
    'moderieren', 'Um es zuzuspitzen: …', 'Steering a discussion',
    'Name, short question, silence. A good discussion needs someone steering, not just talking.',
    Q + 'sprechen_moderieren',
    [
        table('The moderator’s moves', ['move', 'phrase'], [
            ['open', 'Ich begrüße Sie herzlich zu … · Lassen Sie uns mit der Frage beginnen, …'],
            ['give the floor', 'Herr Brandt, Sie sehen die Pläne kritisch – warum?'], ['sharpen', 'Um es zuzuspitzen: … – ja oder nein?'],
            ['interrupt', 'Darf ich Sie an dieser Stelle kurz unterbrechen?'], ['hold', 'Lassen Sie uns das festhalten, bevor wir weitergehen.'],
            ['close', 'Ich fasse zusammen: Einigkeit beim Ziel, Streit über den Weg.'],
        ]),
        slots('Name, short question, stop', [
            (sl('Frau Yilmaz –', 'Ihre Einschätzung', 'in einem Satz?!'), 'then silence'),
        ]),
        words('Words for the practice page', [
            ('die Runde', 'panel'), ('autofrei', 'car-free'), ('die Innenstadt', 'city centre'), ('kritisch', 'critically'),
            ('die Sorge', 'worry'), ('die Händler', 'retailers'), ('das Fahrverbot', 'driving ban'), ('die Altstadt', 'old town'),
            ('unterbrechen', 'to interrupt'), ('bremsen', 'to stop'), ('die Einschätzung', 'assessment'), ('das Schlusswort', 'closing word'),
            ('das Ziel', 'goal'), ('das Tempo', 'pace'), ('lebendig', 'lively'),
            ('streiten', 'to argue'),
        ], 4),
    ],
    [
        gaps('The move', 'Write the missing word.', [
            ('Um es', ': Sind Sie für ein Fahrverbot – ja oder nein?', 'zuzuspitzen'),
            ('Darf ich Sie an dieser Stelle kurz', '?', 'unterbrechen'),
            ('Lassen Sie uns das', ', bevor wir weitergehen.', 'festhalten'),
            ('Ich fasse', ': Einigkeit beim Ziel, Streit über den Weg.', 'zusammen'),
        ]),
        circle('A panel on the radio', 'Listen. Circle what you hear.', [
            ('Lassen Sie uns mit der Frage beginnen, wem die', ['Innenstadt', 'Altstadt'], 'eigentlich gehört.', 'Innenstadt'),
            ('Sie streiten nicht über das Ziel, sondern über das', ['Tempo', 'Geld'], '.', 'Tempo'),
        ], 1) | {'listen': True},
    ],
    ['open a discussion and give the floor',
     'sharpen, interrupt politely and hold a result',
     'sum up in one balanced sentence'],
    listen=Q + 'sprechen_moderieren',
))

# ---- 19 · Satire -------------------------------------------------------------------------------
spreads.append(spread(
    'satire', 'Unsere Stadt ist digital.', 'Reading satire: praise that undoes itself',
    'The speaker never says it is bad. He praises — and puts the evidence right next to the praise.',
    Q + 'hoeren_satire',
    [
        slots('Praise, then the fact', [
            (sl('Anschließend erhält man einen Aktivierungscode.', 'Per Post.!'), 'the shorter, the harder'),
            (sl('Innerhalb von zehn Werktagen.!'), None),
        ]),
        table('Three techniques', ['technique', 'like this'], [
            ['mock praise', 'Das nennt man Transparenz.'], ['jargon quoted, then taken literally', '„medienbruchfrei“ – man wechselt nur noch einmal hin und einmal her'],
            ['the punchline catches the speaker', 'digital angekommen – und ich warte auf einen Brief'],
        ]),
        box('watch', 'A concession is a set-up', '*Ich will nicht ungerecht sein.* In satire, the next sentence attacks.'),
        words('Words for the practice page', [
            ('das Bürgerportal', 'citizens’ portal'), ('der Bildschirm', 'screen'), ('der Aktivierungscode', 'activation code'),
            ('die Werktage', 'working days'), ('die Pressemitteilung', 'press release'), ('der Termin', 'appointment'),
            ('die Beschwerden', 'complaints'), ('ausgedruckt', 'printed'), ('abgeheftet', 'filed'), ('die Einladung', 'invitation'),
            ('das Fax', 'fax'), ('der Preis', 'award'), ('das Plakat', 'poster'), ('das Fernglas', 'binoculars'), ('die Baustelle', 'building site'),
            ('der Februar', 'February'), ('die Transparenz', 'transparency'),
        ], 4),
    ],
    [
        circle('Stadt direkt', 'Listen to the gloss. Circle what you hear.', [
            ('Den Aktivierungscode bekommt man per', ['Post', 'E-Mail'], '.', 'Post'),
            ('Die Beschwerden werden ausgedruckt und', ['abgeheftet', 'gelöscht'], '.', 'abgeheftet'),
            ('Die Einladung zum Preis kam per', ['Fax', 'Brief'], '.', 'Fax'),
            ('Der nächste freie Termin liegt im', ['Februar', 'März'], '.', 'Februar'),
        ], 1) | {'listen': True},
        gaps('What it really means', 'Finish the sentence in your own words.', [
            ('„Das nennt man Transparenz.“ – Der Sprecher meint:', '.'),
        ], 'About you.'),
    ],
    ['recognise mock praise',
     'hear quoted jargon taken literally',
     'read the punchline as the thesis'],
    listen=Q + 'hoeren_satire',
))

# ---- 20 · Kurzgeschichte -----------------------------------------------------------------------
spreads.append(spread(
    'kurzgeschichte', 'Die blaue Tasse', 'Reading a short story',
    'An abrupt start, an ordinary moment, no feelings named, one object that carries the meaning — and an open ending.',
    Q + 'lesen_kurzgeschichte',
    [
        slots('Follow the object', [
            ([('taken out', 'Er nahm die blaue Tasse aus dem Schrank.'), ('left empty', 'Die blaue blieb leer.')], None),
            ([('washed though clean', 'obwohl sie nicht schmutzig war'), {'de': 'on the windowsill', 'tag': 'Von dort sieht man den Hof.', 'hot': True}], None),
        ], note='Each step is a decision about how much of Ruth stays in his day.'),
        table('What makes it a Kurzgeschichte', ['feature', 'in this story'], [
            ['abrupt start', 'Das Wasser kochte schon, als das Telefon klingelte.'], ['no feelings named', 'He acts; the reader infers grief.'],
            ['a symbol', 'the blue cup'], ['an open ending', 'Von dort, dachte er, sieht man den Hof.'],
        ]),
        words('Words for the practice page', [
            ('die Tasse', 'cup'), ('der Schrank', 'cupboard'), ('die Beerdigung', 'funeral'), ('der Zettel', 'note'),
            ('die Zuckerdose', 'sugar bowl'), ('die Fensterbank', 'windowsill'), ('der Hof', 'yard'), ('schmutzig', 'dirty'),
            ('abtrocknen', 'to dry'), ('sorgfältig', 'carefully'), ('die Brusttasche', 'breast pocket'), ('der Nachbar', 'neighbour'),
            ('die Mülltonnen', 'bins'), ('das Telefon', 'phone'), ('klingelte', 'rang'), ('leer', 'empty'), ('der Sprung', 'crack'),
            ('die Wohnung', 'flat'), ('zwei Zimmer', 'two rooms'), ('reichen', 'to be enough'),
            ('die blaue Tasse', 'the blue cup'),
            ('stellte', 'put'),
        ], 4),
    ],
    [
        circle('Brenner’s Tuesday', 'Listen to the story. Circle what you hear.', [
            ('Katrin rief jeden', ['Dienstag', 'Sonntag'], 'um halb acht an.', 'Dienstag'),
            ('Die blaue Tasse blieb', ['leer', 'voll'], '.', 'leer'),
            ('Zwei Zimmer, dachte er, das', ['reicht', 'stimmt'], 'für einen.', 'reicht'),
            ('Die Tasse stellte er auf die', ['Fensterbank', 'Zuckerdose'], '.', 'Fensterbank'),
        ], 1) | {'listen': True},
        gaps('Your reading', 'Finish the sentence.', [('Am Ende stellt Brenner die Tasse auf die Fensterbank, weil', '.')], 'About you.'),
    ],
    ['name the features of a Kurzgeschichte',
     'follow a symbol through a story',
     'read an open ending without closing it'],
    listen=Q + 'lesen_kurzgeschichte',
))

# ---- Review 3 · topics 15–20 ---------------------------------------------------------------
spreads.append(review(
    'review_3', 'Topics 15–20', 'The last part, all at once. No looking back until you have done both pages.',
    Q + 'sprechen_dialog',
    [
        gaps('Voices and devices', 'Write the missing word.', [
            ('Die Ministerin erklärte, die Lage', 'ernst. (sein)', 'sei'),
            ('Die Stille liegt wie ein Tuch über den Straßen. →', '', 'Vergleich'),
            ('Nicht die Technik entscheidet,', 'der Mensch.', 'sondern'),
        ]),
    ],
    [
        gaps('Steering and reading', 'Write the missing word.', [
            ('Um es', ': ja oder nein?', 'zuzuspitzen'), ('Ich fasse', ': Einigkeit beim Ziel.', 'zusammen'),
            ('Das nennt man', '. (mock praise)', 'Transparenz'),
        ]),
    ],
))

book = {
    'title': 'Stil & Register',
    'cover': 'cp_c2_1_cover',
    'welcome': [
        'This book is the paper half of C2.1. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It has three parts. The first is about choosing the word: register, collocation, connotation and degree. The second is grammar at full stretch: valency, compounds, prefixes, the finer Konjunktiv and elevated connectors. The third is about texts and voices: reporting, rhetoric, speeches, moderating, satire and the short story.',
        'It carries on from the earlier books. Words you learned there are not taught again. Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Anna', 'Wendt', 'Berger', 'Brenner', 'Ruth', 'Katrin', 'Brandt', 'Yilmaz', 'Demir', 'Berlin', 'Hamburg',
              'Deutschlands', 'Mio', 'Euro', 'Herr', 'Frau', 'Stadt', 'direkt'],
    'spreads': spreads,
    'overview': {'title': 'C2.1 at a glance', 'blocks': [
        table('Three levels', ['spoken', 'neutral', 'formal'], [
            ['kriegen', 'bekommen', 'erhalten'], ['checken', 'prüfen', 'überprüfen'], ['Kohle', 'Geld', 'Mittel'], ['sauer', 'verärgert', 'ungehalten'],
        ]),
        table('Shading a claim', ['', 'like this'], [
            ['by no means', 'keineswegs'], ['not exactly', 'nicht gerade'], ['certainly', 'durchaus'], ['downright', 'geradezu'], ['at least', 'immerhin'],
        ]),
        table('Elevated connectors', ['verb', 'words'], [
            ['last', 'wiewohl · obschon · zumal · insofern als'], ['next', 'indes · gleichwohl · mithin'], ['unchanged', 'aber · doch · allein'],
        ]),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.', [
            ('der Hobel', 'plane', 'cpd_hobel'), ('die Schraubzwinge', 'clamp', 'cpd_schraubzwinge'), ('der Zollstock', 'folding rule', 'cpd_zollstock'),
            ('die Hobelbank', 'workbench', 'cpd_hobelbank'), ('das Stemmeisen', 'chisel', 'cpd_stemmeisen'), ('der Akkuschrauber', 'cordless drill', 'cpd_akkuschrauber'),
            ('der Sägebock', 'sawhorse', 'cpd_saegebock'), ('das Ölkännchen', 'oil can', 'cpd_oelkaennchen'), ('die Säge', 'saw', 'cpd_saege'),
            ('der Hammer', 'hammer', 'cpd_hammer'), ('die Wasserwaage', 'spirit level', 'cpd_wasserwaage'), ('die Leiter', 'ladder', 'cpd_leiter'),
            ('die Sense', 'scythe', 'cpd_sense'), ('die Egge', 'harrow', 'cpd_egge'), ('der Melkschemel', 'milking stool', 'cpd_melkschemel'),
            ('das Scheunentor', 'barn door', 'cpd_scheunentor'), ('das Wagenrad', 'cart wheel', 'cpd_wagenrad'), ('der Wetterhahn', 'weathercock', 'cpd_wetterhahn'),
            ('das Ferkel', 'piglet', 'cpd_ferkel'), ('das Kalb', 'calf', 'cpd_kalb'), ('die Ziege', 'goat', 'cpd_ziege'), ('die Gans', 'goose', 'cpd_gans'),
            ('die Pumpe', 'pump', 'cpd_pumpe'), ('die Mistgabel', 'pitchfork', 'cpd_mistgabel'), ('der Taubenschlag', 'dovecote', 'cpd_taubenschlag'),
            ('der Strohballen', 'straw bale', 'cpd_strohballen'), ('die Schubkarre', 'wheelbarrow', 'cpd_schubkarre'), ('die Laterne', 'lantern', 'cpd_laterne'),
            ('die Tasse', 'cup', 'cpd_tasse'), ('die Zuckerdose', 'sugar bowl', 'cpd_zuckerdose'), ('das Fernglas', 'binoculars', 'cpd_fernglas'),
            ('das Faxgerät', 'fax machine', 'cpd_faxgeraet'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

kit.write_book(OUT, book)
