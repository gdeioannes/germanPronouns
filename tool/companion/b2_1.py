# Builds assets/content/companion/de_cert_a1/b2_1.json — the B2.1 study companion.
# Run: python -I tool/companion/b2_1.py   (rules: docs/study_companion_guide.md)
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, merge, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_b2_1_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'b2_1.json')
Q = 'quest_b2_1_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ==== Part 1 · Reporting what others say =================================================

# ---- 1 · Gesellschaft & Politik ----------------------------------------------------------
spreads.append(spread(
    'gesellschaft', 'Gesellschaft & Politik', 'The words of the news',
    'Government, laws, taxes, votes: the vocabulary of every news bulletin — each noun with its verb.',
    Q + 'gesellschaft',
    [
        table('The state and its verbs', ['der', 'die', 'das'], [
            ['der Bürger', 'die Regierung', 'das Parlament'], ['der Minister', 'die Wahl', 'das Gesetz'],
            ['der Sprecher', 'die Partei', 'das Einkommen'], ['der Gegner', 'die Mehrheit', 'das Ziel'],
        ], genders=True),
        arrow('Who does what', [
            ('Das Parlament', 'beschließt', 'ein Gesetz', 'passes a law'),
            ('Die Bürger', 'wählen', 'eine neue Regierung', 'elect a new government'),
            ('Die Regierung', 'erhöht', 'die Steuern', 'raises taxes'),
            ('Die Partei', 'gewinnt', 'die Wahl', 'wins the election'),
        ], ('wer?', 'was?')),
        table('In a debate', ['', '~'], [
            ['die Befürworter ↔ die Gegner', 'supporters ↔ opponents'], ['fordern · warnen vor · begrüßen', 'demand · warn of · welcome'],
        ]),
        words('Words for the practice page', [
            ('die Steuern', 'taxes'), ('steigen ↔ sinken · gesunken', 'to rise ↔ fall'), ('die Arbeitslosigkeit', 'unemployment'),
            ('die Kluft zwischen Arm und Reich', 'the gap between rich and poor'), ('wächst', 'grows'),
            ('das Monatsticket', 'monthly ticket'),
            ('kosten', 'to cost'), ('der Sturm', 'storm'), ('die Bäume', 'trees'), ('entwurzelt', 'uprooted'),
            ('das Festival', 'festival'), ('die Karten', 'tickets'), ('verkauft', 'sold'),
            ('in Bayern', 'in Bavaria'), ('leicht', 'slightly'), ('im Februar', 'in February'), ('mehr als', 'more than'),
            ('die Kosten', 'costs'), ('vor höheren Kosten', 'of higher costs'), ('zweihundert', 'two hundred'),
        ], 4),
    ],
    [
        gaps('Noun + verb', 'Write the verb.', [
            ('Das Parlament hat ein neues Gesetz', '.', 'beschlossen'),
            ('Die Partei hat die Wahl', '.', 'gewonnen'),
            ('Die Regierung will die Steuern', '.', 'erhöhen'),
            ('Die Gegner', 'vor höheren Kosten.', 'warnen'),
            ('Die Arbeitslosigkeit ist', ', doch die Kluft zwischen Arm und Reich wächst.', 'gesunken'),
        ]),
        circle('The news', 'Listen to the news. Circle what you hear.', [
            ('Das Monatsticket soll nicht mehr als', ['39', '49'], 'Euro kosten.', '39'),
            ('Nach dem Sturm in', ['Hamburg', 'Berlin'], 'wurden mehr als zweihundert Bäume entwurzelt.', 'Hamburg'),
            ('Die Arbeitslosigkeit in Bayern ist im Februar leicht', ['gesunken', 'gestiegen'], '.', 'gesunken'),
            ('Für das Festival wurden über', ['80.000', '8.000'], 'Karten verkauft.', '80.000'),
        ], 1) | {'listen': True},
    ],
    ['name the people and things of politics with der, die, das',
     'use each noun with its verb',
     'follow a news bulletin'],
    listen=Q + 'hoeren_nachrichten',
))

# ---- 2 · Er sagt, er sei krank -----------------------------------------------------------
spreads.append(spread(
    'konj1', 'Er sagt, er sei krank', 'Reported speech: the Konjunktiv I',
    'The newspaper’s way of saying “he says so — not us”: er sei, sie habe, man werde.',
    Q + 'konj1',
    [
        build('er-form: stem + -e', [
            (['komm', ('e', 'suffix')], 'er komme', 'er kommt'), (['hab', ('e', 'suffix')], 'er habe', 'er hat'),
            (['könn', ('e', 'suffix')], 'er könne', 'er kann'), (['müss', ('e', 'suffix')], 'er müsse', 'er muss'),
            (['werd', ('e', 'suffix')], 'er werde', 'er wird'), (['geb', ('e', 'suffix')], 'es gebe', 'es gibt'),
        ], 'And one on its own: er ist → er sei.'),
        slots('Two verbs, two moods', [
            (sl('Der Minister', 'sagte,', 'die Lage', 'sei!', 'ernst.'), 'the reporter: indicative · the minister: Konjunktiv I'),
            (sl('Sie', 'meint,', 'sie', 'habe!', 'keine Zeit.'), None),
        ], note='The tense stays: sei, not war.'),
        flow('Looks like the indicative?', q('Is the Konjunktiv I the same as the normal form?',
                                             a('use the Konjunktiv II', 'sie haben → sie hätten'),
                                             a('keep it', 'er hat → er habe'))),
        words('Words for the practice page', [
            ('die Lage', 'situation'), ('ernst', 'serious'), ('der Plan', 'plan'), ('der Chef', 'boss'),
            ('die Experten', 'experts'), ('keine schnelle Lösung', 'no quick solution'), ('meinen · sie meint', 'to say, think'),
            ('der Sprecher fügte hinzu', 'the spokesman added'), ('handeln', 'to act'), ('morgen', 'tomorrow'), ('sie sagten', 'they said'),
        ], 4),
    ],
    [
        gaps('Report it', 'Write the verb in brackets in the Konjunktiv I.', [
            ('Er sagt, er', 'morgen. (kommen)', 'komme'),
            ('Sie meint, sie', 'keine Zeit. (haben)', 'habe'),
            ('Der Minister sagte, die Lage', 'ernst. (sein)', 'sei'),
            ('Der Chef sagt, er', 'noch arbeiten. (müssen)', 'müsse'),
            ('Der Sprecher fügte hinzu, es', 'keine schnelle Lösung. (geben)', 'gebe'),
            ('Sie sagte, die Regierung', 'handeln. (werden)', 'werde'),
            ('Die Experten sagten, sie', 'keine schnelle Lösung. (haben)', 'hätten'),
        ]),
        write('In the paper', 'Report what the minister said.', [
            ('„Die Lage ist ernst.“', 'Der Minister sagte, die Lage sei ernst.'),
            ('„Die Regierung hat einen Plan.“', 'Der Minister sagte, die Regierung habe einen Plan.'),
        ], 1),
    ],
    ['report with er sei, sie habe, es gebe',
     'keep the tense: sei, not war',
     'switch to hätten when the form looks normal'],
))

# ---- 3 · Er sagte, er habe … ---------------------------------------------------------------
spreads.append(spread(
    'konj1_verg', 'Sie sagte, sie sei angekommen', 'Reporting the past, questions and requests',
    'Any past becomes habe or sei + the past form. Questions take ob, requests take solle or möge.',
    Q + 'konj1_vergangenheit',
    [
        slots('Every past becomes habe or sei + the past form', [
            ([('„Ich schickte.“ · „Ich habe geschickt.“', 'direct speech'), {'de': 'er habe geschickt', 'tag': 'reported', 'hot': True}], None),
            ([('„Ich kam an.“ · „Ich bin angekommen.“', 'direct speech'), {'de': 'sie sei angekommen', 'tag': 'reported', 'hot': True}], None),
            ([('„Ich konnte nicht kommen.“', 'with a modal'), {'de': 'er habe nicht kommen können', 'tag': 'two infinitives', 'hot': True}], None),
        ]),
        table('Questions and requests', ['direct', 'reported'], [
            ['„Kommst du mit?“', 'Sie fragte, *ob* ich mitkomme.'], ['„Wann fährt der Zug?“', 'Er fragte, *wann* der Zug fahre.'],
            ['„Warte bitte!“', 'Sie bat, ich *möge* warten. (polite)'], ['„Schließen Sie die Tür!“', 'Er sagte, ich *solle* die Tür schließen.'],
        ]),
        words('Words for the practice page', [
            ('der Zeuge', 'witness'), ('der Unfall', 'accident'), ('stehen bleiben · stehen geblieben', 'to stop'),
            ('der Termin', 'appointment'), ('wahrnehmen', 'to keep (an appointment)'), ('die Nachbarn', 'neighbours'),
            ('nichts gehört', 'heard nothing'), ('der Arzt', 'doctor'), ('das Rauchen aufgeben', 'to give up smoking'),
            ('schlafen', 'to sleep'), ('das Projekt', 'project'), ('teuer', 'expensive'), ('verschoben', 'postponed'),
            ('veröffentlicht worden', 'been published'), ('die Studie', 'study'), ('im letzten Jahr', 'last year'),
            ('die Gegner', 'opponents'), ('die Ministerin', 'minister'), ('der Experte', 'expert'), ('erklärte', 'explained'),
        ], 4),
    ],
    [
        gaps('The past, reported', 'Write habe or sei.', [
            ('Der Zeuge sagte, er', 'den Unfall gesehen.', 'habe'),
            ('… und er', 'sofort stehen geblieben.', 'sei'),
            ('Sie erklärte, sie', 'den Termin nicht wahrnehmen können.', 'habe'),
            ('Die Nachbarn sagten, sie', 'nichts gehört.', 'hätten'),
        ]),
        gaps('Questions and requests', 'Write ob, wann, solle or möge.', [
            ('Sie fragte,', 'ich mitkomme.', 'ob'),
            ('Er fragte,', 'der Zug fahre.', 'wann'),
            ('Der Arzt sagte, ich', 'mehr schlafen.', 'solle'),
            ('Sie bat, ich', 'warten.', 'möge'),
        ]),
        gaps('Heard it?', 'Listen to the dictation and write the missing words.', [
            ('Die Ministerin sagte, die Lage', 'ernst, aber man habe einen Plan.', 'sei'),
            ('Die Studie ist im letzten Jahr veröffentlicht', '.', 'worden'),
            ('Die Gegner meinen, dass die Kosten zu hoch', '.', 'seien'),
        ]) | {'listen': True},
    ],
    ['report the past with habe or sei',
     'report a question with ob or a W-word',
     'report a request with solle or möge'],
    listen=Q + 'diktat_argument',
))

# ---- 4 · Er fragte, ob … ------------------------------------------------------------------
spreads.append(spread(
    'indirekt_fragen', 'Ich frage mich, ob das stimmt', 'Indirect questions',
    'ob for yes-or-no, the W-word for the rest, the verb at the end — and womit, worauf, mit wem.',
    Q + 'indirekt_fragen',
    [
        flow('ob or a W-word?', q('Can you answer it with ja or nein?',
                                  a('ob', 'Kommst du? → Er fragt, ob ich komme.'),
                                  a('the W-word', 'Wo wohnst du? → Sie will wissen, wo ich wohne.'))),
        slots('The verb goes to the end', [
            (sl('Er fragt,', 'ob', 'ich morgen', 'komme.!'), None),
            (sl('Sie wollte wissen,', 'womit', 'ich', 'fahre.!'), 'things: wo(r)-'),
            (sl('Er fragte,', 'mit wem', 'ich', 'wohne.!'), 'people: mit wem, auf wen'),
        ]),
        tiles('Four openers', [
            ('Er wollte wissen, …', 'he wanted to know'), ('Sie fragte (sich), …', 'she asked (herself)'),
            ('Er bat mich, …', 'he asked me to'), ('Ich weiß nicht, …', 'I don’t know'),
        ], 4),
        words('Words for the practice page', [
            ('stimmen · das stimmt', 'to be true'), ('womit', 'with what'), ('worauf', 'for what'), ('wovon', 'on what'),
            ('leben', 'to live'), ('warten auf', 'to wait for'), ('der Journalist', 'journalist'), ('wirklich', 'really'),
            ('der Bus', 'bus'),
        ], 4),
    ],
    [
        gaps('Ask it politely', 'Write ob or the W-word.', [
            ('Der Journalist fragte,', 'die Regierung einen Plan habe.', 'ob'),
            ('Sie wollte wissen,', 'ich wohne.', 'wo'),
            ('Ich frage mich,', 'das wirklich stimmt.', 'ob'),
            ('Er fragte,', 'ich fahre: mit dem Bus oder mit dem Rad?', 'womit'),
            ('Sie wollte wissen,', 'ich warte.', 'worauf'),
            ('Er fragte, mit', 'ich wohne.', 'wem'),
        ]),
        write('Indirect', 'Start with Er fragte, … .', [
            ('„Kommst du morgen?“', 'Er fragte, ob ich morgen komme.'),
            ('„Wovon lebst du?“', 'Er fragte, wovon ich lebe.'),
        ], 1),
    ],
    ['ask with ob for a yes-or-no question',
     'put the verb at the end',
     'use womit, worauf, mit wem'],
))

# ---- 5 · warten auf, sich freuen über ----------------------------------------------------
spreads.append(spread(
    'verben_praep', 'Ich freue mich darauf', 'Verbs with a fixed little word',
    'warten auf, denken an, teilnehmen an: learn the verb with its little word — never translate it.',
    Q + 'verben_praep',
    [
        table('By little word', ['', 'verbs'], [
            ['auf + Akk', 'warten · sich freuen (on what’s coming) · sich verlassen'],
            ['über + Akk', 'sprechen · sich freuen (on what’s here) · sich ärgern'],
            ['für + Akk', 'sich interessieren · sich entschuldigen · sich bedanken'],
            ['an', 'denken (Akk) · teilnehmen (Dat) · sich erinnern (Akk)'],
            ['um + Akk', 'sich bewerben · sich kümmern'], ['von + Dat', 'träumen · abhängen'],
        ], 'never: depend on → abhängen von · take part in → teilnehmen an'),
        timeline('sich freuen: auf or über?', [
            ('Ich freue mich über das gute Wetter.', 'über: it’s here now', 0),
            ('Ich freue mich auf den Urlaub.', 'auf: it’s still to come', 2.5),
        ]),
        slots('A whole clause? da(r)- before the comma', [
            (sl('Ich freue mich', 'darauf,!', 'dass', 'ihr kommt.'), 'auf → darauf'),
            (sl('Er denkt', 'daran,', 'das Haus', 'zu verkaufen.'), 'an → daran'),
            (sl('Wovon!', 'hängt', 'das ab?', '– Davon, wie viel Zeit wir haben.'), 'asking: wo(r)-'),
        ]),
        words('Words for the practice page', [
            ('die Konferenz', 'conference'), ('die Organisatoren', 'organisers'), ('die Einladung', 'invitation'),
            ('die Unterlagen', 'documents'), ('rechtzeitig', 'in time'), ('ankommen', 'to arrive'), ('die Verspätung', 'delay'),
            ('die Stelle', 'job'), ('der Urlaub', 'holiday'), ('teilgenommen', 'took part'), ('bedankt', 'thanked'),
            ('der Zug', 'train'), ('beworben', 'applied'), ('kümmern', 'to see to'), ('sie ärgert sich', 'she is annoyed'),
        ], 4),
    ],
    [
        gaps('The little word', 'Write the missing little word.', [
            ('Ich habe', 'der Konferenz teilgenommen.', 'an'),
            ('Ich habe mich bei den Organisatoren', 'die Einladung bedankt.', 'für'),
            ('Er hat sich', 'die Stelle beworben.', 'um'),
            ('Das hängt', 'der Zeit ab.', 'von'),
            ('Ich freue mich', 'den Urlaub.', 'auf'),
        ]),
        gaps('da(r)-', 'Write the da(r)-word.', [
            ('Wir müssen uns', 'kümmern, dass die Unterlagen rechtzeitig ankommen.', 'darum'),
            ('Sie ärgert sich', ', dass der Zug Verspätung hat.', 'darüber'),
            ('Ich freue mich', ', dass ihr kommt.', 'darauf'),
        ]),
    ],
    ['learn verbs with their little word',
     'tell sich freuen auf from sich freuen über',
     'attach a clause with darauf, darüber, daran'],
))

# ---- 6 · stolz auf, zufrieden mit --------------------------------------------------------
spreads.append(spread(
    'adjektive_praep', 'stolz auf, zufrieden mit', 'Describing words with a fixed little word',
    'interested in is interessiert an, proud of is stolz auf: the English little word is a false friend every time.',
    Q + 'adjektive_praep',
    [
        table('The core set', ['', 'describing words'], [
            ['auf + Akk', 'stolz · neugierig · gespannt'], ['mit + Dat', 'zufrieden · einverstanden · fertig'],
            ['an + Dat', 'interessiert · reich · schuld'], ['von + Dat', 'abhängig · begeistert · überzeugt · enttäuscht'],
            ['für + Akk', 'verantwortlich · bekannt · typisch'], ['über + Akk', 'froh · traurig · ärgerlich'],
            ['zu + Dat', 'freundlich · nett · bereit'],
        ]),
        cols(
            table('Verb and describing word can differ', ['verb', 'describing word'], [
                ['sich interessieren *für*', 'interessiert *an*'], ['sich begeistern *für*', 'begeistert *von*'],
            ]),
            slots('Where it goes', [
                (sl('Sie ist', 'mit dem Ergebnis', 'zufrieden.!'), 'the little word in the middle'),
            ]),
        ),
        box('tip', 'A whole clause',
            'Ich bin stolz *darauf*, dass du das geschafft hast. Sie ist neugierig *darauf*, wie es ausgeht.'),
        words('Words for the practice page', [
            ('das Team', 'team'), ('das Budget', 'budget'), ('das Ergebnis', 'result'), ('die Tochter', 'daughter'),
            ('die Wohnung', 'flat'), ('der Käse', 'cheese'), ('niemand', 'nobody'), ('geschafft', 'managed'),
            ('der Vorschlag', 'proposal'), ('die Musik', 'music'), ('die Region', 'region'),
        ], 4),
    ],
    [
        gaps('The little word', 'Write the missing little word.', [
            ('Sie ist stolz', 'ihre Arbeit.', 'auf'),
            ('Wir sind mit dem Ergebnis sehr', '. (zufrieden or stolz?)', 'zufrieden'),
            ('Er ist verantwortlich', 'das Budget.', 'für'),
            ('Ich bin', 'Musik interessiert.', 'an'),
            ('Die Region ist bekannt', 'ihren Käse.', 'für'),
            ('Ich bin', 'dem Vorschlag einverstanden.', 'mit'),
            ('Er ist enttäuscht', ', dass niemand gekommen ist.', 'davon'),
        ]),
        gaps('About you', 'Finish the sentence.', [('Ich bin stolz darauf, dass', '.')], 'About you.'),
    ],
    ['use stolz auf, zufrieden mit, interessiert an',
     'remember that the verb’s little word can differ',
     'attach a clause with darauf, davon'],
))

# ---- 7 · die Angst vor, das Interesse an -------------------------------------------------
spreads.append(spread(
    'nomen_praep', 'die Kritik an der Regierung', 'Nouns with a fixed little word',
    'Written German prefers nouns: die Kritik der Opposition an der Regierung packs a whole sentence into a phrase.',
    Q + 'nomen_praep',
    [
        table('From verb to noun — the little word may change', ['verb', 'noun', ''], [
            ['sich fürchten vor', 'die Angst vor', 'same'], ['sich interessieren für', 'das Interesse *an*', 'changes!'],
            ['kritisieren', 'die Kritik *an*', 'a new one'], ['teilnehmen an', 'die Teilnahme an', 'same'],
            ['bitten um', 'die Bitte um', 'same'],
        ]),
        table('More to learn', ['', 'nouns'], [
            ['auf + Akk', 'der Einfluss · die Lust · die Hoffnung · die Antwort'], ['für + Akk', 'der Grund · die Verantwortung'],
            ['über + Akk', 'die Freude · der Bericht'], ['nach + Dat', 'die Frage · die Suche'],
        ]),
        slots('Unpack the phrase', [
            (sl('der Einfluss', 'der Medien', 'auf die Wahl!'), '= Die Medien beeinflussen die Wahl.'),
        ], note='The genitive is who, the little word is at what.'),
        words('Words for the practice page', [
            ('die Medien', 'the media'), ('die Opposition', 'opposition'), ('wächst', 'grows'), ('der Ärger', 'anger'),
            ('die Lage', 'situation'), ('sich bessern', 'to improve'), ('gering', 'small'), ('die Politik', 'politics'),
            ('groß', 'big'), ('fehlen · er fehlt', 'to be absent'), ('sie bessert sich', 'it improves'), ('klar', 'clear'), ('der Kurs', 'course'), ('die Schüler', 'pupils'),
        ], 4),
    ],
    [
        gaps('The little word', 'Write the missing little word.', [
            ('Die Kritik', 'der Regierung wächst.', 'an'),
            ('Mein Interesse', 'Politik ist groß.', 'an'),
            ('Der Grund', 'den Ärger ist ihr Einfluss auf die Medien.', 'für'),
            ('Ich habe keine Lust', 'den Kurs.', 'auf'),
            ('Die Teilnahme der Schüler', 'dem Kurs ist gering.', 'an'),
        ]),
        gaps('da(r)-', 'Write the da(r)-word.', [
            ('Die Hoffnung', ', dass sich die Lage bessert, ist gering.', 'darauf'),
            ('Der Grund', ', dass er fehlt, ist nicht klar.', 'dafür'),
        ]),
    ],
    ['use nouns with their little word: Kritik an, Angst vor',
     'notice when it changes: Interesse an',
     'unpack a noun phrase into a sentence'],
))

# ---- Review 1 · topics 1–7 -----------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–7', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        gaps('Reported', 'Write the verb in the Konjunktiv I.', [
            ('Er sagt, er', 'krank. (sein)', 'sei'), ('Sie meint, sie', 'keine Zeit. (haben)', 'habe'),
            ('Der Zeuge sagte, er', 'den Unfall gesehen. (haben)', 'habe'),
        ]),
        gaps('Asked', 'Write ob or the W-word.', [
            ('Er fragte,', 'ich morgen komme.', 'ob'), ('Sie wollte wissen,', 'ich wohne.', 'wo'),
        ]),
    ],
    [
        gaps('The little word', 'Write the missing little word.', [
            ('Ich warte', 'den Bus.', 'auf'), ('Ich habe', 'der Konferenz teilgenommen.', 'an'),
            ('Sie ist stolz', 'ihre Tochter.', 'auf'), ('Mein Interesse', 'Politik ist groß.', 'an'),
            ('Ich freue mich', ', dass ihr kommt.', 'darauf'),
        ]),
    ],
))

# ==== Part 2 · The passive and other building blocks =====================================

# ---- 8 · muss gelöst werden ---------------------------------------------------------------
spreads.append(spread(
    'modalpassiv', 'Das muss gelöst werden', 'The passive with a modal — in every tense',
    'gelöst werden is one block. Put muss, musste or hat … müssen around it and you have every tense.',
    Q + 'modalpassiv',
    [
        slots('One block, three tenses', [
            (sl('Das Problem', 'muss!', 'gelöst werden.!'), 'now'),
            (sl('Das Problem', 'musste!', 'gelöst werden.!'), 'past — the one to use'),
            (sl('Das Problem', 'hat!', 'gelöst werden müssen.!'), 'Perfekt: müssen, not gemusst'),
        ], note='Only the modal shows the tense.'),
        table('man or the passive?', ['with man', 'passive'], [
            ['Man muss das Problem lösen.', 'Das Problem muss gelöst werden.'],
            ['Man darf hier nicht rauchen.', 'Hier darf nicht geraucht werden.'],
            ['Man sollte die Fenster schließen.', 'Die Fenster sollten geschlossen werden.'],
        ], 'Conversation likes man; rules and reports like the passive.'),
        words('Words for the practice page', [
            ('das Formular', 'form'), ('ausfüllen · ausgefüllt', 'to fill in'), ('die Regeln', 'rules'), ('beachten', 'to follow'),
            ('der Vertrag', 'contract'), ('unterschreiben · unterschrieben', 'to sign'), ('der Flug', 'flight'),
            ('streichen · gestrichen', 'to cancel'), ('wegen des Sturms', 'because of the storm'), ('der Antrag · die Anträge', 'application'),
            ('einreichen · eingereicht', 'to hand in'), ('bis Freitag', 'by Friday'), ('die Gäste', 'guests'), ('informiert', 'informed'),
            ('reparieren · repariert', 'to repair'), ('informieren', 'to inform'),
        ], 4),
    ],
    [
        gaps('The modal', 'Write the modal in brackets in the right form.', [
            ('Das Formular', 'ausgefüllt werden. (müssen, now)', 'muss'),
            ('Die Anträge', 'bis Freitag eingereicht werden. (müssen, now)', 'müssen'),
            ('Der Vertrag', 'nicht unterschrieben werden. (können, past)', 'konnte'),
            ('Hier', 'nicht geraucht werden. (dürfen, now)', 'darf'),
        ]),
        gaps('The end of the sentence', 'Write the last two words.', [
            ('Die Regeln müssen beachtet', '.', 'werden'),
            ('Der Flug hat wegen des Sturms gestrichen', '.', 'werden müssen'),
        ]),
        write('In the passive', 'Write it in the passive.', [
            ('Man muss die Gäste informieren.', 'Die Gäste müssen informiert werden.'),
            ('Man sollte das Fenster reparieren.', 'Das Fenster sollte repariert werden.'),
        ], 1),
    ],
    ['say what must be done: muss … werden',
     'use the past: musste … werden',
     'read the Perfekt: hat … werden müssen'],
))

# ---- 9 · ist gebaut worden ---------------------------------------------------------------
spreads.append(spread(
    'passiv_perfekt', 'Das Haus ist 1990 gebaut worden', 'The passive in the Perfekt',
    'ist … worden: sein as the helper, worden as the last word — never geworden.',
    Q + 'passiv_perfekt',
    [
        slots('ist … worden', [
            (sl('Das Haus', 'ist!', '1990', 'gebaut worden.!'), 'has been built'),
            (sl('Die Fehler', 'sind!', 'korrigiert worden.!'), 'sein agrees, worden never changes'),
            (sl('Das Haus', 'war!', 'schon', 'gebaut worden.!'), 'one step further back'),
            (sl('…, weil', 'das Haus', 'gebaut worden', 'ist.!'), 'in a clause: the helper last'),
        ]),
        cols(
            box('watch', 'worden or geworden?', '*Das Haus ist gebaut worden* (passive). *Er ist Arzt geworden* (became).'),
            table('Same meaning', ['written', 'spoken'], [['Das Haus wurde gebaut.', 'Das Haus ist gebaut worden.']]),
        ),
        words('Words for the practice page', [
            ('der Dieb', 'thief'), ('gefunden', 'found'), ('die Rechnung', 'bill'), ('bereits', 'already'),
            ('gestrichen', 'cancelled'), ('inzwischen', 'by now'), ('behoben', 'fixed'), ('der Park', 'park'),
            ('das Parkhaus', 'car park'), ('der Spielplatz', 'playground'), ('die Tiefgarage', 'underground car park'),
            ('die Grünflächen', 'green spaces'), ('es fehlt an', 'there is a lack of'), ('das Viertel', 'neighbourhood'),
            ('die Wiese', 'meadow'), ('hinter der Schule', 'behind the school'), ('die Wohnblocks', 'blocks of flats'),
            ('wo früher … war', 'where there used to be'), ('ein Fünftel', 'a fifth'), ('unbebaut', 'not built on'),
            ('gewichen', 'given way to'), ('mindestens', 'at least'), ('jedes Grundstücks', 'of every plot'),
            ('der Flughafen', 'airport'), ('ankamen', 'arrived'), ('die Briefe', 'letters'), ('verschickt', 'sent'),
            ('die Parks', 'parks'), ('die Schulen', 'schools'),
        ], 4),
    ],
    [
        gaps('ist … worden', 'Write ist, sind or war + worden.', [
            ('Der Dieb', 'gestern gefunden', 'ist … worden'),
            ('Die Briefe', 'schon verschickt', 'sind … worden'),
            ('Der Flug', 'schon gestrichen', 'war … worden'),
        ], 'Write both words in the gap, with … between them.'),
        gaps('In a clause', 'Write the last two words.', [
            ('Ich weiß, dass der Fehler inzwischen behoben', '.', 'worden ist'),
            ('Wir waren froh, weil die Rechnung bereits bezahlt', '.', 'worden war'),
        ]),
        circle('A letter to the paper', 'Listen to the letter. Circle what you hear.', [
            ('Wo früher ein kleiner', ['Park', 'Markt'], 'war, ist ein Parkhaus gebaut worden.', 'Park'),
            ('Der Spielplatz ist einer', ['Tiefgarage', 'Schule'], 'gewichen.', 'Tiefgarage'),
            ('Im Viertel fehlt es an', ['Grünflächen', 'Wohnungen'], '.', 'Grünflächen'),
            ('Mindestens ein', ['Fünftel', 'Viertel'], 'jedes Grundstücks soll unbebaut bleiben.', 'Fünftel'),
        ], 1) | {'listen': True},
    ],
    ['say what has been done: ist … worden',
     'tell worden from geworden',
     'put the helper last in a clause'],
    listen=Q + 'lesen_leserbrief',
))

# ---- 10 · wird geöffnet, ist geöffnet ----------------------------------------------------
spreads.append(spread(
    'zustandspassiv', 'ist geöffnet oder wird geöffnet?', 'The action and the state',
    'English says “is opened” for both. German doesn’t: wird geöffnet is happening, ist geöffnet is the result.',
    Q + 'zustandspassiv',
    [
        flow('wird or ist?', q('Is something happening right now?',
                               a('werden: the action', 'Das Geschäft wird um neun geöffnet.'),
                               a('sein: the state', 'Das Geschäft ist geöffnet. = offen'))),
        table('Now and in the past', ['', 'action', 'state'], [
            ['now', 'Der Tisch *wird* gedeckt.', 'Der Tisch *ist* gedeckt.'],
            ['past', 'Das Museum *wurde* um fünf geschlossen.', 'Das Museum *war* schon geschlossen.'],
        ], 'Can you say offen, zu or fertig instead? Then it’s the state.'),
        arrow('von or durch?', [
            ('vom Chef', 'geschrieben', 'a person: von', None),
            ('durch einen Boten', 'überbracht', 'a means: durch', None),
            ('durch ein Erdbeben', 'zerstört', 'nature: von or durch', None),
        ], ('who or what?', ''), 'Der Brief wurde vom Chef geschrieben.'),
        words('Words for the practice page', [
            ('das Geschäft', 'shop'), ('um neun', 'at nine'), ('der Tisch', 'table'), ('gedeckt', 'laid'), ('gerade', 'right now'),
            ('das Museum', 'museum'), ('als wir ankamen', 'when we arrived'), ('der Bote', 'messenger'), ('das Erdbeben', 'earthquake'),
            ('zerstört', 'destroyed'), ('die Stadt', 'city'), ('beschlossen', 'passed'), ('bekannt gemacht', 'made known'), ('repariert', 'repaired'),
            ('wir können essen', 'we can eat'),
        ], 4),
    ],
    [
        circle('Action or state?', 'Circle the right word.', [
            ('Das Geschäft', ['wird', 'ist'], 'jeden Tag um neun geöffnet.', 'wird'),
            ('Der Tisch', ['ist', 'wird'], 'gedeckt, wir können essen.', 'ist'),
            ('Als wir ankamen,', ['war', 'wurde'], 'das Museum schon geschlossen.', 'war'),
            ('Das Auto', ['wird', 'ist'], 'gerade repariert.', 'wird'),
            ('Das Gesetz wurde', ['vom', 'durch das'], 'Parlament beschlossen.', 'vom'),
            ('Die Stadt wurde', ['durch', 'vom'], 'ein Erdbeben zerstört.', 'durch'),
        ], 2),
    ],
    ['tell wird geöffnet from ist geöffnet',
     'use wurde and war in the past',
     'choose von for a person, durch for a means'],
))

# ---- 11 · Hier wird getanzt ---------------------------------------------------------------
spreads.append(spread(
    'passiv_subjektlos', 'Hier wird getanzt', 'A passive with no subject',
    'Hier wird nicht geraucht. Ihm wird geholfen. No subject at all — and es only when nothing else is in front.',
    Q + 'passiv_subjektlos',
    [
        slots('es fills the first place — and only there', [
            (sl('Es!', 'wird', 'getanzt.'), 'nothing else in front: es'),
            (sl('Hier!', 'wird', 'getanzt.'), 'something in front: no es'),
            (sl('Sonntags', 'wird', 'nicht', 'gearbeitet.'), None),
        ], note='Always wird or wurde: singular.'),
        table('The dative stays dative', ['with man', 'passive'], [
            ['Man hilft *ihm*.', '*Ihm* wird geholfen. (not: Er wird …)'],
            ['Man dankte *den Helfern*.', '*Den Helfern* wurde gedankt.'],
            ['Man antwortete *mir* nicht.', '*Mir* wurde nicht geantwortet.'],
        ]),
        words('Words for the practice page', [
            ('die Bibliothek', 'library'), ('gesprochen', 'spoken'), ('gegessen', 'eaten'), ('gelacht', 'laughed'),
            ('viel', 'a lot'), ('die Gewinner', 'winners'), ('gratuliert', 'congratulated'), ('die Helfer', 'helpers'),
            ('über Politik', 'about politics'), ('diskutiert', 'discussed'), ('man lachte', 'people laughed'),
            ('man diskutiert', 'people discuss'), ('rauchen · geraucht', 'to smoke'), ('man raucht', 'people smoke'),
            ('gestern', 'yesterday'), ('auf der Party', 'at the party'), ('getanzt', 'danced'),
        ], 4),
    ],
    [
        gaps('es or not?', 'Write es where it is needed, or – where it isn’t.', [
            ('', 'wird getanzt.', 'Es'), ('Hier wird', 'getanzt.', '–'),
            ('', 'wurde viel gelacht.', 'Es'), ('Gestern wurde', 'viel gelacht.', '–'),
        ]),
        gaps('The dative', 'Write the person in the right form.', [
            ('', 'wird geholfen. (er)', 'Ihm'), ('', 'wurde nicht geantwortet. (ich)', 'Mir'),
            ('', 'wurde gratuliert. (die Gewinner)', 'Den Gewinnern'),
        ]),
        write('Without man', 'Write it in the passive.', [
            ('Man raucht hier nicht.', 'Hier wird nicht geraucht.'),
            ('Man lachte auf der Party viel.', 'Auf der Party wurde viel gelacht.'),
            ('Man diskutiert über Politik.', 'Es wird über Politik diskutiert.'),
        ], 1),
    ],
    ['describe what goes on: Hier wird getanzt',
     'use es only in first place',
     'keep the dative: Ihm wird geholfen'],
))

# ---- 12 · lassen ---------------------------------------------------------------------------
spreads.append(spread(
    'lassen', 'Ich lasse mein Auto reparieren', 'lassen: get it done, let it happen',
    'Ich lasse das Auto reparieren — someone else does it. Ich habe mir die Haare schneiden lassen — two infinitives.',
    Q + 'lassen',
    [
        table('Four jobs', ['', 'like this', '~'], [
            ['get it done', 'Ich lasse das Auto *reparieren*.', 'someone else repairs it'],
            ['allow', 'Sie lässt die Kinder *spielen*.', 'she lets them'],
            ['leave behind', 'Ich habe den Schirm zu Hause *gelassen*.', 'the usual past form'],
            ['can be', 'Das *lässt sich* lösen.', '= kann gelöst werden'],
        ]),
        slots('Perfekt: two infinitives', [
            (sl('Ich', 'habe!', 'mir die Haare', 'schneiden lassen.!'), 'not: gelassen'),
            (sl('Wir', 'haben!', 'ihn', 'kommen sehen.!'), 'sehen and hören work the same'),
        ]),
        box('watch', 'Who did it?', '*Ich habe mein Auto repariert* = I did it myself. *Ich habe mein Auto reparieren lassen* = I had it done.'),
        words('Words for the practice page', [
            ('die Haare schneiden', 'to cut hair'), ('der Brief', 'letter'), ('übersetzen', 'to translate'), ('warten', 'to wait'),
            ('die Wohnung', 'flat'), ('renovieren', 'to renovate'), ('bei Oma', 'at grandma’s'), ('das Kleid', 'dress'),
            ('nähen', 'to sew'), ('im Auto', 'in the car'), ('der Schirm', 'umbrella'), ('wegfahren', 'to drive off'),
            ('hören', 'to hear'), ('ändern', 'to change'), ('in Ruhe', 'in peace'), ('die Frage', 'question'),
            ('beantworten', 'to answer'), ('so einfach', 'so easily'), ('lässt', 'lets'), ('solange', 'meanwhile'),
        ], 4),
    ],
    [
        gaps('lassen', 'Write lassen in the right form.', [
            ('Wir', 'die Wohnung renovieren.', 'lassen'),
            ('Sie', 'die Kinder solange bei Oma.', 'lässt'),
            ('', 'mich in Ruhe!', 'Lass'),
            ('Die Frage', 'sich nicht so einfach beantworten.', 'lässt'),
        ]),
        circle('lassen or gelassen?', 'Circle the right form.', [
            ('Sie hat sich ein Kleid nähen', ['lassen', 'gelassen'], '.', 'lassen'),
            ('Sie hat das Kleid im Auto', ['gelassen', 'lassen'], '.', 'gelassen'),
            ('Er hat uns lange warten', ['lassen', 'gelassen'], '.', 'lassen'),
            ('Ich habe das Auto wegfahren', ['hören', 'gehört'], '.', 'hören'),
        ], 1),
    ],
    ['get something done with lassen',
     'say the Perfekt with two infinitives',
     'tell lassen from gelassen'],
))

# ---- 13 · der ankommende Zug --------------------------------------------------------------
spreads.append(spread(
    'partizip_adj', 'der um acht ankommende Zug', 'Relative clause ↔ describing word',
    'der Zug, der um acht ankommt → der um acht ankommende Zug. Fold it one way, unfold it the other.',
    Q + 'partizip_adj',
    [
        flow('-end or ge-?', q('Is it doing it right now?',
                               a('-end', 'der bellende Hund = der Hund, der bellt'),
                               a('ge-', 'das zerbrochene Fenster = das Fenster, das zerbrochen wurde'))),
        table('Fold and unfold', ['relative clause', 'before the noun'], [
            ['der Zug, der um acht Uhr ankommt', 'der um acht Uhr ankommende Zug'],
            ['die Gäste, die von der Firma eingeladen wurden', 'die von der Firma eingeladenen Gäste'],
            ['die Preise, die seit Jahren steigen', 'die seit Jahren steigenden Preise'],
        ], 'Everything except der/die/das and the helper goes in front.'),
        box('watch', 'The ending',
            'ein *gekochtes* Ei, die eingeladen*en* Gäste — the describing word always takes its ending.'),
        words('Words for the practice page', [
            ('bellen', 'to bark'), ('erschrecken', 'to frighten'), ('spielend', 'playing'), ('die Sonne geht unter', 'the sun sets'),
            ('blühen', 'to bloom'), ('die Blumen', 'flowers'), ('das Ei', 'egg'), ('kochen', 'to boil'), ('das Hemd', 'shirt'),
            ('bügeln', 'to iron'), ('einladen · eingeladen', 'to invite'), ('er erschreckte', 'he frightened'), ('wunderschön', 'beautiful'), ('untergehen', 'to set'), ('pünktlich', 'on time'), ('die Firma', 'company'), ('zerbrechen · zerbrochen', 'to break'),
            ('das Fenster', 'window'), ('parken · geparkt', 'to park'), ('steigen', 'to rise'),
        ], 4),
    ],
    [
        gaps('Ending and all', 'Write the verb in brackets as -end or ge-, with its ending.', [
            ('Der', 'Hund erschreckte die Kinder. (bellen)', 'bellende'),
            ('Ich esse ein', 'Ei. (kochen)', 'gekochtes'),
            ('Die', 'Sonne ist wunderschön. (untergehen)', 'untergehende'),
            ('Er trägt ein', 'Hemd. (bügeln)', 'gebügeltes'),
            ('Die', 'Gäste kamen pünktlich. (einladen)', 'eingeladenen'),
        ]),
        write('Fold it', 'Put the clause before the noun.', [
            ('das Fenster, das gestern zerbrochen wurde', 'das gestern zerbrochene Fenster'),
            ('die Preise, die seit Jahren steigen', 'die seit Jahren steigenden Preise'),
        ], 1),
        write('Unfold it', 'Write it as a relative clause.', [
            ('der um acht Uhr ankommende Zug', 'der Zug, der um acht Uhr ankommt'),
        ], 1),
    ],
    ['fold a relative clause into a describing word',
     'unfold it again',
     'choose -end or ge-'],
))

# ---- 14 · der, die, das by the ending -----------------------------------------------------
spreads.append(spread(
    'nachsilben', 'die Meinung, das Mädchen, der Tourismus', 'The ending gives the gender away',
    'Simple nouns you learn; long nouns you work out. The ending decides — with a handful of exceptions.',
    Q + 'nachsilben_genus',
    [
        table('Endings and their article', ['der', 'die', 'das'], [
            ['-er · -ler', '-ung · -heit · -keit', '-chen · -lein'], ['-ist · -ant · -ent', '-schaft · -ei · -ie', '-tum · -ment'],
            ['-or · -ling', '-ik · -ion · -tät', '-um · -nis'], ['-ismus', '-ur · -enz · -anz · -in', 'Ge- … -e'],
        ], genders=True),
        build('One of each', [
            (['Tour', ('ismus', 'suffix')], 'der Tourismus', ''), (['Meinung'], 'die Meinung', '-ung'),
            (['Mäd', ('chen', 'suffix')], 'das Mädchen', 'even a girl'), (['Ergeb', ('nis', 'suffix')], 'das Ergebnis', ''),
        ]),
        words('Words for the practice page', [
            ('der Frühling', 'spring'), ('der Lehrling', 'apprentice'), ('der Motor', 'engine'), ('der Autor', 'author'),
            ('die Bäckerei', 'bakery'), ('die Energie', 'energy'), ('die Nation', 'nation'), ('die Natur', 'nature'),
            ('die Konferenz', 'conference'), ('das Eigentum', 'property'), ('das Instrument', 'instrument'), ('das Zentrum', 'centre'),
            ('das Erlebnis', 'experience'), ('das Gebäude', 'building'), ('die Distanz', 'distance'), ('der Journalist', 'journalist'),
            ('die Freiheit', 'freedom'), ('der Praktikant', 'intern'), ('das Häuschen', 'little house'), ('die Musik', 'music'),
            ('der Irrtum', 'mistake — an exception'), ('der Reichtum', 'wealth — an exception'), ('die Erlaubnis', 'permission — an exception'),
        ], 4),
    ],
    [
        sort_ex('der, die or das?', 'Write each noun in its column.', ['der', 'die', 'das'], [
            ('Frühling', 0), ('Journalist', 0), ('Motor', 0), ('Bäckerei', 1), ('Nation', 1), ('Freiheit', 1),
            ('Eigentum', 2), ('Zentrum', 2), ('Häuschen', 2), ('Gebäude', 2), ('Musik', 1), ('Praktikant', 0),
        ]),
        circle('The exceptions', 'Circle the right article.', [
            ('', ['der', 'das'], 'Irrtum', 'der'), ('', ['die', 'das'], 'Erlaubnis', 'die'), ('', ['der', 'das'], 'Reichtum', 'der'),
            ('', ['das', 'die'], 'Ergebnis', 'das'),
        ], 2),
    ],
    ['work out the article from the ending',
     'know der for -ist, -ling, -ismus',
     'remember Reichtum, Irrtum, Erlaubnis'],
))

# ---- Review 2 · topics 8–14 ----------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 8–14', 'The passive and its friends, all at once. No looking back until you have done both pages.',
    Q + 'bigtext_presse',
    [
        gaps('The passive', 'Write the missing word.', [
            ('Das Formular muss ausgefüllt', '.', 'werden'), ('Das Haus ist 1990 gebaut', '.', 'worden'),
            ('Hier', 'nicht geraucht. (wird or ist?)', 'wird'), ('Das Geschäft', 'geöffnet: es ist offen. (wird or ist?)', 'ist'),
            ('', 'wird geholfen. (er)', 'Ihm'),
        ]),
    ],
    [
        gaps('lassen and participles', 'Write the missing word.', [
            ('Ich habe mir die Haare schneiden', '.', 'lassen'), ('Der', 'Hund erschreckte die Kinder. (bellen)', 'bellende'),
        ]),
        sort_ex('der, die or das?', 'Write each noun in its column.', ['der', 'die', 'das'], [
            ('Tourismus', 0), ('Meinung', 1), ('Mädchen', 2), ('Autor', 0), ('Konferenz', 1), ('Dokument', 2),
        ]),
    ],
))

# ==== Part 3 · Arguing =====================================================================

# ---- 15 · trotzdem, daher, sonst ----------------------------------------------------------
spreads.append(spread(
    'konnektoren', 'Trotzdem haben wir es gekauft', 'Words that join sentences',
    'Connector first, verb right after: Trotzdem haben wir … Daher sollte … Sonst verpassen wir …',
    Q + 'konnektoren',
    [
        slots('Connector, then the verb', [
            (sl('Es war teuer.', 'Trotzdem', 'haben!', 'wir es gekauft.'), 'first place'),
            (sl('Es war teuer,', 'wir', 'haben!', 'es trotzdem gekauft.'), 'or in the middle'),
        ], note='Never: Trotzdem wir haben …'),
        table('The families and their twins', ['meaning', 'connector (verb 2nd)', 'twin (verb last)'], [
            ['although', 'trotzdem · dennoch · allerdings', 'obwohl'], ['so', 'deshalb · daher · folglich', 'weil'],
            ['and also', 'außerdem · zudem', '—'], ['or else', 'sonst', 'wenn … nicht'],
            ['instead', 'stattdessen', 'statt dass'], ['by contrast', 'dagegen · hingegen', 'während'],
        ], 'In writing: dennoch, daher, folglich, zudem, hingegen.'),
        words('Words for the practice page', [
            ('folglich', 'consequently'), ('bestand', 'passed'), ('überdacht', 'reconsidered'), ('sich beeilen · beeil dich', 'to hurry'),
            ('nass', 'wet'), ('der Schirm', 'umbrella'), ('die Nachricht', 'message'), ('schickte', 'sent'),
            ('die Befürworter betonen', 'supporters stress'), ('die Kritiker', 'critics'), ('die Flexibilität', 'flexibility'),
            ('die Grenze', 'line, boundary'), ('die Freizeit', 'free time'), ('die Kollegen', 'colleagues'), ('der Austausch', 'exchange'),
            ('ein Drittel', 'a third'), ('zwei Drittel', 'two thirds'), ('die Mischung', 'mix'), ('die Arbeitszeiten', 'working hours'),
            ('die Regelung', 'rule'), ('entscheidend', 'what matters'), ('das Büro', 'office'), ('der Ort', 'place'),
            ('die Umfrage', 'survey'), ('vor allem', 'above all'), ('eine klare Regelung', 'a clear rule'), ('am Wochenende', 'at the weekend'), ('die E-Mails', 'e-mails'), ('beantwortet', 'answers'),
        ], 4),
    ],
    [
        gaps('Which connector?', 'Write trotzdem, folglich, außerdem, sonst or stattdessen.', [
            ('Es war teuer.', 'haben wir es gekauft.', 'Trotzdem'),
            ('Er hat viel gelernt.', 'bestand er die Prüfung.', 'Folglich'),
            ('Nimm einen Schirm,', 'wirst du nass.', 'sonst'),
            ('Er kam nicht;', 'schickte er eine Nachricht.', 'stattdessen'),
            ('Die Wohnung ist schön.', 'ist sie günstig.', 'Außerdem'),
        ]),
        circle('Working from home', 'Listen to the text. Circle what you hear.', [
            ('Befürworter betonen vor allem die', ['Flexibilität', 'Ruhe'], '.', 'Flexibilität'),
            ('Ein', ['Drittel', 'Viertel'], 'beantwortet abends und am Wochenende E-Mails.', 'Drittel'),
            ('Der Austausch mit den', ['Kollegen', 'Kunden'], 'fehlt.', 'Kollegen'),
            ('Entscheidend ist eine klare Regelung der', ['Arbeitszeiten', 'Pausen'], '.', 'Arbeitszeiten'),
        ], 1) | {'listen': True},
    ],
    ['join sentences with trotzdem, daher, sonst',
     'put the verb right after the connector',
     'choose the written ones: dennoch, folglich, zudem'],
    listen=Q + 'lesen_homeoffice',
))

# ---- 16 · TeKaMoLo ----------------------------------------------------------------------------
spreads.append(spread(
    'mittelfeld', 'morgen wegen der Arbeit mit dem Zug nach Rom', 'The order in the middle of the sentence',
    'When, why, how, where — Te-Ka-Mo-Lo. And pronouns jump to the front: Ich gebe es ihm.',
    Q + 'mittelfeld',
    [
        slots('Te – Ka – Mo – Lo', [
            ([('Sie fährt', ''), ('morgen', 'Te: wann?'), ('wegen der Arbeit', 'Ka: warum?'), ('mit dem Zug', 'Mo: wie?'),
              {'de': 'nach Rom.', 'tag': 'Lo: wohin?', 'hot': True}], None),
        ], note='English puts time last; German puts it first.'),
        table('Two objects', ['', 'like this'], [
            ['two nouns: dative first', 'Ich gebe *meinem Bruder* das Buch.'],
            ['a pronoun goes first', 'Ich gebe *es* meinem Bruder. · Ich gebe *ihm* das Buch.'],
            ['two pronouns: accusative first', 'Ich gebe *es ihm*.'],
        ]),
        flow('Where does nicht go?', q('Is the whole sentence denied?',
                                       a('at the end', 'Er ist gestern nicht gekommen.'),
                                       a('before that one part', 'nicht das Museum, sondern den Zoo'))),
        words('Words for the practice page', [
            ('der Bruder', 'brother'), ('das Salz', 'salt'), ('der Vertrag', 'contract'), ('gezeigt', 'showed'),
            ('die Fotos', 'photos'), ('um zehn', 'at ten'), ('in Ruhe', 'calmly'), ('wegen des Regens', 'because of the rain'),
            ('das Museum', 'museum'), ('der Zoo', 'zoo'), ('besucht', 'visited'), ('die Serie', 'series'),
            ('jeden Tag', 'every day'), ('gegeben', 'given'), ('zur Arbeit', 'to work'), ('mit dem Rad', 'by bike'), ('blieben', 'stayed'),
        ], 4),
    ],
    [
        write('Put it in order', 'Write the sentence in the usual order.', [
            ('Er fährt (zur Arbeit · jeden Tag · mit dem Rad).', 'Er fährt jeden Tag mit dem Rad zur Arbeit.'),
            ('Sie blieben (zu Hause · am Abend · wegen des Regens).', 'Sie blieben am Abend wegen des Regens zu Hause.'),
            ('Er hat (den Vertrag · mir · gestern) gezeigt.', 'Er hat mir gestern den Vertrag gezeigt.'),
        ], 1),
        gaps('Pronouns', 'Write the two pronouns in the right order.', [
            ('Kannst du mir das Salz geben? – Ich gebe', 'sofort. (es · dir)', 'es dir'),
            ('Hast du ihm das Buch gegeben? – Ja, ich habe', 'gegeben. (es · ihm)', 'es ihm'),
        ]),
        circle('nicht', 'Circle where nicht goes.', [
            ('Ich habe den Film', ['nicht gesehen', 'gesehen nicht'], '.', 'nicht gesehen'),
            ('Wir haben', ['nicht das Museum', 'das Museum nicht'], ', sondern den Zoo besucht.', 'nicht das Museum'),
        ], 1),
    ],
    ['order the middle: when, why, how, where',
     'put pronouns first, accusative before dative',
     'place nicht'],
))

# ---- 17 · wegen des Regens, nach dem Essen ------------------------------------------------
spreads.append(spread(
    'nominal', 'wegen des Regens, nach dem Essen', 'Causes and times as phrases',
    'weil es regnete → wegen des Regens: find the noun, then the little word.',
    Q + 'kausal_nominal',
    [
        merge('Three moves', ('the little word', 'the noun'), [
            ('weil …', 'wegen', 'es regnete', 'des Regens', 'wegen des Regens', 'because of the rain'),
            ('weil …', 'dank', 'du hast geholfen', 'deiner Hilfe', 'dank deiner Hilfe', 'thanks to your help'),
            ('nachdem …', 'nach', 'wir haben gegessen', 'dem Essen', 'nach dem Essen', 'after the meal'),
            ('als …', 'bei', 'er kam an', 'seiner Ankunft', 'bei seiner Ankunft', 'when he arrived'),
        ]),
        cols(
            table('Times', ['clause', 'phrase'], [
                ['bevor', 'vor + Dat'], ['nachdem', 'nach + Dat'], ['während', 'während + Gen'], ['als · wenn', 'bei + Dat'],
            ]),
            table('aus or vor?', ['', '~'], [
                ['*aus* Angst sagte er nichts', 'a reason you act on'], ['*vor* Angst zittern', 'a feeling that overwhelms you'],
            ]),
        ),
        words('Words for the practice page', [
            ('der Sturm · des Sturms', 'storm'), ('die Krankheit', 'illness'),
            ('die Ankunft', 'arrival'), ('der Umzug', 'move'), ('die Landung', 'landing'), ('klatschen', 'to clap'),
            ('die Passagiere', 'passengers'), ('die Kälte', 'cold'),
            ('die Neugier', 'curiosity'), ('weinen', 'to cry'), ('die Freude', 'joy'), ('glücklicher', 'happier'),
            ('stürmte', 'there was a storm'), ('krank', 'ill'), ('der Strom', 'power'),
            ('landete', 'landed'), ('klatschten', 'clapped'), ('zitterte', 'shook'), ('öffnete', 'opened'), ('weinte', 'cried'),
        ], 4),
    ],
    [
        gaps('Shorter', 'Write the phrase.', [
            ('weil es stürmte →', 'fiel der Strom aus.', 'Wegen des Sturms'),
            ('weil er krank war →', 'blieb er zu Hause.', 'Wegen seiner Krankheit'),
            ('Nachdem wir gegessen hatten, gingen wir. →', 'gingen wir.', 'Nach dem Essen'),
            ('Als das Flugzeug landete, klatschten alle. →', 'klatschten alle Passagiere.', 'Bei der Landung'),
            ('Seit sie umgezogen ist, ist sie glücklicher. →', 'ist sie glücklicher.', 'Seit ihrem Umzug'),
        ]),
        circle('aus or vor?', 'Circle the right word.', [
            ('', ['Vor', 'Aus'], 'Kälte zitterte er.', 'Vor'), ('', ['Aus', 'Vor'], 'Neugier öffnete sie den Brief.', 'Aus'),
            ('Sie weinte', ['vor', 'aus'], 'Freude.', 'vor'),
        ], 1),
    ],
    ['turn weil into wegen, aufgrund, dank',
     'turn nachdem, als, seit into a phrase',
     'choose aus or vor'],
))

# ---- 18 · Ich hoffe, zu bestehen ----------------------------------------------------------
spreads.append(spread(
    'infinitiv', 'Ich hoffe, die Prüfung zu bestehen', 'dass or zu? um … zu or damit?',
    'One question decides: does the same person do both things? Then zu. Someone else? Then dass or damit.',
    Q + 'dass_infinitiv',
    [
        flow('dass or zu?', q('Does the same person do both?',
                              a('zu + infinitive', 'Ich hoffe, die Prüfung zu bestehen.'),
                              a('dass, damit, ohne dass', 'Ich hoffe, dass du die Prüfung bestehst.'))),
        table('The three pairs', ['same person', 'someone else'], [
            ['um … zu', 'damit'], ['ohne … zu', 'ohne dass'], ['statt … zu', 'statt dass'],
        ], 'Er ging, ohne zu grüßen. · Er ging, ohne dass ihn jemand sah.'),
        build('Where zu goes', [
            (['zu', 'bestehen'], 'zu bestehen', 'before the infinitive'), (['ein', ('zu', 'joint'), 'laden'], 'einzuladen', 'inside a two-part verb'),
            (['gewusst', 'zu', 'haben'], 'gewusst zu haben', 'the past'),
        ]),
        words('Words for the practice page', [
            ('hoffen', 'to hope'), ('bestehen', 'to pass'), ('versprechen', 'to promise'), ('bitten · ich bitte dich', 'to ask'),
            ('raten · er rät', 'to advise'), ('empfehlen', 'to recommend'), ('behaupten', 'to claim'), ('grüßen', 'to say hello'),
            ('der Vertrag', 'contract'), ('unterschrieb', 'signed'), ('ihn', 'it'), ('jemand', 'someone'), ('sah', 'saw'),
            ('sparen', 'to save'), ('die Tochter', 'daughter'), ('wiedersehen', 'to see again'), ('mehr', 'more'),
            ('sich verabschieden', 'to say goodbye'), ('wusste', 'knew'), ('er verspricht', 'he promises'), ('nahm', 'took'), ('ihr Mann', 'her husband'), ('studieren', 'to study'),
        ], 4),
    ],
    [
        write('zu or dass?', 'Write it with zu if you can — if not, keep dass.', [
            ('Ich hoffe, dass ich die Prüfung bestehe.', 'Ich hoffe, die Prüfung zu bestehen.'),
            ('Ich hoffe, dass du die Prüfung bestehst.', 'Ich hoffe, dass du die Prüfung bestehst.'),
            ('Er verspricht, dass er kommt.', 'Er verspricht zu kommen.'),
            ('Ich bitte dich, dass du mir hilfst.', 'Ich bitte dich, mir zu helfen.'),
        ], 1),
        gaps('um, damit, ohne', 'Write um, damit, ohne or ohne dass.', [
            ('Ich spare,', 'ein Auto zu kaufen.', 'um'),
            ('Ich spare,', 'meine Tochter studieren kann.', 'damit'),
            ('Sie unterschrieb den Vertrag,', 'ihn zu lesen.', 'ohne'),
            ('Sie nahm das Auto,', 'ihr Mann davon wusste.', 'ohne dass'),
        ]),
    ],
    ['replace dass with zu when the person is the same',
     'choose um … zu or damit',
     'put zu inside two-part verbs: einzuladen'],
))

# ---- 19 · Du brauchst nicht zu kommen -----------------------------------------------------
spreads.append(spread(
    'brauchen', 'Du brauchst nicht zu kommen', 'You don’t have to — and you mustn’t',
    'Du musst nicht kommen = Du brauchst nicht zu kommen. Du darfst nicht kommen is a ban.',
    Q + 'brauchen_zu',
    [
        flow('“don’t have to” or “mustn’t”?', q('Is it forbidden?',
                                                 a('nicht dürfen', 'Du darfst hier nicht parken.'),
                                                 a('nicht brauchen zu', 'Du brauchst nicht zu kommen.'))),
        slots('brauchen needs nicht, kein, nur or erst', [
            (sl('Du', 'brauchst!', 'nicht', 'zu kommen.!'), 'you needn’t'),
            (sl('Sie', 'brauchen!', 'keine Angst', 'zu haben.!'), None),
            (sl('Sie', 'brauchen!', 'nur hier', 'zu unterschreiben.!'), 'you only need to'),
        ], note='Never “Du brauchst zu kommen” — for yes, use müssen.'),
        table('In the past', ['', ''], [['Präteritum', 'Wir *brauchten* nicht zu warten.'], ['Perfekt', 'Wir haben nicht zu warten *brauchen*.']]),
        words('Words for the practice page', [
            ('kochen', 'to cook'), ('essen gehen', 'to eat out'), ('bezahlen', 'to pay'), ('heute', 'today'),
            ('mitkommen · mitzukommen', 'to come along'), ('die Angst', 'fear'), ('unterschreiben', 'to sign'),
            ('nichts', 'nothing'), ('brauchte', 'needed'), ('die Jacke', 'jacket'), ('warm', 'warm'), ('mitnehmen · mitzunehmen', 'to take'),
        ], 4),
    ],
    [
        gaps('brauchen + zu', 'Write brauchen in the right form.', [
            ('Du', 'heute nicht zu kochen, wir gehen essen.', 'brauchst'),
            ('Sie', 'nur hier zu unterschreiben.', 'brauchen'),
            ('Er', 'nichts zu bezahlen. (past)', 'brauchte'),
        ]),
        write('Say it with brauchen', 'Write it with nicht brauchen … zu.', [
            ('Du musst nicht mitkommen.', 'Du brauchst nicht mitzukommen.'),
            ('Ihr müsst keine Angst haben.', 'Ihr braucht keine Angst zu haben.'),
        ], 1),
        circle('Ban or no need?', 'Circle the right verb.', [
            ('Hier', ['darf', 'braucht'], 'man nicht rauchen.', 'darf'),
            ('Es ist warm, du', ['brauchst', 'darfst'], 'keine Jacke mitzunehmen.', 'brauchst'),
        ], 1),
    ],
    ['say you needn’t with nicht brauchen zu',
     'say you only need to with nur brauchen zu',
     'keep dürfen nicht for a ban'],
))

# ---- 20 · Eine Stellungnahme --------------------------------------------------------------
spreads.append(spread(
    'stellungnahme', 'Meiner Ansicht nach …', 'Taking a position in writing',
    'Position, reasons, the other side, a conclusion: a Stellungnahme has a fixed shape — and fixed phrases.',
    Q + 'stellungnahme',
    [
        slots('The shape', [
            ([('In letzter Zeit wird viel darüber diskutiert, ob …', 'the question'), ('Dafür spricht, dass …', 'pro')], None),
            ([('Dagegen lässt sich einwenden, dass …', 'contra'), ('Meiner Ansicht nach …', 'your view')], None),
            ([{'de': 'Zusammenfassend lässt sich sagen, dass …', 'tag': 'conclusion', 'hot': True}], None),
        ]),
        table('The phrases and their grammar', ['phrase', 'then'], [
            ['Dafür spricht, dass …', 'verb last'], ['Meiner Ansicht nach …', 'verb next — no dass!'],
            ['Zwar …, aber …', 'concede, then turn'], ['Ich würde vorschlagen, …', 'zu + infinitive'],
        ]),
        box('watch', 'The classic mistake', 'Not *Meiner Meinung nach, dass …* but *Meiner Meinung nach überwiegen die Vorteile.*'),
        words('Words for the practice page', [
            ('die Vorteile', 'advantages'), ('überwiegen', 'to outweigh'), ('die Innenstadt', 'city centre'), ('autofrei', 'car-free'),
            ('sauberer', 'cleaner'), ('die Luft', 'air'), ('die Kunden', 'customers'), ('vom Land', 'from the country'),
            ('der Nahverkehr', 'public transport'), ('besser werden', 'to get better'), ('die Straße · einzelne Straßen', 'street'),
            ('sich einig sein', 'to agree'), ('beginnen', 'to start'), ('der Kompromiss', 'compromise'), ('das Argument', 'argument'),
            ('man spart Zeit', 'you save time'), ('beide Seiten', 'both sides'), ('der Austausch fehlt', 'the exchange is missing'), ('würde', 'would'),
        ], 4),
    ],
    [
        gaps('The phrases', 'Write the missing word.', [
            ('Dafür', ', dass man Zeit spart.', 'spricht'),
            ('Meiner Ansicht nach', 'die Vorteile.', 'überwiegen'),
            ('', 'spart man Zeit, aber der Austausch fehlt.', 'Zwar'),
            ('', 'lässt sich sagen, dass beide Seiten recht haben.', 'Zusammenfassend'),
        ]),
        circle('A debate on the radio', 'Listen to the debate. Circle what you hear.', [
            ('Frau Keller will die Innenstadt', ['autofrei', 'grün'], 'machen.', 'autofrei'),
            ('Herr Brandt: Die Kunden kommen vom', ['Land', 'Meer'], '.', 'Land'),
            ('Beide sind sich einig: Der Nahverkehr muss', ['besser', 'billiger'], 'werden.', 'besser'),
        ], 1) | {'listen': True},
        gaps('Your view', 'Write your own Stellungnahme in three sentences: should city centres be car-free?', [
            ('Dafür spricht, dass', '.'), ('Dagegen lässt sich einwenden, dass', '.'), ('Meiner Ansicht nach', '.'),
        ], 'About you.'),
    ],
    ['build a Stellungnahme: pro, contra, view, conclusion',
     'use the phrases with the right word order',
     'follow a debate'],
    listen=Q + 'hoeren_debatte',
))

# ---- Review 3 · topics 15–20 ---------------------------------------------------------------
spreads.append(review(
    'review_3', 'Topics 15–20', 'The last part, all at once. No looking back until you have done both pages.',
    Q + 'sprechen_dialog',
    [
        gaps('Joining and ordering', 'Write the missing word.', [
            ('Es war teuer.', 'haben wir es gekauft.', 'Trotzdem'),
            ('Nimm einen Schirm,', 'wirst du nass.', 'sonst'),
            ('Kannst du mir das Salz geben? – Ich gebe', 'dir sofort.', 'es'),
            ('weil es regnete →', 'Regens', 'wegen des'),
        ]),
    ],
    [
        gaps('zu and brauchen', 'Write the missing word.', [
            ('Ich hoffe, die Prüfung', 'bestehen.', 'zu'),
            ('Ich spare,', 'meine Tochter studieren kann.', 'damit'),
            ('Du brauchst nicht', 'kommen.', 'zu'),
            ('Meiner Ansicht nach', 'die Vorteile.', 'überwiegen'),
        ]),
    ],
))

book = {
    'title': 'Berichten & Argumentieren',
    'cover': 'cp_b2_1_cover',
    'welcome': [
        'This book is the paper half of B2.1. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It has three parts. The first is about passing on what others say, the way a newspaper does. The second is the passive and the small building blocks of written German. The third is about arguing: joining, ordering and taking a position.',
        'It carries on from the earlier books. Words you learned there are not taught again. Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Paul', 'Mia', 'Tom', 'Anna', 'Keller', 'Brandt', 'Neustadt', 'Gent', 'Karin', 'Schmidt',
              'Hamburg', 'Berlin', 'München', 'Bayern', 'Leipzig', 'Wien', 'Rom', 'Euro', 'Oma'],
    'spreads': spreads,
    'overview': {'title': 'B2.1 at a glance', 'blocks': [
        table('Reported speech', ['', 'direct', 'reported'], [
            ['now', 'Ich bin krank.', 'er sei krank'], ['', 'Ich habe keine Zeit.', 'sie habe keine Zeit'],
            ['past', 'Ich habe es geschickt.', 'er habe es geschickt'], ['', 'Ich bin gekommen.', 'sie sei gekommen'],
            ['question', 'Kommst du?', 'ob ich komme'], ['request', 'Warte!', 'ich solle / möge warten'],
        ]),
        table('The passive', ['', 'like this'], [
            ['with a modal', 'muss gelöst werden · musste gelöst werden'], ['Perfekt', 'ist gebaut worden'],
            ['action ↔ state', 'wird geöffnet ↔ ist geöffnet'], ['no subject', 'Hier wird getanzt. · Ihm wird geholfen.'],
        ]),
        cols(
            table('Clause → phrase', ['clause', 'phrase'], [
                ['weil', 'wegen · aufgrund · dank'], ['nachdem', 'nach'], ['bevor', 'vor'], ['als', 'bei'], ['seit', 'seit'],
            ]),
            table('Same person?', ['yes', 'no'], [
                ['zu', 'dass'], ['um … zu', 'damit'], ['ohne … zu', 'ohne dass'],
            ]),
        ),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.', [
            ('der Kronleuchter', 'chandelier', 'cpd_kronleuchter'), ('die Tischklingel', 'desk bell', 'cpd_tischklingel'),
            ('das Gästebuch', 'guest book', 'cpd_gaestebuch'), ('der Gepäckwagen', 'luggage trolley', 'cpd_gepaeckwagen'),
            ('der Koffer', 'suitcase', 'cpd_koffer'), ('das Klavier', 'piano', 'cpd_klavier'),
            ('der Schirmständer', 'umbrella stand', 'cpd_schirmstaender'), ('der Wasserspender', 'water cooler', 'cpd_wasserspender'),
            ('der Blumentopf', 'flowerpot', 'cpd_blumentopf'), ('die Überwachungskamera', 'security camera', 'cpd_ueberwachungskamera'),
            ('der Bagger', 'digger', 'cpd_bagger'), ('der Betonmischer', 'cement mixer', 'cpd_betonmischer'),
            ('die Schubkarre', 'wheelbarrow', 'cpd_schubkarre'), ('das Gerüst', 'scaffolding', 'cpd_geruest'),
            ('der Helm', 'hard hat', 'cpd_helm'), ('die Wasserwaage', 'spirit level', 'cpd_wasserwaage'),
            ('der Hammer', 'hammer', 'cpd_hammer'), ('die Leiter', 'ladder', 'cpd_leiter'),
            ('der Kran', 'crane', 'cpd_kran'), ('die Baustelle', 'building site', 'cpd_baustelle'),
            ('das Mikrofon', 'microphone', 'cpd_mikrofon'), ('die Wahlurne', 'ballot box', 'cpd_wahlurne'),
            ('der Stimmzettel', 'ballot paper', 'cpd_stimmzettel'), ('die Fahne', 'flag', 'cpd_fahne'),
            ('der Briefkasten', 'postbox', 'cpd_briefkasten'), ('die Zeitung', 'newspaper', 'cpd_zeitung'),
            ('das Radio', 'radio', 'cpd_radio'), ('der Laptop', 'laptop', 'cpd_laptop'),
            ('das Ei', 'egg', 'cpd_ei'), ('das Hemd', 'shirt', 'cpd_hemd'),
            ('der Schirm', 'umbrella', 'cpd_regenschirm'), ('der Vertrag', 'contract', 'cpd_vertrag'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

kit.write_book(OUT, book)
