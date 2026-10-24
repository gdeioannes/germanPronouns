# Extra exercises for the B2.2 study companion: they fill the free space on each practice page
# (EXTRAS) and on each review's left page (EXTRAS_LEFT). Merged by kit.write_book; rules in
# docs/study_companion_guide.md (teach before asking, every answer in the key, paper wording).
from kit import gaps, write

MISTAKE = 'Find the mistake'
MISTAKE_I = 'Each sentence has one mistake. Write it correctly.'
TRANSLATE = 'In German'
TRANSLATE_I = 'Write it in German.'

EXTRAS = {
    # ---- Part 1 ----------------------------------------------------------------------------
    'umwelt': [
        write(TRANSLATE, TRANSLATE_I, [
            ('We separate our rubbish.', 'Wir trennen unseren Müll.'),
            ('Global warming leads to droughts.', 'Die Erderwärmung führt zu Dürren.'),
            ('Grandma does without plastic — but not without chocolate.', 'Oma verzichtet auf Plastik – aber nicht auf Schokolade.'),
        ], 1, not_german=True),
        write(MISTAKE, MISTAKE_I, [
            ('Immer mehr Familien verzichten für Plastik.', 'Immer mehr Familien verzichten auf Plastik.'),
            ('Die Regierung muss Maßnahmen machen.', 'Die Regierung muss Maßnahmen ergreifen.'),
            ('Der hohe Verbrauch führt an mehr Müll.', 'Der hohe Verbrauch führt zu mehr Müll.'),
        ], 1),
    ],
    'irreal': [
        write(MISTAKE, MISTAKE_I, [
            ('Wenn ich reich wäre, ich würde um die Welt reisen.', 'Wenn ich reich wäre, würde ich um die Welt reisen.'),
            ('Wenn ich das gewusst habe, wäre ich geblieben.', 'Wenn ich das gewusst hätte, wäre ich geblieben.'),
            ('Hätte ich Zeit, ich käme.', 'Hätte ich Zeit, käme ich.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('If I were rich, I would travel the world.', 'Wenn ich reich wäre, würde ich um die Welt reisen.'),
            ('If I had known that, I would have stayed.', 'Wenn ich das gewusst hätte, wäre ich geblieben.'),
            ('If my cat had the choice, it would quit.', 'Wenn meine Katze die Wahl hätte, würde sie kündigen.'),
        ], 1, not_german=True),
    ],
    'konj2_verg': [
        write(MISTAKE, MISTAKE_I, [
            ('Wir hätten früher gegangen.', 'Wir wären früher gegangen.'),
            ('Ich wäre das nie gesagt.', 'Ich hätte das nie gesagt.'),
            ('Das hätte nicht passiert.', 'Das wäre nicht passiert.'),
        ], 1),
        write('Should have', 'Say what should have happened. Use sollen.', [
            ('Er ist zu spät gekommen. (pünktlich)', 'Er hätte pünktlich kommen sollen.'),
            ('Ihr habt nicht angerufen.', 'Ihr hättet anrufen sollen.'),
            ('Der Hund hat den Kuchen gegessen. (nicht)', 'Der Hund hätte den Kuchen nicht essen sollen.'),
        ], 1),
    ],
    'als_ob': [
        write(MISTAKE, MISTAKE_I, [
            ('Er tut so, als ob er der Chef ist.', 'Er tut so, als ob er der Chef wäre.'),
            ('Er tut so, als ob wäre er der Chef.', 'Er tut so, als wäre er der Chef.'),
            ('Sie sieht aus, als ob sie nicht geschlafen wäre.', 'Sie sieht aus, als ob sie nicht geschlafen hätte.'),
            ('Er redet, als er alles wüsste.', 'Er redet, als wüsste er alles.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('He acts as if he were rich.', 'Er tut so, als ob er reich wäre.'),
            ('You look as if you had seen a ghost.', 'Du siehst aus, als ob du ein Gespenst gesehen hättest.'),
            ('It sounds as if it were easy.', 'Es klingt, als ob es einfach wäre.'),
            ('My dog behaves as if he were the boss.', 'Mein Hund benimmt sich, als ob er der Chef wäre.'),
            ('She speaks as if she had grown up in Germany.', 'Sie spricht, als ob sie in Deutschland aufgewachsen wäre.'),
        ], 1, not_german=True),
        gaps('About you', 'Finish the sentence.', [('Heute fühle ich mich, als ob', '.')], 'About you.'),
    ],
    'vermutung': [
        write(MISTAKE, MISTAKE_I, [
            ('Er wird den Zug verpasst sein.', 'Er wird den Zug verpasst haben.'),
            ('Sie wird schon gegangen haben.', 'Sie wird schon gegangen sein.'),
            ('Sie wird wohl noch im Büro ist.', 'Sie wird wohl noch im Büro sein.'),
            ('Er wird den Termin vergessen sein.', 'Er wird den Termin vergessen haben.'),
            ('Das wird der Paketbote gewesen haben.', 'Das wird der Paketbote gewesen sein.'),
        ], 1),
        write(TRANSLATE, 'Write the guess in German, with werden.', [
            ('She will probably still be in the meeting.', 'Sie wird wohl noch im Meeting sein.'),
            ('He will have forgotten the appointment.', 'Er wird den Termin vergessen haben.'),
            ('Don’t worry, you’ll manage it.', 'Keine Sorge, du wirst es schon schaffen.'),
            ('The cat will have eaten the cake.', 'Die Katze wird den Kuchen gegessen haben.'),
            ('The light is off — they will already be asleep.', 'Das Licht ist aus – sie werden schon schlafen.'),
        ], 1, not_german=True),
    ],
    'sollen': [
        write('Say it another way', 'Write it with sollen or wollen.', [
            ('Man sagt, der neue Chef ist sehr streng.', 'Der neue Chef soll sehr streng sein.'),
            ('Er sagt, er war nicht dort.', 'Er will nicht dort gewesen sein.'),
            ('Man sagt, sie hat den ersten Preis gewonnen.', 'Sie soll den ersten Preis gewonnen haben.'),
            ('Der Hund sagt, er hat den Käse nicht gegessen.', 'Der Hund will den Käse nicht gegessen haben.'),
        ], 1),
        write(MISTAKE, MISTAKE_I, [
            ('Er soll reich gewesen haben.', 'Er soll reich gewesen sein.'),
            ('Sie will den Minister kennt.', 'Sie will den Minister kennen.'),
            ('Man sagt, er soll reich sein.', 'Er soll reich sein.'),
            ('Er will von nichts gewusst sein.', 'Er will von nichts gewusst haben.'),
        ], 1),
    ],
    'partikeln': [
        write('Make it friendlier', 'Add the little word in brackets.', [
            ('Komm vorbei! (doch mal)', 'Komm doch mal vorbei!'),
            ('Nimm noch ein Stück Kuchen. (ruhig)', 'Nimm ruhig noch ein Stück Kuchen.'),
            ('Dann nehmen wir den nächsten Zug. (eben)', 'Dann nehmen wir eben den nächsten Zug.'),
            ('Das klappt. (schon)', 'Das klappt schon.'),
            ('Mach das nicht! (bloß)', 'Mach das bloß nicht!'),
            ('Kannst du mir helfen? (mal)', 'Kannst du mir mal helfen?'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('Go ahead and sit down!', 'Setz dich ruhig!'),
            ('He is probably ill.', 'Er ist wohl krank.'),
            ('That’s just how it is.', 'Das ist halt so.'),
            ('Don’t you dare eat my cake!', 'Iss bloß nicht meinen Kuchen!'),
            ('It’ll work out, don’t worry.', 'Das klappt schon.'),
            ('Then we will just stay at home.', 'Dann bleiben wir eben zu Hause.'),
        ], 1, not_german=True),
    ],
    'review_1': [
        write('No wenn', 'Start with the verb.', [
            ('Wenn ich das gewusst hätte, wäre ich gekommen.', 'Hätte ich das gewusst, wäre ich gekommen.'),
            ('Wenn ich du wäre, würde ich kündigen.', 'Wäre ich du, würde ich kündigen.'),
            ('Wenn er Zeit hätte, käme er.', 'Hätte er Zeit, käme er.'),
        ], 1),
        gaps('The right form', 'Write the missing word.', [
            ('Wenn es eine Lösung', ', wüssten wir sie. (geben)', 'gäbe'),
            ('Er redet, als ob er alles', '. (wissen)', 'wüsste'),
            ('Es klingelt. Das', 'der Paketbote sein.', 'wird'),
            ('Wir', 'früher aufstehen sollen.', 'hätten'),
        ]),
        write('Say it another way', 'Write it with sollen or wollen.', [
            ('Man sagt, die Firma hat Probleme.', 'Die Firma soll Probleme haben.'),
            ('Sie sagt, sie hat nichts gehört.', 'Sie will nichts gehört haben.'),
            ('Man sagt, die Katze ist sehr streng.', 'Die Katze soll sehr streng sein.'),
        ], 1),
        gaps('About you', 'Finish the sentences.', [
            ('Wenn ich die Wahl hätte, würde ich', '.'), ('Ich hätte gestern', 'sollen.'),
        ], 'About you.'),
    ],

    # ---- Part 2 ----------------------------------------------------------------------------
    'genitiv_praep': [
        write(MISTAKE, MISTAKE_I, [
            ('Wegen dem Streik fahren keine Regionalzüge.', 'Wegen des Streiks fahren keine Regionalzüge.'),
            ('Innerhalb einem Monat wurde das Problem gelöst.', 'Innerhalb eines Monats wurde das Problem gelöst.'),
            ('Bitte bezahlen Sie innerhalb zwei Wochen.', 'Bitte bezahlen Sie innerhalb von zwei Wochen.'),
            ('Mithilfe Freunden haben wir es geschafft.', 'Mithilfe von Freunden haben wir es geschafft.'),
            ('Anlässlich dem Jubiläum gab es Kuchen.', 'Anlässlich des Jubiläums gab es Kuchen.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('Because of the strike, the office is closed.', 'Wegen des Streiks ist das Büro geschlossen.'),
            ('Within a month, the problem was solved.', 'Innerhalb eines Monats wurde das Problem gelöst.'),
            ('Outside opening hours, nobody answers.', 'Außerhalb der Öffnungszeiten antwortet niemand.'),
            ('For the anniversary, there was a cake for the dog.', 'Anlässlich des Jubiläums gab es einen Kuchen für den Hund.'),
            ('Within three days, please.', 'Innerhalb von drei Tagen, bitte.'),
            ('Using the data, we found the mistake.', 'Anhand der Daten fanden wir den Fehler.'),
        ], 1, not_german=True),
    ],
    'nominalisierung': [
        write(MISTAKE, 'Each sentence has the wrong article. Write it correctly.', [
            ('Die Beginn des Konzerts wurde verschoben.', 'Der Beginn des Konzerts wurde verschoben.'),
            ('Der Suche nach einer Wohnung dauert lange.', 'Die Suche nach einer Wohnung dauert lange.'),
            ('Die Gerede der Nachbarn stört mich.', 'Das Gerede der Nachbarn stört mich.'),
        ], 1),
        write('Name the person', 'Write the person who does it, with der.', [
            ('jemand, der fährt', 'der Fahrer'), ('jemand, der läuft', 'der Läufer'),
            ('jemand, der lehrt', 'der Lehrer'), ('jemand, der liest', 'der Leser'),
        ], 2),
        write(TRANSLATE, TRANSLATE_I, [
            ('Running is healthy.', 'Das Laufen ist gesund.'),
            ('My exam nerves are gone.', 'Meine Prüfungsangst ist weg.'),
        ], 1, not_german=True),
    ],
    'nominalstil': [
        write('Say it shorter', 'Write it with bei, ohne, durch or im Falle.', [
            ('Wenn das Wetter schön ist, essen wir draußen.', 'Bei schönem Wetter essen wir draußen.'),
            ('Wenn man keine Hilfe hat, schafft man es nicht.', 'Ohne Hilfe schafft man es nicht.'),
            ('Indem man Energie spart, schützt man die Umwelt.', 'Durch Energiesparen schützt man die Umwelt.'),
            ('Falls ein Brand ausbricht, rufen Sie sofort an.', 'Im Falle eines Brandes rufen Sie sofort an.'),
        ], 1),
        write('Unfold it', 'Write it with wenn or indem.', [
            ('Bei Regen bleibt die Katze im Bett.', 'Wenn es regnet, bleibt die Katze im Bett.'),
            ('Bei Fragen rufen Sie an.', 'Wenn Sie Fragen haben, rufen Sie an.'),
            ('Durch frühes Aufstehen hat man mehr Zeit.', 'Indem man früh aufsteht, hat man mehr Zeit.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('In case of fire, leave the building.', 'Im Falle eines Brandes verlassen Sie das Gebäude.'),
            ('Without help, the cat can’t open the door.', 'Ohne Hilfe kann die Katze die Tür nicht öffnen.'),
        ], 1, not_german=True),
    ],
    'fvg': [
        write(MISTAKE, MISTAKE_I, [
            ('Der Vorstand hat eine Entscheidung gemacht.', 'Der Vorstand hat eine Entscheidung getroffen.'),
            ('Darf ich eine Frage machen?', 'Darf ich eine Frage stellen?'),
            ('Ich stelle Ihnen jederzeit zur Verfügung.', 'Ich stehe Ihnen jederzeit zur Verfügung.'),
            ('Das neue Gesetz kommt am 1. Januar in Kraft.', 'Das neue Gesetz tritt am 1. Januar in Kraft.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('Money plays a big role.', 'Geld spielt eine große Rolle.'),
            ('We should consider a postponement.', 'Wir sollten eine Verschiebung in Betracht ziehen.'),
            ('That is out of the question.', 'Das kommt nicht in Frage.'),
        ], 1, not_german=True),
    ],
    'partizip_attribut': [
        write('Unfold it', 'Write it as a relative clause.', [
            ('die von der Regierung geplanten Maßnahmen', 'die Maßnahmen, die von der Regierung geplant wurden'),
            ('das seit Jahren bestehende Problem', 'das Problem, das seit Jahren besteht'),
            ('der ständig zunehmende Verkehr', 'der Verkehr, der ständig zunimmt'),
        ], 1),
        write('Fold it', 'Put the clause before the noun.', [
            ('die Produkte, die in der Fabrik hergestellt werden', 'die in der Fabrik hergestellten Produkte'),
            ('der Lärm, der ständig zunimmt', 'der ständig zunehmende Lärm'),
            ('das Unternehmen, das seit Jahren wächst', 'das seit Jahren wachsende Unternehmen'),
        ], 1),
        write(MISTAKE, 'Each one has a word in the wrong place. Write it correctly.', [
            ('die geplanten von der Regierung Maßnahmen', 'die von der Regierung geplanten Maßnahmen'),
            ('das Problem seit Jahren bestehende', 'das seit Jahren bestehende Problem'),
        ], 1),
    ],
    'passiversatz': [
        write('Say it shorter', 'Write it with -bar or sich lassen.', [
            ('Die Handschrift kann nicht gelesen werden.', 'Die Handschrift ist nicht lesbar.'),
            ('Die Pilze können gegessen werden.', 'Die Pilze sind essbar.'),
            ('Das Ziel kann erreicht werden.', 'Das Ziel ist erreichbar.'),
            ('Das Problem kann leicht gelöst werden.', 'Das Problem ist leicht zu lösen.'),
            ('Das Fenster kann nicht geöffnet werden.', 'Das Fenster lässt sich nicht öffnen.'),
            ('Die Wohnung kann bezahlt werden.', 'Die Wohnung ist bezahlbar.'),
        ], 1),
        write(MISTAKE, MISTAKE_I, [
            ('Das Problem lässt lösen.', 'Das Problem lässt sich lösen.'),
            ('Die Rechnung ist bis Freitag bezahlen.', 'Die Rechnung ist bis Freitag zu bezahlen.'),
            ('Der Fehler ist leicht zu beheben werden.', 'Der Fehler ist leicht zu beheben.'),
            ('Die Unterlagen sind bis zum 15. einreichen.', 'Die Unterlagen sind bis zum 15. einzureichen.'),
        ], 1),
    ],
    'adjektivbildung': [
        write(MISTAKE, MISTAKE_I, [
            ('Die Ärztin ist nur telefonisch erreichen.', 'Die Ärztin ist nur telefonisch erreichbar.'),
            ('Glücklich ist der Hund nicht nass geworden.', 'Glücklicherweise ist der Hund nicht nass geworden.'),
            ('Der Vortrag ist sinnvoll: niemand hört zu.', 'Der Vortrag ist sinnlos: niemand hört zu.'),
            ('Sie ist sehr geduldig: Sie wartet nie.', 'Sie ist sehr ungeduldig: Sie wartet nie.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('The new colleague is very friendly.', 'Die neue Kollegin ist sehr freundlich.'),
            ('Luckily it was sunny.', 'Glücklicherweise war es sonnig.'),
            ('Normally I cycle.', 'Normalerweise fahre ich Rad.'),
            ('Don’t be so childish!', 'Sei nicht so kindisch!'),
            ('The doctor can be reached by phone.', 'Die Ärztin ist telefonisch erreichbar.'),
            ('For once I am taking the car.', 'Ausnahmsweise nehme ich das Auto.'),
        ], 1, not_german=True),
    ],
    'review_2': [
        gaps('Official German', 'Write infolge, innerhalb, anhand, mithilfe or anlässlich.', [
            ('', 'des Unfalls fiel der Strom aus.', 'Infolge'),
            ('Bitte antworten Sie', 'einer Woche.', 'innerhalb'),
            ('', 'der Daten sieht man das Problem sofort.', 'Anhand'),
            ('', 'einer App lernt mein Opa Deutsch.', 'Mithilfe'),
            ('', 'des Jubiläums gibt es Kuchen für alle.', 'Anlässlich'),
        ]),
        gaps('Make a noun', 'Write the noun with its article. The verb is in brackets.', [
            ('', 'des Films war langweilig. (beginnen)', 'Der Beginn'),
            ('', 'nach dem Schlüssel dauert eine Stunde. (suchen)', 'Die Suche'),
            ('', 'war leicht. (fragen)', 'Die Frage'),
        ]),
        write('Say it shorter', 'Write it with -bar or sich lassen.', [
            ('Das kann gemacht werden.', 'Das ist machbar.'),
            ('Die Wohnung kann bezahlt werden.', 'Die Wohnung ist bezahlbar.'),
            ('Der Fehler kann behoben werden.', 'Der Fehler lässt sich beheben.'),
            ('Das Wasser kann getrunken werden.', 'Das Wasser ist trinkbar.'),
        ], 1),
        write('The opposite', 'Write the opposite.', [
            ('verständlich', 'unverständlich'), ('fettarm', 'fettreich'), ('sinnlos', 'sinnvoll'),
            ('freundlich', 'unfreundlich'), ('ungeduldig', 'geduldig'), ('erfolgreich', 'erfolglos'),
        ], 3),
        gaps('About you', 'Finish the sentence.', [('Normalerweise', '.')], 'About you.'),
    ],

    # ---- Part 3 ----------------------------------------------------------------------------
    'konzessiv': [
        write(MISTAKE, MISTAKE_I, [
            ('Obwohl es regnete, trotzdem gingen wir spazieren.', 'Obwohl es regnete, gingen wir spazieren.'),
            ('Trotzdem es regnete, gingen wir.', 'Obwohl es regnete, gingen wir.'),
            ('Trotz dem Regen gingen wir spazieren.', 'Trotz des Regens gingen wir spazieren.'),
            ('So teuer die Reise war auch, sie hat sich gelohnt.', 'So teuer die Reise auch war, sie hat sich gelohnt.'),
        ], 1),
        write('Say it another way', 'Write it with trotz.', [
            ('Obwohl es regnete, gingen wir spazieren.', 'Trotz des Regens gingen wir spazieren.'),
            ('Obwohl der Preis hoch ist, kaufen wir es.', 'Trotz des hohen Preises kaufen wir es.'),
            ('Obwohl es Mitternacht war, las er weiter.', 'Trotz der späten Stunde las er weiter.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('Although it was expensive, we bought it.', 'Obwohl es teuer war, haben wir es gekauft.'),
            ('Even if it rains, we’re going.', 'Selbst wenn es regnet, gehen wir.'),
        ], 1, not_german=True),
    ],
    'adversativ': [
        write(MISTAKE, MISTAKE_I, [
            ('Während es im Norden kalt ist, es ist im Süden warm.', 'Während es im Norden kalt ist, ist es im Süden warm.'),
            ('Der Süden dagegen trocken ist.', 'Der Süden dagegen ist trocken.'),
            ('Anders wie sein Bruder mag er Sport.', 'Anders als sein Bruder mag er Sport.'),
            ('Die Preise stiegen, während blieben die Löhne gleich.', 'Die Preise stiegen, während die Löhne gleich blieben.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('Cities are growing; villages, by contrast, are shrinking.', 'Städte wachsen; Dörfer dagegen schrumpfen.'),
            ('Unlike his brother, he likes sport.', 'Anders als sein Bruder mag er Sport.'),
            ('While she cooks, the cat orders pizza.', 'Während sie kocht, bestellt die Katze Pizza.'),
        ], 1, not_german=True),
    ],
    'relativ': [
        write(MISTAKE, MISTAKE_I, [
            ('Alles, das er sagt, stimmt.', 'Alles, was er sagt, stimmt.'),
            ('Wer du hilfst, der dankt dir.', 'Wem du hilfst, der dankt dir.'),
            ('Das ist etwas, darauf ich mich freue.', 'Das ist etwas, worauf ich mich freue.'),
            ('Der Termin, den ich so lange gewartet habe, ist morgen.', 'Der Termin, auf den ich so lange gewartet habe, ist morgen.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('Everything he says is true.', 'Alles, was er sagt, stimmt.'),
            ('Whoever sleeps well learns better.', 'Wer gut schläft, lernt besser.'),
            ('The town I grew up in is small.', 'Die Stadt, in der ich aufgewachsen bin, ist klein.'),
            ('Nothing he says is true.', 'Nichts, was er sagt, stimmt.'),
        ], 1, not_german=True),
    ],
    'verweiswoerter': [
        write('Make it a text', 'Join: start the second sentence with the word in brackets.', [
            ('Er trainiert täglich. Er bleibt fit. (dadurch)', 'Er trainiert täglich. Dadurch bleibt er fit.'),
            ('Sie sparte zwei Jahre. Sie kaufte ein Auto. (damit)', 'Sie sparte zwei Jahre. Damit kaufte sie ein Auto.'),
            ('Der Bus kam nicht. Wir gingen zu Fuß. (deshalb)', 'Der Bus kam nicht. Deshalb gingen wir zu Fuß.'),
            ('Die Wohnung ist klein. Sie ist teuer. (zudem)', 'Die Wohnung ist klein. Zudem ist sie teuer.'),
            ('Er war krank. Er kam zur Arbeit. (trotzdem)', 'Er war krank. Trotzdem kam er zur Arbeit.'),
            ('Wir besprachen den Plan. Wir fanden mehrere Fehler. (dabei)', 'Wir besprachen den Plan. Dabei fanden wir mehrere Fehler.'),
        ], 1),
        write(MISTAKE, MISTAKE_I, [
            ('Er sparte Geld. Damit er kaufte ein Auto.', 'Er sparte Geld. Damit kaufte er ein Auto.'),
            ('Zwei Vorschläge: Letzterer wurde abgelehnt, Letzterer angenommen.', 'Zwei Vorschläge: Ersterer wurde abgelehnt, Letzterer angenommen.'),
            ('Die Stadt baute eine Brücke. Dieser kostete Millionen.', 'Die Stadt baute eine Brücke. Diese kostete Millionen.'),
            ('Die Kosten sind hoch. Zudem die Zeit ist knapp.', 'Die Kosten sind hoch. Zudem ist die Zeit knapp.'),
            ('Er war krank. Aus diesem Grund er blieb zu Hause.', 'Er war krank. Aus diesem Grund blieb er zu Hause.'),
        ], 1),
    ],
    'indefinit': [
        write(MISTAKE, MISTAKE_I, [
            ('Ich helfe jemanden gern.', 'Ich helfe jemandem gern.'),
            ('Hast du ein Auto? – Nein, ich habe keinen.', 'Hast du ein Auto? – Nein, ich habe keins.'),
            ('Gibt es noch Milch? – Ja, es gibt noch eine.', 'Gibt es noch Milch? – Ja, es gibt noch welche.'),
            ('Man muss ihn beeilen.', 'Man muss sich beeilen.'),
            ('Ich habe mit niemand gesprochen.', 'Ich habe mit niemandem gesprochen.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('Somebody is calling.', 'Jemand ruft an.'),
            ('Do you have apples? – Yes, I have some.', 'Hast du Äpfel? – Ja, ich habe welche.'),
            ('I know someone who can help you.', 'Ich kenne jemanden, der dir helfen kann.'),
            ('Nobody helps one.', 'Niemand hilft einem.'),
        ], 1, not_german=True),
    ],
    'beschwerde': [
        write(MISTAKE, MISTAKE_I, [
            ('Zwar kam der Techniker pünktlich, und der Schaden ist noch da.', 'Zwar kam der Techniker pünktlich, aber der Schaden ist noch da.'),
            ('Ich bitte Sie, den Mangel bis 15. Juni beheben.', 'Ich bitte Sie, den Mangel bis 15. Juni zu beheben.'),
            ('Andernfalls ich würde den Betrag mindern.', 'Andernfalls würde ich den Betrag mindern.'),
            ('Die Lieferung kam spät, obwohl sie war für den 3. Mai zugesagt.', 'Die Lieferung kam spät, obwohl sie für den 3. Mai zugesagt war.'),
        ], 1),
        write('Write it the formal way', TRANSLATE_I, [
            ('Please fix the damage by 15 June at the latest.', 'Ich bitte Sie, den Schaden bis spätestens 15. Juni zu beheben.'),
            ('Despite repeated promises, nothing has happened so far.', 'Trotz mehrfacher Zusagen ist bislang nichts geschehen.'),
            ('Of the twelve chairs ordered, four were damaged.', 'Von den bestellten zwölf Stühlen waren vier beschädigt.'),
            ('Otherwise I would reduce the amount by 30 percent.', 'Andernfalls würde ich den Betrag um 30 Prozent mindern.'),
            ('The invoice is wrong.', 'Die Rechnung ist falsch.'),
        ], 1, not_german=True),
    ],
    'review_3': [
        gaps('Which word?', 'Write obwohl, trotz, während, dagegen or dadurch.', [
            ('', 'des Sturms fuhr der Bus.', 'Trotz'),
            ('', 'es spät war, rief er noch an.', 'Obwohl'),
            ('', 'sie Tee trinkt, trinkt er Kaffee.', 'Während'),
            ('Im Norden regnet es; im Süden', 'scheint die Sonne.', 'dagegen'),
            ('Sie liest viel.', 'spricht sie immer besser.', 'Dadurch'),
        ]),
        gaps('Someone, some', 'Write the missing word.', [
            ('Ich kenne', 'in Wien. (jemand)', 'jemanden'),
            ('Das hat', 'gesehen. (niemand)', 'niemand'),
            ('Hast du einen Schirm? – Nein, ich habe', '.', 'keinen'),
            ('Brauchst du Äpfel? – Nein, ich habe schon', '.', 'welche'),
            ('Ich helfe', 'gern. (jemand)', 'jemandem'),
        ]),
        write('Join them', 'Join with the word in brackets.', [
            ('Er hatte wenig Zeit. Er half uns. (trotzdem)', 'Er hatte wenig Zeit. Trotzdem half er uns.'),
            ('Sie trainiert täglich. Sie bleibt fit. (dadurch)', 'Sie trainiert täglich. Dadurch bleibt sie fit.'),
            ('Das Hotel ist teuer. Es ist schön. (zwar … aber)', 'Zwar ist das Hotel teuer, aber es ist schön.'),
            ('Er sparte Geld. Er kaufte ein Rad. (damit)', 'Er sparte Geld. Damit kaufte er ein Rad.'),
        ], 1),
        gaps('Your complaint', 'Something you ordered came broken. Finish the sentences.', [
            ('Trotz mehrfacher Zusagen', '.'), ('Ich bitte Sie, bis spätestens', '.'), ('Andernfalls', '.'),
        ], 'About you.'),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        write(MISTAKE, MISTAKE_I, [
            ('Wenn ich Zeit hätte, ich würde kommen.', 'Wenn ich Zeit hätte, würde ich kommen.'),
            ('Wir wären früher aufstehen sollen.', 'Wir hätten früher aufstehen sollen.'),
            ('Er tut so, als ob er alles weiß.', 'Er tut so, als ob er alles wüsste.'),
            ('Sie wird schon nach Hause gegangen haben.', 'Sie wird schon nach Hause gegangen sein.'),
            ('Wir verzichten für Plastik.', 'Wir verzichten auf Plastik.'),
            ('Er wird wohl krank ist.', 'Er wird wohl krank sein.'),
            ('Hätte ich das gewusst, ich wäre gekommen.', 'Hätte ich das gewusst, wäre ich gekommen.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('If I had time, I would come.', 'Wenn ich Zeit hätte, würde ich kommen.'),
            ('You should have called.', 'Du hättest anrufen sollen.'),
            ('He is said to be rich.', 'Er soll reich sein.'),
            ('She will probably be ill.', 'Sie wird wohl krank sein.'),
            ('Then we’ll just take the bus.', 'Dann nehmen wir eben den Bus.'),
            ('Don’t you dare do that!', 'Mach das bloß nicht!'),
        ], 1, not_german=True),
    ],
    'review_2': [
        write(MISTAKE, MISTAKE_I, [
            ('Wegen dem Streik blieb das Büro zu.', 'Wegen des Streiks blieb das Büro zu.'),
            ('Er hat mir eine Frage gemacht.', 'Er hat mir eine Frage gestellt.'),
            ('Der Prüfung war schwer.', 'Die Prüfung war schwer.'),
            ('Die Tür lässt nicht öffnen.', 'Die Tür lässt sich nicht öffnen.'),
            ('Bei schön Wetter essen wir draußen.', 'Bei schönem Wetter essen wir draußen.'),
            ('Innerhalb einem Monat war alles fertig.', 'Innerhalb eines Monats war alles fertig.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('Because of the rain, the match was cancelled.', 'Wegen des Regens fiel das Spiel aus.'),
            ('The water is drinkable.', 'Das Wasser ist trinkbar.'),
            ('The board made a decision.', 'Der Vorstand hat eine Entscheidung getroffen.'),
            ('The fast-growing company needs new offices.', 'Das schnell wachsende Unternehmen braucht neue Büros.'),
            ('Luckily, the dog is friendly.', 'Glücklicherweise ist der Hund freundlich.'),
        ], 1, not_german=True),
    ],
    'review_3': [
        write(MISTAKE, MISTAKE_I, [
            ('Obwohl es kalt war, trotzdem ging er schwimmen.', 'Obwohl es kalt war, ging er schwimmen.'),
            ('Während er Sport mag, sein Bruder liest lieber.', 'Während er Sport mag, liest sein Bruder lieber.'),
            ('Alles, das du sagst, stimmt.', 'Alles, was du sagst, stimmt.'),
            ('Wen du hilfst, der dankt dir.', 'Wem du hilfst, der dankt dir.'),
            ('Er sparte Geld. Damit er kaufte ein Rad.', 'Er sparte Geld. Damit kaufte er ein Rad.'),
            ('Hast du einen Stift? – Ja, ich habe eins.', 'Hast du einen Stift? – Ja, ich habe einen.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('Although it was raining, we went for a walk.', 'Obwohl es regnete, gingen wir spazieren.'),
            ('Nobody helped me.', 'Niemand hat mir geholfen.'),
            ('Do you have milk? – Yes, I have some.', 'Hast du Milch? – Ja, ich habe welche.'),
            ('However tired he was, he read until midnight.', 'So müde er auch war, er las bis Mitternacht.'),
            ('The south, by contrast, is dry.', 'Der Süden dagegen ist trocken.'),
        ], 1, not_german=True),
        gaps('About you', 'Finish the sentences.', [
            ('Obwohl ich wenig Zeit habe,', '.'), ('Im Gegensatz zu meinen Freunden', '.'),
        ], 'About you.'),
    ],
}
