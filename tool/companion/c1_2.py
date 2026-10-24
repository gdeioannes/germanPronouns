# Builds assets/content/companion/de_cert_a1/c1_2.json — the C1.2 study companion.
# Run: python -I tool/companion/c1_2.py   (rules: docs/study_companion_guide.md)
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, merge, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_c1_2_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'c1_2.json')
Q = 'quest_c1_2_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ==== Part 1 · How sure — and who says so ================================================

# ---- 1 · Kultur & Medien ------------------------------------------------------------------
spreads.append(spread(
    'kultur', 'Kultur & Medien', 'Better words than “interessant”',
    'A precise word says what you actually thought: vielschichtig, gelungen, umstritten — not interessant, gut, schlecht.',
    Q + 'kultur',
    [
        build('Verb → noun, with its little word', [
            (['sich auseinandersetzen mit'], 'die Auseinandersetzung mit', 'engagement with'),
            (['anspielen auf'], 'die Anspielung auf', 'allusion to'),
            (['sich begeistern für'], 'die Begeisterung für', 'enthusiasm for'),
            (['kritisieren'], 'die Kritik an', 'criticism of'),
        ]),
        table('Instead of interessant, gut, schlecht', ['instead of', 'say'], [
            ['interessant', 'vielschichtig · aufschlussreich · anregend'], ['gut', 'gelungen · überzeugend · wegweisend'],
            ['schwierig', 'anspruchsvoll · nicht immer zugänglich'], ['schlecht', 'oberflächlich · umstritten'],
        ]),
        words('Words for the practice page', [
            ('prägen', 'to shape'), ('hinterfragen', 'to question'), ('vermitteln', 'to convey'), ('die Inszenierung', 'staging'),
            ('das Stück', 'play'), ('die Gegenwart', 'present day'), ('die Medien', 'media'), ('die Sicht', 'view'),
            ('der Eintritt', 'admission'), ('kostenlos', 'free'), ('die Familien', 'families'), ('die Steuerzahler', 'taxpayers'),
            ('das Publikum', 'audience'), ('die Erstbesucher', 'first-time visitors'), ('zweitrangig', 'secondary'),
            ('verdoppelt', 'doubled'), ('die Inhalte', 'content'), ('der Mittelweg', 'middle way'), ('der Film', 'film'),
            ('die Frage', 'question'), ('unsere', 'our'), ('groß', 'big'), ('blieben', 'remained'),
            ('die Anspielungen', 'allusions'),
            ('eine vielschichtige Inszenierung', 'a multi-layered staging'),
            ('insgesamt', 'all in all'),
            ('kostenloser Eintritt', 'free admission'),
            ('er schlägt vor', 'he proposes'),
        ], 4),
    ],
    [
        gaps('The precise word', 'Write the word from the left page.', [
            ('Der Film setzt sich mit der Frage', ', wie Medien unsere Sicht prägen.', 'auseinander'),
            ('Die Begeisterung', 'das Stück war groß.', 'für'),
            ('Die Anspielungen', 'die Gegenwart blieben aber umstritten.', 'auf'),
            ('Eine vielschichtige, wenn auch nicht immer', 'Inszenierung. (≠ schwer zu verstehen)', 'zugängliche'),
            ('Insgesamt: eine', 'Inszenierung. (≈ gut gemacht)', 'gelungene'),
        ]),
        circle('Free museums?', 'Listen to the four experts. Circle what you hear.', [
            ('Dr. Vogt: Kostenloser Eintritt verschiebt die Kosten auf die', ['Steuerzahler', 'Familien'], '.', 'Steuerzahler'),
            ('Prof. Aydin: Die Zahl der Erstbesucher hat sich', ['verdoppelt', 'halbiert'], '.', 'verdoppelt'),
            ('Frau Sölle: Der Preis ist', ['zweitrangig', 'entscheidend'], '.', 'zweitrangig'),
            ('Herr Reinhardt schlägt einen', ['Mittelweg', 'Kompromiss'], 'vor.', 'Mittelweg'),
        ], 1) | {'listen': True},
    ],
    ['use the verbs of cultural commentary',
     'say what I thought precisely',
     'follow four experts and keep them apart'],
    listen=Q + 'lesen_experten',
))

# ---- 2 · Er muss zu Hause sein ------------------------------------------------------------
spreads.append(spread(
    'vermutung', 'Er dürfte im Stau stehen', 'Modal verbs for how sure you are',
    'Das Licht brennt — er muss zu Hause sein. muss, dürfte, könnte: one scale from sure to impossible.',
    Q + 'modal_vermutung',
    [
        tiles('Sure → impossible', [
            ('muss!', 'almost certain'), ('müsste', 'by rights should'), ('dürfte', 'probably'),
            ('könnte', 'possibly'), ('mag', 'may be so, but'), ('kann nicht', 'impossible'),
        ], 6),
        slots('About then: the modal stays, the past form + haben or sein goes last', [
            (sl('Es', 'muss!', 'geregnet', 'haben.!'), 'must have rained'),
            (sl('Er', 'dürfte!', 'den Bus verpasst', 'haben.!'), 'probably missed'),
            (sl('Sie', 'könnte!', 'schon', 'gegangen sein.!'), 'might have gone'),
        ]),
        flow('Objective or subjective?', q('Is someone obliging or allowing someone?',
                                           a('objective', 'Er muss arbeiten.'), a('subjective: a guess', 'Er muss krank sein.'))),
        words('Words for the practice page', [
            ('das Licht brennt', 'the light is on'), ('die Straße ist nass', 'the road is wet'), ('der Stau', 'traffic jam'),
            ('längst', 'long ago'), ('die Verspätung', 'delay'), ('bei dem Wetter', 'in this weather'), ('schlafen', 'to sleep'),
            ('wahr', 'true'), ('die Fenster', 'windows'), ('dunkel', 'dark'), ('die Post stapelt sich', 'the post is piling up'),
            ('im Urlaub', 'on holiday'), ('verreist', 'away'), ('stimmen', 'to be right'),
        ], 4),
    ],
    [
        gaps('How sure?', 'Write muss, dürfte, könnte or kann (nicht).', [
            ('Das Licht brennt – er', 'zu Hause sein. (almost certain)', 'muss'),
            ('Bei dem Wetter', 'der Zug Verspätung haben. (probably)', 'dürfte'),
            ('Sie', 'schon schlafen. (possibly)', 'könnte'),
            ('Das', 'nicht wahr sein! (impossible)', 'kann'),
            ('Er', 'längst hier sein. (by rights)', 'müsste'),
        ]),
        gaps('About then', 'Write the modal and haben or sein.', [
            ('Die Straße ist nass – es', 'geregnet', 'muss … haben'),
            ('Er ist nicht da – er', 'den Bus verpasst', 'dürfte … haben'),
            ('Die Fenster sind dunkel – sie', 'verreist', 'könnten … sein'),
        ], 'Write both words in the gap, with … between them.'),
    ],
    ['guess with muss, dürfte, könnte',
     'guess about the past: muss geregnet haben',
     'tell a guess from an obligation'],
))

# ---- 3 · soll, will ----------------------------------------------------------------------
spreads.append(spread(
    'hoerensagen', 'Das Bild soll gestohlen worden sein', 'People say … — he claims …',
    'soll for what others say, will for what someone claims about himself — now with the past and the passive.',
    Q + 'modal_hoerensagen',
    [
        arrow('Who makes the claim?', [
            ('die anderen', 'sagen:', 'Er soll reich sein.', 'others say'),
            ('er selbst', 'sagt:', 'Er will reich sein.', 'he claims — I doubt it'),
        ], ('who?', 'the claim')),
        table('Now, then, passive', ['', 'soll', 'will'], [
            ['now', 'Er *soll* krank *sein*.', 'Er *will* krank *sein*.'],
            ['then', 'Sie *soll* den Unfall *gesehen haben*.', 'Sie *will* den Unfall *gesehen haben*.'],
            ['passive', 'Das Bild *soll* gestohlen *worden sein*.', 'Er *will* nicht gewarnt *worden sein*.'],
        ]),
        box('watch', 'Rumour or demand?',
            '*Der Minister soll zurücktreten* usually means someone demands it. For the rumour: *soll zurückgetreten sein* or *soll zurücktreten wollen*.'),
        words('Words for the practice page', [
            ('man sagt', 'people say'), ('angeblich', 'supposedly'), ('er behauptet', 'he claims'), ('das Gemälde', 'painting'),
            ('im Krieg', 'in the war'), ('der Händler', 'dealer'), ('legal', 'legally'), ('erworben', 'acquired'),
            ('der Zeuge', 'witness'), ('der Täter', 'culprit'), ('erkannt', 'recognised'), ('der Marathon', 'marathon'),
            ('gelaufen', 'run'), ('die Insel', 'island'), ('überfüllt', 'overcrowded'), ('zurückgetreten', 'resigned'),
            ('von nichts', 'of nothing'), ('gewusst', 'known'), ('reich', 'rich'), ('hat gesehen', 'saw'),
        ], 4),
    ],
    [
        gaps('soll or will?', 'Write soll or will.', [
            ('Man sagt, die Insel ist im Sommer überfüllt. → Die Insel', 'im Sommer überfüllt sein.', 'soll'),
            ('Er behauptet, er hat von nichts gewusst. → Er', 'von nichts gewusst haben.', 'will'),
            ('Der Zeuge sagt, er hat den Täter erkannt. → Der Zeuge', 'den Täter erkannt haben.', 'will'),
            ('Angeblich ist der Minister zurückgetreten. → Der Minister', 'zurückgetreten sein.', 'soll'),
        ]),
        write('In one sentence', 'Say it with soll and the passive.', [
            ('Man sagt, das Gemälde wurde im Krieg gestohlen.', 'Das Gemälde soll im Krieg gestohlen worden sein.'),
        ], 1),
    ],
    ['pass on a rumour with soll',
     'report a doubtful claim with will',
     'say it about the past and in the passive'],
))

# ---- 4 · Konjunktiv I im Bericht --------------------------------------------------------------
spreads.append(spread(
    'konj1', 'so heißt es, sie seien …', 'Reporting in the Konjunktiv I',
    'The reporter states in the indicative and passes on in the Konjunktiv I: er habe, sie sei, man könne.',
    Q + 'konjunktiv1_indirekte_rede',
    [
        flow('Is the Konjunktiv I clearly different?', q('Does it look like the normal form?',
                                                         a('use the Konjunktiv II', 'sie haben → sie hätten'),
                                                         a('keep the Konjunktiv I', 'er hat → er habe'))),
        table('Everything in one past', ['direct', 'reported'], [
            ['„Ich sah ihn.“ · „Ich habe ihn gesehen.“', 'er *habe* ihn gesehen'], ['„Ist die Finanzierung gesichert?“', 'ob die Finanzierung gesichert *sei*'],
            ['„Schonen Sie sich!“', 'er *solle* sich schonen'], ['„Fassen Sie sich bitte kurz.“', 'man *möge* sich kurz fassen'],
        ]),
        box('watch', 'Not in a formal text', '*er hätte, es wäre* where *er habe, es sei* exist — speech does it, a report shouldn’t.'),
        words('Words for the practice page', [
            ('die Freiwilligen', 'volunteers'), ('die Nachbarn', 'neighbours'), ('angewiesen auf', 'dependent on'),
            ('die Unterstützung', 'support'), ('das Ehrenamt', 'volunteering'), ('der Sozialstaat', 'welfare state'),
            ('ersetzen', 'to replace'), ('ergänzen', 'to complement'), ('einsam', 'lonely'), ('das Einkommen', 'income'),
            ('die Jungen', 'young people'), ('nachkommen', 'to follow on'), ('der Fahrer', 'driver'), ('die Befragten', 'respondents'),
            ('das Vertrauen', 'trust'), ('kaum', 'hardly'), ('die Finanzierung', 'funding'), ('gesichert', 'secured'),
            ('gab an', 'stated'), ('so heißt es', 'it is said'), ('seltener', 'less often'),
            ('sie gaben an', 'they stated'),
            ('wer sich einbringt', 'whoever gets involved'),
        ], 4),
    ],
    [
        gaps('Reported', 'Write the verb in the Konjunktiv I — or II where I looks normal.', [
            ('Er sagte, er', 'keine Zeit. (haben)', 'habe'),
            ('Der Zeuge sagte, er', 'den Fahrer gesehen. (haben)', 'habe'),
            ('Die Befragten gaben an, sie', 'kaum Vertrauen. (haben)', 'hätten'),
            ('Sie fragte, ob die Finanzierung gesichert', '. (sein)', 'sei'),
        ]),
        circle('A Saturday in the Nordviertel', 'Listen to the report. Circle what you hear.', [
            ('Jeden Samstag treffen sich rund', ['dreißig', 'dreizehn'], 'Freiwillige.', 'dreißig'),
            ('Die meisten, so heißt es, seien selbst auf Unterstützung angewiesen', ['gewesen', 'geworden'], '.', 'gewesen'),
            ('Wer sich regelmäßig einbringt, fühlt sich seltener', ['einsam', 'müde'], '.', 'einsam'),
            ('Ehrenamt kann den Sozialstaat ergänzen, aber nicht', ['ersetzen', 'finanzieren'], '.', 'ersetzen'),
        ], 1) | {'listen': True},
    ],
    ['report with er habe, sie sei, man könne',
     'switch to the Konjunktiv II where I looks normal',
     'tell what a reporter states from what he passes on'],
    listen=Q + 'hoeren_reportage',
))

# ---- 5 · Abschwächen ----------------------------------------------------------------------------
spreads.append(spread(
    'abschwaechen', 'Das ist, gelinde gesagt, überraschend', 'Saying it at the right strength',
    'In German professional speech, “nicht ganz überzeugend” means “wrong”. The hedge is a sign of seriousness, not weakness.',
    Q + 'sprechen_abschwaechen',
    [
        table('Blunt → hedged', ['blunt', 'hedged'], [
            ['Das ist falsch.', 'Das dürfte kaum zutreffen.'], ['Das stimmt nicht.', 'Ich wage zu bezweifeln, dass das stimmt.'],
            ['Sie haben unrecht.', 'In gewisser Weise haben Sie recht, aber …'], ['Das ist ein Skandal.', 'Das ist, gelinde gesagt, überraschend.'],
        ]),
        flow('One hedge or two?', q('Is there already a modal like dürfte?',
                                    a('no adverb', 'Das dürfte stimmen.'), a('one adverb is fine', 'Das stimmt vermutlich.')),
             note='Not: Vermutlich dürfte das stimmen.'),
        words('Words for the practice page', [
            ('irren · ich irre mich', 'to be wrong'), ('ausschließen', 'to rule out'), ('korrigiert', 'corrected'),
            ('den Eindruck gewinnen', 'to get the impression'), ('feststand', 'was fixed'), ('zutreffen', 'to be true'),
            ('der Ansatz', 'approach'), ('tragfähig', 'viable'), ('mit Verlaub', 'with respect'), ('die Wahrheit', 'truth'),
            ('festlegen', 'to commit'), ('ungern', 'reluctantly'), ('die Daten', 'data'), ('komplizierter', 'more complicated'),
            ('es scheint mir', 'it seems to me'), ('durchaus', 'quite'),
            ('in diesem Punkt', 'on this point'),
        ], 4),
    ],
    [
        gaps('The hedge', 'Write the missing word.', [
            ('Es könnte', 'sein, dass ich mich in diesem Punkt irre.', 'durchaus'),
            ('Ich würde nicht', ', dass die Zahlen noch korrigiert werden.', 'ausschließen'),
            ('Man könnte den', 'gewinnen, dass die Entscheidung schon feststand.', 'Eindruck'),
            ('Ich', 'zu bezweifeln, dass dieser Ansatz tragfähig ist.', 'wage'),
            ('Da möchte ich mich ungern', '.', 'festlegen'),
        ]) | {'listen': True},
        write('Soften it', 'Say it at the right strength.', [
            ('Das ist falsch.', 'Das dürfte kaum zutreffen.'),
            ('Ihr Ansatz ist schlecht.', 'Ich wage zu bezweifeln, dass dieser Ansatz tragfähig ist.'),
        ], 1),
    ],
    ['turn a blunt claim into a hedged one',
     'hear what understatement really means',
     'use one hedge, not two'],
    listen=Q + 'sprechen_abschwaechen',
))

# ---- 6 · Sie hätten … sollen --------------------------------------------------------------------
spreads.append(spread(
    'kritik', 'Das hätte vermieden werden können', 'Criticism after the fact — and what to do next',
    'Sie hätten uns informieren müssen. Künftig sollten Sie … A good complaint always pairs the two.',
    Q + 'konj2_kritik',
    [
        slots('The cluster at the end', [
            (sl('Sie', 'hätten!', 'früher', 'kommen sollen.!'), 'should have'),
            (sl('Das', 'hätte!', 'vermieden', 'werden können.!'), 'passive inside'),
            (sl('…, weil', 'der Bericht', 'hätte!', 'geschickt werden sollen.'), 'in a clause: hätte first'),
        ]),
        table('Keep it off the person', ['direct', 'softer'], [
            ['Sie hätten nachfragen sollen.', '*An Ihrer Stelle hätte ich* nachgefragt.'],
            ['Sie haben das falsch gemacht.', '*Es wäre ratsam gewesen*, die Frist zu klären.'],
            ['Du hast nicht informiert.', '*Man hätte* die Kunden informieren müssen.'],
        ]),
        words('Words for the practice page', [
            ('die Kunden', 'customers'), ('rechtzeitig', 'in time'), ('die Frist', 'deadline'), ('klären', 'to clarify'),
            ('nachfragen', 'to ask'), ('der Bericht', 'report'), ('der Fehler', 'mistake'), ('entdeckt', 'discovered'),
            ('die Prüfung', 'check'), ('die Unterlagen', 'documents'), ('vollständig', 'complete'), ('eingereicht', 'submitted'),
            ('künftig', 'in future'), ('der Versand', 'dispatch'), ('ratsam', 'advisable'), ('erwartet', 'expected'),
            ('bei einer zweiten Prüfung', 'with a second check'),
        ], 4),
    ],
    [
        gaps('The cluster', 'Write the two words at the end.', [
            ('Man hätte die Kunden rechtzeitig informieren', '. (müssen)', 'müssen'),
            ('Der Fehler hätte bei einer zweiten Prüfung entdeckt werden', '. (können)', 'können'),
            ('Die Unterlagen hätten vollständig eingereicht', '. (werden, müssen)', 'werden müssen'),
            ('Es wäre ratsam', ', die Frist vorher zu klären.', 'gewesen'),
        ]),
        write('Criticise, then recommend', 'Write the criticism with hätten … sollen, then a recommendation with künftig.', [
            ('Sie haben den Bericht zu spät geschickt.', 'Sie hätten den Bericht früher schicken sollen. Künftig sollten Sie ihn rechtzeitig schicken.'),
        ], 1),
    ],
    ['say what should have happened: hätte … sollen',
     'put a passive inside: hätte vermieden werden können',
     'keep the criticism off the person'],
))

# ---- 7 · Partikeln und Ironie --------------------------------------------------------------------
spreads.append(spread(
    'ironie', 'Na, das ist ja großartig gelaufen', 'Particles, tone — and irony',
    'Hast du etwa gelogen? Fass das JA nicht an! Das ist ja großartig. The words say one thing; the particle and the tone say another.',
    Q + 'modalpartikeln',
    [
        table('What the particle adds', ['particle', 'in', 'like this'], [
            ['etwa', 'a question that hopes for no', 'Hast du *etwa* gelogen?'], ['denn', 'an impatient question', 'Wo bleibst du *denn*?'],
            ['JA (stressed)', 'a warning', 'Fass das *JA* nicht an!'], ['bloß · nur', 'a wish, an alarm', 'Wenn ich *nur* mehr Zeit hätte!'],
        ]),
        flow('Praise or irony?', q('Is the tone flat and slow?',
                                   a('irony: it went badly', 'Das ist ja großartig gelaufen.'), a('real praise', 'Das ist großartig!')),
             note='With people you don’t know well, use understatement instead: nicht ganz optimal.'),
        words('Words for the practice page', [
            ('gelogen', 'lied'), ('bleiben · wo bleibst du', 'to be (late)'), ('anfassen · fass … an', 'to touch'), ('der Held', 'hero'),
            ('früh dran', 'early'), ('hinbekommen', 'to manage'), ('begeistert', 'thrilled'), ('heiter', 'cheerful'),
            ('Schön wär’s', 'if only'), ('der Salat', 'mess (here)'), ('mitzuteilen', 'to tell'), ('überaus', 'extremely'),
            ('na toll', 'oh great'), ('optimal', 'ideal'), ('das Problem', 'problem'), ('bekannt', 'known'), ('vorbei', 'by'),
            ('ernst gemeint', 'meant seriously'),
            ('ironisch', 'ironic'),
            ('zu spät kommen', 'to be late'),
        ], 4),
    ],
    [
        circle('Which particle?', 'Circle the particle that fits.', [
            ('Hast du', ['etwa', 'mal'], 'gelogen?', 'etwa'), ('Wo bleibst du', ['denn', 'ruhig'], '?', 'denn'),
            ('Komm doch', ['mal', 'etwa'], 'vorbei!', 'mal'), ('Wenn ich', ['nur', 'denn'], 'mehr Zeit hätte!', 'nur'),
            ('Das Problem ist', ['ja', 'etwa'], 'seit Jahren bekannt.', 'ja'),
        ], 1),
        circle('Meant or not?', 'Listen. Does the speaker mean it? Circle.', [
            ('Na, das ist ja großartig gelaufen.', ['ernst gemeint', 'ironisch'], '', 'ironisch'),
            ('Du bist aber früh dran. (zu jemandem, der zu spät kommt)', ['ernst gemeint', 'ironisch'], '', 'ironisch'),
            ('Das ist großartig!', ['ernst gemeint', 'ironisch'], '', 'ernst gemeint'),
        ], 1) | {'listen': True},
    ],
    ['use etwa, denn, bloß and a stressed JA',
     'hear irony in a flat tone',
     'criticise with understatement instead'],
    listen=Q + 'sprechen_ironie',
))

# ---- Review 1 · topics 1–7 -----------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–7', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        gaps('How sure — and who says so', 'Write the missing word.', [
            ('Die Straße ist nass – es muss geregnet', '.', 'haben'),
            ('Bei dem Wetter', 'der Zug Verspätung haben. (probably)', 'dürfte'),
            ('Man sagt, er ist reich. → Er', 'reich sein.', 'soll'),
            ('Er behauptet, er hat nichts gewusst. → Er', 'nichts gewusst haben.', 'will'),
        ]),
    ],
    [
        gaps('Reporting and criticising', 'Write the missing word.', [
            ('Er sagte, er', 'keine Zeit. (haben)', 'habe'),
            ('Das', 'kaum zutreffen. (muss or dürfte?)', 'dürfte'),
            ('Man hätte die Kunden informieren', '.', 'müssen'),
            ('Hast du', 'gelogen? Das glaube ich nicht!', 'etwa'),
        ]),
    ],
))

# ==== Part 2 · Words and forms ==============================================================

# ---- 8 · be-, ver-, ent- ---------------------------------------------------------------------
spreads.append(spread(
    'vorsilben', 'beantworten, verlaufen, entkommen', 'Prefixes that never split',
    'be-, ver-, er-, ent-, zer-, miss-: never stressed, never split off, no ge- — and each one tells you roughly what the verb means.',
    Q + 'wortbildung_vor',
    [
        build('What the prefix adds', [
            ([('be', 'joint'), 'antworten'], 'beantworten', 'be-: aims at an object'),
            ([('ver', 'joint'), 'laufen'], 'sich verlaufen', 'ver-: wrongly, away'),
            ([('er', 'joint'), 'reichen'], 'erreichen', 'er-: achieves'),
            ([('ent', 'joint'), 'kommen'], 'entkommen', 'ent-: away from'),
            ([('zer', 'joint'), 'brechen'], 'zerbrechen', 'zer-: to pieces'),
            ([('miss', 'joint'), 'verstehen'], 'missverstehen', 'miss-: wrongly'),
        ]),
        slots('be- swallows the little word', [
            (sl('Ich antworte', 'auf die Frage.'), None), (sl('Ich', 'beantworte!', 'die Frage.'), 'no auf: an object'),
        ], note='No ge- in the past form: beantwortet, erreicht, entkommen — never geerreicht.'),
        words('Words for the practice page', [
            ('die Frage', 'question'), ('der Antrag', 'application'), ('bearbeiten', 'to process'), ('das Ziel', 'goal'),
            ('der Gefangene', 'prisoner'), ('die Vase', 'vase'), ('zersprang', 'shattered'), ('der Plan', 'plan'),
            ('misslang', 'failed'), ('die Stadt', 'city'), ('das Hotel', 'hotel'), ('verbessern', 'to improve'),
            ('verlängern', 'to extend'), ('entdecken', 'to discover'), ('der Vertrag', 'contract'),
            ('misslungen', 'failed'),
        ], 4),
    ],
    [
        gaps('Build the verb', 'Write the verb with its prefix, in the form the sentence needs.', [
            ('Ich muss die Frage noch', '. (antworten, be-)', 'beantworten'),
            ('Er hat sich in der Stadt', '. (laufen, ver-)', 'verlaufen'),
            ('Sie hat ihr Ziel', '. (reichen, er-)', 'erreicht'),
            ('Der Gefangene konnte', '. (kommen, ent-)', 'entkommen'),
            ('Die Vase', '. (springen, zer-, past)', 'zersprang'),
            ('Wir müssen den Vertrag', '. (länger machen, ver-)', 'verlängern'),
        ]),
        circle('ge- or not?', 'Circle the right past form.', [
            ('Sie hat ihr Ziel', ['erreicht', 'geerreicht'], '.', 'erreicht'), ('Der Plan ist', ['misslungen', 'gemisslungen'], '.', 'misslungen'),
        ], 1),
    ],
    ['read be-, ver-, er-, ent-, zer-, miss-',
     'use be- instead of a verb with a little word',
     'make the past form without ge-'],
))

# ---- 9 · úmfahren, umfáhren --------------------------------------------------------------------
spreads.append(spread(
    'praefixe', 'den Pfosten umfahren — die Stadt umfahren', 'Same spelling, two verbs',
    'úmfahren: you knock it down. umfáhren: you drive round it. One ge- changes the accident report.',
    Q + 'praefixe',
    [
        table('Literal and split, or figurative and fixed', ['separable: stress on the prefix', 'inseparable: stress on the stem'], [
            ['úmfahren · hat *umgefahren* (knock down)', 'umfáhren · hat *umfahren* (drive round)'],
            ['wíederholen · holt wieder (fetch back)', 'wiederhólen · wiederholt (repeat)'],
            ['dúrchschauen · schaut durch (look through)', 'durchscháuen · durchschaut (see through)'],
            ['übersetzen · setzt über (ferry across)', 'übersétzen · übersetzt (translate)'],
            ['únterstellen · stellt unter (shelter)', 'unterstéllen · unterstellt (insinuate)'],
        ]),
        flow('Split or not?', q('Can you picture the movement?',
                                a('separable, with ge-', 'Er hat den Pfosten umgefahren.'), a('inseparable, no ge-', 'Er hat die Stadt umfahren.'))),
        words('Words for the practice page', [
            ('der Pfosten', 'post'), ('die Fähre', 'ferry'), ('der Trick', 'trick'), ('die Akten', 'files'), ('das Rad', 'bike'),
            ('die Absicht', 'intention'), ('der Einwand', 'objection'), ('das Geschäft', 'business'), ('der Sohn', 'son'),
            ('übergehen', 'to pass to · to ignore'), ('hinterlassen', 'to leave behind'), ('sofort', 'at once'),
            ('übergesetzt', 'ferried across'),
            ('übergangen', 'ignored'),
        ], 4),
    ],
    [
        circle('Which past form?', 'Circle the right form.', [
            ('Er ist gegen den Pfosten gefahren und hat ihn', ['umgefahren', 'umfahren'], '.', 'umgefahren'),
            ('Wegen des Staus hat er die Stadt', ['umfahren', 'umgefahren'], '.', 'umfahren'),
            ('Sie hat den Trick sofort', ['durchschaut', 'durchgeschaut'], '.', 'durchschaut'),
            ('Er hat den Brief ins Deutsche', ['übersetzt', 'übergesetzt'], '.', 'übersetzt'),
            ('Wir sind mit der Fähre', ['übergesetzt', 'übersetzt'], '.', 'übergesetzt'),
            ('Sie hat den Einwand einfach', ['übergangen', 'übergegangen'], '.', 'übergangen'),
        ], 1),
    ],
    ['tell separable from inseparable by the meaning',
     'make the right past form: umgefahren or umfahren',
     'read the stress'],
))

# ---- 10 · -heit, -keit, -los, -frei ----------------------------------------------------------
spreads.append(spread(
    'nachsilben', 'die Durchführbarkeit', 'Word families and their endings',
    'durchführen → durchführbar → die Durchführbarkeit. One root, a family of words — and the ending tells you the gender.',
    Q + 'wortbildung_nach',
    [
        build('A word family', [
            (['durchführ', ('bar', 'suffix')], 'durchführbar', 'can be done'), (['durchführbar', ('keit', 'suffix')], 'die Durchführbarkeit', ''),
            (['Wissen', ('schaft', 'suffix')], 'die Wissenschaft', ''), (['wissenschaft', ('lich', 'suffix')], 'wissenschaftlich', ''),
        ]),
        flow('-heit or -keit?', q('Does it end in -ig, -lich, -bar or -sam?',
                                  a('-keit', 'möglich → die Möglichkeit · einsam → die Einsamkeit'), a('-heit', 'frei → die Freiheit · gelassen → die Gelassenheit'))),
        table('Easy to mix up', ['', '~'], [
            ['kindlich ↔ kindisch', 'childlike ↔ childish'], ['arbeitslos ↔ alkoholfrei', '-los: missing · -frei: free of (good)'],
        ]),
        words('Words for the practice page', [
            ('die Neugier', 'curiosity'), ('die Getränke', 'drinks'), ('der Tag', 'day'), ('wolkenlos', 'cloudless'),
            ('gleichgültig', 'indifferent'), ('gelassen', 'calm'), ('mehrsprachig', 'multilingual'), ('genau', 'precise'),
            ('verhältnismäßig', 'relatively'), ('ruhig', 'quiet'), ('traumhaft', 'dreamlike'), ('das Projekt', 'project'),
            ('die Hoffnung', 'hope'), ('stressfrei', 'stress-free'),
            ('betrachten · betrachtete', 'to look at'),
            ('der Alkohol', 'alcohol'),
            ('ein traumhafter Tag', 'a dreamlike day'),
            ('ein ruhiger Tag', 'a quiet day'),
            ('nicht negativ', 'not negative'),
        ], 4),
    ],
    [
        gaps('Build the word', 'Write the word in brackets in the form the sentence needs.', [
            ('Wir prüfen die', 'des Projekts. (durchführbar)', 'Durchführbarkeit'),
            ('Ihre', 'hat mich überrascht. (gleichgültig)', 'Gleichgültigkeit'),
            ('Er reagierte mit großer', '. (gelassen)', 'Gelassenheit'),
            ('Sie betrachtete alles mit einer', 'Neugier. (Kind, nicht negativ)', 'kindlichen'),
            ('Wir servieren nur', 'Getränke. (ohne Alkohol)', 'alkoholfreie'),
            ('ein', ', traumhafter, verhältnismäßig ruhiger Tag (ohne Wolken)', 'wolkenloser'),
        ]),
        sort_ex('-heit or -keit?', 'Write each word in its column.', ['-heit', '-keit'], [
            ('Frei-', 0), ('Möglich-', 1), ('Krank-', 0), ('Einsam-', 1), ('Gelassen-', 0), ('Mehrsprachig-', 1),
        ]),
    ],
    ['build a word family from one root',
     'choose -heit or -keit',
     'tell kindlich from kindisch, -los from -frei'],
))

# ---- 11 · die Eltern, die Studierenden -------------------------------------------------------
spreads.append(spread(
    'numerus', 'Liebe Studierende!', 'Only plural, only singular — and words for everyone',
    'die Eltern sind, das Obst ist, die Museen, die Studierenden: number, foreign plurals and gender-neutral words.',
    Q + 'numerus_gender',
    [
        table('Only one number', ['only plural', 'only singular'], [
            ['die Eltern · die Leute · die Ferien', 'das Obst · das Gemüse · das Gepäck'], ['die Kosten · die Möbel · die Lebensmittel', 'der Verkehr · der Lärm · das Wissen'],
        ], 'One piece of furniture: ein Möbelstück.'),
        build('Foreign plurals', [
            (['Muse', ('en', 'suffix')], 'die Museen', 'das Museum'), (['Them', ('en', 'suffix')], 'die Themen', 'das Thema'),
            (['Praktik', ('a', 'suffix')], 'die Praktika', 'das Praktikum'), (['Hotel', ('s', 'suffix')], 'die Hotels', 'das Hotel'),
        ]),
        table('Words for everyone', ['way', 'like this'], [
            ['-ende', 'die Studierenden · die Mitarbeitenden · die Teilnehmenden'], ['-kraft · -person', 'die Lehrkraft · die Ansprechperson'],
            ['a group', 'das Personal · die Belegschaft'], ['both', 'Kolleginnen und Kollegen'],
        ]),
        words('Words for the practice page', [
            ('vorbei', 'over'), ('gepackt', 'packed'), ('der Flur', 'hall'), ('die Daten', 'data'), ('die Websites', 'websites'),
            ('behandelt', 'covered'), ('die Pünktlichkeit', 'punctuality'), ('bitten um', 'to ask for'), ('die Fachkraft', 'skilled worker'),
            ('liebe', 'dear'), ('sehr geehrte', 'dear (formal)'), ('ein Studierender', 'a student (m)'),
        ], 4),
    ],
    [
        gaps('One or many?', 'Write ist or sind.', [
            ('Die Ferien', 'vorbei.', 'sind'), ('Das Gepäck', 'gepackt.', 'ist'), ('Die Möbel', 'noch im Flur.', 'sind'),
            ('Das Obst', 'frisch.', 'ist'), ('Die Kosten', 'hoch.', 'sind'),
        ]),
        gaps('Plural and neutral', 'Write the word in brackets in the form the sentence needs.', [
            ('In den', 'der Stadt werden drei Themen behandelt. (Museum)', 'Museen'),
            ('Die', 'bitten alle um Pünktlichkeit. (Lehrkraft, plural)', 'Lehrkräfte'),
            ('Liebe', ', … (studieren)', 'Studierende'),
            ('Sehr geehrte Kolleginnen und', ', … ', 'Kollegen'),
        ]),
    ],
    ['know die Eltern sind, das Obst ist',
     'make foreign plurals: Museen, Themen, Praktika',
     'address a group neutrally'],
))

# ---- 12 · Redewendungen --------------------------------------------------------------------
spreads.append(spread(
    'redewendungen', 'auf die lange Bank schieben', 'Idioms of commentary',
    'A commentator who writes that a reform was “auf die lange Bank geschoben” is criticising, not reporting. Never translate the image.',
    Q + 'redewendungen',
    [
        table('The picture and what it means', ['idiom', '~'], [
            ['etwas auf die lange Bank schieben', 'keep putting it off'], ['etwas ins Rollen bringen', 'set it in motion'],
            ['auf dem Holzweg sein', 'be on the wrong track'], ['etwas unter den Teppich kehren', 'hush it up'],
            ['jemandem reinen Wein einschenken', 'tell the plain truth'], ['Öl ins Feuer gießen', 'make it worse'],
            ['den Nagel auf den Kopf treffen', 'hit the nail on the head'], ['ins Fettnäpfchen treten', 'put your foot in it'],
        ]),
        flow('Can I say it in a meeting?', q('Is it a commentary idiom?',
                                             a('yes', 'auf den Punkt bringen · ins Rollen bringen'), a('keep it for friends', 'Das ist nicht mein Bier.')),
             note='One idiom per talk reads as command; three read as showing off.'),
        words('Words for the practice page', [
            ('die Reform', 'reform'), ('jahrelang', 'for years'), ('geschoben', 'pushed'), ('der Stadtrat', 'city council'),
            ('die Debatte', 'debate'), ('längst überfällig', 'long overdue'), ('der Fehler', 'mistake'), ('kehren', 'to sweep'),
            ('die Verwaltung', 'administration'), ('sich kein Bein ausreißen', 'not to bust a gut'), ('aussitzen', 'to sit out'),
            ('im selben Boot sitzen', 'to be in the same boat'), ('die Mieter', 'tenants'), ('gebracht', 'brought'),
            ('der Antrag', 'motion'), ('einschenken', 'to pour'), ('glaubt', 'believes'), ('lasse sich', 'can be'),
            ('mit seinem Antrag', 'with his motion'),
            ('verstecken', 'to hide'),
        ], 4),
    ],
    [
        gaps('The picture', 'Write the noun that carries the image.', [
            ('Die Reform wurde jahrelang auf die lange', 'geschoben. (= immer wieder verschoben)', 'Bank'),
            ('Statt den Fehler unter den', 'zu kehren, … (= verstecken)', 'Teppich'),
            ('… sollte man den Kunden reinen', 'einschenken. (= die Wahrheit sagen)', 'Wein'),
            ('Damit haben Sie den', 'auf den Kopf getroffen. (= genau so ist es)', 'Nagel'),
        ]),
        gaps('Heard it?', 'Listen to the dictation and write the missing words.', [
            ('Mit seinem Antrag hat der Stadtrat eine Debatte ins', 'gebracht.', 'Rollen'),
            ('Wer glaubt, das Problem lasse sich einfach aussitzen, ist auf dem', '.', 'Holzweg'),
            ('Am Ende sitzen Stadt und Mieter ja doch im selben', '.', 'Boot'),
        ]) | {'listen': True},
    ],
    ['understand the idioms of commentary',
     'learn each idiom with its verb',
     'choose one for a formal talk'],
    listen=Q + 'diktat_idiom',
))

# ---- 13 · mit dessen Hilfe, worauf ---------------------------------------------------------
spreads.append(spread(
    'relativ', 'die Professorin, mit deren Hilfe …', 'Relative clauses at full stretch',
    'mit dessen Hilfe, auf deren Unterstützung, …, worauf wir gehofft hatten: the joints of long written sentences.',
    Q + 'relativ_advanced',
    [
        slots('Little word, then dessen or deren, then the noun', [
            (sl('der Autor,', 'mit', 'dessen!', 'Hilfe', 'ich das Buch schrieb'), 'not: mit der Hilfe dessen'),
            (sl('die Kollegen,', 'auf', 'deren!', 'Unterstützung', 'ich zähle'), None),
        ]),
        table('A comment on the whole sentence', ['clause', 'because'], [
            ['…, *was* alle überraschte', 'the whole fact'], ['…, *womit* niemand gerechnet hatte', 'rechnen mit'],
            ['…, *worauf* wir gehofft hatten', 'hoffen auf'], ['…, *wofür* ich dankbar bin', 'dankbar für'],
        ]),
        words('Words for the practice page', [
            ('die Unterstützung', 'support'), ('zustande kommen', 'to come about'), ('zählen auf', 'to count on'),
            ('rechnen mit', 'to expect'), ('hoffen auf', 'to hope for'), ('absagen', 'to cancel'), ('enttäuschte', 'disappointed'),
            ('stammen', 'to come from'), ('die Professorin', 'professor'), ('dankbar', 'grateful'), ('die Antwort', 'answer'),
            ('aussteht', 'is still due'), ('der Autor', 'author'), ('das Buch', 'book'),
        ], 4),
    ],
    [
        gaps('Which relative word?', 'Write the relative word — with its little word where needed.', [
            ('Das ist die Professorin, mit', 'Unterstützung das Projekt zustande kam.', 'deren'),
            ('der Autor, mit', 'Hilfe ich das Buch schrieb', 'dessen'),
            ('Sie sagte die Konferenz ab,', 'viele enttäuschte.', 'was'),
            ('…,', 'niemand gerechnet hatte.', 'womit'),
            ('Er hat bestanden,', 'wir alle gehofft hatten.', 'worauf'),
            ('das Land,', 'ich stamme', 'woher'),
        ]),
    ],
    ['use mit dessen Hilfe, auf deren Unterstützung',
     'comment on a whole sentence with was, womit, worauf',
     'choose wo, wohin, woher for places'],
))

# ---- Review 2 · topics 8–13 ----------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 8–13', 'Words and forms, all at once. No looking back until you have done both pages.',
    Q + 'bigtext_nachbar',
    [
        gaps('Words', 'Write the missing word.', [
            ('Sie hat ihr Ziel', '. (reichen, er-)', 'erreicht'),
            ('Er ist gegen den Pfosten gefahren und hat ihn', '.', 'umgefahren'),
            ('Ihre', 'hat mich überrascht. (gleichgültig)', 'Gleichgültigkeit'),
            ('Die Kosten', 'hoch.', 'sind'),
        ]),
    ],
    [
        gaps('Phrases', 'Write the missing word.', [
            ('Die Reform wurde auf die lange', 'geschoben.', 'Bank'),
            ('der Autor, mit', 'Hilfe ich das Buch schrieb', 'dessen'),
            ('Er hat bestanden,', 'wir gehofft hatten.', 'worauf'),
            ('Liebe', ', … (studieren)', 'Studierende'),
        ]),
    ],
))

# ==== Part 3 · Text and register ==============================================================

# ---- 14 · Textkohäsion ----------------------------------------------------------------------
spreads.append(spread(
    'kohaesion', 'Ein solcher Schritt wäre teuer', 'Holding a text together',
    'das Problem → diese Schwierigkeit → der Punkt: don’t repeat the noun, point back to it — and start each sentence with what is known.',
    Q + 'kohaesion',
    [
        build('Point back without repeating', [
            (['das Problem'], 'diese Schwierigkeit', 'a synonym'), (['der Tunnel'], 'das Bauwerk', 'a wider word'),
            (['ein Vorgehen'], 'ein solches Vorgehen', 'of this kind'), (['zwei Vorschläge'], 'Ersterer · Letzterer', 'the first · the second'),
        ]),
        table('Linking words', ['does', 'word'], [
            ['confirms', 'tatsächlich · in der Tat'], ['lists', 'zum einen … zum anderen'], ['points forward', 'Folgendes · im Folgenden'],
            ['concedes, then turns', 'gleichwohl · dennoch'],
        ]),
        words('Words for the practice page', [
            ('verschieben', 'to postpone'), ('der Schritt', 'step'), ('teuer', 'expensive'), ('die Kosten stiegen', 'costs rose'),
            ('sich verdoppeln', 'to double'), ('die Energie', 'energy'), ('die Löhne', 'wages'), ('der Tunnel', 'tunnel'),
            ('das Bauwerk', 'structure'), ('die Umleitung', 'diversion'), ('beachten', 'to note'), ('riskant', 'risky'),
            ('die Prüfung', 'exam'), ('der Vorschlag', 'proposal'), ('abgelehnt', 'rejected'), ('angenommen', 'accepted'),
            ('man schlug vor', 'it was proposed'),
            ('plant', 'plans'),
        ], 4),
    ],
    [
        gaps('Point back', 'Write the missing word.', [
            ('Man schlug vor, die Prüfung zu verschieben. Ein', 'Schritt wäre allerdings teuer.', 'solcher'),
            ('Die Kosten stiegen.', 'haben sie sich verdoppelt. (confirms)', 'Tatsächlich'),
            ('', 'wegen der Energie, zum anderen wegen der Löhne.', 'Zum einen'),
            ('Zwei Vorschläge: Ersterer wurde abgelehnt,', 'angenommen.', 'Letzterer'),
            ('Dabei ist', 'zu beachten: … (points forward)', 'Folgendes'),
        ]),
        write('Don’t repeat it', 'Write the second sentence without repeating “der Tunnel”.', [
            ('Die Stadt plant einen Tunnel. Der Tunnel soll 2030 fertig sein.', 'Die Stadt plant einen Tunnel. Das Bauwerk soll 2030 fertig sein.'),
        ], 1),
    ],
    ['point back with ein solcher, Letzterer, a synonym',
     'confirm, list and point forward',
     'start each sentence with what is known'],
))

# ---- 15 · Umformulierung -------------------------------------------------------------------
spreads.append(spread(
    'umformung', 'Die Regeln sind zu beachten', 'One meaning, another grammar',
    'Relative clause ↔ participle, active ↔ passive ↔ substitute, clause ↔ noun phrase: each direction has a fixed procedure.',
    Q + 'umformung_1',
    [
        slots('One rule, three grammars', [
            (sl('Man', 'muss!', 'die Regeln', 'beachten.'), 'active'),
            (sl('Die Regeln', 'müssen!', 'beachtet', 'werden.'), 'passive'),
            (sl('Die Regeln', 'sind!', 'zu beachten.'), 'substitute'),
        ]),
        table('Fold and unfold', ['long', 'short'], [
            ['die Gäste, die von der Firma eingeladen wurden', 'die von der Firma eingeladenen Gäste'],
            ['das Problem, das seit Jahren besteht', 'das seit Jahren bestehende Problem'],
            ['obwohl die Anwohner Widerstand leisteten', 'trotz des Widerstands der Anwohner'],
        ]),
        words('Words for the practice page', [
            ('die Studie', 'study'), ('kürzlich', 'recently'), ('veröffentlicht', 'published'), ('steigen · steigend', 'to rise'),
            ('der Tunnel', 'tunnel'), ('geplant', 'planned'), ('herstellen · hergestellt', 'to make'), ('das Produkt', 'product'),
            ('die Anwohner', 'residents'), ('Widerstand leisten', 'to resist'), ('der Abschluss', 'completion'),
            ('abgeschlossen worden war', 'had been completed'), ('die Reisenden', 'travellers'), ('warten', 'to wait'),
            ('die Firma', 'company'), ('lösen', 'to solve'),
        ], 4),
    ],
    [
        gaps('Rephrase', 'Write the missing part.', [
            ('die Studie, die kürzlich veröffentlicht wurde → die kürzlich', 'Studie', 'veröffentlichte'),
            ('die Kosten, die ständig steigen → die ständig', 'Kosten', 'steigenden'),
            ('der von der Stadt geplante Tunnel → der Tunnel,', 'von der Stadt geplant wird', 'der'),
            ('Die Firma stellt das Produkt her. → Das Produkt wird von der Firma', '.', 'hergestellt'),
            ('Das Problem kann gelöst werden. → Das Problem', 'sich lösen.', 'lässt'),
            ('nach Abschluss der Prüfung →', 'die Prüfung abgeschlossen worden war', 'nachdem'),
        ]),
    ],
    ['turn a relative clause into a participle and back',
     'move between active, passive and substitute',
     'fold a clause into a noun phrase'],
))

# ---- 16 · Bericht im Nominalstil ----------------------------------------------------------
spreads.append(spread(
    'bericht', 'wegen fehlender Unterlagen', 'A report in the nominal style',
    'Weil Unterlagen fehlten → wegen fehlender Unterlagen. Shorter, impersonal, exactly what a report should sound like.',
    Q + 'schreiben_nominalstil',
    [
        merge('Clause → phrase', ('the little word', 'the noun phrase'), [
            ('weil …', 'wegen', 'Unterlagen fehlten', 'fehlender Unterlagen', 'wegen fehlender Unterlagen', 'cause'),
            ('obwohl …', 'trotz', 'es regnete stark', 'starker Regenfälle', 'trotz starker Regenfälle', 'concession'),
            ('bevor …', 'vor', 'die Arbeiten begannen', 'Beginn der Arbeiten', 'vor Beginn der Arbeiten', 'time'),
            ('um … zu', 'zur', 'die Kosten senken', 'Senkung der Kosten', 'zur Senkung der Kosten', 'purpose'),
        ], note='No article? The describing word shows the case: fehlender, starker.'),
        box('tip', 'Don’t overdo it', 'Two or three noun chains per paragraph are enough. Four genitives in a row lose the reader.'),
        words('Words for the practice page', [
            ('die Unterlagen', 'documents'), ('fehlen', 'to be missing'), ('die Regenfälle', 'rainfall'), ('die Arbeiten', 'work'),
            ('die Senkung', 'reduction'), ('die Leitungen', 'pipes'), ('die Erneuerung', 'renewal'), ('der Zwischenbericht', 'interim report'),
            ('die Sanierung', 'renovation'), ('die Straße', 'street'), ('verzögern · verzögerte sich', 'to delay'), ('die Materialpreise', 'material prices'),
            ('der Anstieg', 'rise'), ('zurückzuführen auf', 'due to'), ('die Kostenüberschreitung', 'cost overrun'), ('die Anwohner', 'residents'),
            ('der Schutz', 'protection'), ('informieren', 'to inform'),
            ('erneuert', 'renewed'),
        ], 4),
    ],
    [
        gaps('Nominal', 'Write the phrase.', [
            ('Weil Unterlagen fehlten, verzögerte sich der Beginn. →', 'Unterlagen verzögerte sich der Beginn.', 'Wegen fehlender'),
            ('Obwohl es stark regnete, … →', 'Regenfälle …', 'Trotz starker'),
            ('Bevor die Arbeiten begannen, … →', 'Beginn der Arbeiten …', 'Vor'),
            ('Um die Kosten zu senken, … →', 'der Kosten …', 'Zur Senkung'),
            ('Nachdem die Leitungen erneuert worden waren, … →', 'Erneuerung der Leitungen …', 'Nach'),
        ]),
        write('Why so expensive?', 'Write it in one sentence with zurückzuführen auf.', [
            ('Die Kosten sind gestiegen, weil die Materialpreise gestiegen sind.', 'Die Kostenüberschreitung ist auf den Anstieg der Materialpreise zurückzuführen.'),
        ], 1),
    ],
    ['turn weil, obwohl, bevor, um … zu into phrases',
     'show the case without an article: fehlender',
     'write a report in two or three noun chains per paragraph'],
))

# ---- 17 · informell → formell -------------------------------------------------------------
spreads.append(spread(
    'register', 'Wäre es Ihnen möglich, …?', 'From a chat to a formal e-mail',
    'Kannst du mal schicken? → Könnten Sie mir bitte … zukommen lassen? The same message, a different world.',
    Q + 'register_formell',
    [
        table('Chat → formal e-mail', ['chat', 'formal'], [
            ['Kannst du mal … schicken?', 'Könnten Sie mir bitte … zukommen lassen?'], ['Sag Bescheid, ob …', 'Ich bitte Sie, mir mitzuteilen, ob …'],
            ['Ich find’s nicht gut.', 'Ich halte es für bedenklich.'], ['Das geht so nicht.', 'In dieser Form ist das nicht umsetzbar.'],
            ['Das müssen wir klären.', 'Dieser Punkt bedarf der Klärung.'], ['Sorry, dass …', 'Bitte entschuldigen Sie, dass …'],
        ]),
        slots('Five out, five in', [
            ([('du · mal · echt · Sorry · !', 'out')], None), ([{'de': 'Sie · Konjunktiv II · nouns · ist zu … · Mit freundlichen Grüßen', 'tag': 'in', 'hot': True}], None),
        ]),
        words('Words for the practice page', [
            ('die Unterlagen', 'documents'), ('zukommen lassen', 'to send'), ('mitteilen', 'to inform'), ('bedenklich', 'questionable'),
            ('umsetzbar', 'feasible'), ('die Klärung', 'clarification'), ('unverhältnismäßig', 'disproportionately'),
            ('die Kapazitäten', 'capacity'), ('Rückfragen', 'questions'), ('zur Verfügung stehen', 'to be available'),
            ('die Lösung', 'solution'), ('vorgeschlagen', 'proposed'), ('bis Freitag', 'by Friday'), ('jederzeit', 'at any time'),
            ('die vorgeschlagene Lösung', 'the proposed solution'),
        ], 4),
    ],
    [
        gaps('Make it formal', 'Write the missing word.', [
            ('Kannst du mir die Unterlagen schicken? → Wäre es Ihnen', ', mir die Unterlagen zukommen zu lassen?', 'möglich'),
            ('Sag mir Bescheid! → Ich bitte Sie, mir', ', ob …', 'mitzuteilen'),
            ('Find ich nicht gut. → Ich halte die vorgeschlagene Lösung für', '.', 'bedenklich'),
            ('Das müssen wir noch klären. → Dieser Punkt bedarf der', '.', 'Klärung'),
            ('Ruf an, wenn was ist. → Für Rückfragen stehe ich Ihnen gern zur', '.', 'Verfügung'),
        ]),
        circle('Mit freundlichen Grüßen', 'Circle the right layout.', [
            ('Mit freundlichen', ['Grüßen', 'Grüßen,'], '(dann: Anna Berger)', 'Grüßen'),
        ], 1),
    ],
    ['turn a chat into a formal e-mail',
     'leave out du, mal, echt, Sorry',
     'close without a comma'],
))

# ---- 18 · Redemittel ----------------------------------------------------------------------
spreads.append(spread(
    'redemittel', 'Dies dürfte darauf zurückzuführen sein', 'Phrases for the talk, the graph and the position',
    'Learn three sets of fixed phrases until they run without thought — then your attention is free for the content.',
    Q + 'redemittel_vortrag',
    [
        table('Three sets', ['', 'phrases'], [
            ['the talk', 'Mein Vortrag *befasst* sich mit … · Damit komme ich zum nächsten Punkt.'],
            ['the graph', 'Die Daten *stammen* von … · Dies dürfte darauf *zurückzuführen* sein, dass …'],
            ['the position', 'Ich *vertrete* die Auffassung, dass … · Zwar lässt sich einwenden, dass …, *doch* …'],
        ]),
        slots('dass sends the verb to the end', [
            (sl('Ich vertrete die Auffassung,', 'dass', 'die Vorteile', 'überwiegen.!'), 'not: dass überwiegen die Vorteile'),
        ]),
        words('Words for the practice page', [
            ('die Hitze', 'heat'), ('der Hitzeaktionsplan', 'heat action plan'), ('auf dem Papier', 'on paper'), ('die Bäume', 'trees'),
            ('die Dächer', 'roofs'), ('begrünt', 'green'), ('die Akzeptanz', 'acceptance'), ('der Parkplatz', 'parking space'),
            ('ermutigend', 'encouraging'), ('die Gemeinden', 'small towns'), ('stimmt', 'true'), ('stimmt nicht', 'not true'),
            ('nicht gesagt', 'not said'), ('die Ausgangslage', 'starting point'), ('erläutern', 'to explain'), ('das Homeoffice', 'working from home'),
            ('die Kosten', 'costs'), ('langfristig', 'in the long run'), ('gespart', 'saved'), ('hoch', 'high'),
            ('eine bundesweite Umfrage · einer bundesweiten', 'a nationwide survey'),
            ('fast alle größeren Städte', 'almost all larger cities'),
            ('begrünte Dächer', 'green roofs'),
            ('wirksamer', 'more effective'),
            ('die Pläne', 'plans'),
            ('überall', 'everywhere'),
            ('umgesetzt', 'put into practice'),
        ], 4),
    ],
    [
        gaps('The chunk', 'Write the word that makes the chunk work.', [
            ('Mein Vortrag', 'sich mit dem Homeoffice.', 'befasst'),
            ('Die Daten', 'von einer bundesweiten Umfrage.', 'stammen'),
            ('Dies dürfte auf die gestiegenen Kosten', 'sein.', 'zurückzuführen'),
            ('Ich', 'die Auffassung, dass die Vorteile überwiegen.', 'vertrete'),
            ('Zwar lässt sich einwenden, dass die Kosten hoch sind,', 'langfristig wird gespart.', 'doch'),
        ]),
        circle('Heat in the city', 'Listen to the interview. Stimmt, stimmt nicht or nicht gesagt? Circle.', [
            ('Fast alle größeren Städte haben einen Hitzeaktionsplan.', ['stimmt', 'stimmt nicht', 'nicht gesagt'], '', 'stimmt'),
            ('Begrünte Dächer sind wirksamer als Bäume.', ['stimmt', 'stimmt nicht', 'nicht gesagt'], '', 'stimmt nicht'),
            ('Die Pläne werden überall umgesetzt.', ['stimmt', 'stimmt nicht', 'nicht gesagt'], '', 'nicht gesagt'),
            ('Die Akzeptanz ist hoch, solange niemand seinen Parkplatz verliert.', ['stimmt', 'stimmt nicht', 'nicht gesagt'], '', 'stimmt'),
        ], 1) | {'listen': True},
    ],
    ['open, structure and close a talk',
     'describe and explain a graph',
     'state a position with its concession'],
    listen=Q + 'hoeren_interview_stimmt',
))

# ---- 19 · Forum und Beschwerde --------------------------------------------------------------
spreads.append(spread(
    'forum', 'Dem möchte ich entgegenhalten, …', 'A forum post and a formal complaint',
    'Two texts with fixed shapes: the post that takes up a view and counters it, and the complaint that is firm without being rude.',
    Q + 'schreiben_forum_beschwerde',
    [
        slots('The forum post', [
            ([('Mit Interesse habe ich … gelesen.', 'refer'), ('Aus eigener Erfahrung …', 'experience')], None),
            ([('Einige vertreten die Ansicht, …', 'their view'), {'de': 'Dem möchte ich entgegenhalten, …', 'tag': 'yours', 'hot': True}], None),
            ([('Ich würde vorschlagen, …', 'propose'), ('Wie seht ihr das?', 'ask')], None),
        ]),
        table('The complaint: firm, not rude', ['rude', 'firm'], [
            ['Sonst gehe ich zum Anwalt!', 'Andernfalls sehe ich mich gezwungen, rechtliche Schritte einzuleiten.'],
            ['Machen Sie das sofort!', 'Ich fordere Sie daher auf, … bis spätestens 15. März …'],
        ]),
        words('Words for the practice page', [
            ('die Beiträge', 'posts'), ('die Erfahrung', 'experience'), ('entgegenhalten', 'to counter'), ('die Ansicht', 'view'),
            ('der Betrag', 'amount'), ('erstatten', 'to refund'), ('rechtliche Schritte', 'legal action'), ('einleiten', 'to take'),
            ('wenden · ich wende mich', 'to turn'), ('zeitnah', 'prompt'), ('die Rückmeldung', 'reply'), ('erwartet', 'expected'),
            ('die Erreichbarkeit', 'being reachable'), ('selbstverständlich', 'taken for granted'), ('unhöflich', 'rude'),
            ('das Café', 'café'), ('die Freundin', 'friend'), ('der Chef', 'boss'), ('der Samstag', 'Saturday'),
            ('die Kunst des Wartens', 'the art of waiting'), ('gilt als', 'is seen as'), ('antworten', 'to answer'),
            ('die bisherigen Beiträge', 'the posts so far'),
            ('eine zeitnahe Rückmeldung', 'a prompt reply'),
            ('ihrem', 'her'),
            ('er schlägt vor', 'he proposes'),
        ], 4),
    ],
    [
        gaps('The chunks', 'Write the missing word.', [
            ('Mit Interesse habe ich die bisherigen Beiträge', '.', 'gelesen'),
            ('Einige vertreten die Ansicht, …; dem möchte ich', ', dass …', 'entgegenhalten'),
            ('Ich', 'mich an Sie, da …', 'wende'),
            ('Andernfalls sehe ich mich', ', rechtliche Schritte einzuleiten.', 'gezwungen'),
            ('Ich hoffe auf eine zeitnahe', '.', 'Rückmeldung'),
        ]),
        circle('Always reachable?', 'Listen to the column. Circle what you hear.', [
            ('Ständige Erreichbarkeit gilt als', ['selbstverständlich', 'unhöflich'], '.', 'selbstverständlich'),
            ('Die Freundin antwortete im Café ihrem', ['Chef', 'Vater'], '.', 'Chef'),
            ('Es war', ['Samstag', 'Montag'], 'nachmittag.', 'Samstag'),
            ('Der Autor schlägt vor, die Kunst des', ['Wartens', 'Schweigens'], 'neu zu lernen.', 'Wartens'),
        ], 1) | {'listen': True},
    ],
    ['write a forum post that counters a view',
     'write a firm, polite complaint',
     'set a deadline and a consequence'],
    listen=Q + 'lesen_kolumne',
))

# ---- 20 · Literatur -------------------------------------------------------------------------
spreads.append(spread(
    'literatur', 'Den Umschlag noch in der Hand haltend, …', 'Reading literature',
    'Literary German withholds: no name, no content, only images. Translate each image into plain words before you answer.',
    Q + 'lesen_literatur',
    [
        table('Translate the image', ['image', 'plain words'], [
            ['Die Worte fielen wie Steine ins Wasser.', 'heavy words, a lasting effect that keeps spreading'],
            ['Die Dächer verloren ihre Farbe, dann ihre Kanten.', 'what was certain becomes blurred'],
            ['als hätte jemand die Möbel verschoben', 'everything the same — and yet different'],
        ]),
        slots('A participle opens the sentence', [
            (sl('Den Umschlag noch in der Hand', 'haltend,!', 'trat!', 'sie ans Fenster.'), 'while she held it'),
            (sl('Die Knie an die Brust', 'gezogen,!', 'saß!', 'sie da.'), 'with her knees drawn up'),
        ]),
        words('Words for the practice page', [
            ('der Umschlag', 'envelope'), ('der Absender', 'sender'), ('die Schrift', 'handwriting'), ('das Fenster', 'window'),
            ('die Knie', 'knees'), ('die Brust', 'chest'), ('der Regen', 'rain'), ('die Kette', 'chain'), ('zögern', 'to hesitate'),
            ('die Brücke', 'bridge'), ('gesperrt', 'closed'), ('der Lehrer', 'teacher'), ('erkennen', 'to recognise'),
            ('die Tür', 'door'), ('zittern', 'to tremble'), ('sich schämen', 'to be ashamed'), ('das Forsthaus', 'forester’s lodge'),
            ('Mitternacht', 'midnight'), ('klopfen', 'to knock'), ('der Tee', 'tea'), ('die Hände', 'hands'), ('der Brief', 'letter'),
            ('weil', 'because'), ('alt', 'old'),
            ('zwischen den Fingern', 'between her fingers'),
            ('das Fensterbrett', 'windowsill'),
            ('hier oben', 'up here'),
            ('der Empfang', 'reception'),
            ('herein', 'in'),
            ('der Fremde', 'stranger'),
        ], 4),
    ],
    [
        gaps('The participle', 'Write the verb in brackets as a participle.', [
            ('Den Umschlag noch zwischen den Fingern', ', trat sie ans Fenster. (halten)', 'haltend'),
            ('Die Knie an die Brust', ', saß sie auf dem Fensterbrett. (ziehen)', 'gezogen'),
        ]),
        circle('A knock at midnight', 'Listen to the radio play. Circle what you hear.', [
            ('Es ist kurz nach', ['Mitternacht', 'zehn Uhr'], '.', 'Mitternacht'),
            ('Annas Handy hat hier oben keinen', ['Empfang', 'Akku'], '.', 'Empfang'),
            ('Sie lässt ihn herein, weil seine Hände', ['zittern', 'bluten'], '.', 'zittern'),
            ('Der Fremde war früher ihr', ['Lehrer', 'Nachbar'], '.', 'Lehrer'),
        ], 1) | {'listen': True},
    ],
    ['translate an image into plain words',
     'read a participle at the start of a sentence',
     'follow tone and motive in a radio play'],
    listen=Q + 'hoeren_hoerspiel',
))

# ---- Review 3 · topics 14–20 ---------------------------------------------------------------
spreads.append(review(
    'review_3', 'Topics 14–20', 'The last part, all at once. No looking back until you have done both pages.',
    Q + 'sprechen_dialog',
    [
        gaps('Text and register', 'Write the missing word.', [
            ('Ein', 'Schritt wäre allerdings teuer. (of this kind)', 'solcher'),
            ('Das Problem kann gelöst werden. → Das Problem', 'sich lösen.', 'lässt'),
            ('Weil Unterlagen fehlten → wegen', 'Unterlagen', 'fehlender'),
            ('Wäre es Ihnen', ', mir die Unterlagen zukommen zu lassen?', 'möglich'),
        ]),
    ],
    [
        gaps('Phrases', 'Write the missing word.', [
            ('Ich', 'die Auffassung, dass die Vorteile überwiegen.', 'vertrete'),
            ('Andernfalls sehe ich mich', ', rechtliche Schritte einzuleiten.', 'gezwungen'),
            ('Den Umschlag in der Hand', ', trat sie ans Fenster. (halten)', 'haltend'),
        ]),
    ],
))

book = {
    'title': 'Andeuten & Formulieren',
    'cover': 'cp_c1_2_cover',
    'welcome': [
        'This book is the paper half of C1.2. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It has three parts. The first is about how sure you are and who says so: guesses, hearsay, reports, hedges and criticism. The second is about words and forms: prefixes, word families, idioms and long relative clauses. The third is about texts and register: holding a text together, rephrasing, writing formally and reading literature.',
        'It carries on from the earlier books. Words you learned there are not taught again. Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Anna', 'Berger', 'Lorenz', 'Vogt', 'Aydin', 'Sölle', 'Reinhardt', 'Prof', 'Dr', 'Keller', 'Nordviertel',
              'Freitag', 'März', 'Deutsche', 'Herr', 'Frau'],
    'spreads': spreads,
    'overview': {'title': 'C1.2 at a glance', 'blocks': [
        table('How sure — and who says so', ['', 'now', 'then'], [
            ['almost certain', 'er muss krank sein', 'er muss krank gewesen sein'], ['probably', 'er dürfte krank sein', 'er dürfte den Bus verpasst haben'],
            ['possibly', 'er könnte krank sein', 'es könnte geregnet haben'], ['people say', 'er soll reich sein', 'das Bild soll gestohlen worden sein'],
            ['he claims', 'er will reich sein', 'er will nichts gewusst haben'],
        ]),
        table('Criticism after the fact', ['', 'like this'], [
            ['should have', 'Sie hätten früher kommen sollen.'], ['could have been avoided', 'Das hätte vermieden werden können.'],
            ['softer', 'Es wäre ratsam gewesen, … · An Ihrer Stelle hätte ich …'],
        ]),
        table('Chat → formal', ['chat', 'formal'], [
            ['Kannst du mal …?', 'Wäre es Ihnen möglich, … zu …?'], ['Sag Bescheid', 'Ich bitte Sie, mir mitzuteilen'],
            ['Find ich nicht gut', 'Ich halte es für bedenklich'], ['Sorry', 'Bitte entschuldigen Sie'],
        ]),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.', [
            ('der Aktenvernichter', 'shredder', 'cpd_aktenvernichter'), ('die Briefablage', 'letter tray', 'cpd_briefablage'),
            ('der Aktenschrank', 'filing cabinet', 'cpd_aktenschrank'), ('das Stativ', 'tripod', 'cpd_stativ'),
            ('die Leinwand', 'projection screen', 'cpd_leinwand'), ('der Beamer', 'projector', 'cpd_beamer'),
            ('das Megafon', 'megaphone', 'cpd_megafon'), ('das Aquarium', 'aquarium', 'cpd_aquarium'),
            ('der Locher', 'hole punch', 'cpd_locher'), ('der Tacker', 'stapler', 'cpd_tacker'),
            ('das Röntgengerät', 'X-ray scanner', 'cpd_roentgengeraet'), ('die Fluggastbrücke', 'jet bridge', 'cpd_fluggastbruecke'),
            ('der Gepäckwagen', 'luggage trolley', 'cpd_gepaeckwagen'), ('das Triebwerk', 'jet engine', 'cpd_triebwerk'),
            ('die Sonnenbrille', 'sunglasses', 'cpd_sonnenbrille'), ('der Kinderwagen', 'pram', 'cpd_kinderwagen'),
            ('der Reisepass', 'passport', 'cpd_reisepass'), ('die Bordkarte', 'boarding pass', 'cpd_bordkarte'),
            ('der Koffer', 'suitcase', 'cpd_koffer'), ('das Flugzeug', 'plane', 'cpd_flugzeug'),
            ('der Umschlag', 'envelope', 'cpd_umschlag'), ('die Kette', 'door chain', 'cpd_tuerkette'),
            ('die Laterne', 'street lamp', 'cpd_laterne'), ('der Herd', 'stove', 'cpd_herd'),
            ('der Teppich', 'carpet', 'cpd_teppich'), ('die Bank', 'bench', 'cpd_parkbank'),
            ('die Vase', 'vase', 'cpd_vase'), ('der Pfosten', 'post', 'cpd_pfosten'),
            ('die Fähre', 'ferry', 'cpd_faehre'), ('das Gemälde', 'painting', 'cpd_gemaelde'),
            ('das Wappen', 'coat of arms', 'cpd_wappen'), ('der Lederkoffer', 'leather briefcase', 'cpd_lederkoffer'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

kit.write_book(OUT, book)
