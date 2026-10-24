# Builds assets/content/companion/de_cert_a1/b2_2.json — the B2.2 study companion.
# Run: python -I tool/companion/b2_2.py   (rules: docs/study_companion_guide.md)
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, merge, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_b2_2_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'b2_2.json')
Q = 'quest_b2_2_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ==== Part 1 · What if — and what probably happened =====================================

# ---- 1 · Wissenschaft & Umwelt -----------------------------------------------------------
spreads.append(spread(
    'umwelt', 'Wissenschaft & Umwelt', 'Cause, effect — and what we can do',
    'The words of every article about the climate: the problem, and what we can do about it.',
    Q + 'umwelt',
    [
        arrow('Cause and effect', [
            ('Die Abgase', 'führen zu', 'schlechter Luft', 'exhaust fumes lead to bad air'),
            ('Die Erderwärmung', 'führt zu', 'Dürren und Überschwemmungen', 'global warming leads to droughts and floods'),
            ('Der hohe Verbrauch', 'führt zu', 'mehr Müll', 'high consumption leads to more rubbish'),
        ], ('Ursache?', 'Folge?'), 'die Ursache = cause · die Folge = effect'),
        cols(build('One long word: the last part decides', [
            (['Umwelt', ('schutz', 'suffix')], 'der Umweltschutz', 'der Schutz'),
            (['Energie', ('verbrauch', 'suffix')], 'der Energieverbrauch', 'der Verbrauch'),
            (['Klima', ('wandel', 'suffix')], 'der Klimawandel', 'der Wandel'),
            (['Erd', ('erwärmung', 'suffix')], 'die Erderwärmung', 'die Erwärmung'),
        ]),
        table('Noun + its verb', ['', '~'], [
            ['Energie sparen', 'save'], ['den Müll trennen', 'separate'],
            ['auf Plastik verzichten', 'do without'], ['den Verbrauch reduzieren', 'cut'],
            ['Maßnahmen ergreifen', 'take'], ['die Umwelt schützen', 'protect'],
        ])),
        words('Words for the practice page', [
            ('die Regierung', 'government'), ('das Fleisch', 'meat'),
            ('die Treibhausgase', 'greenhouse gases'), ('der Haushalt · die Haushalte', 'household'), ('privat', 'private'),
            ('rund ein Viertel', 'about a quarter'), ('zurückgehen auf · geht zurück', 'to come from'),
            ('beitragen zu · trägt bei', 'to contribute to'), ('der Klimaschutz', 'climate protection'),
            ('der Ökostrom', 'green electricity'), ('das Angebot', 'offer, range'), ('auf dem Land', 'in the country'),
            ('immer mehr', 'more and more'), ('die Familien', 'families'),
            ('private Haushalte', 'private households'), ('weniger', 'less'), ('fragen · sie fragten', 'to ask'),
        ], 4),
    ],
    [
        gaps('Noun + verb', 'Write the verb that goes with the noun.', [
            ('Immer mehr Familien', 'auf Plastik.', 'verzichten'), ('Bei uns', 'wir den Müll.', 'trennen'),
            ('Die Regierung muss Maßnahmen', '.', 'ergreifen'), ('Mit LED-Lampen kann man Energie', '.', 'sparen'),
            ('Wir müssen die Umwelt', '.', 'schützen'),
        ]),
        circle('Who can save the climate?', 'Listen to the text. Circle what you hear.', [
            ('Rund ein', ['Viertel', 'Drittel'], 'der Treibhausgase geht auf private Haushalte zurück.', 'Viertel'),
            ('Wer weniger', ['Fleisch', 'Brot'], 'isst, trägt zum Klimaschutz bei.', 'Fleisch'),
            ('Immer mehr Kunden fragten nach', ['Ökostrom', 'Wasser'], '.', 'Ökostrom'),
            ('Wer auf dem', ['Land', 'Meer'], 'lebt, braucht oft das Auto.', 'Land'),
        ], 1) | {'listen': True},
        gaps('About you', 'Finish the sentence.', [('Für die Umwelt verzichte ich auf', '.')], 'About you.'),
    ],
    ['name causes and effects: führt zu …',
     'use the verb that goes with each noun',
     'follow a text about the climate'],
    listen=Q + 'lesen_klima',
))

# ---- 2 · Wenn ich reich wäre … ------------------------------------------------------------
spreads.append(spread(
    'irreal', 'Wenn ich reich wäre …', 'Unreal conditions — now and then',
    'Wenn ich Zeit hätte, käme ich. Wenn ich das gewusst hätte, wäre ich geblieben. The dots say: but it isn’t so.',
    Q + 'irreal',
    [
        flow('Could it still happen?', q('Is it still possible?',
                                         a('indicative', 'Wenn ich Zeit habe, komme ich.'),
                                         a('Konjunktiv II', 'Wenn ich Zeit hätte, käme ich.')),
             note='The Konjunktiv is the sound of “but it isn’t so”.'),
        table('Past + dots = the one-word form', ['verb', 'past', 'Konjunktiv II'], [
            ['sein', 'war', 'w*ä*re'], ['haben', 'hatte', 'h*ä*tte'], ['kommen', 'kam', 'k*ä*me'],
            ['geben', 'gab', 'g*ä*be'], ['wissen', 'wusste', 'w*ü*sste'], ['können', 'konnte', 'k*ö*nnte'],
        ], 'Other verbs: würde + infinitive — ich würde reisen.'),
        table('Now or then?', ['', 'wenn …', 'main clause'], [
            ['now', 'Wenn ich reich *wäre*,', '*würde* ich reisen.'],
            ['then', 'Wenn ich das gewusst *hätte*,', '*wäre* ich geblieben.'],
        ]),
        slots('No wenn: start with the verb', [
            (sl('Hätte!', 'ich', 'das gewusst,', 'wäre!', 'ich geblieben.'), 'verb first, comma, verb first again'),
        ]),
        words('Words for the practice page', [
            ('die Wahl', 'choice'), ('kündigen', 'to quit'), ('um die Welt reisen', 'to travel the world'),
            ('wüssten', 'would know'), ('eine einfache Lösung', 'a simple solution'),
            ('fragen · gefragt', 'to ask'), ('wir hätten', 'we would have'),
        ], 3),
    ],
    [
        gaps('Now', 'Write the verb in brackets in the Konjunktiv II.', [
            ('Wenn ich reich', ', würde ich um die Welt reisen. (sein)', 'wäre'),
            ('Wenn ich du', ', würde ich kündigen. (sein)', 'wäre'),
            ('Wenn es eine einfache Lösung', ', wüssten wir sie. (geben)', 'gäbe'),
            ('Was würdest du machen, wenn du die Wahl', '? (haben)', 'hättest'),
            ('Wenn er jetzt', ', könnten wir anfangen. (kommen)', 'käme'),
        ]),
        gaps('Then', 'Write hätte or wäre in the right form.', [
            ('Wenn ich das gewusst', ', wäre ich zu Hause geblieben.', 'hätte'),
            ('Wenn wir früher losgefahren', ', hätten wir den Zug nicht verpasst.', 'wären'),
            ('Wenn du mich gefragt hättest,', 'ich dir gern geholfen.', 'hätte'),
        ]),
        write('Without wenn', 'Start with the verb.', [
            ('Wenn ich das gewusst hätte, wäre ich geblieben.', 'Hätte ich das gewusst, wäre ich geblieben.'),
            ('Wenn ich reich wäre, würde ich reisen.', 'Wäre ich reich, würde ich reisen.'),
        ], 1),
    ],
    ['tell a real condition from an unreal one',
     'say what would be: wäre, hätte, käme, würde',
     'say what would have been: hätte gewusst, wäre geblieben'],
))

# ---- 3 · Du hättest anrufen sollen --------------------------------------------------------
spreads.append(spread(
    'konj2_verg', 'Du hättest anrufen sollen', 'Regret and reproach',
    'Ich hätte mehr lernen müssen. Du hättest anrufen können. The four sentences of every regret — modal last.',
    Q + 'konj2_verg',
    [
        slots('With a modal: two infinitives at the end', [
            (sl('Du', 'hättest!', 'früher', 'aufstehen', 'sollen.!'), 'you should have'),
            (sl('Ihr', 'hättet!', 'mich', 'anrufen', 'können.!'), 'you could have'),
            (sl('Ich', 'hätte!', 'mehr', 'lernen', 'müssen.!'), 'I ought to have'),
        ], note='Not gesollt or gekonnt: the modal stays an infinitive.'),
        table('hätte or wäre? The Perfekt decides', ['Perfekt', 'Konjunktiv II'], [
            ['Ich habe es gesagt.', 'Ich *hätte* es nie gesagt.'],
            ['Wir sind gegangen.', 'Wir *wären* früher gegangen.'],
            ['Es ist passiert.', 'Das *wäre* nicht passiert.'],
        ], 'Never “würde gegangen haben”.'),
        box('tip', 'Four sentences of regret',
            '*Du hättest … sollen* (you should have) · *Ich hätte … müssen* (I ought to have) · *Wir hätten … können* (we could have) · *Hätte ich doch …!* (if only)'),
        words('Words for the practice page', [
            ('der Termin', 'appointment'), ('verschieben', 'to postpone'), ('warnen', 'to warn'),
            ('ruhig', 'here: you know'), ('pünktlich', 'on time'), ('vorher', 'before'), ('erreicht', 'caught'),
            ('ohne deine Hilfe', 'without your help'), ('bestanden', 'passed'), ('aufstehen', 'to get up'), ('nie', 'never'),
            ('warnen · gewarnt', 'to warn'), ('wir hätten', 'we would have'),
        ], 3),
    ],
    [
        gaps('hätte or wäre?', 'Write hätte or wäre in the right form.', [
            ('Ich', 'das an deiner Stelle nie gesagt.', 'hätte'), ('Wir', 'gern früher gegangen.', 'wären'),
            ('Bei dem Regen', 'ich lieber zu Hause geblieben.', 'wäre'), ('Sie', 'den Termin verschieben können.', 'hätte'),
        ]),
        gaps('Heard it?', 'Listen to the dictation and write the missing words.', [
            ('Du hättest mich ruhig', '.', 'anrufen können'),
            ('Wir hätten früher', ', dann hätten wir den Zug erreicht.', 'aufstehen sollen'),
            ('Wenn der Bus pünktlich gekommen', ', hätte ich den Termin nicht verpasst.', 'wäre'),
            ('Ohne deine Hilfe hätte ich die Prüfung nicht', '.', 'bestanden'),
        ]) | {'listen': True},
        write('A reproach', 'Say what they should have done. Use sollen.', [
            ('Du bist zu spät aufgestanden. (früher)', 'Du hättest früher aufstehen sollen.'),
            ('Ihr habt uns nicht gewarnt.', 'Ihr hättet uns warnen sollen.'),
        ], 1),
    ],
    ['say what would have happened',
     'say should have, could have, ought to have',
     'choose hätte or wäre by the Perfekt'],
    listen=Q + 'diktat_irreal',
))

# ---- 4 · als ob ---------------------------------------------------------------------------
spreads.append(spread(
    'als_ob', 'als ob er der Chef wäre', 'Untrue comparisons',
    'Er tut so, als ob er der Chef wäre — he isn’t. The Konjunktiv marks the comparison as untrue.',
    Q + 'als_ob',
    [
        slots('Two shapes, one meaning', [
            (sl('Er tut so,', 'als ob', 'er der Chef', 'wäre.!'), 'als ob: verb last'),
            (sl('Er tut so,', 'als', 'wäre!', 'er der Chef.'), 'als alone: verb straight after'),
        ]),
        table('Now or then?', ['', 'als ob …', '~'], [
            ['now', 'als ob er reich *wäre*', 'as if he were rich'],
            ['now', 'als ob er alles *wüsste*', 'as if he knew everything'],
            ['then', 'als ob nichts passiert *wäre*', 'as if nothing had happened'],
            ['then', 'als ob sie nicht geschlafen *hätte*', 'as if she hadn’t slept'],
        ]),
        tiles('Verbs of seeming', [
            ('aussehen', 'look'), ('klingen', 'sound'), ('wirken', 'seem'),
            ('so tun', 'pretend'), ('sich fühlen', 'feel'), ('sich benehmen', 'behave'),
        ], 6),
        words('Words for the practice page', [
            ('das Gespenst', 'ghost'), ('Geld ausgeben', 'to spend money'), ('aufgewachsen', 'grown up'),
            ('die Zeit stand still', 'time stood still'), ('hören · gehört', 'to hear'), ('Tu nicht so!', 'Don’t pretend!'),
            ('er benimmt sich', 'he behaves'), ('sie sieht aus', 'she looks'), ('du siehst aus', 'you look'), ('reden · er redet', 'to talk'),
        ], 3),
    ],
    [
        gaps('als ob', 'Write the verb in brackets in the Konjunktiv II.', [
            ('Er gibt Geld aus, als ob er reich', '. (sein)', 'wäre'),
            ('Sie spricht, als ob sie in Deutschland aufgewachsen', '. (sein)', 'wäre'),
            ('Tu nicht so, als ob du das nicht', '! (wissen)', 'wüsstest'),
            ('Er benimmt sich, als ob nichts passiert', '. (sein)', 'wäre'),
            ('Sie sieht aus, als ob sie nicht geschlafen', '. (haben)', 'hätte'),
        ]),
        write('Without ob', 'Write it with als and the verb straight after.', [
            ('Du siehst aus, als ob du ein Gespenst gesehen hättest.', 'Du siehst aus, als hättest du ein Gespenst gesehen.'),
            ('Er redet, als ob er alles wüsste.', 'Er redet, als wüsste er alles.'),
        ], 1),
    ],
    ['say as if with als ob and the Konjunktiv',
     'use the short form: als wäre er …',
     'pretend: so tun, als ob'],
))

# ---- 5 · Er wird wohl … haben -------------------------------------------------------------
spreads.append(spread(
    'vermutung', 'Er wird den Zug verpasst haben', 'Guessing with werden',
    'Sie wird noch im Büro sein. Er wird den Zug verpasst haben. werden is not about time here: it means probably.',
    Q + 'futur2',
    [
        timeline('One step further back', [
            ('Er wird krank gewesen sein.', 'a guess about then', -2.5),
            ('Er wird krank sein.', 'a guess about now', 0),
            ('Das Paket wird morgen ankommen.', 'a forecast', 2.5),
        ], note='Same werden; the past form + sein or haben pushes the guess back.'),
        slots('The frame', [
            (sl('Sie', 'wird!', 'wohl noch im Büro', 'sein.!'), 'now: werden + infinitive'),
            (sl('Er', 'wird!', 'den Zug', 'verpasst haben.!'), 'then: past form + haben'),
            (sl('Sie', 'wird!', 'schon', 'gegangen sein.!'), 'then: sein-verbs keep sein'),
        ]),
        cols(
            table('Make the guess clear', ['', '~'], [
                ['wohl · vermutlich', 'probably'], ['sicher · bestimmt', 'surely'], ['schon', 'don’t worry'],
            ]),
            box('tip', 'Plain future? Present tense',
                '*Morgen fahre ich nach Berlin.* A fixed plan needs no werden.'),
        ),
        words('Words for the practice page', [
            ('das Licht ist aus', 'the light is off'), ('die Straße ist nass', 'the road is wet'), ('vergessen', 'to forget'),
            ('der Paketbote', 'delivery man'), ('blass', 'pale'), ('in der Nacht', 'in the night'), ('Keine Sorge!', 'Don’t worry!'),
            ('schaffen', 'to manage, pass'), ('das Meeting', 'meeting'), ('es klingelt', 'the doorbell rings'),
            ('die Jackentasche', 'jacket pocket'), ('stecken', 'to be (in a pocket)'), ('wahrscheinlich', 'probably'),
        ], 3),
    ],
    [
        write('Now or then?', 'Write the guess with werden. Is it about now or about then?', [
            ('Sie antwortet nicht. (sie · wohl noch im Meeting sein)', 'Sie wird wohl noch im Meeting sein.'),
            ('Es klingelt. (das · der Paketbote sein)', 'Das wird der Paketbote sein.'),
            ('Er ist nicht da. (er · den Zug verpassen)', 'Er wird den Zug verpasst haben.'),
            ('Das Licht ist aus. (sie · schon gehen)', 'Sie wird schon gegangen sein.'),
            ('Die Straße ist nass. (es · in der Nacht regnen)', 'Es wird in der Nacht geregnet haben.'),
        ], 1),
        gaps('Don’t worry', 'Write the form of werden.', [
            ('Keine Sorge, du', 'die Prüfung schon schaffen.', 'wirst'),
            ('Wahrscheinlich ist er krank. Er', 'wohl krank sein.', 'wird'),
        ]),
    ],
    ['guess about now with wird … sein',
     'guess about then with wird … gemacht haben',
     'keep sein for the sein-verbs'],
))

# ---- 6 · Er soll reich sein ---------------------------------------------------------------
spreads.append(spread(
    'sollen', 'Er soll reich sein', 'People say …, he claims …',
    'Er soll reich sein: not “he should be rich” but “people say he is rich”. Er will nichts gewusst haben: he claims so.',
    Q + 'sollen_subjektiv',
    [
        flow('Who says so?', q('Do other people say it?',
                               a('sollen', 'Er soll reich sein.'), a('wollen: he says it himself', 'Er will reich sein.')),
             note='Either way, the speaker isn’t vouching for it.'),
        slots('Now or then', [
            (sl('Der neue Chef', 'soll!', 'sehr streng', 'sein.!'), 'is said to be'),
            (sl('Sie', 'soll!', 'den ersten Preis', 'gewonnen haben.!'), 'is said to have won'),
            (sl('Er', 'will!', 'nicht dort', 'gewesen sein.!'), 'claims not to have been'),
        ]),
        box('watch', 'Rumour, not an order',
            'In the news, *Der Minister soll zurücktreten* is usually a rumour: he is said to be resigning.'),
        words('Words for the practice page', [
            ('streng', 'strict'), ('der erste Preis', 'first prize'), ('die Probleme', 'problems'),
            ('der Minister', 'minister'), ('von nichts', 'of nothing'), ('der Vorsatz · die Vorsätze', 'resolution'),
            ('das Gemüse', 'vegetables'), ('die Tasse', 'cup'), ('die Süßigkeiten', 'sweets'), ('der Zucker', 'sugar'),
            ('der Rat', 'advice'), ('scheitern', 'to fail'), ('problematisch', 'a problem'), ('eher', 'rather'),
            ('genug', 'enough'), ('ganz', 'completely'), ('falsch', 'false'), ('ihr wichtigster Rat', 'her most important advice'), ('drei Tassen', 'three cups'),
        ], 4),
    ],
    [
        gaps('soll or will?', 'Write soll or will.', [
            ('Man sagt, er ist sehr reich. Er', 'sehr reich sein.', 'soll'),
            ('Er sagt, er hat von nichts gewusst. Er', 'von nichts gewusst haben.', 'will'),
            ('Man sagt, die Firma hat Probleme. Die Firma', 'Probleme haben.', 'soll'),
            ('Sie sagt, sie kennt den Minister. Sie', 'den Minister kennen.', 'will'),
        ]),
        circle('Ask the doctor', 'Listen to the interview. Circle what you hear.', [
            ('Viele Vorsätze scheitern, weil sie zu', ['streng', 'teuer'], 'sind.', 'streng'),
            ('Ihr wichtigster Rat: viel', ['Gemüse', 'Obst'], 'essen und genug Wasser trinken.', 'Gemüse'),
            ('Kaffee: drei bis vier', ['Tassen', 'Liter'], 'am Tag sind kein Problem.', 'Tassen'),
            ('Problematisch ist eher der', ['Zucker', 'Kaffee'], '.', 'Zucker'),
            ('Man muss ganz auf Süßigkeiten verzichten:', ['richtig', 'falsch'], '', 'falsch'),
        ], 1) | {'listen': True},
    ],
    ['pass on what people say with sollen',
     'report a claim I doubt with wollen',
     'say it about the past: soll gewonnen haben'],
    listen=Q + 'hoeren_fachinterview',
))

# ---- 7 · eben, halt, schon, wohl ---------------------------------------------------------
spreads.append(spread(
    'partikeln', 'Das ist halt so', 'Six more little words',
    'Dann nehmen wir eben den nächsten. Das klappt schon. Nimm ruhig noch ein Stück. Six more words you can’t translate.',
    Q + 'modalpartikeln',
    [
        table('What each one adds', ['word', 'adds', '~'], [
            ['eben · halt', 'that’s just how it is', 'Dann bleiben wir *eben* zu Hause.'],
            ['schon', 'don’t worry · true enough', 'Das klappt *schon*. Das ist *schon* richtig, aber …'],
            ['wohl', 'probably', 'Er ist *wohl* krank.'],
            ['ruhig', 'go ahead', 'Nimm *ruhig* noch ein Stück.'],
            ['bloß · nur', 'don’t you dare · if only', 'Mach das *bloß* nicht! Wenn er *nur* käme!'],
        ]),
        slots('In the middle, never stressed', [
            (sl('Dann', 'nehmen', 'wir', 'eben!', 'den nächsten Zug.'), None),
            (sl('Komm', 'doch!', 'mal!', 'vorbei!'), 'two together: doch mal'),
        ], note='After the verb and the pronouns. Stress it and it means something else.'),
        box('watch', 'False friends',
            '*wohl* is not “well”, *ruhig* is not “quietly” here, *eben* is not “just now”.'),
        words('Words for the practice page', [
            ('klappen', 'to work out'), ('das Stück Kuchen', 'piece of cake'), ('der Koffer', 'suitcase'),
            ('nächste', 'next'), ('vorbeikommen', 'to drop by'), ('helfen', 'to help'),
        ], 3),
    ],
    [
        circle('Which little word?', 'Circle the word that fits.', [
            ('Der Zug ist weg? Dann nehmen wir', ['eben', 'ruhig'], 'den nächsten.', 'eben'),
            ('Keine Sorge, das klappt', ['schon', 'bloß'], '.', 'schon'),
            ('Nimm dir', ['ruhig', 'eben'], 'noch ein Stück Kuchen.', 'ruhig'),
            ('Er ist nicht da. Er ist', ['wohl', 'ruhig'], 'krank.', 'wohl'),
            ('Mach das', ['bloß', 'schon'], 'nicht!', 'bloß'),
            ('Das ist', ['halt', 'ruhig'], 'so.', 'halt'),
        ]),
        gaps('Soften it', 'Add mal to make the request friendly.', [
            ('Kannst du mir', 'mit dem Koffer helfen?', 'mal'), ('Komm doch', 'vorbei!', 'mal'),
        ]),
    ],
    ['shrug with eben and halt',
     'reassure with schon, allow with ruhig',
     'guess with wohl'],
))

# ---- Review 1 · topics 1–7 -----------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–7', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        gaps('What if', 'Write the missing word.', [
            ('Wenn ich reich', ', würde ich reisen.', 'wäre'), ('Wenn ich das gewusst', ', wäre ich geblieben.', 'hätte'),
            ('Du hättest früher aufstehen', '.', 'sollen'), ('Er tut so, als ob er der Chef', '.', 'wäre'),
        ]),
        gaps('Noun + verb', 'Write the verb.', [
            ('den Müll', '', 'trennen'), ('Maßnahmen', '', 'ergreifen'), ('auf Plastik', '', 'verzichten'),
        ]),
    ],
    [
        gaps('Probably', 'Write the missing word.', [
            ('Er ist nicht da. Er wird den Zug verpasst', '.', 'haben'),
            ('Das Licht ist aus. Sie wird schon gegangen', '.', 'sein'),
            ('Man sagt, er ist reich. Er', 'reich sein.', 'soll'),
        ]),
        circle('Which little word?', 'Circle the word that fits.', [
            ('Der Bus ist weg? Dann gehen wir', ['eben', 'ruhig'], 'zu Fuß.', 'eben'),
            ('Keine Sorge, das klappt', ['schon', 'bloß'], '.', 'schon'),
            ('Setz dich', ['ruhig', 'wohl'], '!', 'ruhig'),
        ], 1),
    ],
))

# ==== Part 2 · The written style ==========================================================

# ---- 8 · aufgrund, infolge, innerhalb ----------------------------------------------------
spreads.append(spread(
    'genitiv_praep', 'aufgrund des Wetters', 'Little words of official German',
    'trotz, wegen, während you know. Reports and official letters add a dozen more — all with the genitive.',
    Q + 'genitiv_praep',
    [
        table('The written set — all + genitive', ['word', '~', 'like this'], [
            ['aufgrund', 'because of, on the basis of', 'aufgrund des Wetters'],
            ['infolge', 'as a result of', 'infolge des Sturms'],
            ['innerhalb · außerhalb', 'within · outside', 'innerhalb eines Monats'],
            ['anhand', 'using, on the evidence of', 'anhand der Daten'],
            ['mithilfe', 'with the help of', 'mithilfe einer App'],
            ['anlässlich', 'on the occasion of', 'anlässlich des Jubiläums'],
            ['(an)statt', 'instead of', 'statt eines Briefes'],
        ]),
        build('No article? von steps in', [
            (['innerhalb', ('von', 'joint'), 'drei Tagen'], 'innerhalb von drei Tagen', 'within three days'),
            (['mithilfe', ('von', 'joint'), 'Freunden'], 'mithilfe von Freunden', 'with the help of friends'),
        ], 'With nothing to show the genitive, von + dative does the job.'),
        words('Words for the practice page', [
            ('der Streik · des Streiks', 'strike'), ('die Öffnungszeiten', 'opening hours'), ('erreichbar', 'reachable'),
            ('der Unfall · des Unfalls', 'accident'), ('der Strom', 'electricity'), ('ausfallen · fiel aus', 'to fail, be cancelled'),
            ('die Ausstellung', 'exhibition'), ('das Jubiläum', 'anniversary'), ('der Betrag', 'amount'),
            ('die Bauarbeiten', 'roadworks'), ('gesperrt', 'closed'), ('die Regionalzüge', 'regional trains'),
            ('die Fahrt · der langen Fahrt', 'journey'), ('kaum ein Wort', 'hardly a word'), ('das Büro', 'office'),
            ('die Woche · zwei Wochen', 'week'), ('der Monat · eines Monats', 'month'), ('eröffnet', 'opened'), ('gelöst', 'solved'), ('das Problem', 'problem'),
        ], 4),
    ],
    [
        gaps('Which little word?', 'Write wegen, außerhalb, infolge, anlässlich or innerhalb.', [
            ('', 'des Streiks fahren heute keine Regionalzüge.', 'Wegen'),
            ('', 'der Öffnungszeiten ist das Büro nicht erreichbar.', 'Außerhalb'),
            ('', 'des Unfalls fiel der Strom aus.', 'Infolge'),
            ('', 'des Jubiläums wurde eine Ausstellung eröffnet.', 'Anlässlich'),
            ('Bitte überweisen Sie den Betrag', 'von zwei Wochen.', 'innerhalb'),
        ]),
        gaps('The genitive', 'Write the words in brackets in the genitive.', [
            ('Während', 'haben wir kaum ein Wort gesprochen. (die lange Fahrt)', 'der langen Fahrt'),
            ('Innerhalb', 'wurde das Problem gelöst. (ein Monat)', 'eines Monats'),
            ('Aufgrund', 'ist die Straße gesperrt. (die Bauarbeiten)', 'der Bauarbeiten'),
        ]),
    ],
    ['use aufgrund, infolge, innerhalb, mithilfe',
     'put the genitive after them',
     'use von when there is no article'],
))

# ---- 9 · Die sechs Typen -------------------------------------------------------------------
spreads.append(spread(
    'nominalisierung', 'der Lauf, das Laufen', 'Six ways to make a noun from a verb',
    'Written German runs on nouns made from verbs. Six patterns, and each one tells you the gender.',
    Q + 'nominalisierung_intro',
    [
        build('Six patterns, three genders', [
            (['lehr', ('er', 'suffix')], 'der Lehrer', 'the person · der'),
            (['beginn'], 'der Beginn', 'the stem: the event · der'),
            ([('Ge', 'joint'), 'red', ('e', 'suffix')], 'das Gerede', 'Ge-…-e: constant, annoying · das'),
            (['lesen'], 'das Lesen', 'the infinitive: the activity · das'),
            (['frag', ('e', 'suffix')], 'die Frage', 'stem + -e · die'),
            (['prüf', ('ung', 'suffix')], 'die Prüfung', '-ung: process or result · die'),
        ], 'Two der, two das, two die.'),
        cols(
            table('One verb, several nouns', ['', '~'], [
                ['der Läufer', 'runner'], ['der Lauf', 'a run'], ['das Laufen', 'running'], ['das Gelaufe', 'running about'],
            ]),
            build('The joining -s-', [
                (['Prüfung', ('s', 'joint'), 'angst'], 'die Prüfungsangst', 'exam nerves'),
            ], 'After -ung, -heit, -keit, -schaft, -ion.'),
        ),
        words('Words for the practice page', [
            ('die Suche', 'search'), ('die Hilfe', 'help'), ('die Bitte', 'request'), ('die Entscheidung', 'decision'),
            ('der Schlaf', 'sleep'), ('der Fahrer', 'driver'), ('das Geschrei', 'shouting'), ('die Fans', 'fans'),
            ('die Nachbarn', 'neighbours'), ('das Treppenhaus', 'stairwell'), ('stören', 'to bother'),
            ('verschoben', 'postponed'), ('dauern', 'to last'), ('ein halbes Jahr', 'half a year'),
            ('die Aufgabe', 'task'), ('erklärt', 'explained'), ('noch einmal', 'once more'),
            ('leiden unter', 'to suffer from'), ('die Studierenden', 'students'), ('rief', 'called'),
            ('das Konzert · des Konzerts', 'concert'), ('das ständige Reden', 'the constant talking'), ('dauern · es dauert', 'to last'),
        ], 4),
    ],
    [
        gaps('Make a noun', 'Write the noun with its article. The verb is in brackets.', [
            ('', 'hat uns die Aufgabe noch einmal erklärt. (lehren → the person)', 'Der Lehrer'),
            ('', 'des Konzerts wurde verschoben. (beginnen)', 'Der Beginn'),
            ('Das ständige', 'der Nachbarn im Treppenhaus stört mich. (reden: Ge-…-e)', 'Gerede'),
            ('', 'nach einer Wohnung dauert schon ein halbes Jahr. (suchen)', 'Die Suche'),
            ('Viele Studierende leiden unter', '. (Prüfung + Angst)', 'Prüfungsangst'),
        ]),
        sort_ex('der, die or das?', 'Write each noun in its column.', ['der', 'die', 'das'], [
            ('Fahrer', 0), ('Schlaf', 0), ('Hilfe', 1), ('Entscheidung', 1), ('Schwimmen', 2), ('Geschrei', 2),
        ]),
    ],
    ['make nouns from verbs in six ways',
     'know the gender from the pattern',
     'join compounds with -s- after -ung'],
))

# ---- 10 · bei Regen, durch Sparen --------------------------------------------------------
spreads.append(spread(
    'nominalstil', 'bei Regen, durch Sparen', 'From a clause to a phrase',
    'Wenn es regnet → bei Regen. Indem man Energie spart → durch Energiesparen. The same thought, half the words.',
    Q + 'konditional_nominal',
    [
        merge('Fold the clause', ('the little word', 'the verb becomes a noun'), [
            ('wenn …', 'bei', 'es regnet', 'Regen', 'bei Regen', 'if it rains'),
            ('wenn …', 'bei', 'Sie haben Fragen', 'Fragen', 'bei Fragen', 'if you have questions'),
            ('indem …', 'durch', 'man steht früh auf', 'frühes Aufstehen', 'durch frühes Aufstehen', 'by getting up early'),
            ('falls …', 'im Falle', 'ein Brand bricht aus', 'eines Brandes', 'im Falle eines Brandes', 'in case of fire'),
            ('wenn … nicht', 'ohne', 'man hat keine Hilfe', 'Hilfe', 'ohne Hilfe', 'without help'),
            ('sodass …', 'infolge', 'es stürmte', 'des Sturms', 'infolge des Sturms', 'as a result of the storm'),
        ], note='sodass names the result, infolge the cause. bei takes the dative ending: bei schönem Wetter.'),
        words('Words for the practice page', [
            ('das Spiel', 'match'), ('ausfallen · fällt aus', 'to be cancelled'), ('das Gebäude', 'building'),
            ('verlassen', 'to leave'), ('die Anmeldung', 'registration'), ('rechtzeitig', 'in time'), ('die Teilnahme', 'taking part'),
            ('möglich', 'possible'), ('der Brand · eines Brandes', 'fire'), ('ausbrechen · bricht aus', 'to break out'),
            ('die Erlaubnis', 'permission'), ('das Training', 'training'), ('regelmäßig', 'regular'), ('das Üben · tägliches Üben', 'practice'),
            ('stehe zur Verfügung', 'am at your disposal'), ('anrufen · rufen Sie an', 'to call'), ('fit', 'fit'),
            ('wenn ein Brand ausbricht', 'if a fire breaks out'), ('trainieren · man trainiert', 'to train'), ('es stürmte', 'there was a storm'), ('…, sodass der Strom ausfiel', '… so the power failed'),
        ], 3),
    ],
    [
        gaps('Shorter', 'Write the phrase.', [
            ('Wenn es regnet, fällt das Spiel aus. →', 'fällt das Spiel aus.', 'Bei Regen'),
            ('Wenn Sie Fragen haben, rufen Sie an. →', 'rufen Sie an.', 'Bei Fragen'),
            ('Falls ein Brand ausbricht, verlassen Sie das Gebäude. →', 'verlassen Sie das Gebäude.', 'Im Falle eines Brandes'),
            ('Wenn man keine Erlaubnis hat, darf man hier nicht parken. →', 'darf man hier nicht parken.', 'Ohne Erlaubnis'),
            ('Man bleibt fit, indem man regelmäßig trainiert. → Man bleibt', 'fit.', 'durch regelmäßiges Training'),
            ('Es stürmte, sodass der Strom ausfiel. →', 'fiel der Strom aus.', 'Infolge des Sturms'),
        ]),
        write('In a letter', 'Write it the formal way, with bei.', [
            ('Wenn Sie Fragen haben, helfe ich Ihnen gern.', 'Bei Fragen stehe ich Ihnen gern zur Verfügung.'),
        ], 1),
    ],
    ['turn wenn into bei, indem into durch',
     'turn sodass into infolge — the cause',
     'write the formal letter phrase: Bei Fragen …'],
))

# ---- 11 · eine Entscheidung treffen ------------------------------------------------------
spreads.append(spread(
    'fvg', 'eine Entscheidung treffen', 'Noun + light verb',
    'Make a decision is eine Entscheidung treffen, not machen. Learn the noun with its verb, like an ending.',
    Q + 'fvg',
    [
        build('The noun carries the meaning', [
            (['eine Entscheidung', ('treffen', 'suffix')], 'eine Entscheidung treffen', '= entscheiden'),
            (['eine Frage', ('stellen', 'suffix')], 'eine Frage stellen', '= fragen'),
            (['Kritik', ('üben', 'suffix')], 'Kritik üben', '= kritisieren'),
            (['in Betracht', ('ziehen', 'suffix')], 'in Betracht ziehen', '= consider'),
            (['zur Verfügung', ('stehen', 'suffix')], 'zur Verfügung stehen', '= be available'),
            (['in Kraft', ('treten', 'suffix')], 'in Kraft treten', '= come into force'),
        ], 'The verb means almost nothing on its own: make a decision is treffen, not machen.'),
        table('By verb', ['verb', 'nouns'], [
            ['treffen', 'eine Entscheidung · Maßnahmen'], ['stellen', 'eine Frage · in Frage · zur Verfügung'],
            ['nehmen', 'Rücksicht auf · Abschied von'], ['bringen · kommen · spielen', 'zum Ausdruck · in Frage · eine Rolle'],
        ]),
        words('Words for the practice page', [
            ('der Vorstand', 'board'), ('das Gesetz', 'law'), ('am 1. Januar', 'on 1 January'), ('die Zuhörer', 'audience'),
            ('der Vortrag', 'talk'), ('die Opposition', 'opposition'), ('der Vorschlag', 'proposal'),
            ('die Option', 'option'), ('die Verschiebung', 'postponement'), ('jederzeit', 'at any time'), ('eine wichtige Entscheidung', 'an important decision'), ('scharfe Kritik', 'sharp criticism'),
        ], 4),
    ],
    [
        gaps('The light verb', 'Write the verb that goes with the noun.', [
            ('Der Vorstand hat eine wichtige Entscheidung', '.', 'getroffen'),
            ('Nach dem Vortrag durften die Zuhörer Fragen', '.', 'stellen'),
            ('Wir sollten auch eine Verschiebung in Betracht', '.', 'ziehen'),
            ('Das neue Gesetz', 'am 1. Januar in Kraft.', 'tritt'),
            ('Ich', 'Ihnen jederzeit zur Verfügung.', 'stehe'),
            ('Die Opposition', 'scharfe Kritik an dem Vorschlag.', 'übte'),
            ('Diese Option', 'nicht in Frage.', 'kommt'),
        ]),
        match('Noun and verb', 'Draw a line from the noun to its verb.', [
            ('Rücksicht', 'nehmen'), ('eine Rolle', 'spielen'), ('zum Ausdruck', 'bringen'), ('Maßnahmen', 'treffen'),
        ], [3, 0, 2, 1]),
    ],
    ['use eine Entscheidung treffen, eine Frage stellen',
     'learn each noun with its light verb',
     'sound formal in a letter: zur Verfügung stehen'],
))

# ---- 12 · die von mir gelesene Zeitung ---------------------------------------------------
spreads.append(spread(
    'partizip_attribut', 'die geplanten Maßnahmen', 'A whole clause before the noun',
    'Written German packs a relative clause between the article and the noun. Jump to the noun, then read the middle.',
    Q + 'partizip_attribut',
    [
        slots('Article … the middle … participle + ending … noun', [
            ([('die', 'article'), ('von der Regierung', 'the middle'), {'de': 'geplanten', 'tag': 'participle', 'hot': True}, ('Maßnahmen', 'noun')], None),
            ([('das', 'article'), ('seit Jahren', 'the middle'), {'de': 'bestehende', 'tag': 'participle', 'hot': True}, ('Problem', 'noun')], None),
            ([('der', 'article'), ('ständig', 'the middle'), {'de': 'zunehmende', 'tag': 'participle', 'hot': True}, ('Verkehr', 'noun')], None),
        ], note='Read: article → noun → back to the middle.'),
        flow('-end or ge-?', q('Is the noun doing it?',
                               a('-end: doing', 'der zunehmende Verkehr = der Verkehr, der zunimmt'),
                               a('ge-: done', 'die geplanten Maßnahmen = die Maßnahmen, die geplant wurden'))),
        table('Fold the clause', ['relative clause', 'before the noun'], [
            ['die Brücke, die 2020 eröffnet wurde', 'die 2020 eröffnete Brücke'],
            ['das Unternehmen, das schnell wächst', 'das schnell wachsende Unternehmen'],
            ['die Zahlen, die im Bericht genannt werden', 'die im Bericht genannten Zahlen'],
        ], 'The ending comes from the article, as for any describing word.'),
        words('Words for the practice page', [
            ('beschließen · beschlossen', 'to decide'), ('bestehen', 'to exist'), ('zunehmen', 'to increase'),
            ('der Lärm', 'noise'), ('die Innenstadt', 'city centre'), ('das Unternehmen', 'company'),
            ('herstellen · hergestellt', 'to make'), ('die Produkte', 'products'), ('die Fabrik', 'factory'),
            ('diskutierten über', 'discussed'), ('im letzten Monat', 'last month'), ('die Luftverschmutzung', 'air pollution'),
            ('noch immer nicht', 'still not'), ('erbauen · erbaut', 'to build'), ('das Schloss', 'palace'),
        ], 4),
    ],
    [
        gaps('Participle + ending', 'Write the verb in brackets as -end or ge-, with its ending.', [
            ('Wir diskutierten über die von der Regierung im letzten Monat', 'Maßnahmen. (beschließen)', 'beschlossenen'),
            ('Das seit Jahren', 'Problem der Luftverschmutzung ist noch immer nicht gelöst. (bestehen)', 'bestehende'),
            ('Mit dem ständig', 'Verkehr wächst auch der Lärm in der Innenstadt. (zunehmen)', 'zunehmenden'),
            ('Die in der Fabrik', 'Produkte sind sehr teuer. (herstellen)', 'hergestellten'),
        ]),
        write('Fold it', 'Put the clause before the noun.', [
            ('das Schloss, das im 18. Jahrhundert erbaut wurde', 'das im 18. Jahrhundert erbaute Schloss'),
            ('das Unternehmen, das schnell wächst', 'das schnell wachsende Unternehmen'),
        ], 1),
    ],
    ['read a long attribute: article, noun, then the middle',
     'choose -end (doing) or ge- (done)',
     'fold a relative clause into an attribute'],
))

# ---- 13 · Das lässt sich lösen -----------------------------------------------------------
spreads.append(spread(
    'passiversatz', 'Das lässt sich lösen', 'Four ways to say “can be done”',
    'kann gelöst werden — or lösbar, lässt sich lösen, ist zu lösen. Shorter, lighter, and everywhere in written German.',
    Q + 'passiversatz_intro',
    [
        tiles('One meaning, four shapes', [
            ('ist lösbar', '-bar'), ('lässt sich lösen', 'sich lassen'), ('ist zu lösen', 'sein + zu'), ('man kann es lösen', 'man'),
        ], 4, note='= Das Problem kann gelöst werden.'),
        flow('ist zu … : can or must?', q('Is there leicht, schwer or kaum?',
                                          a('can', 'Der Fehler ist leicht zu beheben.'),
                                          a('must', 'Die Rechnung ist bis Freitag zu bezahlen.'))),
        table('-bar and -lich', ['can be …', '~'], [
            ['machbar · lesbar · trinkbar · essbar', 'doable · readable · drinkable · edible'],
            ['erreichbar · vermeidbar · bezahlbar', 'reachable · avoidable · affordable'],
            ['verständlich · unglaublich', 'understandable · unbelievable'],
        ], 'Not verstehbar: learn each one as a word.'),
        words('Words for the practice page', [
            ('die Handschrift', 'handwriting'), ('die Quelle', 'spring'), ('die Unterlagen', 'documents'), ('einreichen', 'to hand in'),
            ('beheben', 'to fix'), ('der Fehler', 'mistake'), ('die Pilze', 'mushrooms'), ('die Frage', 'question'),
            ('mit Ja oder Nein', 'with yes or no'), ('beantworten', 'to answer'), ('öffnen', 'to open'), ('das Ziel', 'goal'),
            ('die Reaktion', 'reaction'), ('bis zum 15.', 'by the 15th'), ('das Formular', 'form'), ('ausfüllen · auszufüllen', 'to fill in'), ('eingereicht', 'handed in'), ('behoben', 'fixed'),
        ], 4),
    ],
    [
        gaps('Say it shorter', 'Write the shorter form.', [
            ('Das kann gemacht werden. → Das ist', '.', 'machbar'),
            ('Das Wasser aus dieser Quelle kann getrunken werden. → Das Wasser ist', '.', 'trinkbar'),
            ('Die Tür kann nicht geöffnet werden. → Die Tür', 'nicht öffnen.', 'lässt sich'),
            ('Die Unterlagen müssen bis zum 15. eingereicht werden. → Die Unterlagen sind bis zum 15.', '.', 'einzureichen'),
            ('Der Fehler kann leicht behoben werden. → Der Fehler ist leicht', '.', 'zu beheben'),
        ]),
        write('With sich lassen', 'Write it with sich lassen.', [
            ('Die Frage kann nicht mit Ja oder Nein beantwortet werden.', 'Die Frage lässt sich nicht mit Ja oder Nein beantworten.'),
            ('Das Problem kann gelöst werden.', 'Das Problem lässt sich lösen.'),
        ], 1),
    ],
    ['say can be done with -bar and sich lassen',
     'read sein + zu: must or can',
     'choose the shape that fits the text'],
))

# ---- 14 · freundlich, sinnlos, erfolgreich -----------------------------------------------
spreads.append(spread(
    'adjektivbildung', 'sinnvoll oder sinnlos?', 'Endings that make describing words',
    'Freund → freundlich, Sonne → sonnig, Erfolg → erfolgreich: read the ending and you can guess a word you’ve never seen.',
    Q + 'adjektivbildung',
    [
        build('Noun + ending', [
            (['Freund', ('lich', 'suffix')], 'freundlich', 'like'), (['Sonn', ('ig', 'suffix')], 'sonnig', 'full of'),
            (['Kind', ('isch', 'suffix')], 'kindisch', 'childish — it judges'), (['Arbeit', ('s', 'joint'), ('los', 'suffix')], 'arbeitslos', 'without'),
            (['Erfolg', ('reich', 'suffix')], 'erfolgreich', 'rich in'),
        ]),
        table('Opposites', ['', '↔', ''], [
            ['sinnvoll', '↔', 'sinnlos'], ['fettreich', '↔', 'fettarm'], ['geduldig', '↔', 'ungeduldig'],
        ]),
        cols(
            build('Verb + ending', [
                (['erreich', ('bar', 'suffix')], 'erreichbar', 'can be reached'), (['wirk', ('sam', 'suffix')], 'wirksam', 'effective'),
                ]),
            build('-weise: how', [
                (['glücklicher', ('weise', 'suffix')], 'glücklicherweise', 'luckily'),
                (['normaler', ('weise', 'suffix')], 'normalerweise', 'normally'),
                (['ausnahms', ('weise', 'suffix')], 'ausnahmsweise', 'for once'),
            ]),
        ),
        words('Words for the practice page', [
            ('die Kollegin', 'colleague'), ('hilft allen', 'helps everyone'), ('der Nachmittag', 'afternoon'),
            ('endlich', 'at last'), ('Hör auf!', 'Stop it!'), ('das Medikament', 'medicine'),
            ('gegen Kopfschmerzen', 'for headaches'), ('die Fabrik', 'factory'), ('geschlossen', 'closed'),
            ('die Anleitung', 'instructions'), ('völlig', 'completely'), ('telefonisch', 'by phone'), ('tagsüber', 'during the day'),
            ('die Ärztin', 'doctor'), ('Rad fahren', 'to cycle'), ('viele Menschen', 'many people'), ('normal', 'normal'),
        ], 4),
    ],
    [
        gaps('Which ending?', 'Write the describing word. The noun or verb is in brackets.', [
            ('Die neue Kollegin ist sehr', 'und hilft allen. (Freund)', 'freundlich'),
            ('Am Nachmittag wurde es endlich', '. (Sonne)', 'sonnig'),
            ('Hör auf, dich so', 'zu benehmen! (Kind: -isch)', 'kindisch'),
            ('Das Medikament ist sehr', 'gegen Kopfschmerzen. (wirken)', 'wirksam'),
            ('Seit die Fabrik geschlossen hat, sind viele Menschen', '. (Arbeit: -los)', 'arbeitslos'),
            ('Die Ärztin ist tagsüber telefonisch', '. (erreichen)', 'erreichbar'),
            ('', 'fahre ich Rad, heute nehme ich ausnahmsweise das Auto. (normal)', 'Normalerweise'),
        ]),
        write('The opposite', 'Write the opposite.', [
            ('sinnvoll', 'sinnlos'), ('geduldig', 'ungeduldig'), ('fettreich', 'fettarm'),
        ], 3),
    ],
    ['build describing words with -lich, -ig, -los, -reich, -bar',
     'say the opposite with un- or -los',
     'make adverbs with -weise'],
))

# ---- Review 2 · topics 8–14 ----------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 8–14', 'The written style, all at once. No looking back until you have done both pages.',
    Q + 'lesen_textergaenzung',
    [
        gaps('Official German', 'Write the missing word.', [
            ('', 'des Streiks fahren keine Regionalzüge. (because of)', 'Wegen'),
            ('Bitte bezahlen Sie', 'von zwei Wochen. (≠ außerhalb)', 'innerhalb'),
            ('Wenn es regnet, fällt das Spiel aus. →', 'Regen fällt das Spiel aus.', 'Bei'),
            ('Der Vorstand hat eine Entscheidung', '.', 'getroffen'),
        ]),
        sort_ex('der, die or das?', 'Write each noun in its column.', ['der', 'die', 'das'], [
            ('Beginn', 0), ('Prüfung', 1), ('Lesen', 2), ('Lehrer', 0), ('Frage', 1), ('Gerede', 2),
        ]),
    ],
    [
        gaps('Shorter', 'Write the missing word.', [
            ('Das Problem kann gelöst werden. → Das Problem', 'sich lösen.', 'lässt'),
            ('Das kann gemacht werden. → Das ist', '.', 'machbar'),
            ('der Verkehr, der ständig zunimmt → der ständig', 'Verkehr', 'zunehmende'),
            ('Die Anleitung ist völlig', '. (≠ verständlich)', 'unverständlich'),
        ]),
    ],
))

# ==== Part 3 · Arguing and holding a text together =======================================

# ---- 15 · obwohl, selbst wenn, so … auch --------------------------------------------------
spreads.append(spread(
    'konzessiv', 'So teuer es auch war …', 'Although — in five shapes',
    'Obwohl es regnete, gingen wir. Es regnete, trotzdem gingen wir. Trotz des Regens gingen wir. Same thought, five shapes.',
    Q + 'konzessiv',
    [
        slots('Where the verb goes', [
            (sl('Obwohl', 'es', 'regnete,!', 'gingen!', 'wir spazieren.'), 'obwohl · obgleich · wenngleich: verb last'),
            (sl('Es regnete.', 'Trotzdem', 'gingen!', 'wir spazieren.'), 'trotzdem · dennoch: verb second'),
            (sl('Zwar', 'regnete!', 'es,', 'aber', 'wir gingen!', 'spazieren.'), 'zwar … aber'),
            (sl('Selbst wenn', 'es', 'regnet,!', 'gehen!', 'wir.'), 'even if: verb last'),
            (sl('Trotz des Regens', 'gingen!', 'wir spazieren.'), 'trotz + genitive'),
        ]),
        box('watch', 'One marker per sentence',
            'Never *Obwohl es regnete, trotzdem gingen wir.* Choose obwohl **or** trotzdem.'),
        table('The elegant one: so … auch', ['', '~'], [
            ['So teuer die Reise *auch* war, sie hat sich gelohnt.', 'however expensive it was'],
            ['So müde er *auch* war, er las bis Mitternacht.', 'tired as he was'],
        ], 'so + describing word, subject, verb, auch.'),
        words('Words for the practice page', [
            ('in Strömen', 'pouring'), ('das Gehalt', 'salary'), ('niedrig', 'low'), ('Spaß machen', 'to be fun'),
            ('wert', 'worth'), ('der Preis', 'price'), ('sich lohnen · hat sich gelohnt', 'to be worth it'), ('riskant', 'risky'),
            ('versuchen', 'to try'), ('provozieren', 'to provoke'), ('Mitternacht', 'midnight'), ('müde', 'tired'),
            ('weiter', 'on'), ('ruhig bleiben', 'to stay calm'), ('half', 'helped'), ('seinen Preis wert', 'worth its price'), ('wenig Zeit', 'little time'),
        ], 4),
    ],
    [
        gaps('Which word?', 'Write obwohl, trotzdem, trotz, zwar, selbst wenn or so.', [
            ('', 'es in Strömen regnete, gingen wir spazieren.', 'Obwohl'),
            ('Es regnete in Strömen.', 'gingen wir spazieren.', 'Trotzdem'),
            ('', 'des Regens gingen wir spazieren.', 'Trotz'),
            ('', 'ist das Hotel teuer, aber es ist seinen Preis wert.', 'Zwar'),
            ('', 'das Gehalt niedrig ist, macht mir die Arbeit Spaß.', 'Selbst wenn'),
            ('', 'müde er auch war, er las bis Mitternacht.', 'So'),
        ]),
        write('Say it another way', 'Write it with trotzdem.', [
            ('Obwohl sie wenig Zeit hatte, half sie uns.', 'Sie hatte wenig Zeit. Trotzdem half sie uns.'),
            ('Obwohl der Plan riskant ist, wollen wir es versuchen.', 'Der Plan ist riskant. Trotzdem wollen wir es versuchen.'),
        ], 1),
    ],
    ['say although in five ways',
     'put the verb in the right place for each',
     'use so … auch in writing'],
))

# ---- 16 · während, dagegen, im Gegensatz zu ----------------------------------------------
spreads.append(spread(
    'adversativ', 'Der Süden dagegen ist trocken', 'Two things side by side',
    'No surprise here — just two different things, held up side by side.',
    Q + 'adversativ',
    [
        flow('Contrast or concession?', q('Could you add “surprisingly”?',
                                          a('concession: obwohl, trotzdem', 'Obwohl es kalt ist, badet er.'),
                                          a('contrast: während, dagegen', 'Während es im Norden kalt ist, ist es im Süden warm.'))),
        slots('Three shapes', [
            (sl('Während', 'der Norden regnerisch', 'ist,!', 'ist!', 'der Süden trocken.'), 'während = whereas: verb last'),
            (sl('Der Süden', 'dagegen', 'ist!', 'trocken.'), 'dagegen · hingegen: after the subject'),
            (sl('Im Gegensatz zum Norden', 'ist!', 'der Süden trocken.'), 'im Gegensatz zu · im Vergleich zu + dative'),
            (sl('Anders als sein Bruder', 'mag!', 'er Sport.'), 'anders als = unlike'),
        ]),
        words('Words for the practice page', [
            ('die Preise', 'prices'), ('die Löhne', 'wages'), ('gleich bleiben', 'to stay the same'), ('Pizza bestellen', 'to order pizza'),
            ('die Städte', 'cities'), ('die Dörfer', 'villages'), ('schrumpfen', 'to shrink'), ('wachsen', 'to grow'),
            ('die Kritiker', 'critics'), ('bemängeln', 'to find fault with'), ('die Figuren', 'characters'), ('der Rezensent', 'reviewer'),
            ('bereichernd', 'enriching'), ('der Anfang', 'beginning'), ('langsam', 'slow'),
            ('die zweite Hälfte', 'the second half'), ('entschädigt dafür', 'makes up for it'),
            ('schwächer', 'weaker'), ('allenfalls', 'if anything'), ('das Ende', 'ending'),
            ('die vielen', 'the many'), ('stiegen', 'rose'), ('blieben', 'stayed'), ('manche', 'some'),
        ], 4),
    ],
    [
        gaps('Which word?', 'Write während, dagegen, im Gegensatz zum or anders als.', [
            ('', 'sie jeden Tag kocht, bestellt er nur Pizza.', 'Während'),
            ('Städte wachsen; Dörfer', 'schrumpfen.', 'dagegen'),
            ('', 'Norden ist der Süden trocken.', 'Im Gegensatz zum'),
            ('', 'sein Bruder mag er Sport.', 'Anders als'),
            ('Die Preise stiegen,', 'die Löhne gleich blieben.', 'während'),
        ]),
        circle('A book review', 'Listen to the review. Circle what you hear.', [
            ('Zwar ist der Anfang', ['langsam', 'spannend'], ', aber die zweite Hälfte entschädigt dafür.', 'langsam'),
            ('Manche Kritiker bemängeln die vielen', ['Figuren', 'Seiten'], '.', 'Figuren'),
            ('Der Rezensent fand sie dagegen', ['bereichernd', 'langweilig'], '.', 'bereichernd'),
            ('Schwächer ist allenfalls das', ['Ende', 'Kapitel'], '.', 'Ende'),
        ], 1) | {'listen': True},
    ],
    ['set two things side by side with während and dagegen',
     'tell contrast from concession',
     'compare with im Gegensatz zu and anders als'],
    listen=Q + 'lesen_rezension',
))

# ---- 17 · Wer gut schläft … ----------------------------------------------------------------
spreads.append(spread(
    'relativ', 'Wer gut schläft, lernt besser', 'wer, was, wo',
    'Alles, was er sagt. Die Stadt, wo ich wohne. Der Termin, auf den ich warte: the relatives that don’t point at one noun.',
    Q + 'relativ_wer_was',
    [
        flow('der/die/das or was?', q('Is there a real noun before the comma?',
                                      a('der · die · das', 'der Film, den ich sah'),
                                      a('was', 'alles, was ich sah · das Beste, was ich sah'))),
        table('wer = whoever: it changes for its job', ['', 'wer-clause', 'main clause'], [
            ['wer → (der)', '*Wer* gut schläft,', '(der) lernt besser.'],
            ['wem → der', '*Wem* du hilfst,', '*der* dankt dir.'],
            ['wen → den', '*Wen* ich mag,', '*den* lade ich ein.'],
        ], 'When the two cases differ, the der-word is needed.'),
        slots('The preposition goes in front', [
            (sl('der Termin,', 'auf den!', 'ich so lange', 'gewartet habe'), 'warten auf + Akk'),
            (sl('die Stadt,', 'in der!', 'ich', 'aufgewachsen bin'), 'or: wo'),
            (sl('etwas,', 'worüber!', 'du dich', 'freust'), 'after etwas, alles: wo(r)-'),
        ], note='English leaves it at the end (the town I grew up in); German never does.'),
        words('Words for the practice page', [
            ('der Unfall', 'accident'), ('stimmen', 'to be true'), ('nichts ärgert mich mehr', 'nothing annoys me more'),
            ('die Unpünktlichkeit', 'lateness'), ('das Dorf', 'village'), ('zurückkehren', 'to return'),
            ('dauerhaft', 'permanently'), ('riskieren', 'to risk'), ('gesundheitliche Probleme', 'health problems'),
            ('die Erwachsenen', 'adults'), ('der Schlaf', 'sleep'), ('das Schlafzimmer', 'bedroom'), ('dunkel', 'dark'),
            ('kühl', 'cool'), ('das Schlafengehen', 'going to bed'), ('weglegen', 'to put away'), ('sieben bis acht', 'seven to eight'),
            ('die Stunden', 'hours'), ('brauchen', 'to need'), ('gefreut', 'pleased'), ('mich', 'me'),
        ], 4),
    ],
    [
        gaps('Which relative word?', 'Write wer, wem, was, wo or worauf.', [
            ('', 'gut schläft, lernt besser.', 'Wer'),
            ('', 'du hilfst, der dankt dir auch.', 'Wem'),
            ('Alles,', 'er über den Unfall gesagt hat, stimmt.', 'was'),
            ('Er hat die Prüfung bestanden,', 'mich sehr gefreut hat.', 'was'),
            ('Wir fahren nach Wien,', 'meine Schwester wohnt.', 'wo'),
            ('Das ist etwas,', 'ich mich schon lange freue.', 'worauf'),
        ]),
        gaps('A talk about sleep', 'Listen to the talk and fill in the notes.', [
            ('Erwachsene brauchen', 'Stunden Schlaf.', 'sieben bis acht'),
            ('Wer dauerhaft weniger schläft, riskiert gesundheitliche', '.', 'Probleme'),
            ('Das Schlafzimmer: dunkel und eher', '', 'kühl'),
            ('Das Handy eine', 'vor dem Schlafengehen weglegen.', 'Stunde'),
        ]) | {'listen': True},
    ],
    ['make a general point with wer …, (der) …',
     'use was after alles, nichts, etwas',
     'put the preposition before the relative word'],
    listen=Q + 'hoeren_vortrag',
))

# ---- 18 · damit, dadurch, Letzterer --------------------------------------------------------
spreads.append(spread(
    'verweiswoerter', 'Damit kaufte er ein Auto', 'Words that point back',
    'Er sparte zwei Jahre. Damit kaufte er ein Auto. Each new sentence points at the last one — that’s what makes a text.',
    Q + 'verweiswoerter',
    [
        build('da(r) + little word = “this”', [
            (['da', 'mit'], 'damit', 'with this'), (['da', 'durch'], 'dadurch', 'through this'),
            (['da', 'bei'], 'dabei', 'in doing so'), (['da', 'nach'], 'danach', 'after that'),
        ], 'An -r- before a vowel. At the start, the verb comes next: Damit kaufte er …'),
        table('What points at what', ['points at', 'word', 'like this'], [
            ['a noun', 'er · sie · es · dieser', 'Die Stadt baute eine Brücke. *Diese* kostete Millionen.'],
            ['a whole fact', 'das · dies', 'Die Preise stiegen. *Das* überraschte niemanden.'],
            ['two things', 'Ersterer · Letzterer', 'Zwei Vorschläge: *Ersterer* wurde abgelehnt, *Letzterer* angenommen.'],
        ]),
        table('Links between sentences', ['', 'word'], [
            ['cause', 'aus diesem Grund · deshalb'], ['adding', 'zudem · außerdem · darüber hinaus'],
            ['although', 'dennoch · trotzdem'], ['contrast', 'hingegen · dagegen'],
        ]),
        words('Words for the practice page', [
            ('sparen · sparte', 'to save'), ('unabhängig', 'independent'), ('trainieren · trainiert', 'to train'),
            ('besprechen · besprachen', 'to discuss'), ('der Plan', 'plan'), ('mehrere Fehler', 'several mistakes'),
            ('die Kosten', 'costs'), ('knapp', 'short'), ('beginnen', 'to start'), ('im Mai', 'in May'),
            ('überraschen · überraschte', 'to surprise'), ('niemanden', 'nobody'),
            ('blieb', 'stayed'), ('krank', 'ill'),
            ('fanden', 'found'), ('täglich', 'daily'),
        ], 4),
    ],
    [
        gaps('Point back', 'Write damit, dadurch, dabei, das, aus diesem Grund or zudem.', [
            ('Er sparte Geld.', 'kaufte er ein Auto.', 'Damit'),
            ('Sie trainiert täglich.', 'bleibt sie fit.', 'Dadurch'),
            ('Wir besprachen den Plan.', 'fanden wir mehrere Fehler.', 'Dabei'),
            ('Die Preise stiegen.', 'überraschte niemanden.', 'Das'),
            ('Er war krank.', 'blieb er zu Hause.', 'Aus diesem Grund'),
            ('Die Kosten sind hoch.', 'ist die Zeit knapp.', 'Zudem'),
        ]),
        write('Make it a text', 'Join the sentences: start the second with the word in brackets.', [
            ('Die Kosten sind hoch. Wir beginnen im Mai. (dennoch)', 'Die Kosten sind hoch. Dennoch beginnen wir im Mai.'),
        ], 1),
    ],
    ['point back with damit, dadurch, dabei',
     'use das, dieser, Letzterer',
     'link sentences with deshalb, zudem, dennoch'],
))

# ---- 19 · jemand, niemand, welche ---------------------------------------------------------
spreads.append(spread(
    'indefinit', 'Ja, ich habe welche', 'someone, nobody, one, some',
    'Hast du einen Stift? – Ja, ich habe einen. Gibt es Äpfel? – Ja, es gibt welche. The words stand in for the noun.',
    Q + 'indefinit',
    [
        table('jemand and niemand change; etwas and nichts don’t', ['', 'jemand', 'niemand', 'etwas · nichts'], [
            ['wer?', 'jemand', 'niemand', 'etwas · nichts'],
            ['wen?', 'jemand*en*', 'niemand*en*', 'etwas · nichts'],
            ['wem?', 'jemand*em*', 'niemand*em*', 'etwas · nichts'],
        ]),
        slots('One word for the noun: it keeps the gender', [
            (sl('Hast du einen Stift?', '– Ja, ich habe', 'einen.!'), 'der → einen · keinen'),
            (sl('Hast du ein Auto?', '– Nein, ich habe', 'keins.!'), 'das → eins · keins'),
            (sl('Gibt es Äpfel?', '– Ja, es gibt', 'welche.!'), 'plural or milk, water … → welche · keine'),
        ]),
        table('man → einen → einem → sich', ['', '~'], [
            ['*Man* weiß nie.', 'one never knows'], ['Das ärgert *einen*.', 'that annoys one'],
            ['Niemand hilft *einem*.', 'nobody helps one'], ['*Man* muss *sich* beeilen.', 'one must hurry'],
        ]),
        words('Words for the practice page', [
            ('irgendjemand', 'anyone at all'), ('irgendwo', 'somewhere'), ('irgendwann', 'some day'),
            ('der Schirm', 'umbrella'), ('die Handschuhe', 'gloves'), ('der Stift', 'pen'), ('die Äpfel', 'apples'),
            ('anrufen · hat angerufen', 'to call'), ('helfen kann', 'can help'), ('gelesen', 'read'),
            ('die Milch', 'milk'), ('brauchst', 'need'), ('schon', 'already'), ('ruft an', 'is calling'),
        ], 4),
    ],
    [
        gaps('Someone, nobody', 'Write the word in the right form.', [
            ('', 'ruft an. (jemand)', 'Jemand'), ('Ich habe', 'gesehen. (niemand)', 'niemanden'),
            ('Ich kenne', ', der dir helfen kann. (jemand)', 'jemanden'), ('Ich helfe', 'gern. (jemand)', 'jemandem'),
            ('Das hat', 'gesagt. (niemand)', 'niemand'),
        ]),
        gaps('One, none, some', 'Write einen, eins, keins, keine or welche.', [
            ('Hast du einen Stift? – Ja, ich habe', '.', 'einen'),
            ('Hast du ein Auto? – Nein, ich habe', '.', 'keins'),
            ('Gibt es noch Äpfel? – Ja, es gibt noch', '.', 'welche'),
            ('Und Handschuhe? – Ich habe', '.', 'keine'),
            ('Hast du Milch? – Ja, ich habe', '.', 'welche'),
        ]),
    ],
    ['say someone and nobody in every case',
     'stand in for a noun: einen, keins, welche',
     'use man, einen, einem'],
))

# ---- 20 · Eine Beschwerde ------------------------------------------------------------------
spreads.append(spread(
    'beschwerde', 'Trotz mehrfacher Zusagen …', 'A complaint that works',
    'Concede a point, then press: dates, amounts, a deadline. The Konjunktiv keeps it polite; the facts keep it firm.',
    Q + 'schreiben_beschwerde',
    [
        slots('The shape of a complaint', [
            ([('Sehr geehrte Damen und Herren,', 'greeting'), ('Am 3. Mai …', 'the facts'), ('Zwar …, aber …', 'concede, then press'),
              ('Ich bitte Sie, bis …', 'what you want, by when'), {'de': 'Andernfalls …', 'tag': 'what follows', 'hot': True}], None),
        ]),
        table('Facts, not adjectives', ['weak', 'strong'], [
            ['Die Lieferung kam viel zu spät.', 'Die Lieferung war für den 3. Mai zugesagt und kam erst am 28. Mai.'],
            ['Viele Stühle waren kaputt.', 'Von den bestellten zwölf Stühlen waren vier beschädigt.'],
        ]),
        table('Firm but polite', ['', '~'], [
            ['Zwar kam der Techniker pünktlich, aber der Schaden ist noch da.', 'concede, then press'],
            ['Trotz mehrfacher Zusagen ist bislang nichts geschehen.', 'trotz + genitive'],
            ['Ich bitte Sie, den Mangel bis spätestens 15. Juni zu beheben.', 'the deadline'],
            ['Andernfalls würde ich den Betrag um 30 Prozent mindern.', 'what follows — in the Konjunktiv'],
        ]),
        words('Words for the practice page', [
            ('die Lieferung', 'delivery'), ('zugesagt', 'promised'), ('die Zusage', 'promise'), ('mehrfach', 'repeated'),
            ('beschädigt', 'damaged'), ('bestellt', 'ordered'), ('der Techniker', 'technician'), ('der Schaden', 'damage'),
            ('der Mangel', 'fault'), ('spätestens', 'at the latest'), ('andernfalls', 'otherwise'), ('mindern', 'to reduce'),
            ('bislang', 'so far'), ('geschehen', 'happened'), ('die Rechnung', 'invoice'), ('die Bestellung', 'order'),
            ('die Waschmaschine', 'washing machine'), ('repariert', 'repaired'), ('freundlich', 'friendly'),
        ], 4),
    ],
    [
        gaps('Firm but polite', 'Write the missing word.', [
            ('', 'kam der Techniker pünktlich, aber der Schaden ist noch da.', 'Zwar'),
            ('', 'mehrfacher Zusagen ist bislang nichts geschehen.', 'Trotz'),
            ('Ich bitte Sie, den Mangel bis', '15. Juni zu beheben.', 'spätestens'),
            ('', 'würde ich den Betrag um 30 Prozent mindern.', 'Andernfalls'),
        ]),
        write('Concede, then press', 'Join with obwohl.', [
            ('Der Techniker war freundlich. Die Waschmaschine ist nicht repariert.',
             'Obwohl der Techniker freundlich war, ist die Waschmaschine nicht repariert.'),
        ], 1),
        gaps('Your complaint', 'Write the start of a complaint about something that went wrong.', [
            ('Sehr geehrte Damen und Herren, am', '.'), ('Zwar', ', aber …'), ('Ich bitte Sie, bis', '.'),
        ], 'About you.'),
    ],
    ['complain with dates and amounts',
     'concede a point, then press',
     'set a deadline and say what follows'],
))

# ---- Review 3 · topics 15–20 ---------------------------------------------------------------
spreads.append(review(
    'review_3', 'Topics 15–20', 'The last part, all at once. No looking back until you have done both pages.',
    Q + 'sprechen_dialog',
    [
        gaps('Although or whereas?', 'Write the missing word.', [
            ('', 'es regnete, gingen wir spazieren.', 'Obwohl'),
            ('Es regnete.', 'gingen wir spazieren.', 'Trotzdem'),
            ('', 'der Norden regnerisch ist, ist der Süden trocken.', 'Während'),
            ('Städte wachsen; Dörfer', 'schrumpfen.', 'dagegen'),
        ]),
        gaps('Relative words', 'Write the missing word.', [
            ('', 'gut schläft, lernt besser.', 'Wer'), ('Alles,', 'er sagt, stimmt.', 'was'),
        ]),
    ],
    [
        gaps('Pointing and standing in', 'Write the missing word.', [
            ('Er sparte Geld.', 'kaufte er ein Auto.', 'Damit'),
            ('Ich habe', 'gesehen. (niemand)', 'niemanden'),
            ('Gibt es noch Äpfel? – Ja, es gibt', '.', 'welche'),
            ('', 'mehrfacher Zusagen ist nichts geschehen.', 'Trotz'),
        ]),
    ],
))

book = {
    'title': 'Was wäre, wenn?',
    'cover': 'cp_b2_2_cover',
    'welcome': [
        'This book is the paper half of B2.2. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It has three parts. The first is about what isn’t so: what would be, what would have been, and what probably happened. The second is the written style of reports and letters. The third is about arguing well and holding a text together.',
        'It carries on from the earlier books. Words you learned there are not taught again. Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Paul', 'Mia', 'Tom', 'Anna', 'Berg', 'Hedwig', 'Lindner', 'Wien', 'Berlin', 'Deutschland',
              'Kanada', 'Europa', 'LED', 'Lampen', 'Juni', 'Mai', 'Januar', 'Prozent'],
    'spreads': spreads,
    'overview': {'title': 'B2.2 at a glance', 'blocks': [
        table('What isn’t so: the Konjunktiv II', ['', 'now', 'then'], [
            ['sein · haben', 'wäre · hätte', 'wäre gewesen · hätte gehabt'],
            ['other verbs', 'würde machen · käme, gäbe, wüsste', 'hätte gemacht · wäre gegangen'],
            ['with a modal', 'könnte machen', 'hätte machen können'],
            ['as if', 'als ob er reich wäre', 'als ob nichts passiert wäre'],
        ]),
        table('Probably, people say, he claims', ['', 'now', 'then'], [
            ['probably', 'er wird krank sein', 'er wird krank gewesen sein'],
            ['people say', 'er soll reich sein', 'er soll gewonnen haben'],
            ['he claims', 'er will reich sein', 'er will nichts gewusst haben'],
        ]),
        cols(
            table('Clause → phrase', ['clause', 'phrase'], [
                ['weil', 'wegen · aufgrund'], ['obwohl', 'trotz'], ['wenn', 'bei · im Falle'],
                ['indem', 'durch · mithilfe'], ['sodass', 'infolge (the cause)'],
            ]),
            table('Can be done', ['', ''], [
                ['kann gelöst werden', 'ist lösbar'], ['', 'lässt sich lösen'], ['', 'ist zu lösen'],
            ]),
        ),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.', [
            ('die Solaranlage', 'solar panels', 'cpd_solaranlage'), ('das Windrad', 'wind turbine', 'cpd_windrad'),
            ('der Heizkörper', 'radiator', 'cpd_heizkoerper'), ('die Gießkanne', 'watering can', 'cpd_giesskanne'),
            ('der Rauchmelder', 'smoke detector', 'cpd_rauchmelder'), ('das Bügeleisen', 'iron', 'cpd_buegeleisen'),
            ('die Steckdosenleiste', 'power strip', 'cpd_steckdosenleiste'), ('das Einmachglas', 'preserving jar', 'cpd_einmachglas'),
            ('die Waschmaschine', 'washing machine', 'cpd_waschmaschine'), ('die Plastiktüte', 'plastic bag', 'cpd_plastiktuete'),
            ('die Mülltonne', 'wheelie bin', 'cpd_muelltonne'), ('die Batterie', 'battery', 'cpd_batterie'),
            ('das Thermometer', 'thermometer', 'cpd_thermometer'), ('die Glühbirne', 'light bulb', 'cpd_gluehbirne'),
            ('das Fahrrad', 'bicycle', 'cpd_fahrrad'), ('der Wald', 'forest', 'cpd_wald'),
            ('der Eisbär', 'polar bear', 'cpd_eisbaer'), ('die Biene', 'bee', 'cpd_biene'),
            ('der Baum', 'tree', 'cpd_baum'), ('die Wolke', 'cloud', 'cpd_wolke'),
            ('das Mikroskop', 'microscope', 'cpd_mikroskop'), ('das Reagenzglas', 'test tube', 'cpd_reagenzglas'),
            ('der Bunsenbrenner', 'Bunsen burner', 'cpd_bunsenbrenner'), ('der Trichter', 'funnel', 'cpd_trichter'),
            ('die Pinzette', 'tweezers', 'cpd_pinzette'), ('die Lupe', 'magnifying glass', 'cpd_lupe'),
            ('das Teleskop', 'telescope', 'cpd_teleskop'), ('das Fossil', 'fossil', 'cpd_fossil'),
            ('der Feuerlöscher', 'fire extinguisher', 'cpd_feuerloescher'), ('die Schutzbrille', 'safety goggles', 'cpd_schutzbrille'),
            ('der Globus', 'globe', 'cpd_globus'), ('die Waage', 'scales', 'cpd_waage'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

kit.write_book(OUT, book)
