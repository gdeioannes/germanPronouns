# Builds assets/content/companion/de_cert_a1/a2_2.json — the A2.2 study companion.
# Run: python -I tool/companion/a2_2.py   (rules: docs/study_companion_guide.md)
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_a2_2_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'a2_2.json')
Q = 'quest_a2_2_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ---- 1 · Wo? ---------------------------------------------------------------------
spreads.append(spread(
    'wechsel_wo', 'Wo?', 'Where things are: nine little words + dem, der',
    'The book on the table, the cat under the bed: when nothing moves, these nine words take the dative.',
    Q + 'wechsel_wo',
    [
        pictures('The cat and the basket', [
            ('cp_a2_2_katze_auf', 'auf dem Korb', 'on'), ('cp_a2_2_katze_in', 'im Korb', 'in'),
            ('cp_a2_2_katze_unter', 'unter dem Korb', 'under'), ('cp_a2_2_katze_neben', 'neben dem Korb', 'next to'),
            ('cp_a2_2_katze_vor', 'vor dem Korb', 'in front of'), ('cp_a2_2_katze_hinter', 'hinter dem Korb', 'behind'),
        ], 6, note='Wo ist die Katze? She sits still: dem.'),
        tiles('Nine words for places', [
            ('auf', 'on (top of)'), ('unter', 'under'), ('in', 'in'), ('an', 'at, on (a wall)'), ('neben', 'next to'),
            ('vor', 'in front of'), ('hinter', 'behind'), ('über', 'above'), ('zwischen', 'between'),
        ], 5),
        table('Wo? — nothing moves: dem, der', ['~', 'der', 'die', 'das', 'plural'], [
            ['Wo?', 'auf *dem* Tisch', 'an *der* Wand', 'unter *dem* Bett', 'zwischen *den* Häusern'],
        ], 'Remember wem? from A2.1: the same dem, der, dem, den.', genders=True),
        cols(
            table('Verbs of being somewhere', ['', '~'], [
                ['stehen', 'stand (upright)'], ['liegen', 'lie (flat)'], ['sitzen', 'sit'], ['hängen', 'hang'],
            ], 'Das Buch *liegt* auf dem Tisch. Das Bild *hängt* an der Wand.'),
            box('tip', 'Still = dem, der',
                'Nothing moves, so the dative: auf *dem* Tisch, an *der* Wand. In the next topic the cat jumps.'),
        ),
        words('Words for the practice page', [
            ('der Korb', 'basket'), ('das Regal', 'shelf'), ('die Schuhe', 'shoes'), ('die Vase', 'vase'),
            ('der Teppich', 'rug'), ('die Wand', 'wall'), ('das Bett · die Betten', 'bed · beds'),
        ], 3),
    ],
    [
        gaps('In the living room', 'Look at the picture on the left page. Where is everything?', [
            ('Das Buch liegt', '. (der Tisch)', 'auf dem Tisch'), ('Das Bild hängt', '. (die Wand)', 'an der Wand'),
            ('Die Lampe hängt', '. (der Tisch)', 'über dem Tisch'), ('Die Schuhe stehen', '. (die Tür)', 'neben der Tür'),
            ('Die Katze schläft', '. (das Sofa)', 'unter dem Sofa'),
        ]),
        gaps('dem, der or den?', 'Write the article.', [
            ('Das Buch liegt auf', 'Tisch. (der)', 'dem'), ('Das Bild hängt an', 'Wand. (die)', 'der'),
            ('Das Auto steht vor', 'Haus. (das)', 'dem'), ('Die Lampe hängt über', 'Tisch. (der)', 'dem'),
            ('Die Schuhe stehen neben', 'Tür. (die)', 'der'), ('Der Tisch steht zwischen', 'Betten. (die)', 'den'),
        ]),
        gaps('My room', 'Write two true sentences about your room.', [
            ('Mein Bett steht', '.'), ('An der Wand hängt', '.'),
        ], 'About you — Wo? takes dem, der.'),
    ],
    ['say where things are with the nine place words',
     'use dem and der when nothing moves',
     'describe my room'],
))

# ---- 2 · Wohin? ------------------------------------------------------------------
spreads.append(spread(
    'wechsel_wohin', 'Wohin?', 'Putting things somewhere: den, die, das',
    'Now the cat jumps: the same nine words, but when something moves, they take den, die, das.',
    Q + 'wechsel_wohin',
    [
        flow('Wo? or Wohin?', q('Does something move to a place?',
                                a('Wohin? den · die · das', 'auf den Tisch'),
                                a('Wo? dem · der', 'auf dem Tisch')),
             note='The arrow of movement: A for Akkusativ.'),
        table('Being there — putting it there', ['Wo? it is there', 'Wohin? you put it there'], [
            ['Das Buch *liegt* auf dem Tisch.', 'Ich *lege* das Buch auf *den* Tisch.'],
            ['Die Vase *steht* auf dem Regal.', 'Ich *stelle* die Vase auf *das* Regal.'],
            ['Das Kind *sitzt* auf dem Stuhl.', 'Ich *setze* das Kind auf *den* Stuhl.'],
            ['Das Bild *hängt* an der Wand.', 'Ich *hänge* das Bild an *die* Wand.'],
        ], 'liegen – legen, stehen – stellen, sitzen – setzen, hängen – hängen.'),
        cols(
            build('Two words become one', [
                (['in', ('das', 'joint')], 'ins', 'ins Bett'),
                (['an', ('das', 'joint')], 'ans', 'ans Fenster'),
                (['auf', ('das', 'joint')], 'aufs', 'aufs Sofa'),
            ]),
            box('watch', 'Only der changes',
                'auf *den* Tisch — but die Wand and das Regal look the same as always. Watch the der-words.'),
        ),
        words('Words for the practice page', [
            ('legen', 'to lay, put (flat)'), ('stellen', 'to put (upright)'), ('setzen', 'to seat, put'),
            ('springen', 'to jump'), ('sich setzen', 'to sit down'), ('der Schrank', 'cupboard'), ('der Teller', 'plate'),
        ], 3),
    ],
    [
        gaps('den, die or das?', 'Write the article.', [
            ('Ich lege das Buch auf', 'Tisch. (der)', 'den'), ('Die Katze springt unter', 'Bett. (das)', 'das'),
            ('Ich hänge das Bild an', 'Wand. (die)', 'die'), ('Wir gehen in', 'Park. (der)', 'den'),
            ('Ich stelle die Vase auf', 'Regal. (das)', 'das'), ('Ich setze mich neben', 'Mann. (der)', 'den'),
        ]),
        circle('Wo? or Wohin?', 'Circle the right word.', [
            ('Das Buch liegt auf', ['dem', 'den'], 'Tisch.', 'dem'), ('Ich lege das Buch auf', ['dem', 'den'], 'Tisch.', 'den'),
            ('Die Katze', ['sitzt', 'setzt'], 'auf dem Sofa.', 'sitzt'), ('Ich', ['stelle', 'stehe'], 'die Schuhe vor die Tür.', 'stelle'),
            ('Der Hund springt', ['ins', 'im'], 'Wasser.', 'ins'), ('Der Hund schwimmt', ['ins', 'im'], 'Wasser.', 'im'),
        ]),
        write('Tidy up!', 'Say where you put each thing.', [
            ('das Buch · das Regal', 'Ich stelle das Buch ins Regal.'),
            ('die Jacke · der Schrank', 'Ich hänge die Jacke in den Schrank.'),
            ('der Teller · der Tisch', 'Ich stelle den Teller auf den Tisch.'),
        ], 1),
    ],
    ['tell Wo? from Wohin?',
     'use legen, stellen, setzen, hängen',
     'say where I put things'],
))

# ---- 3 · Ich freue mich --------------------------------------------------------------
spreads.append(spread(
    'reflexiv', 'Ich freue mich', 'Verbs with mich, dich, sich',
    'Ich freue mich! A little word bounces the verb back onto you — and only one form, sich, is new.',
    Q + 'reflexiv',
    [
        table('mich, dich, sich', ['who', 'back to …', '~'], [
            ['ich', 'mich', 'Ich freue *mich*.'], ['du', 'dich', 'Freust du *dich*?'],
            ['er · sie · es', '*sich*', 'Er freut *sich*.'], ['wir', 'uns', 'Wir freuen *uns*.'],
            ['ihr', 'euch', 'Freut ihr *euch*?'], ['sie · Sie', '*sich*', 'Sie freuen *sich*.'],
        ], 'Only sich is new.'),
        cols(
            tiles('Always with sich', [
                ('sich freuen', 'be glad'), ('sich beeilen', 'hurry'), ('sich erinnern', 'remember'),
                ('sich ausruhen', 'rest'), ('sich erkälten', 'catch a cold'), ('sich interessieren', 'be interested'),
            ], 2),
            slots('Where it goes', [
                (sl('Ich', 'freue!', 'mich!', 'sehr.'), None),
                (sl('Freust!', 'du', 'dich!', '?'), None),
                (sl('Ich', 'muss!', 'mich!', 'beeilen.'), None),
            ], note='Right after the verb — or after du.'),
        ),
        box('tip', 'Me or the car?',
            'Ich wasche *das Auto* — ich wasche *mich*. Ich setze *das Kind* — ich setze *mich*. When it comes back to you, it’s mich.'),
        words('Words for the practice page', [
            ('sich waschen', 'to wash (yourself)'), ('sich anziehen · zieht euch an!', 'to get dressed'), ('sich treffen', 'to meet'),
            ('auch', 'too, also'), ('das Bad', 'bathroom'), ('die Garage', 'garage'),
            ('duschen', 'to shower'), ('warm', 'warm'), ('das Wochenende', 'weekend'),
        ], 3),
    ],
    [
        gaps('mich, dich, sich …', 'Write the little word for the person in brackets.', [
            ('Ich freue', 'auf das Wochenende. (ich)', 'mich'), ('Freust du', 'auch? (du)', 'dich'),
            ('Er interessiert', 'für Musik. (er)', 'sich'), ('Wir treffen', 'um acht Uhr. (wir)', 'uns'),
            ('Zieht', 'warm an! (ihr)', 'euch'), ('Die Kinder freuen', '. (sie)', 'sich'),
            ('Sie duscht', 'am Abend. (sie)', 'sich'), ('Rocky, du musst', 'beeilen! (du)', 'dich'),
        ]),
        circle('With or without?', 'Circle the right sentence part.', [
            ('Ich wasche', ['mich', 'das Auto'], 'jeden Morgen im Bad.', 'mich'),
            ('Ich wasche', ['mich', 'das Auto'], 'in der Garage.', 'das Auto'),
            ('Wir', ['freuen uns', 'freuen'], 'auf den Urlaub.', 'freuen uns'),
        ], 1),
        gaps('Looking forward', 'Write two true sentences.', [
            ('Ich freue mich auf', '.'), ('Ich interessiere mich für', '.'),
        ], 'About you.'),
    ],
    ['use mich, dich, sich, uns, euch',
     'say what I’m looking forward to',
     'tell washing the car from washing myself'],
))

# ---- 4 · weil & dass -----------------------------------------------------------------
spreads.append(spread(
    'weil_dass', 'weil & dass', 'The verb goes to the very end',
    'Say weil — and kick the verb to the end. dass does exactly the same.',
    Q + 'weil',
    [
        slots('The kick', [
            (sl('Ich bleibe zu Hause,', 'weil', 'ich krank', 'bin.!'), 'because I’m ill'),
            (sl('Ich glaube,', 'dass', 'er recht', 'hat.!'), 'that he’s right'),
            (sl('Er ist müde,', 'weil', 'er schlecht geschlafen', 'hat.!'), 'two verbs: the helper last'),
            (sl('Ich weiß,', 'dass', 'ich früh aufstehen', 'muss.!'), 'a helper last'),
        ], note='Remember weil from A2.1 — now with two verbs.'),
        cols(
            table('Openers for dass', ['', '~'], [
                ['Ich glaube, dass …', 'I think that'], ['Ich hoffe, dass …', 'I hope that'],
                ['Ich weiß, dass …', 'I know that'], ['Er sagt, dass …', 'he says that'],
                ['Es ist gut, dass …', 'it’s good that'],
            ]),
            box('watch', 'das or dass?',
                '*das* is the, that one: Das Buch ist gut. *dass* joins two sentences: Ich weiß, *dass* du kommst. Can you say dieses? Then it’s das.'),
        ),
        words('Words for the practice page', [
            ('glauben', 'to believe, think'), ('hoffen', 'to hope'), ('recht haben', 'to be right'),
            ('schlecht', 'bad, badly'), ('die Ausstellung', 'exhibition'), ('voll', 'full, crowded'),
            ('der Studentenausweis', 'student card'), ('das Kunstmuseum', 'art museum'), ('der Eintritt', 'entry'),
        ], 3),
    ],
    [
        write('Kick the verb', 'Join with weil or dass.', [
            ('Ich bleibe zu Hause. (weil) Ich bin krank.', 'Ich bleibe zu Hause, weil ich krank bin.'),
            ('Ich hoffe. (dass) Das Wetter ist schön.', 'Ich hoffe, dass das Wetter schön ist.'),
            ('Er ist müde. (weil) Er hat schlecht geschlafen.', 'Er ist müde, weil er schlecht geschlafen hat.'),
            ('Sie sagt. (dass) Sie kommt morgen.', 'Sie sagt, dass sie morgen kommt.'),
        ], 1),
        circle('das or dass?', 'Circle the right word.', [
            ('', ['Das', 'Dass'], 'Buch ist gut.', 'Das'), ('Ich weiß,', ['das', 'dass'], 'du kommst.', 'dass'),
            ('Es ist schön,', ['das', 'dass'], 'du da bist.', 'dass'), ('', ['Das', 'Dass'], 'ist toll!', 'Das'),
        ]),
        circle('Jan’s message', 'Listen to Jan’s message for Lisa. Circle what you hear.', [
            ('Jan und Lisa gehen am', ['Samstag', 'Sonntag'], 'ins Museum.', 'Samstag'),
            ('Die Ausstellung ist im', ['Kunstmuseum', 'Kino'], '.', 'Kunstmuseum'),
            ('Sie gehen um drei, weil es dann nicht so', ['voll', 'teuer'], 'ist.', 'voll'),
            ('Mit Studentenausweis kostet der Eintritt', ['vier', 'acht'], 'Euro.', 'vier'),
        ], 1) | {'listen': True},
    ],
    ['give a reason with weil, verb last',
     'say what I think or hope with dass',
     'tell das from dass'],
    listen=Q + 'hoeren_verabredung',
))

# ---- 5 · wenn & deshalb ----------------------------------------------------------------
spreads.append(spread(
    'wenn_deshalb', 'wenn & deshalb', 'If and when — and so',
    'Wenn ich Zeit habe, komme ich: the two verbs meet at the comma. deshalb gives the result.',
    Q + 'wenn_deshalb',
    [
        slots('Verb, comma, verb', [
            (sl('Wenn', 'ich', 'Zeit', 'habe,!', 'komme!', 'ich.'), 'If I have time, I’ll come.'),
            (sl('Wenn', 'es', '', 'regnet,!', 'bleiben!', 'wir zu Hause.'), 'When it rains, we stay home.'),
        ], note='The wenn-verb closes its part; the next verb opens the next.'),
        table('One fact, two directions', ['the reason: weil (verb last)', 'the result: deshalb (verb second)'], [
            ['Ich bleibe zu Hause, weil es *regnet*.', 'Es regnet, deshalb *bleibe* ich zu Hause.'],
            ['Ich gehe ins Bett, weil ich müde *bin*.', 'Ich bin müde, deshalb *gehe* ich ins Bett.'],
        ]),
        box('watch', 'wenn is not one time in the past',
            '*wenn* = if, or whenever: Wenn ich Hunger habe, koche ich. For one time in the past German says *als*: Als ich ein Kind war …'),
        words('Words for the practice page', [
            ('wandern', 'to hike'), ('das Taxi', 'taxi'), ('zu spät', 'too late'), ('kochen', 'to cook'),
            ('drinnen', 'inside'), ('anrufen · ruf mich an', 'to call · call me'),
        ], 3),
    ],
    [
        write('Wenn …', 'Start with wenn.', [
            ('Ich habe Zeit. Ich komme gern.', 'Wenn ich Zeit habe, komme ich gern.'),
            ('Das Wetter ist schön. Wir gehen wandern.', 'Wenn das Wetter schön ist, gehen wir wandern.'),
            ('Ich habe Hunger. Ich koche etwas.', 'Wenn ich Hunger habe, koche ich etwas.'),
        ], 1),
        write('… deshalb …', 'Say it again with deshalb.', [
            ('Ich bleibe zu Hause, weil es regnet.', 'Es regnet, deshalb bleibe ich zu Hause.'),
            ('Ich nehme ein Taxi, weil der Bus zu spät kommt.', 'Der Bus kommt zu spät, deshalb nehme ich ein Taxi.'),
        ], 1),
        circle('Where is the verb?', 'Circle the right order.', [
            ('Er ist krank, deshalb', ['kommt er', 'er kommt'], 'nicht.', 'kommt er'),
            ('Ruf mich an, wenn', ['du zu Hause bist', 'du bist zu Hause'], '.', 'du zu Hause bist'),
        ], 1),
        gaps('Your plans', 'Finish the sentences.', [
            ('Wenn ich Zeit habe,', '.'), ('Ich lerne Deutsch, deshalb', '.'),
        ], 'About you.'),
    ],
    ['make plans with wenn',
     'give a result with deshalb',
     'turn weil into deshalb'],
))

# ---- 6 · Wissen Sie, ob …? -----------------------------------------------------------
spreads.append(spread(
    'indirekt', 'Wissen Sie, ob …?', 'Asking politely: wrapped questions',
    'Wo ist der Bahnhof? is fine for friends. For strangers, wrap it — and the verb goes to the end.',
    Q + 'indirekte_fragen',
    [
        flow('Which word starts the wrap?', q('Does the question start with a W-word?',
                                               a('keep it', 'wo, wann, wie …'), a('ob', 'yes or no')),
             note='ob = whether, if.'),
        slots('Wrap it, verb last', [
            (sl('Wo', 'ist!', 'der Bahnhof?'), 'the question'),
            (sl('Können Sie mir sagen,', 'wo', 'der Bahnhof', 'ist?!'), 'wrapped'),
            (sl('Ist', 'das Geschäft', 'offen?'), 'a yes/no question'),
            (sl('Wissen Sie,', 'ob', 'das Geschäft offen', 'ist?!'), 'wrapped with ob'),
        ]),
        table('The wrappers', ['', '~'], [
            ['Können Sie mir sagen, …?', 'can you tell me'], ['Wissen Sie, …? · Weißt du, …?', 'do you know'],
            ['Ich weiß nicht, …', 'I don’t know'], ['Ich frage mich, …', 'I wonder'],
        ]),
        words('Words for the practice page', [
            ('das Geschäft', 'shop'), ('offen', 'open'), ('bedeuten', 'to mean'), ('die Toilette', 'toilet'),
            ('abfahren · …, wann der Zug abfährt', 'to leave'),
        ], 4),
    ],
    [
        gaps('ob or a W-word?', 'Write ob, wo, wann, wie or was.', [
            ('Wissen Sie,', 'das Geschäft offen ist?', 'ob'), ('Können Sie mir sagen,', 'der Bahnhof ist?', 'wo'),
            ('Ich weiß nicht,', 'er kommt.', 'ob'), ('Könnten Sie mir sagen,', 'der Zug abfährt?', 'wann'),
            ('Können Sie mir sagen,', 'ich zum Museum komme?', 'wie'), ('Könnten Sie mir sagen,', 'das bedeutet?', 'was'),
        ]),
        write('Wrap it', 'Ask politely: Können Sie mir sagen, …?', [
            ('Wo ist die Toilette?', 'Können Sie mir sagen, wo die Toilette ist?'),
            ('Wann kommt der Bus?', 'Können Sie mir sagen, wann der Bus kommt?'),
            ('Ist hier eine Apotheke?', 'Können Sie mir sagen, ob hier eine Apotheke ist?'),
        ], 1),
    ],
    ['ask a stranger politely',
     'use ob for yes/no questions',
     'put the verb at the end in a wrapped question'],
))

# ---- 7 · Worauf wartest du? -----------------------------------------------------------
spreads.append(spread(
    'verben_praep', 'Worauf wartest du?', 'Verbs that come with their own little word',
    'You wait auf the bus and think an your holiday: learn each verb with its little word.',
    Q + 'verben_praep_intro',
    [
        table('Verb + little word', ['verb', '+', '~in English'], [
            ['warten', 'auf + den', 'wait for'], ['sich freuen', 'auf + den', 'look forward to'],
            ['sich freuen', 'über + den', 'be pleased about'], ['sich interessieren', 'für + den', 'be interested in'],
            ['sprechen', 'über + den', 'talk about'], ['denken · sich erinnern', 'an + den', 'think of · remember'],
            ['träumen', 'von + dem', 'dream of'], ['fragen', 'nach + dem', 'ask about'],
        ], 'Learn them as one piece: warten auf.'),
        cols(
            build('Asking about a thing', [
                (['wo', ('r', 'joint'), 'auf'], 'worauf?', 'Worauf wartest du?'),
                (['wo', 'für'], 'wofür?', 'Wofür interessierst du dich?'),
                (['wo', ('r', 'joint'), 'an'], 'woran?', 'Woran denkst du?'),
            ], 'An r before a vowel.'),
            build('Answering without repeating', [
                (['da', ('r', 'joint'), 'auf'], 'darauf', 'Ich warte darauf.'),
                (['da', 'für'], 'dafür', 'Ich interessiere mich dafür.'),
                (['da', ('r', 'joint'), 'an'], 'daran', 'Ich denke daran.'),
            ]),
        ),
        box('watch', 'auf or über?',
            'Ich freue mich *auf* das Wochenende — it’s coming. Ich freue mich *über* das Geschenk — I have it now.'),
        words('Words for the practice page', [
            ('träumen', 'to dream'), ('sich ärgern · ich ärgere mich', 'to be annoyed'), ('oft', 'often'), ('die Großeltern', 'grandparents'),
            ('der Tourist', 'tourist'), ('der Weg', 'way'), ('schlecht', 'bad'),
        ], 3),
    ],
    [
        gaps('The little word', 'Write auf, über, für, an, von or nach.', [
            ('Ich freue mich', 'das Wochenende.', 'auf'), ('Sie freut sich', 'das Geschenk.', 'über'),
            ('Wir warten', 'den Bus.', 'auf'), ('Interessierst du dich', 'Fußball?', 'für'),
            ('Ich denke oft', 'meine Großeltern.', 'an'), ('Er träumt', 'einem Haus am Meer.', 'von'),
            ('Der Tourist fragt', 'dem Weg.', 'nach'), ('Ich ärgere mich', 'das Wetter.', 'über'),
        ]),
        match('Question and answer', 'Draw a line from each question to its answer.', [
            ('Worauf wartest du?', 'Auf den Bus.'),
            ('Wofür interessierst du dich?', 'Für Musik.'),
            ('Woran denkst du?', 'An den Urlaub.'),
            ('Freust du dich auf die Party?', 'Ja, ich freue mich sehr darauf.'),
        ], [2, 0, 3, 1]),
        gaps('Your answers', 'Answer two questions about yourself.', [
            ('Worauf freust du dich? – Ich freue mich auf', '.'), ('Wofür interessierst du dich? – Für', '.'),
        ], 'About you.'),
    ],
    ['learn verbs with their little word',
     'ask worauf? wofür? woran?',
     'answer with darauf, dafür, daran'],
))

# ---- Review 1 · topics 1–7 --------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–7', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        circle('Wo? or Wohin?', 'Circle the right article.', [
            ('Die Katze liegt unter', ['dem', 'das'], 'Bett.', 'dem'), ('Die Katze springt unter', ['dem', 'das'], 'Bett.', 'das'),
            ('Ich hänge die Uhr an', ['der', 'die'], 'Wand.', 'die'), ('Die Uhr hängt an', ['der', 'die'], 'Wand.', 'der'),
        ]),
        gaps('mich, dich, sich', 'Write the little word.', [
            ('Wir freuen', 'auf den Sommer.', 'uns'), ('Er beeilt', '.', 'sich'), ('Interessierst du', 'für Musik?', 'dich'),
        ]),
    ],
    [
        write('Verb last', 'Join the sentences.', [
            ('Ich komme nicht. (weil) Ich habe keine Zeit.', 'Ich komme nicht, weil ich keine Zeit habe.'),
            ('Ich glaube. (dass) Er hat recht.', 'Ich glaube, dass er recht hat.'),
            ('Wissen Sie? (ob) Der Zug kommt.', 'Wissen Sie, ob der Zug kommt?'),
        ], 1),
        gaps('The little word', 'Write the little word.', [
            ('Ich warte', 'dich.', 'auf'), ('Wir sprechen', 'den Film.', 'über'),
        ]),
        match('Question and answer', 'Draw a line from each question to its answer.', [
            ('Wo ist mein Handy?', 'Auf dem Sofa.'),
            ('Wohin legst du das Buch?', 'Ins Regal.'),
            ('Warum kommst du nicht?', 'Weil ich krank bin.'),
            ('Worauf freust du dich?', 'Auf den Urlaub.'),
        ], [1, 3, 0, 2]),
    ],
))

# ---- 8 · Beim Arzt ----------------------------------------------------------------------
spreads.append(spread(
    'gesundheit', 'Beim Arzt', 'What hurts, since when — and what the doctor says',
    'Say what hurts and since when, understand the doctor, and get your medicine: a whole visit in German.',
    Q + 'gesundheit',
    [
        tiles('From the doctor to the pharmacy', [
            ('die Praxis', '1 the doctor’s surgery'), ('das Rezept', '2 the prescription'),
            ('die Apotheke', '3 the pharmacy'), ('das Medikament', '4 the medicine'),
        ], 4),
        table('You say — the doctor says', ['you', 'the doctor'], [
            ['Ich habe Kopfschmerzen.', 'Was fehlt Ihnen?'],
            ['Ich habe seit drei Tagen Fieber.', 'Wo tut es weh?'],
            ['Mein Hals tut weh.', 'Sie müssen viel trinken.'],
            ['*Mir ist schlecht.*', 'Sie sollten im Bett bleiben.'],
            ['Ich bin erkältet.', 'Nehmen Sie die Tabletten dreimal am Tag.'],
        ], 'Mir ist schlecht = I feel sick (mir, not ich!).'),
        cols(
            box('tip', 'seit + the present',
                'Ich habe *seit* gestern Fieber — and I still have it. Like seit in A2.1: present tense.'),
            box('culture', 'The Krankschreibung',
                'In Germany the doctor writes you a *Krankschreibung* — a note for work that says you are ill and for how long.'),
        ),
        words('Words for the practice page', [
            ('die Erkältung', 'cold'), ('der Husten', 'cough'), ('die Versichertenkarte', 'health-insurance card'),
            ('das Wartezimmer', 'waiting room'), ('die Temperatur', 'temperature'), ('dreimal am Tag', 'three times a day'),
            ('sich fühlen', 'to feel'), ('untersuchen', 'to examine'),
        ], 4),
    ],
    [
        gaps('Herr Berger at the doctor’s', 'Listen to the story and fill in the notes.', [
            ('Kopfschmerzen und Fieber seit', 'Tagen', 'drei'),
            ('Temperatur:', 'Grad', '38,5'),
            ('Er muss viel', 'und im Bett bleiben.', 'trinken'),
            ('Tabletten:', 'am Tag', 'dreimal'),
        ]) | {'listen': True},
        match('At the doctor’s', 'Draw a line from the doctor’s question to the answer.', [
            ('Was fehlt Ihnen?', 'Ich habe Fieber und Husten.'),
            ('Seit wann?', 'Seit drei Tagen.'),
            ('Wo tut es weh?', 'Hier, im Hals.'),
            ('Haben Sie Fieber?', 'Ja, 39 Grad.'),
        ], [1, 3, 0, 2]),
        gaps('Say it another way', 'Write the missing word.', [
            ('Mein Kopf tut weh. Ich habe', '.', 'Kopfschmerzen'), ('Ich habe eine Erkältung. Ich bin', '.', 'erkältet'),
        ]),
    ],
    ['say what hurts and since when',
     'understand what the doctor tells me',
     'get my medicine at the pharmacy'],
    listen=Q + 'lesen_arzt',
))

# ---- 9 · Ein neuer Mantel ---------------------------------------------------------------
spreads.append(spread(
    'kleidung', 'Ein neuer Mantel', 'Clothes, shops — and the endings of describing words',
    'A new coat, a red dress: in front of a noun the describing word takes an ending — and one signal is enough.',
    Q + 'kleidung',
    [
        build('One signal is enough', [
            (['ein', 'neu', ('er', 'suffix'), 'Mantel'], 'ein neuer Mantel', 'ein shows nothing — the -er says der'),
            (['der', 'neu', ('e', 'suffix'), 'Mantel'], 'der neue Mantel', 'der already says it — just -e'),
            (['ein', 'neu', ('es', 'suffix'), 'Kleid'], 'ein neues Kleid', 'the -es says das'),
            (['das', 'neu', ('e', 'suffix'), 'Kleid'], 'das neue Kleid', 'das says it — just -e'),
        ], 'Either the article shows the gender or the describing word does — never both.'),
        table('After ein: the describing word shows the gender', ['~', 'der', 'die', 'das'], [
            ['wer?', 'ein neu*er* Mantel', 'eine neu*e* Jacke', 'ein neu*es* Kleid'],
            ['wen?', 'einen neu*en* Mantel', 'eine neu*e* Jacke', 'ein neu*es* Kleid'],
        ], '-er, -e, -es: the ending of der, die, das.', genders=True),
        table('After der, die, das: just -e', ['~', 'der', 'die', 'das'], [
            ['wer?', 'der neu*e* Mantel', 'die neu*e* Jacke', 'das neu*e* Kleid'],
            ['wen?', 'den neu*en* Mantel', 'die neu*e* Jacke', 'das neu*e* Kleid'],
        ], 'The article already shows the gender, so the ending is quiet.', genders=True),
        table('In the shop', ['seller', 'you'], [
            ['Kann ich Ihnen helfen?', 'Ich suche eine Hose.'], ['Welche Größe?', '38.'],
            ['Möchten Sie sie anprobieren?', 'Ja, gern. Wo ist die Kabine?'],
            ['Passt sie?', 'Nein, sie ist *zu groß*. Haben Sie sie eine Nummer kleiner?'],
        ], 'passen and stehen take mir, dir: Die Jacke *steht dir* gut!'),
        words('Words for the practice page', [
            ('die Größe', 'size'), ('anprobieren', 'to try on'), ('tragen · sie trägt', 'to wear'), ('eng · weit', 'tight · loose'),
            ('das Hemd', 'shirt'), ('der Pullover', 'jumper'), ('das T-Shirt', 'T-shirt'), ('die Socken', 'socks'),
            ('aus Wolle', 'made of wool'),
        ], 3),
    ],
    [
        tags_ex('What is it?', 'Write each thing with der, die or das.', [
            ('cpd_hemd', '', 'das Hemd'), ('cpd_pullover', '', 'der Pullover'), ('cpd_schuhe', '', 'die Schuhe'),
            ('cpd_socken', '', 'die Socken'), ('cpd_tshirt', '', 'das T-Shirt'), ('cpd_hut', '', 'der Hut'),
        ]),
        gaps('After ein', 'Write the ending.', [
            ('Ich brauche einen neu', 'Mantel.', 'en'), ('Das ist ein schön', 'Kleid.', 'es'),
            ('Sie trägt eine rot', 'Jacke.', 'e'), ('Er hat ein neu', 'Hemd.', 'es'),
        ]),
        gaps('After der, die, das', 'Write the ending.', [
            ('Der rot', 'Pullover ist aus Wolle.', 'e'), ('Ich nehme den blau', 'Mantel.', 'en'),
            ('Das neu', 'T-Shirt kostet zehn Euro.', 'e'),
        ]),
    ],
    ['ask for my size and try clothes on',
     'say a new coat, a red dress with the right ending',
     'say what fits and suits me'],
))

# ---- 10 · Du solltest … ----------------------------------------------------------------
spreads.append(spread(
    'ratschlaege', 'Du solltest …', 'Suggestions, advice, and polite orders',
    'Wir könnten … and Du solltest … make you sound kind instead of bossy — and Nimm! Gib! Hilf! are friendly orders.',
    Q + 'koennte_sollte',
    [
        slots('A suggestion, a piece of advice', [
            (sl('Wir', 'könnten!', 'ins Kino', 'gehen.!'), 'a suggestion: could'),
            (sl('Du', 'solltest!', 'mehr', 'schlafen.!'), 'advice: should'),
            (sl('Sie', 'sollten!', 'zum Arzt', 'gehen.!'), 'polite advice'),
        ], note='The bracket of every helper verb.'),
        box('watch', 'könnte or konnte?',
            '*konnte* is the past: Ich konnte nicht kommen. *könnte* — with dots — is could, maybe: Ich könnte morgen kommen.'),
        cols(
            build('du-orders with the vowel change', [
                (['nimm', ('st', 'cut')], 'Nimm!', 'du nimmst'),
                (['gib', ('st', 'cut')], 'Gib!', 'du gibst'),
                (['hilf', ('st', 'cut')], 'Hilf!', 'du hilfst'),
                (['lies', ('t', 'cut')], 'Lies!', 'du liest'),
            ], 'Remember A1.2: drop du and -st.'),
            tiles('Softer orders', [
                ('bitte', 'please'), ('doch', 'go on'), ('mal', 'just'), ('doch mal', 'why don’t you'),
            ], 2, note='Komm *doch mal* vorbei!'),
        ),
        words('Words for the practice page', [
            ('sollen · sollte', 'should'), ('mehr', 'more'), ('früher', 'earlier'), ('das Salz', 'salt'), ('öffnen', 'to open'), ('langsamer', 'more slowly'), ('gleich', 'right away'),
            ('vorbeikommen', 'to drop by'), ('leise', 'quiet'),
        ], 3),
    ],
    [
        gaps('könnte or sollte?', 'Write könnte or sollte in the right form.', [
            ('Wir', 'ins Kino gehen. (können)', 'könnten'), ('Du', 'mehr schlafen. (sollen)', 'solltest'),
            ('Sie', 'zum Arzt gehen. (sollen)', 'sollten'), ('Du', 'Anna fragen. (können)', 'könntest'),
        ]),
        gaps('Friendly orders', 'Write the du-form of the verb in brackets.', [
            ('', 'bitte langsamer! (sprechen)', 'Sprich'), ('', 'mir bitte das Salz! (geben)', 'Gib'),
            ('', 'den Bus, er kommt gleich! (nehmen)', 'Nimm'), ('', 'bitte das Fenster! (öffnen)', 'Öffne'),
        ]),
        write('Give advice', 'Answer with du solltest …', [
            ('Ich bin immer müde.', 'Du solltest mehr schlafen.'),
            ('Ich habe Kopfschmerzen.', 'Du solltest zum Arzt gehen.'),
        ], 1),
    ],
    ['suggest plans with könnte',
     'give friendly advice with sollte',
     'make du-orders: Nimm! Gib! Hilf!'],
))

# ---- 11 · der Mann, der … ---------------------------------------------------------------
spreads.append(spread(
    'relativ', 'der Mann, der …', 'Describing people and things in one sentence',
    'Der Mann, der dort wohnt: the article of the noun comes back — and only den is new.',
    Q + 'relativ_intro',
    [
        slots('Same word as the article', [
            (sl('Das ist der Mann,', 'der!', 'dort', 'wohnt.!'), 'who lives there — he does it'),
            (sl('Das ist der Mann,', 'den!', 'ich', 'kenne.!'), 'whom I know — I do it to him'),
            (sl('Das ist die Frau,', 'die!', 'hier', 'arbeitet.!'), 'die stays die'),
            (sl('Das ist das Buch,', 'das!', 'ich', 'lese.!'), 'das stays das'),
        ], note='Comma before, verb last.'),
        table('wer? or wen?', ['~', 'der', 'die', 'das', 'plural'], [
            ['does it', 'der', 'die', 'das', 'die'], ['it’s done to', '*den*', 'die', 'das', 'die'],
        ], 'Exactly the article table — one word changes.', genders=True),
        box('tip', 'Ask: does it, or is it done to?',
            'Der Mann wohnt dort → *der*. Ich kenne den Mann → *den*. Find the verb in the second part and ask who does it.'),
        words('Words for the practice page', [
            ('dort', 'there'), ('die Freunde', 'friends'), ('fahren · er fährt', 'to drive'), ('helfen · er hilft · geholfen', 'to help'),
        ], 3),
    ],
    [
        gaps('der, die, das or den?', 'Write the right word.', [
            ('Das ist der Mann,', 'dort wohnt.', 'der'), ('Das ist die Frau,', 'hier arbeitet.', 'die'),
            ('Das ist das Buch,', 'auf dem Tisch liegt.', 'das'), ('Das sind die Kinder,', 'im Park spielen.', 'die'),
            ('Das ist der Mann,', 'ich kenne.', 'den'), ('Das ist der Film,', 'ich gestern gesehen habe.', 'den'),
            ('Das ist das Auto,', 'er fährt.', 'das'), ('Das ist der Lehrer,', 'uns hilft.', 'der'),
        ]),
        write('One sentence', 'Make one sentence from two.', [
            ('Das ist der Hund. Der Hund heißt Rocky.', 'Das ist der Hund, der Rocky heißt.'),
            ('Das ist die Tasche. Ich habe die Tasche gekauft.', 'Das ist die Tasche, die ich gekauft habe.'),
        ], 1),
    ],
    ['describe people and things with der, die, das',
     'use den when it’s done to him',
     'send the verb to the end'],
))

# ---- 12 · Es war einmal ---------------------------------------------------------------
spreads.append(spread(
    'praeteritum', 'Es war einmal', 'The past of stories and newspapers',
    'Fairy tales, novels and the news all tell their stories in this past: learn to recognise it.',
    Q + 'praeteritum_intro',
    [
        cols(
            build('Regular: -te', [
                (['sag', ('te', 'suffix')], 'sagte', 'sagen'),
                (['mach', ('te', 'suffix')], 'machte', 'machen'),
                (['wohn', ('te', 'suffix')], 'wohnte', 'wohnen'),
                (['arbeit', ('ete', 'suffix')], 'arbeitete', 'arbeiten'),
            ], 'Like war and hatte.'),
            table('Irregular: a new vowel', ['verb', 'past'], [
                ['kommen', '*kam*'], ['geben', '*gab*'], ['finden', '*fand*'], ['sehen', '*sah*'],
                ['gehen', '*ging*'], ['fahren', '*fuhr*'], ['essen', '*aß*'], ['lesen', '*las*'],
            ]),
        ),
        box('culture', 'Es war einmal …',
            'Every German fairy tale starts *Es war einmal* — once upon a time. In speech most people use the Perfekt; in books and the news, this past.'),
        words('A tiny fairy tale', [
            ('Es war einmal ein Hund.', 'Once upon a time there was a dog.'),
            ('Er wohnte in einem kleinen Haus.', 'He lived in a small house.'),
            ('Eines Tages fand er einen Schlüssel.', 'One day he found a key.'),
            ('Er ging in den Wald und sah ein Schloss.', 'He went into the wood and saw a castle.'),
            ('Dort aß er den Kuchen des Königs.', 'There he ate the king’s cake.'),
        ], 1),
        words('Words for the practice page', [
            ('damals', 'back then'), ('früher', 'in the past'), ('plötzlich', 'suddenly'), ('der Wald', 'wood'),
            ('das Schloss', 'castle'), ('das Dorf', 'village'), ('eines Tages', 'one day'), ('der König', 'king'),
        ], 4),
    ],
    [
        match('Which verb?', 'Draw a line from the past form to its verb.', [
            ('kam', 'kommen'), ('gab', 'geben'), ('fand', 'finden'), ('sah', 'sehen'), ('ging', 'gehen'), ('aß', 'essen'),
        ], [3, 5, 0, 2, 4, 1]),
        gaps('Write the past', 'Write the verb in the past.', [
            ('Der Lehrer', ': „Danke!“ (sagen)', 'sagte'), ('Früher', 'er in einem kleinen Dorf. (wohnen)', 'wohnte'),
            ('Gestern', 'der Zug zu spät. (kommen)', 'kam'), ('Wir', 'den Schlüssel unter dem Sofa. (finden)', 'fanden'),
            ('Plötzlich', 'ich einen Hund. (sehen)', 'sah'),
        ]),
        gaps('Your fairy tale', 'Finish the fairy tale.', [
            ('Es war einmal', '.'), ('Eines Tages', '.'),
        ], 'About you — any story, in this past.'),
    ],
    ['recognise the past of stories',
     'make the regular -te past',
     'know the irregular kam, gab, ging, sah'],
))

# ---- 13 · Das wird gemacht -------------------------------------------------------------
spreads.append(spread(
    'passiv', 'Das wird gemacht', 'Saying what gets done — not who does it',
    'Hier wird Deutsch gesprochen: signs and notices say what gets done and leave out who does it.',
    Q + 'passiv_intro',
    [
        slots('werden + the past form', [
            (sl('Das Zimmer', 'wird!', 'jeden Tag', 'geputzt.!'), 'one thing: wird'),
            (sl('Die Briefe', 'werden!', 'heute', 'geschickt.!'), 'more than one: werden'),
            (sl('Hier', 'wird!', 'Deutsch', 'gesprochen.!'), 'on a sign'),
        ], note='Another bracket: wird second, the past form at the end.'),
        table('On signs and notices', ['', '~'], [
            ['Hier wird Deutsch gesprochen.', 'German spoken here.'], ['Das Büro wird renoviert.', 'The office is being renovated.'],
            ['Die Straße wird gesperrt.', 'The road is being closed.'], ['Das Brot wird jeden Morgen gebacken.', 'The bread is baked every morning.'],
        ]),
        box('tip', 'And who did it? von',
            'Usually nobody says. When you want to: *von* + dem/der: Die Rechnung wird *vom* Chef bezahlt.'),
        words('Words for the practice page', [
            ('putzen', 'to clean'), ('reparieren', 'to repair'), ('backen · gebacken', 'to bake'),
            ('verkaufen', 'to sell'), ('bauen', 'to build'), ('das Paket', 'parcel'),
            ('die Werkstatt', 'garage, workshop'), ('der Schalter', 'counter'), ('das Ticket · die Tickets', 'ticket'),
            ('die Küche', 'kitchen'), ('das Fahrrad · die Fahrräder', 'bike · bikes'),
        ], 4),
    ],
    [
        gaps('wird or werden?', 'Write wird or werden.', [
            ('Das Auto', 'repariert.', 'wird'), ('Die Briefe', 'heute geschickt.', 'werden'),
            ('Hier', 'Deutsch gesprochen.', 'wird'), ('Die Tickets', 'am Schalter verkauft.', 'werden'),
        ]),
        gaps('The past form', 'Write the past form at the end.', [
            ('Das Brot wird jeden Morgen', '. (backen)', 'gebacken'), ('Das Zimmer wird jeden Tag', '. (putzen)', 'geputzt'),
            ('Das neue Haus wird im Sommer', '. (bauen)', 'gebaut'), ('Das Essen wird in der Küche', '. (kochen)', 'gekocht'),
        ]),
        write('Make a sign', 'Write the sign with wird or werden.', [
            ('Man spricht hier Englisch.', 'Hier wird Englisch gesprochen.'),
            ('Man repariert hier Fahrräder.', 'Hier werden Fahrräder repariert.'),
        ], 1),
    ],
    ['read signs and notices with wird',
     'say what gets done',
     'use wird and werden with the past form'],
))

# ---- 14 · am schnellsten --------------------------------------------------------------
spreads.append(spread(
    'superlativ', 'am schnellsten', 'The winner: the most, the best',
    'schnell – schneller – am schnellsten: learn all three steps together and you can crown the winner.',
    Q + 'superlativ',
    [
        table('Three steps', ['', 'more (A2.1)', 'the most'], [
            ['schnell', 'schneller', 'am schnell*sten*'], ['klein', 'kleiner', 'am klein*sten*'],
            ['alt', 'älter', 'am ält*esten*'], ['groß', 'größer', 'am größ*ten*'],
            ['gut', 'besser', 'am *besten*'], ['viel', 'mehr', 'am *meisten*'],
            ['gern', 'lieber', 'am *liebsten*'], ['hoch', 'höher', 'am *höchsten*'],
        ], 'After -t, -d, -s, -z: -esten, so you can hear it.'),
        box('tip', 'Before a noun: der, die, das …-ste',
            'der schnell*ste* Zug, die größ*te* Stadt, das *beste* Eis. Berlin ist die größte Stadt Deutschlands.'),
        words('Words for the practice page', [
            ('der Elefant', 'elephant'), ('das Eis', 'ice cream'), ('leicht', 'easy, light'), ('die Übung', 'exercise'), ('von allen', 'of all'),
        ], 4),
    ],
    [
        gaps('am …-sten', 'Write the most.', [
            ('Der Elefant ist am', '. (groß)', 'größten'), ('Im Winter sind die Tage am', '. (kurz)', 'kürzesten'),
            ('Anna läuft am', '. (schnell)', 'schnellsten'), ('Dieses Eis schmeckt am', '. (gut)', 'besten'),
            ('Ich trinke am', 'Wasser. (gern)', 'liebsten'), ('Mein Opa ist am', '. (alt)', 'ältesten'),
            ('Im Juli ist es am', '. (warm)', 'wärmsten'), ('Rocky isst am', 'von allen. (viel)', 'meisten'),
        ]),
        write('Three steps', 'Write all three steps.', [
            ('gut', 'gut – besser – am besten'), ('gern', 'gern – lieber – am liebsten'), ('jung', 'jung – jünger – am jüngsten'),
        ], 1),
        gaps('Your best', 'Write two true sentences.', [
            ('Am liebsten esse ich', '.'), ('Am besten kann ich', '.'),
        ], 'About you.'),
    ],
    ['say the most with am …-sten',
     'use am besten, am meisten, am liebsten',
     'say the biggest city, the best ice cream'],
))

# ---- 15 · Wörter bauen ----------------------------------------------------------------
spreads.append(spread(
    'wortbildung', 'Wörter bauen', 'Five word parts that unlock hundreds of words',
    '-er, -ung, un-, -los, -bar: spot five little parts and hundreds of new words suddenly make sense.',
    Q + 'wortbildung',
    [
        build('-er: the person who does it — always der', [
            (['fahr', ('er', 'suffix')], 'der Fahrer', 'driver'),
            (['lehr', ('er', 'suffix')], 'der Lehrer', 'teacher'),
            (['verkäuf', ('er', 'suffix')], 'der Verkäufer', 'shop assistant'),
        ], 'For a woman: -erin. die Fahrerin.'),
        build('-ung: the thing — always die', [
            (['wohn', ('ung', 'suffix')], 'die Wohnung', 'flat'),
            (['bedeut', ('ung', 'suffix')], 'die Bedeutung', 'meaning'),
            (['üb', ('ung', 'suffix')], 'die Übung', 'exercise'),
        ]),
        build('un-, -los, -bar', [
            ([('un', 'suffix'), 'freundlich'], 'unfreundlich', 'not friendly'),
            (['arbeit', 's', ('los', 'suffix')], 'arbeitslos', 'without work'),
            (['kosten', ('los', 'suffix')], 'kostenlos', 'free (of charge)'),
            (['ess', ('bar', 'suffix')], 'essbar', 'can be eaten'),
        ]),
        box('watch', '-er alone is not a rule',
            'die Butter, das Fenster, die Mutter end in -er too. The rule is verb + -er = the person who does it = der.'),
        words('Words for the practice page', [
            ('freundlich', 'friendly'), ('glücklich', 'happy'), ('die Anmeldung', 'registration'),
            ('die Erfahrung', 'experience'), ('die Arbeit', 'work'), ('die Stelle', 'job'),
            ('lehren', 'to teach'), ('halten · er hält', 'to stop'), ('die Grammatik', 'grammar'), ('das Wort', 'word'),
        ], 3),
    ],
    [
        gaps('Build the word', 'Write the new word.', [
            ('Der', 'hält den Bus an. (fahren → der …)', 'Fahrer'), ('Unser', 'erklärt die Grammatik. (lehren → der …)', 'Lehrer'),
            ('Unsere', 'hat drei Zimmer. (wohnen → die …)', 'Wohnung'), ('Was ist die', 'von diesem Wort? (bedeuten → die …)', 'Bedeutung'),
            ('Der Kellner war', '. (freundlich → un…)', 'unfreundlich'), ('Er ist', 'und sucht eine Stelle. (Arbeit → …los)', 'arbeitslos'),
        ]),
        sort_ex('der or die?', 'Write each word in its column.', ['der', 'die'], [
            ('Fahrer', 0), ('Wohnung', 1), ('Lehrer', 0), ('Übung', 1), ('Verkäufer', 0), ('Bedeutung', 1),
        ]),
    ],
    ['build people with -er',
     'build things with -ung',
     'understand un-, -los and -bar'],
))

# ---- 16 · Wann? Wie? Wo? ---------------------------------------------------------------
spreads.append(spread(
    'tekamolo', 'Wann? Wie? Wo?', 'Time, manner, place — in that order',
    'Ich fahre morgen mit dem Zug nach Berlin: when, how, where — always in that order.',
    Q + 'tekamolo',
    [
        slots('When, how, where', [
            (['Ich', {'de': 'fahre', 'hot': True}, ('morgen', 'wann?'), ('mit dem Zug', 'wie?'), ('nach Berlin.', 'wohin?')], None),
            (['Wir', {'de': 'treffen', 'hot': True}, 'uns', ('um drei', 'wann?'), ('im Café.', 'wo?')], None),
            (['Er', {'de': 'fährt', 'hot': True}, ('jeden Tag', 'wann?'), ('mit dem Rad', 'wie?'), ('zur Schule.', 'wohin?')], None),
        ], note='Missing one? Keep the order of the others.'),
        slots('Or time first', [
            (sl('Morgen', 'fahre!', 'ich', 'mit dem Zug', 'nach Berlin.'), 'the rest keeps its order'),
            (sl('Ich', 'bin!', 'gestern mit dem Zug', 'nach Berlin', 'gefahren.!'), 'the place stays next to the end'),
        ]),
        box('tip', 'Te – Mo – Lo',
            '*Te*mporal (wann?), *Mo*dal (wie?), *Lo*kal (wo?). Say it like a name: Temolo.'),
        words('Words for the practice page', [
            ('mit dem Rad', 'by bike'), ('die Bibliothek', 'library'), ('sonntags', 'on Sundays'), ('nächste Woche', 'next week'),
        ], 4),
    ],
    [
        write('Put it in order', 'Write the sentence: when, how, where.', [
            ('Ich fahre · nach Berlin · morgen · mit dem Zug', 'Ich fahre morgen mit dem Zug nach Berlin.'),
            ('Wir treffen uns · im Café · um drei', 'Wir treffen uns um drei im Café.'),
            ('Er fährt · zur Schule · mit dem Rad · jeden Tag', 'Er fährt jeden Tag mit dem Rad zur Schule.'),
            ('Ich gehe · ins Kino · heute Abend · mit Anna', 'Ich gehe heute Abend mit Anna ins Kino.'),
        ], 1),
        write('Time first', 'Start with the time.', [
            ('Wir fahren im Sommer ans Meer.', 'Im Sommer fahren wir ans Meer.'),
            ('Er lernt jeden Abend in der Bibliothek Deutsch.', 'Jeden Abend lernt er in der Bibliothek Deutsch.'),
        ], 1),
    ],
    ['put when, how and where in order',
     'start a sentence with the time',
     'keep the place next to the end'],
))

# ---- 17 · Annas Auto, der 3. Oktober -----------------------------------------------------
spreads.append(spread(
    'datum_email', 'Annas Auto', 'Whose it is, the date — and an e-mail',
    'Annas Auto, der 3. Oktober, Liebe Anna or Sehr geehrte Frau Weber: the small pieces of every message.',
    Q + 'genitiv_s_datum',
    [
        cols(
            build('Whose? name + s', [
                (['Anna', ('s', 'suffix')], 'Annas Auto', 'Anna’s car — no apostrophe'),
                (['Paul', ('s', 'suffix')], 'Pauls Schwester', 'Paul’s sister'),
                (['Deutschland', ('s', 'suffix')], 'Deutschlands Hauptstadt', 'Germany’s capital'),
            ], 'Or: das Auto von Anna.'),
            table('The date', ['', 'say'], [
                ['der 1. Mai', 'der *erste* Mai'], ['der 3. Oktober', 'der *dritte* Oktober'],
                ['der 7. Juli', 'der *siebte* Juli'], ['der 20. August', 'der *zwanzigste* August'],
                ['am 12. März', 'am *zwölften* März'],
            ], 'The dot is -te: up to 19 -te, from 20 -ste.'),
        ),
        table('An e-mail: to a friend, to an office', ['to a friend (du)', 'to an office (Sie)'], [
            ['Liebe Anna, · Lieber Tom,', 'Sehr geehrte Frau Weber, · Sehr geehrter Herr Braun,'],
            ['Vielen Dank für deine E-Mail.', 'Vielen Dank für Ihre Nachricht.'],
            ['Ich schreibe dir, weil …', 'Ich schreibe Ihnen, weil …'],
            ['Ich freue mich auf deine Antwort.', 'Ich freue mich auf Ihre Antwort.'],
            ['Viele Grüße · Liebe Grüße', 'Mit freundlichen Grüßen'],
        ], 'Never mix them: du with Liebe, Sie with Sehr geehrte.'),
        words('Words for the practice page', [
            ('die Hauptstadt', 'capital'), ('die Nachricht', 'message'), ('die Einladung', 'invitation'),
            ('einladen', 'to invite'), ('Es tut mir leid', 'I’m sorry'), ('der Feiertag', 'public holiday'),
            ('Der Wievielte ist heute?', 'What’s the date today?'), ('wessen?', 'whose?'),
        ], 3),
    ],
    [
        gaps('Whose?', 'Write it with -s.', [
            ('Das ist', 'Auto. (Anna)', 'Annas'), ('', 'Schwester wohnt in Bonn. (Paul)', 'Pauls'),
            ('Berlin ist', 'Hauptstadt. (Deutschland)', 'Deutschlands'),
        ]),
        gaps('The date', 'Write the number as a word.', [
            ('Heute ist der', 'Oktober. (3.)', 'dritte'), ('Am', 'Mai ist ein Feiertag. (1.)', 'ersten'),
            ('Ich habe am', 'März Geburtstag. (12.)', 'zwölften'), ('Der Kurs beginnt am', 'September. (7.)', 'siebten'),
        ]),
        gaps('Your e-mail', 'Write to a friend: invite them to your party.', [
            ('Liebe', ','), ('ich möchte dich zu meiner Party einladen. Sie ist am', '.'),
            ('Kannst du', 'mitbringen?'), ('Ich freue mich auf', '.'), ('Viele Grüße,', ''),
        ], 'About you — du-forms all the way through.'),
    ],
    ['say whose it is: Annas Auto',
     'say and write the date',
     'write a short e-mail to a friend or an office'],
))

# ---- Review 2 · topics 8–17 ---------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 8–17', 'The second half of the book, all at once. No looking back until you have done both pages.',
    Q + 'wortschatz',
    [
        gaps('Endings', 'Write the ending.', [
            ('Ich kaufe einen neu', 'Mantel.', 'en'), ('Das ist ein schön', 'Kleid.', 'es'), ('Der rot', 'Rock passt mir.', 'e'),
        ]),
        gaps('der, die, das or den?', 'Write the right word.', [
            ('Das ist der Arzt,', 'mir geholfen hat.', 'der'), ('Das ist der Film,', 'ich gesehen habe.', 'den'),
        ]),
        gaps('Steps', 'Write the most.', [
            ('Dieses Eis ist am', '. (gut)', 'besten'), ('Berlin ist die', 'Stadt Deutschlands. (groß)', 'größte'),
        ]),
    ],
    [
        gaps('Advice and signs', 'Write the missing word.', [
            ('Du', 'mehr trinken. (sollen)', 'solltest'), ('Hier', 'Deutsch gesprochen.', 'wird'),
            ('Es war', 'ein König.', 'einmal'),
        ]),
        write('In order', 'Write the sentence: when, how, where.', [
            ('Wir fahren · ans Meer · im Sommer · mit dem Auto', 'Wir fahren im Sommer mit dem Auto ans Meer.'),
        ], 1),
        match('Question and answer', 'Draw a line from each question to its answer.', [
            ('Was fehlt Ihnen?', 'Ich habe Kopfschmerzen.'),
            ('Welche Größe haben Sie?', '38.'),
            ('Der Wievielte ist heute?', 'Der dritte Oktober.'),
            ('Wessen Auto ist das?', 'Annas.'),
        ], [2, 3, 0, 1]),
    ],
))

book = {
    'title': 'Beschreiben & Planen',
    'cover': 'cp_a2_2_cover',
    'welcome': [
        'This book is the paper half of A2.2. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It carries on from the earlier books. Words you learned there are not taught again; where a topic builds on something from before, a small note brings it back.',
        'Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Paul', 'Mia', 'Tom', 'Anna', 'Lisa', 'Jan', 'Rocky', 'Braun', 'Weber', 'Berger', 'Schmidt',
              'Hamburg', 'Rom', 'Bonn', 'Berlin', 'Hans'],
    'spreads': spreads,
    'overview': {'title': 'A2.2 at a glance', 'blocks': [
        table('Wo? or Wohin?', ['', 'Wo? (still)', 'Wohin? (moving)'], [
            ['auf · unter · in · an · neben · vor · hinter · über · zwischen', 'dem · der · dem · den', 'den · die · das · die'],
            ['the verbs', 'liegen · stehen · sitzen · hängen', 'legen · stellen · setzen · hängen'],
        ]),
        slots('The verb goes last', [
            (sl('…, weil', 'ich krank', 'bin.!'), 'because'), (sl('…, dass', 'er recht', 'hat.!'), 'that'),
            (sl('Wenn', 'ich Zeit', 'habe,!', 'komme!', 'ich.'), 'if, when'), (sl('…, ob', 'er', 'kommt.!'), 'whether'),
            (sl('der Mann,', 'der dort', 'wohnt.!'), 'who'),
        ]),
        table('Endings before a noun', ['~', 'der', 'die', 'das'], [
            ['after ein', 'ein neu*er* Mantel', 'eine neu*e* Jacke', 'ein neu*es* Kleid'],
            ['after der, die, das', 'der neu*e* Mantel', 'die neu*e* Jacke', 'das neu*e* Kleid'],
        ], genders=True),
        cols(
            table('Three steps', ['', 'more', 'the most'], [
                ['schnell', 'schneller', 'am schnellsten'], ['gut', 'besser', 'am besten'], ['gern', 'lieber', 'am liebsten'],
            ]),
            table('Verb + little word', ['', '+'], [
                ['warten · sich freuen', 'auf'], ['sich interessieren', 'für'], ['denken · sich erinnern', 'an'],
                ['sprechen · sich ärgern', 'über'], ['träumen', 'von'],
            ]),
        ),
        table('mich, dich, sich', ['ich', 'du', 'er · sie · es', 'wir', 'ihr', 'sie · Sie'], [
            ['mich', 'dich', '*sich*', 'uns', 'euch', '*sich*'],
        ]),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.', [
            ('der Korb', 'basket', 'cpd_korb'), ('das Regal', 'shelf', 'cpd_regal'), ('die Vase', 'vase', 'cpd_vase'),
            ('der Teppich', 'rug', 'cpd_teppich'), ('der Schrank', 'cupboard', 'cpd_schrank'), ('der Teller', 'plate', 'cpd_teller'),
            ('das Hemd', 'shirt', 'cpd_hemd'), ('der Pullover', 'jumper', 'cpd_pullover'), ('die Schuhe', 'shoes', 'cpd_schuhe'),
            ('die Socken', 'socks', 'cpd_socken'), ('das T-Shirt', 'T-shirt', 'cpd_tshirt'), ('der Hut', 'hat', 'cpd_hut'),
            ('das Rezept', 'prescription', 'cpd_rezept'), ('das Medikament', 'medicine', 'cpd_medikament'),
            ('das Thermometer', 'thermometer', 'cpd_thermometer'), ('das Pflaster', 'plaster', 'cpd_pflaster'),
            ('das Paket', 'parcel', 'cpd_paket'), ('das Salz', 'salt', 'cpd_salz'), ('das Taxi', 'taxi', 'cpd_taxi'),
            ('das Fahrrad', 'bike', 'cpd_fahrrad'), ('das Schloss', 'castle', 'cpd_schloss'), ('der Wald', 'wood, forest', 'cpd_wald'),
            ('der König', 'king', 'cpd_koenig'), ('das Dorf', 'village', 'cpd_dorf'), ('der Elefant', 'elephant', 'cpd_elefant'),
            ('das Eis', 'ice cream', 'cpd_eis'), ('die Bibliothek', 'library', 'cpd_bibliothek'), ('der Schlüssel', 'key', 'cpd_schluessel'),
            ('die Einladung', 'invitation', 'cpd_einladung'), ('der Kalender', 'calendar', 'cpd_kalender'),
            ('die Toilette', 'toilet', 'cpd_toilette'), ('der Fahrer', 'driver', 'cpd_fahrer'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

kit.write_book(OUT, book)
