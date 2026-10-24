# Extra exercises for the B1.1 study companion: they fill the free paper on each practice page
# and review page. Merged by kit.write_book (rerun: python -I tool/companion/b1_1.py).
from kit import circle, gaps, write

FIX = 'Each sentence has one mistake. Write it correctly.'


def fix(items, title='Find the mistake'):
    return write(title, FIX, items, 1)


def en(items, title='Say it in German'):
    return write(title, 'Write it in German.', items, 1, not_german=True)


EXTRAS = {
    'arbeit': [
        en([
            ('I’m looking for a new job.', 'Ich suche eine neue Stelle.'),
            ('I work part-time, twenty hours a week.', 'Ich arbeite Teilzeit, zwanzig Stunden pro Woche.'),
            ('The meeting is at ten o’clock.', 'Die Besprechung ist um zehn Uhr.'),
            ('I’m sending my application to the company.', 'Ich schicke meine Bewerbung an die Firma.'),
            ('It’s five o’clock: have a nice evening!', 'Es ist fünf Uhr: Schönen Feierabend!'),
        ]),
    ],
    'adj_bestimmt': [
        fix([
            ('Ich sehe den große Mann.', 'Ich sehe den großen Mann.'),
            ('Der großen Mann liest.', 'Der große Mann liest.'),
            ('Ich mag die neue Schuhe.', 'Ich mag die neuen Schuhe.'),
            ('Ich helfe dem kleine Kind.', 'Ich helfe dem kleinen Kind.'),
            ('Das neuen Auto ist teuer.', 'Das neue Auto ist teuer.'),
        ]),
        en([
            ('The old table is in the kitchen.', 'Der alte Tisch steht in der Küche.'),
            ('I like the yellow flowers.', 'Ich mag die gelben Blumen.'),
            ('Which new car? This one!', 'Welches neue Auto? Dieses!'),
        ]),
    ],
    'adj_unbestimmt': [
        fix([
            ('Das ist ein große Mann.', 'Das ist ein großer Mann.'),
            ('Wir haben ein neue Haus.', 'Wir haben ein neues Haus.'),
        ]),
        en([
            ('My big brother lives in Bern.', 'Mein großer Bruder wohnt in Bern.'),
            ('That’s a good idea!', 'Das ist eine gute Idee!'),
        ]),
    ],
    'adj_nullartikel': [
        fix([
            ('Frische Brot schmeckt am besten.', 'Frisches Brot schmeckt am besten.'),
            ('Bei schönes Wetter sitzen wir im Garten.', 'Bei schönem Wetter sitzen wir im Garten.'),
            ('Schöne Wohnung mit großer Balkon zu vermieten.', 'Schöne Wohnung mit großem Balkon zu vermieten.'),
            ('Ich treffe mich mit guten Freunde.', 'Ich treffe mich mit guten Freunden.'),
            ('Ich habe drei kleinen Kinder.', 'Ich habe drei kleine Kinder.'),
        ]),
        en([
            ('Fresh bread and strong coffee, please.', 'Frisches Brot und starken Kaffee, bitte.'),
            ('Bright room with balcony to let.', 'Helles Zimmer mit Balkon zu vermieten.'),
            ('In the course I got to know nice people.', 'Im Kurs habe ich nette Leute kennengelernt.'),
            ('With good friends everything tastes better.', 'Mit guten Freunden schmeckt alles besser.'),
            ('My cat drinks cold water.', 'Meine Katze trinkt kaltes Wasser.'),
        ]),
    ],
    'adj_komparativ': [
        fix([
            ('Wir nehmen den schneller Zug.', 'Wir nehmen den schnelleren Zug.'),
            ('Das ist der beste Idee.', 'Das ist die beste Idee.'),
            ('Ich suche eine größer Wohnung.', 'Ich suche eine größere Wohnung.'),
            ('Die meiste Leute arbeiten im Büro.', 'Die meisten Leute arbeiten im Büro.'),
        ]),
        en([
            ('We need a bigger flat.', 'Wir brauchen eine größere Wohnung.'),
            ('That’s the cheapest offer.', 'Das ist das günstigste Angebot.'),
            ('The next train is faster.', 'Der nächste Zug ist schneller.'),
        ]),
        gaps('Your best', 'Finish the sentences.', [
            ('Die beste Idee in diesem Jahr war', '.'), ('Ich wünsche mir eine größere', '.'),
        ], 'About you.'),
    ],
    'adj_nomen': [
        fix([
            ('Mein Bruder ist Angestellte bei einer Bank.', 'Mein Bruder ist Angestellter bei einer Bank.'),
            ('Alle Angestellter bekommen dreißig Tage Urlaub.', 'Alle Angestellten bekommen dreißig Tage Urlaub.'),
            ('Gibt es etwas Neue?', 'Gibt es etwas Neues?'),
            ('Sie ist mit einem Deutscher verheiratet.', 'Sie ist mit einem Deutschen verheiratet.'),
        ]),
        en([
            ('All the best!', 'Alles Gute!'),
            ('Nothing special.', 'Nichts Besonderes.'),
            ('Adults pay ten euros, the dog pays nothing.', 'Erwachsene zahlen zehn Euro, der Hund zahlt nichts.'),
        ]),
        gaps('What matters', 'Finish the sentences.', [
            ('Das Wichtigste für mich ist', '.'), ('Zu meiner Party kommen alle', '.'),
        ], 'About you.'),
    ],
    'konj2_wuerde': [
        fix([
            ('Würdest Sie mir bitte das Salz reichen?', 'Würden Sie mir bitte das Salz reichen?'),
            ('An deiner Stelle ich würde das nicht machen.', 'An deiner Stelle würde ich das nicht machen.'),
            ('Wir würde gern ein Haus kaufen.', 'Wir würden gern ein Haus kaufen.'),
        ]),
        en([
            ('I’d like to climb more often.', 'Ich würde gern öfter klettern.'),
            ('Would you come along? (du)', 'Würdest du mitkommen?'),
            ('If I were you, I wouldn’t accept the job.', 'An deiner Stelle würde ich den Job nicht annehmen.'),
        ]),
    ],
    'konj2_haette': [
        fix([
            ('Wenn ich Zeit hätte, ich würde kommen.', 'Wenn ich Zeit hätte, würde ich kommen.'),
            ('Wenn er reich ist, könnte er reisen.', 'Wenn er reich wäre, könnte er reisen.'),
            ('Wenn ich mehr Zeit hatte, würde ich kommen.', 'Wenn ich mehr Zeit hätte, würde ich kommen.'),
            ('Könnte du mir kurz helfen?', 'Könntest du mir kurz helfen?'),
        ]),
        en([
            ('If I were rich, I would buy a castle.', 'Wenn ich reich wäre, würde ich ein Schloss kaufen.'),
            ('If only I had more time!', 'Wenn ich nur mehr Zeit hätte!'),
            ('That would be really nice.', 'Das wäre wirklich schön.'),
            ('My battery is flat. Could I use your phone? (Sie)', 'Mein Akku ist leer. Dürfte/Könnte ich Ihr Telefon benutzen?'),
        ]),
    ],
    'review_1': [
        circle('Which one?', 'Circle the right word.', [
            ('Der', ['neue', 'neuen'], 'Kollege ist nett.', 'neue'),
            ('Ich sehe den', ['große', 'großen'], 'Mann.', 'großen'),
            ('Das ist ein', ['neues', 'neue'], 'Haus.', 'neues'),
            ('Ich trinke', ['kaltes', 'kalte'], 'Wasser.', 'kaltes'),
            ('Wir suchen eine', ['größere', 'größer'], 'Wohnung.', 'größere'),
            ('Er ist', ['Angestellter', 'Angestellte'], 'bei einer Bank.', 'Angestellter'),
            ('Wenn ich Zeit', ['hätte', 'habe'], ', würde ich kommen.', 'hätte'),
            ('', ['Würden', 'Wären'], 'Sie mir helfen?', 'Würden'),
            ('Das', ['wäre', 'würde'], 'schön!', 'wäre'),
            ('Ich', ['würde', 'wäre'], 'gern reisen.', 'würde'),
        ], 2),
        write('Describe it', 'Write the sentence with the describing word.', [
            ('Ich trinke Kaffee. (schwarz)', 'Ich trinke schwarzen Kaffee.'),
            ('Das ist ein Kleid. (schön)', 'Das ist ein schönes Kleid.'),
            ('Wir wohnen in einer Wohnung. (groß + er)', 'Wir wohnen in einer größeren Wohnung.'),
            ('Ich helfe dem Kind. (klein)', 'Ich helfe dem kleinen Kind.'),
            ('Er hat einen Hund. (stark)', 'Er hat einen starken Hund.'),
        ], 1),
        gaps('About you', 'Write true sentences.', [
            ('Am Wochenende würde ich gern', '.'), ('Wenn ich reich wäre,', '.'),
            ('Wenn ich mehr Zeit hätte, könnte ich', '.'),
        ], 'About you.'),
    ],
    'futur': [
        fix([
            ('Morgen werdet es regnen.', 'Morgen wird es regnen.'),
            ('Ich werde vergessen dich nie.', 'Ich werde dich nie vergessen.'),
            ('Wirst du zur Party kommst?', 'Wirst du zur Party kommen?'),
        ]),
        en([
            ('It will rain tomorrow.', 'Morgen wird es regnen.'),
            ('He’s probably at the office.', 'Er wird wohl im Büro sein.'),
            ('Next year we will move house.', 'Nächstes Jahr werden wir umziehen.'),
        ]),
    ],
    'relativ': [
        fix([
            ('Das ist der Kollege, mit den ich arbeite.', 'Das ist der Kollege, mit dem ich arbeite.'),
            ('Die Freunde, mit dem ich reise, wohnen in Bonn.', 'Die Freunde, mit denen ich reise, wohnen in Bonn.'),
            ('Das ist der Mann, dem ich gut kenne.', 'Das ist der Mann, den ich gut kenne.'),
            ('Das ist das Thema, wir sprechen über das.', 'Das ist das Thema, über das wir sprechen.'),
        ]),
        en([
            ('That’s the colleague I work with.', 'Das ist der Kollege, mit dem ich arbeite.'),
            ('The friends I trust live in Bonn.', 'Die Freunde, denen ich vertraue, wohnen in Bonn.'),
            ('That’s the café where we met.', 'Das ist das Café, wo wir uns kennengelernt haben.'),
            ('That’s the dog I’m waiting for.', 'Das ist der Hund, auf den ich warte.'),
        ]),
    ],
    'genitiv': [
        fix([
            ('Das ist das Auto meines Vater.', 'Das ist das Auto meines Vaters.'),
            ('Die Farbe des Haus gefällt mir.', 'Die Farbe des Hauses gefällt mir.'),
            ('Das ist die Tasche des Lehrerin.', 'Das ist die Tasche der Lehrerin.'),
            ('Während der Konzert war es laut.', 'Während des Konzerts war es laut.'),
            ('Trotz des Regen gehen wir spazieren.', 'Trotz des Regens gehen wir spazieren.'),
        ]),
        write('Say it another way', 'Write it with the genitive instead of von.', [
            ('das Auto von meinem Bruder', 'das Auto meines Bruders'),
            ('die Farbe von dem Haus', 'die Farbe des Hauses'),
            ('das Ende von dem Film', 'das Ende des Films'),
            ('die Eltern von den Kindern', 'die Eltern der Kinder'),
            ('der Titel von dem Buch', 'der Titel des Buches'),
        ], 1),
    ],
    'konjunktionen': [
        fix([
            ('Wenn ich ein Kind war, wohnten wir in Köln.', 'Als ich ein Kind war, wohnten wir in Köln.'),
            ('Als ich Zeit habe, lese ich.', 'Wenn ich Zeit habe, lese ich.'),
            ('Obwohl es kalt ist, wir gehen spazieren.', 'Obwohl es kalt ist, gehen wir spazieren.'),
            ('Es ist kalt. Trotzdem wir gehen spazieren.', 'Es ist kalt. Trotzdem gehen wir spazieren.'),
        ]),
        en([
            ('When I turned eighteen, I got my driving licence.', 'Als ich achtzehn wurde, machte ich den Führerschein.'),
            ('Whenever we were at Grandma’s, there was cake.', 'Immer wenn wir bei Oma waren, gab es Kuchen.'),
            ('Although he is tired, he works on.', 'Obwohl er müde ist, arbeitet er weiter.'),
            ('When the film began, the dog came.', 'Als der Film begann, kam der Hund.'),
        ]),
    ],
    'falls_da': [
        fix([
            ('Nimm einen Schirm mit, falls es regnet später.', 'Nimm einen Schirm mit, falls es später regnet.'),
            ('Da ich habe kein Auto, fahre ich Rad.', 'Da ich kein Auto habe, fahre ich Rad.'),
            ('Der Film war langweilig. Trotzdem wir sind geblieben.', 'Der Film war langweilig. Trotzdem sind wir geblieben.'),
            ('Ich bin müde, deshalb ich gehe ins Bett.', 'Ich bin müde, deshalb gehe ich ins Bett.'),
            ('Falls Sie haben noch Fragen, schreiben Sie mir.', 'Falls Sie noch Fragen haben, schreiben Sie mir.'),
        ]),
        write('Say it another way', 'Write it again with the word in brackets.', [
            ('Ich bin müde, deshalb gehe ich ins Bett. (weil)', 'Ich gehe ins Bett, weil ich müde bin.'),
            ('Obwohl es regnet, gehen wir spazieren. (trotzdem)', 'Es regnet. Trotzdem gehen wir spazieren.'),
            ('Der Zug hat Verspätung, deshalb komme ich später. (da)', 'Da der Zug Verspätung hat, komme ich später.'),
            ('Es kann regnen. Nimm einen Schirm mit! (falls)', 'Nimm einen Schirm mit, falls es regnet.'),
            ('Der Film ist langweilig. Trotzdem bleiben wir. (obwohl)', 'Obwohl der Film langweilig ist, bleiben wir.'),
        ], 1),
    ],
    'infinitiv_zu': [
        fix([
            ('Ich will zu schlafen.', 'Ich will schlafen.'),
            ('Ich versuche, früh zu aufstehen.', 'Ich versuche, früh aufzustehen.'),
            ('Hast du Lust, ins Kino gehen?', 'Hast du Lust, ins Kino zu gehen?'),
            ('Ich habe vergessen, zu anrufen.', 'Ich habe vergessen anzurufen.'),
        ]),
        en([
            ('I plan to learn German.', 'Ich habe vor, Deutsch zu lernen.'),
            ('It’s important to practise every day.', 'Es ist wichtig, jeden Tag zu üben.'),
            ('I’m learning German in order to work here.', 'Ich lerne Deutsch, um hier zu arbeiten.'),
        ]),
    ],
    'es': [
        fix([
            ('Ich bin kalt.', 'Mir ist kalt.'),
            ('Es geben viele Cafés.', 'Es gibt viele Cafés.'),
            ('Es tut mich leid.', 'Es tut mir leid.'),
            ('In der Stadt gibt es ein Park.', 'In der Stadt gibt es einen Park.'),
        ]),
        en([
            ('Is it worth it? – It depends.', 'Lohnt es sich? – Es kommt darauf an.'),
            ('It doesn’t matter.', 'Es macht nichts.'),
            ('It’s a pity that you aren’t coming.', 'Es ist schade, dass du nicht kommst.'),
        ]),
        gaps('Your town', 'Finish the sentences.', [
            ('In meiner Stadt gibt es', '.'), ('Es ist schade, dass', '.'),
        ], 'About you.'),
    ],
    'verben_praep': [
        fix([
            ('Ich warte seit zwanzig Minuten für den Bus.', 'Ich warte seit zwanzig Minuten auf den Bus.'),
            ('Er hat Angst von dem Hund.', 'Er hat Angst vor dem Hund.'),
            ('Hast du dich für die Stelle beworben?', 'Hast du dich um die Stelle beworben?'),
            ('Der Nachbar beschwert sich für den Lärm.', 'Der Nachbar beschwert sich über den Lärm.'),
            ('Ich freue mich für die Ferien.', 'Ich freue mich auf die Ferien.'),
        ]),
        write('A thing or a person?', 'Answer without repeating the noun.', [
            ('Wartest du auf den Bus? – Ja, …', 'Ja, ich warte darauf.'),
            ('Wartest du auf Anna? – Ja, …', 'Ja, ich warte auf sie.'),
            ('Hast du Angst vor dem Hund? – Nein, …', 'Nein, ich habe keine Angst davor.'),
            ('Interessierst du dich für Politik? – Ja, …', 'Ja, ich interessiere mich dafür.'),
            ('Sprecht ihr über den Chef? – Ja, …', 'Ja, wir sprechen über ihn.'),
        ], 1),
    ],
    'email': [
        fix([
            ('Sehr geehrte Damen und Herren, vielen Dank für deine Antwort.',
             'Sehr geehrte Damen und Herren, vielen Dank für Ihre Antwort.'),
            ('Liebe Tom, danke für deine Mail!', 'Lieber Tom, danke für deine Mail!'),
            ('Könnten Sie mir sagen, wann fährt der Zug ab?', 'Könnten Sie mir sagen, wann der Zug abfährt?'),
            ('Könnten Sie mir sagen, ob ist das Museum geöffnet?', 'Könnten Sie mir sagen, ob das Museum geöffnet ist?'),
        ]),
        en([
            ('Thank you in advance.', 'Vielen Dank im Voraus.'),
            ('Could you please send me the documents?', 'Könnten Sie mir bitte die Unterlagen schicken?'),
            ('Would it be possible to come on Monday?', 'Wäre es möglich, am Montag zu kommen?'),
        ]),
        gaps('A mail to a friend', 'Start a mail to a friend.', [
            ('Liebe', ', danke für deine Mail!'), ('Hättest du Lust,', '?'),
        ], 'About you — du all the way through.'),
    ],
    'review_2': [
        circle('Which one?', 'Circle the right word.', [
            ('', ['Als', 'Wenn'], 'wir in Köln waren, regnete es.', 'Als'),
            ('Ich', ['werde', 'wird'], 'dich anrufen.', 'werde'),
            ('Das ist die Frau,', ['der', 'die'], 'ich helfe.', 'der'),
            ('Die Farbe', ['des', 'dem'], 'Hauses gefällt mir.', 'des'),
            ('Es', ['gibt', 'geben'], 'viele Cafés.', 'gibt'),
            ('Ich versuche,', ['zu schlafen', 'schlafen'], '.', 'zu schlafen'),
            ('', ['Falls', 'Trotzdem'], 'du Zeit hast, ruf mich an!', 'Falls'),
            ('Er hat Angst', ['vor', 'von'], 'dem Hund.', 'vor'),
        ], 2),
        write('Short answers', 'Answer without repeating the noun.', [
            ('Denkst du an den Termin? – Ja, …', 'Ja, ich denke daran.'),
            ('Freust du dich auf die Ferien? – Ja, …', 'Ja, ich freue mich darauf.'),
            ('Hast du Angst vor dem Chef? – Nein, …', 'Nein, ich habe keine Angst vor ihm.'),
            ('Sprichst du über das Thema? – Ja, …', 'Ja, ich spreche darüber.'),
        ], 1),
        gaps('About you', 'Write true sentences.', [
            ('Nächstes Jahr werde ich', '.'), ('Als ich ein Kind war,', '.'),
        ], 'About you.'),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        fix([
            ('Der Kollege hat einen neue Job.', 'Der Kollege hat einen neuen Job.'),
            ('Wir trinken starker Kaffee.', 'Wir trinken starken Kaffee.'),
            ('Das ist ein schwierig Problem.', 'Das ist ein schwieriges Problem.'),
            ('Gibt es nichts Neue?', 'Gibt es nichts Neues?'),
            ('Wenn ich Zeit hätte, ich würde mitkommen.', 'Wenn ich Zeit hätte, würde ich mitkommen.'),
        ]),
        en([
            ('I’m looking for a bigger flat.', 'Ich suche eine größere Wohnung.'),
            ('The new colleague is nice.', 'Der neue Kollege ist nett.'),
            ('Would you pass me the salt, please? (Sie)', 'Würden Sie mir bitte das Salz reichen?'),
            ('If I were rich, I would work part-time.', 'Wenn ich reich wäre, würde ich Teilzeit arbeiten.'),
            ('All the best for the new job!', 'Alles Gute für die neue Stelle!'),
        ]),
        write('Say it another way', 'Write it again with the words in brackets.', [
            ('Ich habe keine Zeit. Ich komme nicht. (Wenn … hätte …)', 'Wenn ich Zeit hätte, würde ich kommen.'),
            ('Kannst du mir helfen? (Könntest …)', 'Könntest du mir helfen?'),
            ('Mach das nicht! (An deiner Stelle …)', 'An deiner Stelle würde ich das nicht machen.'),
            ('Ich möchte mehr reisen. (würde)', 'Ich würde gern mehr reisen.'),
        ], 1),
    ],
    'review_2': [
        fix([
            ('Morgen wirst es regnen.', 'Morgen wird es regnen.'),
            ('Die Leute, mit dem ich arbeite, sind nett.', 'Die Leute, mit denen ich arbeite, sind nett.'),
            ('Wegen des Wetter bleiben wir zu Hause.', 'Wegen des Wetters bleiben wir zu Hause.'),
            ('Wenn ich achtzehn wurde, machte ich den Führerschein.', 'Als ich achtzehn wurde, machte ich den Führerschein.'),
            ('Ich habe vor, Deutsch lernen.', 'Ich habe vor, Deutsch zu lernen.'),
        ]),
        en([
            ('I will never forget you.', 'Ich werde dich nie vergessen.'),
            ('Take an umbrella, in case it rains. (du)', 'Nimm einen Schirm mit, falls es regnet.'),
            ('It’s worth it.', 'Es lohnt sich.'),
            ('Who are you waiting for? – For my sister.', 'Auf wen wartest du? – Auf meine Schwester.'),
        ]),
        write('Say it another way', 'Write it again with the words in brackets.', [
            ('Obwohl es kalt ist, gehen wir spazieren. (trotzdem)', 'Es ist kalt. Trotzdem gehen wir spazieren.'),
            ('das Auto von meinem Vater (meines …)', 'das Auto meines Vaters'),
            ('Wann fährt der Zug ab? (Könnten Sie mir sagen …)', 'Könnten Sie mir sagen, wann der Zug abfährt?'),
        ], 1),
    ],
}
