# Extra exercises for the B1.2 study companion: they fill the free paper on each practice page
# and review page. Merged by kit.write_book (rerun: python -I tool/companion/b1_2.py).
from kit import circle, gaps, write

FIX = 'Each sentence has one mistake. Write it correctly.'


def fix(items, title='Find the mistake'):
    return write(title, FIX, items, 1)


def en(items, title='Say it in German'):
    return write(title, 'Write it in German.', items, 1, not_german=True)


EXTRAS = {
    'technik': [
        fix([
            ('Ich herunterlade die App.', 'Ich lade die App herunter.'),
            ('Der Datei ist zu groß.', 'Die Datei ist zu groß.'),
            ('Das Bildschirm bleibt schwarz.', 'Der Bildschirm bleibt schwarz.'),
            ('Die Programm stürzt schon wieder ab.', 'Das Programm stürzt schon wieder ab.'),
        ]),
        en([
            ('I’ve forgotten my password — again.', 'Ich habe mein Passwort schon wieder vergessen.'),
            ('Switch off the laptop and restart it. (du)', 'Schalte den Laptop aus und starte ihn neu.'),
            ('The connection is gone, and the cat is sitting on the printer.',
             'Die Verbindung ist weg, und die Katze sitzt auf dem Drucker.'),
        ]),
    ],
    'praet_reg': [
        write('Write it down', 'Write it in the written past.', [
            ('Ich habe in Köln gearbeitet.', 'Ich arbeitete in Köln.'),
            ('Er hat mir Blumen gebracht.', 'Er brachte mir Blumen.'),
            ('Wir haben an dich gedacht.', 'Wir dachten an dich.'),
            ('Niemand hat es gewusst.', 'Niemand wusste es.'),
            ('Ich habe ihm einen Brief geschickt.', 'Ich schickte ihm einen Brief.'),
        ], 1),
        en([
            ('In 2019 I learned German.', '2019 lernte ich Deutsch.'),
            ('Back then I knew all the neighbours.', 'Früher kannte ich alle Nachbarn.'),
            ('We ran to the stop.', 'Wir rannten zur Haltestelle.'),
            ('He sent me a letter — from the sofa.', 'Er schickte mir einen Brief – vom Sofa.'),
        ]),
    ],
    'praet_unreg': [
        fix([
            ('Gestern geht ich früh nach Hause.', 'Gestern ging ich früh nach Hause.'),
            ('Wir fand den Schlüssel nicht.', 'Wir fanden den Schlüssel nicht.'),
            ('Gestern trinke ich zu viel Kaffee.', 'Gestern trank ich zu viel Kaffee.'),
            ('Wir fuhr mit dem Zug nach Wien.', 'Wir fuhren mit dem Zug nach Wien.'),
        ]),
        en([
            ('She only ate a salad.', 'Sie aß nur einen Salat.'),
            ('We went home late.', 'Wir gingen spät nach Hause.'),
            ('The dog slept; the cat stood at the window.', 'Der Hund schlief, die Katze stand am Fenster.'),
        ]),
    ],
    'plusquamperfekt': [
        fix([
            ('Als ich ankam, hatte der Zug schon abgefahren.', 'Als ich ankam, war der Zug schon abgefahren.'),
            ('Nachdem wir gegessen haben, gingen wir spazieren.', 'Nachdem wir gegessen hatten, gingen wir spazieren.'),
            ('Sie war den Film schon zweimal gesehen.', 'Sie hatte den Film schon zweimal gesehen.'),
            ('Als die Polizei kam, hatte der Dieb schon verschwunden.', 'Als die Polizei kam, war der Dieb schon verschwunden.'),
        ]),
        write('First, then', 'Join with nachdem: the first thing takes hatte or war.', [
            ('Wir essen. Wir gehen spazieren.', 'Nachdem wir gegessen hatten, gingen wir spazieren.'),
            ('Der Dieb verschwindet. Die Polizei kommt.', 'Nachdem der Dieb verschwunden war, kam die Polizei.'),
            ('Wir kommen an. Wir trinken Kaffee.', 'Nachdem wir angekommen waren, tranken wir Kaffee.'),
        ], 1),
        en([
            ('When I arrived, the train had already left.', 'Als ich ankam, war der Zug schon abgefahren.'),
            ('The children had already fallen asleep.', 'Die Kinder waren schon eingeschlafen.'),
            ('We had already eaten — the dog too.', 'Wir hatten schon gegessen – der Hund auch.'),
        ]),
    ],
    'temporal': [
        fix([
            ('Bevor ich gehe zur Arbeit, frühstücke ich.', 'Bevor ich zur Arbeit gehe, frühstücke ich.'),
            ('Während sie kocht, er deckt den Tisch.', 'Während sie kocht, deckt er den Tisch.'),
            ('Seit ich hier wohnte, habe ich kein Auto.', 'Seit ich hier wohne, habe ich kein Auto.'),
            ('Warte, bis ich bin zurück.', 'Warte, bis ich zurück bin.'),
            ('Sobald der Bus kommt, wir fahren los.', 'Sobald der Bus kommt, fahren wir los.'),
        ]),
        en([
            ('Before I go to bed, I read.', 'Bevor ich ins Bett gehe, lese ich.'),
            ('While he sleeps, the cat eats his breakfast.', 'Während er schläft, isst die Katze sein Frühstück.'),
            ('Since I’ve lived in the country, I’ve had no car.', 'Seit ich auf dem Land wohne, habe ich kein Auto.'),
            ('Wait until I’m back! (du)', 'Warte, bis ich zurück bin!'),
            ('As soon as the bus comes, we set off.', 'Sobald der Bus kommt, fahren wir los.'),
        ]),
    ],
    'passiv': [
        fix([
            ('Das Haus wird 1990 gebaut.', 'Das Haus wurde 1990 gebaut.'),
            ('Die Fenster wurde letzte Woche geputzt.', 'Die Fenster wurden letzte Woche geputzt.'),
            ('In der Schweiz wird vier Sprachen gesprochen.', 'In der Schweiz werden vier Sprachen gesprochen.'),
            ('Das Auto wird gerade reparieren.', 'Das Auto wird gerade repariert.'),
        ]),
        write('Who did it? Nobody says', 'Write it in the passive.', [
            ('Man hat das Haus 1990 gebaut.', 'Das Haus wurde 1990 gebaut.'),
            ('Man repariert das Auto gerade.', 'Das Auto wird gerade repariert.'),
            ('Man serviert die Getränke am Platz.', 'Die Getränke werden am Platz serviert.'),
        ], 1),
    ],
    'passiv_modal': [
        fix([
            ('Das Auto muss repariert worden.', 'Das Auto muss repariert werden.'),
            ('Hier darf nicht parken werden.', 'Hier darf nicht geparkt werden.'),
            ('Das Haus ist gebaut geworden.', 'Das Haus ist gebaut worden.'),
            ('Die Rechnung muss heute bezahlt wird.', 'Die Rechnung muss heute bezahlt werden.'),
            ('Das Restaurant wird dienstags geschlossen — es ist zu.', 'Das Restaurant ist dienstags geschlossen — es ist zu.'),
        ]),
        write('Make it a rule', 'Write it in the passive with the helper.', [
            ('Man muss die Rechnung heute bezahlen.', 'Die Rechnung muss heute bezahlt werden.'),
            ('Man darf hier nicht parken.', 'Hier darf nicht geparkt werden.'),
            ('Man kann das Problem lösen.', 'Das Problem kann gelöst werden.'),
            ('Man muss die Tür abschließen.', 'Die Tür muss abgeschlossen werden.'),
            ('Man kann den Tisch reservieren.', 'Der Tisch kann reserviert werden.'),
        ], 1),
    ],
    'review_1': [
        circle('Which one?', 'Circle the right word.', [
            ('Er', ['ging', 'geht'], 'gestern früh ins Bett.', 'ging'),
            ('Ich', ['fand', 'fanden'], 'den Schlüssel.', 'fand'),
            ('Sie', ['brachte', 'bringte'], 'mir Blumen.', 'brachte'),
            ('Ich', ['wusste', 'wisste'], 'es nicht.', 'wusste'),
            ('Der Zug', ['war', 'hatte'], 'schon abgefahren.', 'war'),
            ('Wir', ['hatten', 'waren'], 'schon gegessen.', 'hatten'),
            ('', ['Nachdem', 'Bevor'], 'wir gegessen hatten, gingen wir.', 'Nachdem'),
            ('', ['Seit', 'Bis'], 'ich hier wohne, habe ich kein Auto.', 'Seit'),
            ('Das Haus', ['wurde', 'wird'], '1990 gebaut.', 'wurde'),
            ('Hier darf nicht geparkt', ['werden', 'worden'], '.', 'werden'),
            ('Die Tür', ['ist', 'wird'], 'schon geschlossen.', 'ist'),
            ('Sie', ['kam', 'kommt'], 'gestern spät an.', 'kam'),
            ('Er', ['blieb', 'bleibt'], 'gestern zu Hause.', 'blieb'),
            ('Ich lade die App', ['herunter', 'hoch'], '— jetzt ist sie auf meinem Handy.', 'herunter'),
        ], 2),
        write('A bad day', 'Tell it in the story past.', [
            ('Ich gehe zum Bahnhof.', 'Ich ging zum Bahnhof.'),
            ('Der Zug kommt nicht.', 'Der Zug kam nicht.'),
            ('Ich rufe den Kundendienst an.', 'Ich rief den Kundendienst an.'),
            ('Der Bildschirm bleibt schwarz.', 'Der Bildschirm blieb schwarz.'),
            ('Wir essen nur einen Salat.', 'Wir aßen nur einen Salat.'),
            ('Sie schreibt eine E-Mail.', 'Sie schrieb eine E-Mail.'),
            ('Ich nehme den letzten Bus.', 'Ich nahm den letzten Bus.'),
        ], 1),
    ],
    'n_dekl': [
        fix([
            ('Ich kenne den Student.', 'Ich kenne den Studenten.'),
            ('Ich helfe dem Junge.', 'Ich helfe dem Jungen.'),
            ('Der Studenten ist nett.', 'Der Student ist nett.'),
            ('Wir sprechen mit dem Nachbar.', 'Wir sprechen mit dem Nachbarn.'),
            ('Fragen Sie den Herr dort!', 'Fragen Sie den Herrn dort!'),
            ('Das ist das Auto des Präsident.', 'Das ist das Auto des Präsidenten.'),
        ]),
        en([
            ('I shake hands with the president.', 'Ich gebe dem Präsidenten die Hand.'),
            ('Do you know the new colleague? (du)', 'Kennst du den neuen Kollegen?'),
            ('The customer is king.', 'Der Kunde ist König.'),
            ('We help the tourist.', 'Wir helfen dem Touristen.'),
            ('The neighbour’s monkey is in the hall.', 'Der Affe des Nachbarn ist im Flur.'),
        ]),
    ],
    'zweck': [
        fix([
            ('Ich lerne Deutsch, damit hier zu arbeiten.', 'Ich lerne Deutsch, um hier zu arbeiten.'),
            ('Ich lerne Deutsch, um meine Kinder stolz sind.', 'Ich lerne Deutsch, damit meine Kinder stolz sind.'),
            ('Ich spare Geld, indem ich koche selbst.', 'Ich spare Geld, indem ich selbst koche.'),
            ('Er war so müde, dass er schlief ein.', 'Er war so müde, dass er einschlief.'),
            ('Sie ging, ohne etwas sagen.', 'Sie ging, ohne etwas zu sagen.'),
        ]),
        en([
            ('I save money by cooking myself.', 'Ich spare Geld, indem ich selbst koche.'),
            ('I ride my bike to stay fit.', 'Ich fahre Rad, um fit zu bleiben.'),
            ('He speaks slowly so that everyone understands him.', 'Er spricht langsam, damit alle ihn verstehen.'),
            ('The bus was late, so we missed the train.', 'Der Bus kam zu spät, sodass wir den Zug verpassten.'),
        ]),
    ],
    'relativ_dat': [
        fix([
            ('Die Frau, dessen Auto vor dem Haus steht, ist nett.', 'Die Frau, deren Auto vor dem Haus steht, ist nett.'),
            ('Der Kollege, deren Frau Ärztin ist, arbeitet hier.', 'Der Kollege, dessen Frau Ärztin ist, arbeitet hier.'),
            ('Das sind die Freunde, dem ich vertraue.', 'Das sind die Freunde, denen ich vertraue.'),
            ('Die Nachbarn, deren der Hund immer bellt, wohnen hier.', 'Die Nachbarn, deren Hund immer bellt, wohnen hier.'),
            ('Das Kind, deren Eltern noch arbeiten, wartet hier.', 'Das Kind, dessen Eltern noch arbeiten, wartet hier.'),
        ]),
        write('One sentence', 'Join with dessen or deren.', [
            ('Das ist der Kollege. Seine Frau ist Ärztin.', 'Das ist der Kollege, dessen Frau Ärztin ist.'),
            ('Das ist die Nachbarin. Ihr Hund bellt immer.', 'Das ist die Nachbarin, deren Hund immer bellt.'),
            ('Das sind die Kinder. Ihre Eltern arbeiten noch.', 'Das sind die Kinder, deren Eltern noch arbeiten.'),
            ('Das ist das Kind. Sein Fahrrad steht vor dem Haus.', 'Das ist das Kind, dessen Fahrrad vor dem Haus steht.'),
        ], 1),
        en([
            ('That’s the man whose dog always barks.', 'Das ist der Mann, dessen Hund immer bellt.'),
            ('The friends I trust most live in Bonn.', 'Die Freunde, denen ich am meisten vertraue, wohnen in Bonn.'),
            ('The neighbours whose dog barks are on holiday.', 'Die Nachbarn, deren Hund bellt, sind im Urlaub.'),
            ('The colleague I share the office with sings a lot.', 'Die Kollegin, mit der ich das Büro teile, singt viel.'),
        ]),
    ],
    'konnektoren': [
        fix([
            ('Ich habe weder Zeit noch kein Geld.', 'Ich habe weder Zeit noch Geld.'),
            ('Je mehr ich übe, desto ich werde besser.', 'Je mehr ich übe, desto besser werde ich.'),
            ('Sie spricht sowohl Deutsch oder Englisch.', 'Sie spricht sowohl Deutsch als auch Englisch.'),
            ('Er ist nicht nur klug, aber auch fleißig.', 'Er ist nicht nur klug, sondern auch fleißig.'),
        ]),
        en([
            ('We go either by train or by car.', 'Wir fahren entweder mit dem Zug oder mit dem Auto.'),
            ('The hotel is expensive, true, but very nice.', 'Das Hotel ist zwar teuer, aber sehr schön.'),
            ('The more I sleep, the more tired I am.', 'Je mehr ich schlafe, desto müder bin ich.'),
            ('My cat is neither clever nor hard-working.', 'Meine Katze ist weder klug noch fleißig.'),
        ]),
        gaps('Your pairs', 'Finish the sentences.', [
            ('Ich spreche sowohl', '.'), ('Je mehr ich Deutsch übe,', '.'),
        ], 'About you.'),
    ],
    'wuensche': [
        fix([
            ('Hätte ich doch zu Hause geblieben!', 'Wäre ich doch zu Hause geblieben!'),
            ('Wäre ich doch mehr gelernt!', 'Hätte ich doch mehr gelernt!'),
            ('Wenn ich doch hätte mehr gelernt!', 'Wenn ich doch mehr gelernt hätte!'),
            ('Hätte er doch gekommen!', 'Wäre er doch gekommen!'),
        ]),
        en([
            ('If only I had called her!', 'Hätte ich sie doch angerufen!'),
            ('If only we had stayed at home!', 'Wären wir doch zu Hause geblieben!'),
            ('If only I hadn’t said that!', 'Hätte ich das bloß nicht gesagt!'),
        ]),
        gaps('Your sighs', 'Write two wishes about the past.', [
            ('Hätte ich doch', '!'), ('Wäre ich nur', '!'),
        ], 'About you — hätte or wäre + the past form.'),
    ],
    'trotz_wegen': [
        fix([
            ('Wegen des Stau kamen wir zu spät.', 'Wegen des Staus kamen wir zu spät.'),
            ('Während der Film darf man nicht telefonieren.', 'Während des Films darf man nicht telefonieren.'),
            ('Trotz der Regen gehen wir raus.', 'Trotz des Regens gehen wir raus.'),
            ('Obwohl es regnet, wir gehen raus.', 'Obwohl es regnet, gehen wir raus.'),
            ('Es regnet, trotzdem wir gehen raus.', 'Es regnet, trotzdem gehen wir raus.'),
        ]),
        write('Say it another way', 'Write it again with the word in brackets.', [
            ('Weil es regnet, bleiben wir zu Hause. (wegen)', 'Wegen des Regens bleiben wir zu Hause.'),
            ('Obwohl es regnet, gehen wir raus. (trotzdem)', 'Es regnet, trotzdem gehen wir raus.'),
            ('Weil es einen Stau gab, kamen wir zu spät. (wegen)', 'Wegen des Staus kamen wir zu spät.'),
            ('Während ich arbeite, telefoniere ich nicht. (während der …)', 'Während der Arbeit telefoniere ich nicht.'),
            ('Wegen des Regens bleiben wir zu Hause. (weil)', 'Weil es regnet, bleiben wir zu Hause.'),
            ('Obwohl ich erkältet war, ging ich zur Arbeit. (trotz)', 'Trotz meiner Erkältung ging ich zur Arbeit.'),
        ], 1),
    ],
    'partizip': [
        fix([
            ('Ich sehe den schlafende Hund.', 'Ich sehe den schlafenden Hund.'),
            ('Durch die geöffnet Tür kam kalte Luft.', 'Durch die geöffnete Tür kam kalte Luft.'),
            ('Der lachende Kind sitzt auf dem Schoß.', 'Das lachende Kind sitzt auf dem Schoß.'),
            ('Ich suche die verloren Schlüssel.', 'Ich suche die verlorenen Schlüssel.'),
            ('Das Wasser kocht noch: Vorsicht, das gekochte Wasser!', 'Das Wasser kocht noch: Vorsicht, das kochende Wasser!'),
        ]),
        en([
            ('the laughing child', 'das lachende Kind'),
            ('the opened door', 'die geöffnete Tür'),
            ('the sleeping dog', 'der schlafende Hund'),
            ('the lost keys', 'die verlorenen Schlüssel'),
            ('Careful, boiling water!', 'Vorsicht, kochendes Wasser!'),
        ]),
    ],
    'partikeln': [
        write('Make it friendlier', 'Write it again with the little word in brackets.', [
            ('Was machst du hier? (denn)', 'Was machst du denn hier?'),
            ('Komm mit! (doch)', 'Komm doch mit!'),
            ('Warte! (mal)', 'Warte mal!'),
            ('Das ist toll! (ja)', 'Das ist ja toll!'),
            ('Kommst du mit? (eigentlich)', 'Kommst du eigentlich mit?'),
        ], 1),
        fix([
            ('Was denn machst du hier?', 'Was machst du denn hier?'),
            ('Doch komm mit!', 'Komm doch mit!'),
            ('Kommst du nicht mit? – Ja!', 'Kommst du nicht mit? – Doch!'),
            ('Mal schau hier!', 'Schau mal hier!'),
        ]),
        gaps('In a chat', 'Write denn, doch or ja.', [
            ('Wo warst du', 'gestern?', 'denn'), ('Du weißt', ', ich habe keine Zeit.', 'ja'),
        ]),
    ],
    'wortbildung': [
        fix([
            ('Der Gesundheit ist das Wichtigste.', 'Die Gesundheit ist das Wichtigste.'),
            ('Das Freundschaft hat dreißig Jahre gehalten.', 'Die Freundschaft hat dreißig Jahre gehalten.'),
            ('Die Journalist fragt nach meiner Meinung.', 'Der Journalist fragt nach meiner Meinung.'),
            ('Das Möglichkeit ist gut.', 'Die Möglichkeit ist gut.'),
        ], 'der or die? Find the mistake'),
        en([
            ('Health is the most important thing.', 'Die Gesundheit ist das Wichtigste.'),
            ('That was a difficult decision.', 'Das war eine schwierige Entscheidung.'),
            ('Health is the most important thing in life.', 'Die Gesundheit ist das Wichtigste im Leben.'),
            ('The athlete has a lot of experience.', 'Der Sportler hat viel Erfahrung.'),
        ]),
    ],
    'geschichte': [
        fix([
            ('Am Anfang war ich ruhig. Dann gehe ich zum Bahnhof.', 'Am Anfang war ich ruhig. Dann ging ich zum Bahnhof.'),
            ('Plötzlich regnet es stark.', 'Plötzlich regnete es stark.'),
            ('Zum Glück gibt mir eine Frau ihren Regenschirm.', 'Zum Glück gab mir eine Frau ihren Regenschirm.'),
            ('Als ich ankam, ist der Zug schon abgefahren.', 'Als ich ankam, war der Zug schon abgefahren.'),
            ('Am Ende bin ich nass, aber glücklich.', 'Am Ende war ich nass, aber glücklich.'),
        ]),
        en([
            ('At the beginning I was very nervous.', 'Am Anfang war ich sehr nervös.'),
            ('Luckily I had an umbrella.', 'Zum Glück hatte ich einen Regenschirm.'),
            ('Suddenly it rained.', 'Plötzlich regnete es.'),
            ('Suddenly the screen stayed black.', 'Plötzlich blieb der Bildschirm schwarz.'),
            ('Then I called customer service.', 'Dann rief ich den Kundendienst an.'),
            ('In the end everything was fine.', 'Am Ende war alles gut.'),
        ]),
    ],
    'review_2': [
        circle('Which one?', 'Circle the right word.', [
            ('Wir sprechen mit dem', ['Nachbarn', 'Nachbar'], '.', 'Nachbarn'),
            ('Ich lerne,', ['um', 'damit'], 'hier zu arbeiten.', 'um'),
            ('Die Frau,', ['deren', 'dessen'], 'Hund bellt, wohnt hier.', 'deren'),
            ('Das sind die Freunde,', ['denen', 'dem'], 'ich vertraue.', 'denen'),
            ('Ich habe weder Zeit', ['noch', 'oder'], 'Geld.', 'noch'),
            ('Je mehr ich übe,', ['desto', 'dann'], 'besser werde ich.', 'desto'),
            ('', ['Wäre', 'Hätte'], 'ich nur zu Hause geblieben!', 'Wäre'),
            ('', ['Wegen', 'Trotz'], 'des Staus kamen wir zu spät.', 'Wegen'),
            ('Der', ['schlafende', 'geschlafene'], 'Hund soll nicht aufwachen.', 'schlafende'),
            ('Komm', ['doch', 'denn'], 'mit!', 'doch'),
            ('', ['Die', 'Der'], 'Freundschaft hat lange gehalten.', 'Die'),
            ('Am Ende', ['war', 'ist'], 'alles gut.', 'war'),
        ], 2),
        write('One sentence', 'Join with the word in brackets.', [
            ('Ich fahre Rad. Ich will fit bleiben. (um … zu)', 'Ich fahre Rad, um fit zu bleiben.'),
            ('Er spricht langsam. Alle verstehen ihn. (damit)', 'Er spricht langsam, damit alle ihn verstehen.'),
            ('Sie spart Geld. Sie kocht selbst. (indem)', 'Sie spart Geld, indem sie selbst kocht.'),
            ('Es regnete stark. Die Straße wurde gesperrt. (sodass)', 'Es regnete stark, sodass die Straße gesperrt wurde.'),
        ], 1),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        fix([
            ('Ich herunterlade das Programm.', 'Ich lade das Programm herunter.'),
            ('Gestern geht er nach Hause.', 'Gestern ging er nach Hause.'),
            ('Als ich ankam, hatte der Bus schon abgefahren.', 'Als ich ankam, war der Bus schon abgefahren.'),
            ('Bevor ich frühstücke, ich dusche.', 'Bevor ich frühstücke, dusche ich.'),
            ('Die Fenster wird gerade geputzt.', 'Die Fenster werden gerade geputzt.'),
        ]),
        en([
            ('Restart the computer! (du)', 'Starte den Computer neu!'),
            ('We didn’t find the key.', 'Wir fanden den Schlüssel nicht.'),
            ('After we had eaten, we went for a walk.', 'Nachdem wir gegessen hatten, gingen wir spazieren.'),
            ('Parking is not allowed here.', 'Hier darf nicht geparkt werden.'),
        ]),
        write('Say it another way', 'Write it again with the word in brackets.', [
            ('Ich habe Deutsch gelernt. (lernte)', 'Ich lernte Deutsch.'),
            ('Man hat das Haus 1990 gebaut. (wurde)', 'Das Haus wurde 1990 gebaut.'),
            ('Ich frühstücke. Dann gehe ich zur Arbeit. (bevor)', 'Bevor ich zur Arbeit gehe, frühstücke ich.'),
        ], 1),
    ],
    'review_2': [
        fix([
            ('Ich kenne den Kollege.', 'Ich kenne den Kollegen.'),
            ('Ich spare, damit ein Auto zu kaufen.', 'Ich spare, um ein Auto zu kaufen.'),
            ('Die Frau, dessen Auto dort steht, ist nett.', 'Die Frau, deren Auto dort steht, ist nett.'),
            ('Wir fahren entweder mit dem Zug und mit dem Auto.', 'Wir fahren entweder mit dem Zug oder mit dem Auto.'),
            ('Hätte ich nur zu Hause geblieben!', 'Wäre ich nur zu Hause geblieben!'),
            ('Trotz der Regen gehen wir spazieren.', 'Trotz des Regens gehen wir spazieren.'),
            ('Der Freundschaft ist wichtig.', 'Die Freundschaft ist wichtig.'),
        ]),
        en([
            ('We help the student.', 'Wir helfen dem Studenten.'),
            ('If only I had stayed in bed!', 'Wäre ich doch im Bett geblieben!'),
            ('Because of the traffic jam we were late.', 'Wegen des Staus kamen wir zu spät.'),
            ('Careful, sleeping dog!', 'Vorsicht, schlafender Hund!'),
            ('Luckily the cat had the key.', 'Zum Glück hatte die Katze den Schlüssel.'),
        ]),
        write('Say it another way', 'Write it again with the words in brackets.', [
            ('Das ist der Nachbar. Sein Hund bellt immer. (dessen)', 'Das ist der Nachbar, dessen Hund immer bellt.'),
            ('Obwohl es regnet, gehen wir raus. (trotz)', 'Trotz des Regens gehen wir raus.'),
            ('Weil es regnet, bleiben wir zu Hause. (wegen)', 'Wegen des Regens bleiben wir zu Hause.'),
            ('Ich habe nicht gelernt. (Hätte ich doch …)', 'Hätte ich doch gelernt!'),
        ], 1),
    ],
}
