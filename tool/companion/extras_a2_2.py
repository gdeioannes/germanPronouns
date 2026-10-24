# Extra exercises for the A2.2 study companion: they fill the free paper on each practice page
# and review page. Merged by kit.write_book (rerun: python -I tool/companion/a2_2.py).
from kit import circle, gaps, write

FIX = 'Each sentence has one mistake. Write it correctly.'


def fix(items, title='Find the mistake'):
    return write(title, FIX, items, 1)


def en(items, title='Say it in German'):
    return write(title, 'Write it in German.', items, 1, not_german=True)


EXTRAS = {
    'wechsel_wo': [
        fix([
            ('Das Buch liegt auf den Tisch.', 'Das Buch liegt auf dem Tisch.'),
            ('Die Katze schläft unter das Bett.', 'Die Katze schläft unter dem Bett.'),
            ('Das Bild hängt an dem Wand.', 'Das Bild hängt an der Wand.'),
            ('Die Schuhe stehen neben die Tür.', 'Die Schuhe stehen neben der Tür.'),
            ('Der Hund sitzt auf das Sofa und liest.', 'Der Hund sitzt auf dem Sofa und liest.'),
        ]),
    ],
    'wechsel_wohin': [
        en([
            ('I put the plate on the table.', 'Ich stelle den Teller auf den Tisch.'),
            ('The cat jumps onto the sofa.', 'Die Katze springt aufs Sofa.'),
            ('I hang my jacket in the cupboard.', 'Ich hänge meine Jacke in den Schrank.'),
            ('The dog lies under the table — with my shoes.', 'Der Hund liegt unter dem Tisch – mit meinen Schuhen.'),
            ('Sit down next to me! (du)', 'Setz dich neben mich!'),
        ]),
    ],
    'reflexiv': [
        fix([
            ('Ich freue dich auf das Wochenende.', 'Ich freue mich auf das Wochenende.'),
            ('Er interessiert ihn für Musik.', 'Er interessiert sich für Musik.'),
            ('Wir treffen sich um acht Uhr.', 'Wir treffen uns um acht Uhr.'),
            ('Du musst mich beeilen!', 'Du musst dich beeilen!'),
            ('Ihr müsst uns beeilen!', 'Ihr müsst euch beeilen!'),
        ]),
    ],
    'weil_dass': [
        fix([
            ('Ich bleibe zu Hause, weil ich bin krank.', 'Ich bleibe zu Hause, weil ich krank bin.'),
            ('Ich glaube, dass er hat recht.', 'Ich glaube, dass er recht hat.'),
            ('Ich weiß, das du kommst.', 'Ich weiß, dass du kommst.'),
        ]),
        en([
            ('I hope that the weather is nice.', 'Ich hoffe, dass das Wetter schön ist.'),
            ('He is tired because he slept badly.', 'Er ist müde, weil er schlecht geschlafen hat.'),
            ('I think that the dog has my umbrella.', 'Ich glaube, dass der Hund meinen Regenschirm hat.'),
        ]),
    ],
    'wenn_deshalb': [
        fix([
            ('Wenn ich habe Zeit, komme ich.', 'Wenn ich Zeit habe, komme ich.'),
            ('Wenn es regnet, wir bleiben zu Hause.', 'Wenn es regnet, bleiben wir zu Hause.'),
            ('Es regnet, deshalb ich bleibe drinnen.', 'Es regnet, deshalb bleibe ich drinnen.'),
        ]),
        en([
            ('If the cat is hungry, she calls me.', 'Wenn die Katze Hunger hat, ruft sie mich an.'),
            ('When it rains, we cook inside.', 'Wenn es regnet, kochen wir drinnen.'),
            ('The bus is too late, so I take a taxi.', 'Der Bus kommt zu spät, deshalb nehme ich ein Taxi.'),
        ]),
    ],
    'indirekt': [
        fix([
            ('Können Sie mir sagen, wo ist der Bahnhof?', 'Können Sie mir sagen, wo der Bahnhof ist?'),
            ('Wissen Sie, wenn das Geschäft offen ist?', 'Wissen Sie, ob das Geschäft offen ist?'),
            ('Ich weiß nicht, wann kommt der Zug.', 'Ich weiß nicht, wann der Zug kommt.'),
        ]),
        en([
            ('Do you know whether the shop is open? (Sie)', 'Wissen Sie, ob das Geschäft offen ist?'),
            ('Can you tell me what that means?', 'Können Sie mir sagen, was das bedeutet?'),
            ('I wonder where my cat is.', 'Ich frage mich, wo meine Katze ist.'),
        ]),
        gaps('What you wonder', 'Finish the sentences.', [
            ('Ich weiß nicht, ob', '.'), ('Ich frage mich, warum', '.'),
        ], 'About you — the verb goes last.'),
    ],
    'verben_praep': [
        fix([
            ('Ich warte für den Bus.', 'Ich warte auf den Bus.'),
            ('Sie interessiert sich auf Musik.', 'Sie interessiert sich für Musik.'),
            ('Ich denke oft von meinen Großeltern.', 'Ich denke oft an meine Großeltern.'),
            ('Er träumt an einem Haus am Meer.', 'Er träumt von einem Haus am Meer.'),
            ('Der Tourist fragt von dem Weg.', 'Der Tourist fragt nach dem Weg.'),
        ]),
    ],
    'review_1': [
        circle('Wo? or Wohin?', 'Circle the right word.', [
            ('Die Vase steht auf', ['dem', 'das'], 'Regal.', 'dem'),
            ('Ich', ['lege', 'liege'], 'das Handy aufs Sofa.', 'lege'),
            ('Die Jacke hängt', ['im', 'in den'], 'Schrank.', 'im'),
            ('Rocky springt', ['ins', 'im'], 'Bett.', 'ins'),
            ('Das Kind', ['sitzt', 'setzt'], 'auf dem Stuhl.', 'sitzt'),
            ('Ich', ['stelle', 'stehe'], 'den Teller auf den Tisch.', 'stelle'),
        ], 2),
        write('Short answers', 'Answer with darauf, dafür or daran.', [
            ('Wartest du auf den Bus? – Ja, …', 'Ja, ich warte darauf.'),
            ('Interessierst du dich für Fußball? – Ja, …', 'Ja, ich interessiere mich dafür.'),
            ('Denkst du an den Urlaub? – Ja, …', 'Ja, ich denke daran.'),
            ('Freust du dich auf die Party? – Ja, …', 'Ja, ich freue mich darauf.'),
        ], 1),
        gaps('Your week', 'Write true sentences.', [
            ('Am Wochenende freue ich mich auf', '.'), ('Ich lerne Deutsch, weil', '.'),
            ('Wenn ich müde bin,', '.'),
        ], 'About you.'),
    ],
    'gesundheit': [
        fix([
            ('Ich bin schlecht, ich muss ins Bett.', 'Mir ist schlecht, ich muss ins Bett.'),
            ('Mein Hals tun weh.', 'Mein Hals tut weh.'),
            ('Meine Füße tut weh.', 'Meine Füße tun weh.'),
            ('Ich bin seit gestern Fieber.', 'Ich habe seit gestern Fieber.'),
        ]),
        en([
            ('My head hurts.', 'Mein Kopf tut weh. / Ich habe Kopfschmerzen.'),
            ('I’ve had a cough for two days.', 'Ich habe seit zwei Tagen Husten.'),
            ('Take the tablets three times a day. (Sie)', 'Nehmen Sie die Tabletten dreimal am Tag.'),
        ]),
    ],
    'kleidung': [
        fix([
            ('Ich brauche einen neuer Mantel.', 'Ich brauche einen neuen Mantel.'),
            ('Das ist ein neue Kleid.', 'Das ist ein neues Kleid.'),
            ('Der neue Pullover passt ich nicht.', 'Der neue Pullover passt mir nicht.'),
            ('Die Jacke steht dich gut!', 'Die Jacke steht dir gut!'),
        ]),
        en([
            ('The blue coat is too big.', 'Der blaue Mantel ist zu groß.'),
            ('Do you have it one size smaller? (der Mantel)', 'Haben Sie ihn eine Nummer kleiner?'),
        ]),
    ],
    'ratschlaege': [
        fix([
            ('Wir konnten morgen ins Kino gehen.', 'Wir könnten morgen ins Kino gehen.'),
            ('Du solltest zum Arzt gehst.', 'Du solltest zum Arzt gehen.'),
            ('Sprechen bitte langsamer, Rocky!', 'Sprich bitte langsamer, Rocky!'),
            ('Nimmst den Bus, er kommt gleich!', 'Nimm den Bus, er kommt gleich!'),
        ]),
        en([
            ('We could go to the cinema.', 'Wir könnten ins Kino gehen.'),
            ('You should sleep more. (du)', 'Du solltest mehr schlafen.'),
            ('Why don’t you come along! (du)', 'Komm doch mal mit!'),
        ]),
    ],
    'relativ': [
        fix([
            ('Das ist der Mann, der ich kenne.', 'Das ist der Mann, den ich kenne.'),
            ('Das ist die Frau, die arbeitet hier.', 'Das ist die Frau, die hier arbeitet.'),
            ('Das ist das Buch, den ich lese.', 'Das ist das Buch, das ich lese.'),
            ('Das sind die Kinder, der im Park spielen.', 'Das sind die Kinder, die im Park spielen.'),
            ('Das ist der Hund, den Rocky heißt.', 'Das ist der Hund, der Rocky heißt.'),
        ]),
        en([
            ('That is the man who lives there.', 'Das ist der Mann, der dort wohnt.'),
            ('This is the bag that I bought.', 'Das ist die Tasche, die ich gekauft habe.'),
            ('That’s the teacher who helps us.', 'Das ist der Lehrer, der uns hilft.'),
            ('That’s the cat that sits on my phone.', 'Das ist die Katze, die auf meinem Handy sitzt.'),
        ]),
    ],
    'praeteritum': [
        write('Tell it like a story', 'Write it in the past of stories.', [
            ('Er hat einen Schlüssel gefunden.', 'Er fand einen Schlüssel.'),
            ('Wir sind in den Wald gegangen.', 'Wir gingen in den Wald.'),
            ('Der König hat den Kuchen gegessen.', 'Der König aß den Kuchen.'),
        ], 1),
        en([
            ('Suddenly he saw a castle.', 'Plötzlich sah er ein Schloss.'),
            ('Back then we lived in a village.', 'Damals wohnten wir in einem Dorf.'),
        ]),
    ],
    'passiv': [
        fix([
            ('Das Auto werden repariert.', 'Das Auto wird repariert.'),
            ('Die Briefe wird heute geschickt.', 'Die Briefe werden heute geschickt.'),
            ('Hier wird Deutsch sprechen.', 'Hier wird Deutsch gesprochen.'),
            ('Das Zimmer wird jeden Tag putzen.', 'Das Zimmer wird jeden Tag geputzt.'),
        ]),
        write('Say it another way', 'Write it with wird or werden.', [
            ('Man verkauft hier Tickets.', 'Hier werden Tickets verkauft.'),
            ('Man baut das Haus im Sommer.', 'Das Haus wird im Sommer gebaut.'),
            ('Man repariert das Fahrrad in der Werkstatt.', 'Das Fahrrad wird in der Werkstatt repariert.'),
        ], 1),
    ],
    'superlativ': [
        fix([
            ('Anna läuft am schneller.', 'Anna läuft am schnellsten.'),
            ('Dieses Eis schmeckt am besser.', 'Dieses Eis schmeckt am besten.'),
            ('Berlin ist die größten Stadt.', 'Berlin ist die größte Stadt.'),
            ('Mein Opa ist am älter.', 'Mein Opa ist am ältesten.'),
            ('Rocky isst am mehr von allen.', 'Rocky isst am meisten von allen.'),
            ('Das ist der beste Eis.', 'Das ist das beste Eis.'),
        ]),
    ],
    'wortbildung': [
        fix([
            ('Der Wohnung hat drei Zimmer.', 'Die Wohnung hat drei Zimmer.'),
            ('Das Lehrer erklärt die Grammatik.', 'Der Lehrer erklärt die Grammatik.'),
            ('Der Übung ist leicht.', 'Die Übung ist leicht.'),
            ('Die Verkäufer ist freundlich.', 'Der Verkäufer ist freundlich.'),
        ], 'der or die? Find the mistake'),
        en([
            ('The driver is unfriendly.', 'Der Fahrer ist unfreundlich.'),
            ('The museum is free (of charge).', 'Das Museum ist kostenlos.'),
            ('Is that edible?', 'Ist das essbar?'),
        ]),
    ],
    'tekamolo': [
        fix([
            ('Ich fahre nach Berlin morgen mit dem Zug.', 'Ich fahre morgen mit dem Zug nach Berlin.'),
            ('Wir treffen uns im Café um drei.', 'Wir treffen uns um drei im Café.'),
            ('Er fährt mit dem Rad jeden Tag zur Schule.', 'Er fährt jeden Tag mit dem Rad zur Schule.'),
            ('Morgen ich fahre nach Berlin.', 'Morgen fahre ich nach Berlin.'),
            ('Sonntags gehe ich in die Bibliothek mit Anna.', 'Sonntags gehe ich mit Anna in die Bibliothek.'),
        ]),
        en([
            ('Next week I’m going to Hamburg by train.', 'Nächste Woche fahre ich mit dem Zug nach Hamburg.'),
            ('We’re meeting at eight in the library.', 'Wir treffen uns um acht in der Bibliothek.'),
            ('On Sundays the cat rides to the market by bike.', 'Sonntags fährt die Katze mit dem Rad zum Markt.'),
        ]),
        gaps('Your week in order', 'Finish with how and where.', [
            ('Morgen fahre ich', '.'), ('Am Wochenende', '.'), ('Jeden Tag', '.'),
        ], 'About you — when, how, where.'),
    ],
    'datum_email': [
        fix([
            ('Sehr geehrte Herr Braun,', 'Sehr geehrter Herr Braun,'),
            ('Lieber Anna,', 'Liebe Anna,'),
            ('Am zwölfte März habe ich Geburtstag.', 'Am zwölften März habe ich Geburtstag.'),
        ]),
        en([
            ('Paul’s sister lives in Bonn.', 'Pauls Schwester wohnt in Bonn.'),
            ('Today is the first of May.', 'Heute ist der erste Mai.'),
        ]),
    ],
    'review_2': [
        write('Say it another way', 'Write it again with the word in brackets.', [
            ('Man putzt das Zimmer jeden Tag. (wird)', 'Das Zimmer wird jeden Tag geputzt.'),
            ('Er ist in den Wald gegangen. (ging)', 'Er ging in den Wald.'),
            ('Das ist der Mann. Ich kenne ihn. (den)', 'Das ist der Mann, den ich kenne.'),
            ('Das Auto von Anna ist rot. (Annas)', 'Annas Auto ist rot.'),
            ('Du musst zum Arzt gehen. (solltest)', 'Du solltest zum Arzt gehen.'),
        ], 1),
        circle('Which one?', 'Circle the right word.', [
            ('Das ist das', ['beste', 'besten'], 'Eis.', 'beste'),
            ('Ich trage einen', ['neuen', 'neuer'], 'Pullover.', 'neuen'),
            ('Die Jacke steht', ['dir', 'dich'], 'gut.', 'dir'),
            ('Die Fahrräder', ['wird', 'werden'], 'repariert.', 'werden'),
            ('Am', ['zwölften', 'zwölfte'], 'März habe ich Geburtstag.', 'zwölften'),
            ('Es', ['war', 'wird'], 'einmal ein König.', 'war'),
        ], 2),
        gaps('About you', 'Write true sentences.', [
            ('Am liebsten trage ich', '.'), ('Wenn ich krank bin,', '.'),
            ('Ich habe einen Freund, der', '.'),
        ], 'About you.'),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        fix([
            ('Ich lege das Handy auf dem Sofa.', 'Ich lege das Handy auf das Sofa. / aufs Sofa.'),
            ('Wir freuen uns für den Urlaub.', 'Wir freuen uns auf den Urlaub.'),
            ('Ich komme nicht, weil ich bin müde.', 'Ich komme nicht, weil ich müde bin.'),
            ('Wissen Sie, ob kommt der Bus?', 'Wissen Sie, ob der Bus kommt?'),
            ('Du musst sich beeilen!', 'Du musst dich beeilen!'),
        ]),
        en([
            ('The key is under the rug.', 'Der Schlüssel liegt unter dem Teppich.'),
            ('Put the vase on the shelf! (du)', 'Stell die Vase aufs Regal!'),
            ('I think that Rocky is hungry.', 'Ich glaube, dass Rocky Hunger hat.'),
            ('If it rains, I stay at home.', 'Wenn es regnet, bleibe ich zu Hause.'),
        ]),
        write('Say it another way', 'Write it again with the words in brackets.', [
            ('Ich bin müde, deshalb gehe ich ins Bett. (weil)', 'Ich gehe ins Bett, weil ich müde bin.'),
            ('Wo ist die Apotheke? (Können Sie mir sagen …)', 'Können Sie mir sagen, wo die Apotheke ist?'),
            ('Ist das Museum offen? (Wissen Sie …)', 'Wissen Sie, ob das Museum offen ist?'),
            ('Es regnet. Wir bleiben zu Hause. (wenn)', 'Wenn es regnet, bleiben wir zu Hause.'),
        ], 1),
    ],
    'review_2': [
        fix([
            ('Ich bin schlecht, ich habe Fieber.', 'Mir ist schlecht, ich habe Fieber.'),
            ('Ich suche einen neuer Pullover.', 'Ich suche einen neuen Pullover.'),
            ('Wir konnten morgen wandern gehen.', 'Wir könnten morgen wandern gehen.'),
            ('Das ist die Frau, der hier arbeitet.', 'Das ist die Frau, die hier arbeitet.'),
            ('Das Brot werden jeden Morgen gebacken.', 'Das Brot wird jeden Morgen gebacken.'),
            ('Mein Bruder ist am größer.', 'Mein Bruder ist am größten.'),
        ]),
        en([
            ('My throat hurts.', 'Mein Hals tut weh.'),
            ('The red dress suits you. (du)', 'Das rote Kleid steht dir gut.'),
            ('You should drink more water. (du)', 'Du solltest mehr Wasser trinken.'),
            ('Once upon a time there was a cat.', 'Es war einmal eine Katze.'),
            ('Today is the third of October.', 'Heute ist der dritte Oktober.'),
        ]),
    ],
}
