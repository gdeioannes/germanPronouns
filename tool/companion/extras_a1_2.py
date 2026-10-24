# Extra exercises that fill the free space on A1.2's practice and review pages.
# Merged by kit.write_book when tool/companion/a1_2.py runs.
from kit import gaps, write, circle, match  # noqa: F401

MISTAKE = 'One word is wrong in each sentence. Write the sentence correctly.'
TRANSLATE = 'Write it in German.'

EXTRAS = {
    'possessiv': [
        write('Find the mistake', MISTAKE, [
            ('Lena sucht seine Jacke.', 'Lena sucht ihre Jacke.'),
            ('Das ist mein Mutter.', 'Das ist meine Mutter.'),
        ], ncols=2),
    ],
    'modalverben': [
        write('Find the mistake', MISTAKE, [
            ('Du kann gut kochen.', 'Du kannst gut kochen.'),
            ('Tom muss heute arbeitet.', 'Tom muss heute arbeiten.'),
        ], ncols=2),
    ],
    'uhrzeit': [
        write('Say it in German', TRANSLATE, [
            ('What time is it?', 'Wie spät ist es?'),
            ('It’s half past seven.', 'Es ist halb acht.'),
            ('The film starts at quarter past eight.', 'Der Film beginnt um Viertel nach acht.'),
            ('At what time? – At nine, in the evening.', 'Um wie viel Uhr? – Um neun, abends.'),
        ], not_german=True),
    ],
    'datum': [
        write('Find the mistake', MISTAKE, [
            ('Ich komme im Montag.', 'Ich komme am Montag.'),
            ('Der Film beginnt am acht Uhr.', 'Der Film beginnt um acht Uhr.'),
        ], ncols=2),
    ],
    'trennbare': [
        write('Find the mistake', MISTAKE, [
            ('Ich stehe auf um sieben.', 'Ich stehe um sieben auf.'),
            ('Lena einkauft heute.', 'Lena kauft heute ein.'),
        ], ncols=2),
    ],
    'praepositionen': [
        write('Say it in German', TRANSLATE, [
            ('Coffee without sugar, please.', 'Kaffee ohne Zucker, bitte.'),
            ('The cake is for the dog.', 'Der Kuchen ist für den Hund.'),
        ], ncols=2, not_german=True),
    ],
    'wohin': [
        write('Find the mistake', MISTAKE, [
            ('Heute Abend gehe ich im Kino.', 'Heute Abend gehe ich ins Kino.'),
            ('Es ist spät. Ich gehe zu Hause.', 'Es ist spät. Ich gehe nach Hause.'),
            ('Ich bin krank. Ich gehe beim Arzt.', 'Ich bin krank. Ich gehe zum Arzt.'),
            ('Wir fliegen im Juli zu Spanien.', 'Wir fliegen im Juli nach Spanien.'),
        ]),
    ],
    'cafe': [
        write('Say it in German', TRANSLATE, [
            ('I’d like a piece of cake.', 'Ich hätte gern ein Stück Kuchen.'),
            ('A glass of water for the dog, please.', 'Ein Glas Wasser für den Hund, bitte.'),
            ('The bill, please. – Keep the change.', 'Die Rechnung, bitte. – Stimmt so.'),
        ], not_german=True),
    ],
    'einkaufen': [
        write('Say it in German', TRANSLATE, [
            ('a bottle of water', 'eine Flasche Wasser'),
            ('two cups of coffee', 'zwei Tassen Kaffee'),
            ('Is that all? – Yes, that’s all.', 'Ist das alles? – Ja, das ist alles.'),
            ('Ten kilos of chocolate, please.', 'Zehn Kilo Schokolade, bitte.'),
        ], not_german=True),
    ],
    'imperativ': [
        write('Find the mistake', MISTAKE, [
            ('Kommt bitte her, Tom!', 'Komm bitte her, Tom!'),
            ('Herr Braun, nimm bitte Platz!', 'Herr Braun, nehmen Sie bitte Platz!'),
            ('Esst dein Brot, Lena!', 'Iss dein Brot, Lena!'),
        ]),
        write('Make it an order', 'Write the sentence as an order.', [
            ('Du sprichst langsam.', 'Sprich langsam!'),
            ('Ihr seid leise.', 'Seid leise!'),
        ], ncols=2),
    ],
    'war_hatte': [
        write('That was yesterday', 'Start with Gestern and write it in the past.', [
            ('Ich bin müde.', 'Gestern war ich müde.'),
            ('Wir haben keine Zeit.', 'Gestern hatten wir keine Zeit.'),
            ('Rocky hat Hunger.', 'Gestern hatte Rocky Hunger.'),
        ]),
    ],
    'perfekt': [
        write('Find the mistake', MISTAKE, [
            ('Ich habe nach Hamburg gefahren.', 'Ich bin nach Hamburg gefahren.'),
            ('Wir haben Pizza essen.', 'Wir haben Pizza gegessen.'),
            ('Lena hat gelernt Deutsch.', 'Lena hat Deutsch gelernt.'),
        ]),
    ],
    'satzbau': [
        write('Find the mistake', 'The verb is in the wrong place. Write the sentence correctly.', [
            ('Morgen ich fahre nach Berlin.', 'Morgen fahre ich nach Berlin.'),
            ('Ich komme nicht, denn bin ich krank.', 'Ich komme nicht, denn ich bin krank.'),
        ]),
    ],
    'review_1': [
        write('Make it no', 'Write the sentence with kein or nicht.', [
            ('Ich habe einen Regenschirm.', 'Ich habe keinen Regenschirm.'),
            ('Das Fleisch ist teuer.', 'Das Fleisch ist nicht teuer.'),
            ('Rocky hat ein Problem.', 'Rocky hat kein Problem.'),
        ]),
        write('Add the helper', 'Write the sentence again with the helper verb.', [
            ('Wir fahren nach Berlin. (wollen)', 'Wir wollen nach Berlin fahren.'),
            ('Du kochst gut. (können)', 'Du kannst gut kochen.'),
            ('Die Katze schläft nicht hier. (dürfen)', 'Die Katze darf nicht hier schlafen.'),
        ]),
        gaps('You and the helpers', 'Write two true sentences.', [
            ('Ich kann nicht', '.'), ('Am Wochenende möchte ich', '.'),
        ], 'About you.'),
    ],
    'review_2': [
        write('Say it politely', 'Write it the polite way.', [
            ('Ich will einen Kaffee.', 'Ich hätte gern einen Kaffee.'),
            ('Helfen Sie mir!', 'Könnten Sie mir helfen?'),
            ('Ich will bezahlen.', 'Ich würde gern bezahlen.'),
        ]),
        write('Find the mistake', MISTAKE, [
            ('Ich rufe dich morgen auf.', 'Ich rufe dich morgen an.'),
            ('Wir gehen durch der Park.', 'Wir gehen durch den Park.'),
            ('Mein Bauch tun weh.', 'Mein Bauch tut weh.'),
        ]),
        gaps('Last week', 'Write two true sentences.', [
            ('Letzte Woche war ich', '.'), ('Am Sonntag habe ich', 'gemacht.'),
        ], 'About you.'),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        write('Find the mistake', MISTAKE, [
            ('Ich habe ein Bruder.', 'Ich habe einen Bruder.'),
            ('Wir haben keinen Zeit.', 'Wir haben keine Zeit.'),
            ('Tom ist krank. Er muss zu Hause bleibt.', 'Tom ist krank. Er muss zu Hause bleiben.'),
            ('Der Film beginnt im acht.', 'Der Film beginnt um acht.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('I don’t know him.', 'Ich kenne ihn nicht.'),
            ('Can you swim?', 'Kannst du schwimmen?'),
            ('My birthday is in May.', 'Mein Geburtstag ist im Mai.'),
        ], not_german=True),
    ],
    'review_2': [
        write('Find the mistake', MISTAKE, [
            ('Ich habe gestern nach Wien gefahren.', 'Ich bin gestern nach Wien gefahren.'),
            ('Mein Füße tun weh.', 'Meine Füße tun weh.'),
            ('Gestern ich war krank.', 'Gestern war ich krank.'),
            ('Das Geschenk ist für dir.', 'Das Geschenk ist für dich.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('My head hurts.', 'Mein Kopf tut weh.'),
            ('Take the bus, Tom!', 'Nimm den Bus, Tom!'),
            ('Yesterday we were at the cinema.', 'Gestern waren wir im Kino.'),
            ('I’d like a bottle of water.', 'Ich hätte gern eine Flasche Wasser.'),
        ], not_german=True),
        write('It already happened', 'Write it in the past with haben or sein.', [
            ('Ich kaufe ein Buch.', 'Ich habe ein Buch gekauft.'),
            ('Wir gehen ins Kino.', 'Wir sind ins Kino gegangen.'),
        ], ncols=2),
    ],
}
