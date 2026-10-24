# Extra exercises that fill the free space on A2.1's practice and review pages.
# Merged by kit.write_book when tool/companion/a2_1.py runs.
from kit import gaps, write, circle, match  # noqa: F401

MISTAKE = 'One word is wrong in each sentence. Write the sentence correctly.'
TRANSLATE = 'Write it in German.'

EXTRAS = {
    'perfekt_sein': [
        write('Find the mistake', MISTAKE, [
            ('Ich habe nach Köln gefahren.', 'Ich bin nach Köln gefahren.'),
            ('Wir sind Pizza gegessen.', 'Wir haben Pizza gegessen.'),
        ], ncols=2),
    ],
    'war_hatte': [
        write('Say it in German', TRANSLATE, [
            ('As a child I had a dog.', 'Als Kind hatte ich einen Hund.'),
            ('Sorry, I couldn’t come.', 'Ich konnte leider nicht kommen.'),
        ], ncols=2, not_german=True),
    ],
    'dativ_artikel': [
        write('Find the mistake', MISTAKE, [
            ('Ich helfe die Frau.', 'Ich helfe der Frau.'),
            ('Das Auto gehört den Lehrer.', 'Das Auto gehört dem Lehrer.'),
            ('Rocky gibt dem Katze den Knochen.', 'Rocky gibt der Katze den Knochen.'),
        ]),
        write('Ask with wem?', 'Ask about the person.', [
            ('Das Buch gehört dem Lehrer.', 'Wem gehört das Buch?'),
            ('Wir danken der Oma.', 'Wem dankt ihr?'),
        ], ncols=2),
    ],
    'dativ_praep': [
        write('Say it in German', TRANSLATE, [
            ('I take the bus to work.', 'Ich fahre mit dem Bus zur Arbeit.'),
            ('She is at the baker’s.', 'Sie ist beim Bäcker.'),
            ('I have lived with my parents for a year.', 'Ich wohne seit einem Jahr bei meinen Eltern.'),
        ], not_german=True),
    ],
    'pronomen_dativ': [
        write('Find the mistake', MISTAKE, [
            ('Kannst du mich helfen?', 'Kannst du mir helfen?'),
            ('Die Suppe schmeckt er nicht.', 'Die Suppe schmeckt ihm nicht.'),
        ], ncols=2),
    ],
    'dativ_akkusativ': [
        write('Say it shorter', 'Write both nouns as small words.', [
            ('Ich gebe dem Kind den Ball.', 'Ich gebe ihn ihm.'),
            ('Er schenkt der Mutter die Blumen.', 'Er schenkt sie ihr.'),
            ('Wir zeigen den Kindern den Garten.', 'Wir zeigen ihn ihnen.'),
        ]),
        write('Find the mistake', 'One word is in the wrong place. Write the sentence correctly.', [
            ('Ich gebe ihm es.', 'Ich gebe es ihm.'),
            ('Kannst du mir leihen den Stift?', 'Kannst du mir den Stift leihen?'),
        ], ncols=2),
    ],
    'woher_wo_wohin': [
        write('Find the mistake', MISTAKE, [
            ('Heute Abend gehen wir im Kino.', 'Heute Abend gehen wir ins Kino.'),
            ('Sie kommt gerade beim Arzt.', 'Sie kommt gerade vom Arzt.'),
            ('Morgen fahre ich in Berlin.', 'Morgen fahre ich nach Berlin.'),
            ('Ich bin krank und bleibe nach Hause.', 'Ich bin krank und bleibe zu Hause.'),
        ]),
    ],
    'temporal': [
        write('Find the mistake', MISTAKE, [
            ('Ich wohne seit zwei Jahre hier.', 'Ich wohne seit zwei Jahren hier.'),
            ('Vor einer Woche habe ich Urlaub.', 'In einer Woche habe ich Urlaub.'),
        ], ncols=2),
    ],
    'wetter': [
        write('Say it in German', TRANSLATE, [
            ('It’s raining and it’s cold.', 'Es regnet und es ist kalt.'),
            ('It’s minus five degrees in the north.', 'Im Norden sind es minus fünf Grad.'),
            ('Sunglasses in the snow? Yes, the sun is shining!', 'Eine Sonnenbrille im Schnee? Ja, die Sonne scheint!'),
        ], not_german=True),
        write('Find the mistake', MISTAKE, [
            ('Es ist regnet.', 'Es regnet.'),
            ('Heute ist es Sonne.', 'Heute ist es sonnig.'),
        ], ncols=2),
    ],
    'komparativ': [
        write('Find the mistake', MISTAKE, [
            ('Der Zug ist schnell als der Bus.', 'Der Zug ist schneller als der Bus.'),
            ('Tom ist genauso alt als ich.', 'Tom ist genauso alt wie ich.'),
            ('Der Berg ist hoch als das Hotel.', 'Der Berg ist höher als das Hotel.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('I prefer tea.', 'Ich trinke lieber Tee.'),
            ('The days are getting longer.', 'Die Tage werden länger.'),
        ], ncols=2, not_german=True),
    ],
    'welcher_dieser': [
        write('Say it in German', TRANSLATE, [
            ('Which dress do you like?', 'Welches Kleid gefällt dir?'),
            ('I’ll take this coat.', 'Ich nehme diesen Mantel.'),
            ('I go to the cinema with my boss.', 'Ich gehe mit meinem Chef ins Kino.'),
        ], not_german=True),
        write('Find the mistake', MISTAKE, [
            ('Welcher Hose nimmst du?', 'Welche Hose nimmst du?'),
            ('Ich fahre mit meiner Bruder.', 'Ich fahre mit meinem Bruder.'),
        ], ncols=2),
    ],
    'indefinit': [
        write('Find the mistake', MISTAKE, [
            ('Alles sind da.', 'Alle sind da.'),
            ('Hier darf jemand nicht rauchen.', 'Hier darf man nicht rauchen.'),
            ('Ich habe alle verstanden.', 'Ich habe alles verstanden.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('Don’t worry, everything is fine.', 'Keine Sorge, alles ist in Ordnung.'),
            ('Someone has my glasses!', 'Jemand hat meine Brille!'),
        ], ncols=2, not_german=True),
    ],
    'wochenende': [
        write('Find the mistake', MISTAKE, [
            ('Ich bleibe zu Hause, weil ich bin krank.', 'Ich bleibe zu Hause, weil ich krank bin.'),
            ('Zuerst wir sind ins Museum gegangen.', 'Zuerst sind wir ins Museum gegangen.'),
            ('Lieber Anna, wie geht’s?', 'Liebe Anna, wie geht’s?'),
            ('Am letzten Tag haben wir ans Meer gefahren.', 'Am letzten Tag sind wir ans Meer gefahren.'),
        ]),
    ],
    'review_1': [
        write('Say it with small words', 'Write the person as mir, dir, ihm, ihr, uns or ihnen.', [
            ('Das Auto gehört dem Lehrer.', 'Das Auto gehört ihm.'),
            ('Ich helfe der Frau.', 'Ich helfe ihr.'),
            ('Wir danken den Kindern.', 'Wir danken ihnen.'),
            ('Die Jacke passt meinem Bruder.', 'Die Jacke passt ihm.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('As a child I wanted to be a doctor.', 'Als Kind wollte ich Arzt (Ärztin) werden.'),
            ('I go by train.', 'Ich fahre mit der Bahn.'),
            ('Lena moved to Cologne last year.', 'Lena ist letztes Jahr nach Köln umgezogen.'),
            ('We thanked the neighbours.', 'Wir haben den Nachbarn gedankt.'),
        ], not_german=True),
        gaps('Back then', 'Write three true sentences.', [
            ('Gestern bin ich', '.'), ('Als Kind konnte ich', '.'),
            ('Zum Geburtstag schenke ich meiner Mutter', '.'),
        ], 'About you.'),
    ],
    'review_2': [
        write('Say the opposite', 'Write the sentence so it means the opposite.', [
            ('Ich habe alles gegessen.', 'Ich habe nichts gegessen.'),
            ('Jemand hat geklingelt.', 'Niemand hat geklingelt.'),
            ('Es wird wärmer.', 'Es wird kälter.'),
        ]),
        write('Find the mistake', MISTAKE, [
            ('Wo fährst du? – Nach Wien.', 'Wohin fährst du? – Nach Wien.'),
            ('Ich fahre seit eine Woche nach Wien.', 'Ich fahre für eine Woche nach Wien.'),
            ('Mit welche Bus fährst du?', 'Mit welchem Bus fährst du?'),
        ]),
        gaps('You, compared', 'Write two true sentences.', [
            ('Ich bin älter als', '.'), ('Ich lerne Deutsch, weil', '.'),
        ], 'About you.'),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        write('Find the mistake', MISTAKE, [
            ('Ich bin einen Kuchen gekauft.', 'Ich habe einen Kuchen gekauft.'),
            ('Wir haben nach Rom geflogen.', 'Wir sind nach Rom geflogen.'),
            ('Ich helfe dem Frau.', 'Ich helfe der Frau.'),
            ('Gestern ich musste lange arbeiten.', 'Gestern musste ich lange arbeiten.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('I got up at six.', 'Ich bin um sechs aufgestanden.'),
            ('Did you phone Grandma?', 'Hast du Oma angerufen?'),
            ('I like the soup.', 'Die Suppe schmeckt mir.'),
        ], not_german=True),
        write('Into the past', 'Write it in the Perfekt.', [
            ('Ich schreibe einen Brief.', 'Ich habe einen Brief geschrieben.'),
            ('Er kommt nach Hause.', 'Er ist nach Hause gekommen.'),
        ], ncols=2),
    ],
    'review_2': [
        write('Find the mistake', MISTAKE, [
            ('Sie kommt gerade aus dem Arzt.', 'Sie kommt gerade vom Arzt.'),
            ('Ich lerne vor einem Jahr Deutsch.', 'Ich lerne seit einem Jahr Deutsch.'),
            ('Rocky ist groß als die Katze.', 'Rocky ist größer als die Katze.'),
            ('Welchen Kleid nimmst du?', 'Welches Kleid nimmst du?'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('It’s snowing in the south.', 'Im Süden schneit es.'),
            ('Two days ago I was in Vienna.', 'Vor zwei Tagen war ich in Wien.'),
            ('Nobody is at home.', 'Niemand ist zu Hause.'),
            ('The train is faster than the bus.', 'Der Zug ist schneller als der Bus.'),
        ], not_german=True),
        write('Join them with weil', 'Make one sentence. The verb goes to the end.', [
            ('Ich bin glücklich. Es schneit.', 'Ich bin glücklich, weil es schneit.'),
            ('Wir bleiben hier. Es regnet.', 'Wir bleiben hier, weil es regnet.'),
            ('Tom kommt nicht. Er ist krank.', 'Tom kommt nicht, weil er krank ist.'),
        ]),
    ],
}
