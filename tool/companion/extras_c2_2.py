# Extra exercises that fill the C2.2 practice and review pages (rules: docs/study_companion_guide.md).
# Merged by kit.write_book when tool/companion/c2_2.py runs; fit_extras.py decides how many fit each page.
from kit import circle, gaps, write

MISTAKE = 'Find the mistake'
MISTAKE_HOW = 'Each sentence has one mistake. Write it correctly.'
ENGLISH = 'In German'
ENGLISH_HOW = 'Write it in German.'
ABOUT = 'About you.'

EXTRAS = {
    'philosophie': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Wer ein Amt annimmt, muss die Verantwortung nehmen.', 'Wer ein Amt annimmt, muss die Verantwortung tragen.'),
            ('Die Determinismus ist eine These.', 'Der Determinismus ist eine These.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('The end does not justify the means.', 'Der Zweck heiligt nicht die Mittel.'),
            ('Nobody denies that science has made progress.', 'Niemand stellt in Abrede, dass die Wissenschaft Fortschritte gemacht hat.'),
        ], 1, not_german=True),
        gaps('About you', 'Write one thing you do out of duty and one out of inclination.', [('Aus Pflicht:', '.'), ('Aus Neigung:', '.')], ABOUT),
    ],
    'fokus': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Es ist nur drei Uhr, wir haben noch Zeit.', 'Es ist erst drei Uhr, wir haben noch Zeit.'),
            ('Der zweite Winter war selbst kälter.', 'Der zweite Winter war noch kälter.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('Even the boss knew nothing.', 'Selbst der Chef wusste nichts.'),
            ('Not even the opposition knew it.', 'Nicht einmal die Opposition wusste es.'),
        ], 1, not_german=True),
        gaps('About you', 'Write what happened to you today of all days.', [('Ausgerechnet heute', '.')], ABOUT),
    ],
    'anspielung': [
        write('Plain words', 'Say what the speaker really means.', [
            ('„Ganz schön frisch hier.“', 'Bitte mach das Fenster zu.'),
            ('„Ich will Sie nicht länger aufhalten.“', 'Das Gespräch ist beendet.'),
            ('„Die Kosten waren nicht unerheblich.“', 'Die Kosten waren hoch.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('The task is anything but easy.', 'Die Aufgabe ist alles andere als leicht.'),
        ], 1, not_german=True),
        gaps('About you', 'Write something you say when you want guests to go.', [('', '.')], ABOUT),
    ],
    'paraphrase': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Er starb bei einem Unfall ums Leben.', 'Er kam bei einem Unfall ums Leben.'),
            ('Eine Vielzahl von Einwendungen sind eingegangen.', 'Eine Vielzahl von Einwendungen ist eingegangen.'),
            ('Es kamen keinerlei.', 'Es kamen keinerlei Argumente.'),
        ], 1),
        write('One step up', 'Write it with the weightier phrase.', [
            ('Das ist wichtig.', 'Das ist von Bedeutung.'),
            ('Die Stadt fängt mit der Sanierung an.', 'Die Stadt nimmt die Sanierung in Angriff.'),
        ], 1),
    ],
    'wortspiel': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Die Regierung will das Steuer senken.', 'Die Regierung will die Steuer senken.'),
        ], 1),
        write('Two meanings', 'Write both meanings in English.', [
            ('der Hahn', 'tap · rooster'), ('die Birne', 'pear · light bulb'), ('das Schloss', 'lock · palace'), ('der Flügel', 'wing · grand piano'),
        ], 2),
    ],
    'redewendungen': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Sie hat mich den Rang abgelaufen.', 'Sie hat mir den Rang abgelaufen.'),
            ('Mit seinem Lob hat er der Kollegin einen Bärendienst gemacht.', 'Mit seinem Lob hat er der Kollegin einen Bärendienst erwiesen.'),
            ('Die Verwaltung ist ins Hintertreffen gekommen.', 'Die Verwaltung ist ins Hintertreffen geraten.'),
        ], 1),
        gaps('About you', 'Write one thing you push onto the long bench.', [('Ich schiebe', 'auf die lange Bank.')], ABOUT),
    ],
    'fremdwoerter': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Die Regierung hat die Reform sensibel umgesetzt – ohne Ausnahme.', 'Die Regierung hat die Reform konsequent umgesetzt – ohne Ausnahme.'),
            ('Die Unterschiede sind ambivalent und ändern nichts am Ergebnis.', 'Die Unterschiede sind marginal und ändern nichts am Ergebnis.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('We may possibly come a bit later.', 'Wir kommen eventuell etwas später.'),
            ('In law the president decides; in fact parliament decides.', 'De jure entscheidet der Präsident, de facto das Parlament.'),
        ], 1, not_german=True),
    ],
    'wissenschaft': [
        write('Make it academic', 'Write it without “ich”.', [
            ('Ich glaube, die Zahlen steigen.', 'Es ist davon auszugehen, dass die Zahlen steigen.'),
            ('Wir zeigen, dass der Effekt altersabhängig ist.', 'Die Studie kommt zu dem Ergebnis, dass der Effekt altersabhängig ist.'),
        ], 1),
        write(MISTAKE, MISTAKE_HOW, [
            ('Im Hinblick der Kosten ist der Plan kritisch zu bewerten.', 'Im Hinblick auf die Kosten ist der Plan kritisch zu bewerten.'),
        ], 1),
    ],
    'praepositionen': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Gemäß der Vorschriften wurde die Brücke gesperrt.', 'Gemäß den Vorschriften wurde die Brücke gesperrt.'),
            ('Zufolge dem Gutachten ist die Brücke nicht sicher.', 'Dem Gutachten zufolge ist die Brücke nicht sicher.'),
        ], 1),
        write('Unpack it', 'Write it with wenn or weil.', [
            ('vorbehaltlich der Zustimmung →', 'wenn man zustimmt'),
            ('kraft seines Amtes →', 'weil es sein Amt ist'),
        ], 1),
    ],
    'nominalstil': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Die Sitzung erfolgt am Montag.', 'Die Sitzung findet am Montag statt.'),
            ('nach Schließung das Werk', 'nach Schließung des Werks'),
        ], 1),
        write('Pack it', 'Write it as a noun phrase.', [
            ('weil die Kosten stiegen', 'wegen steigender Kosten'),
            ('wenn die Gebühr nicht gezahlt wird', 'bei Nichtzahlung der Gebühr'),
        ], 1),
    ],
    'behoerde': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Für eine Ordnungswidrigkeit bekommt man eine Geldstrafe.', 'Für eine Ordnungswidrigkeit bekommt man eine Geldbuße.'),
            ('Gegen den Bußgeldbescheid legt man Berufung ein.', 'Gegen den Bußgeldbescheid legt man Einspruch ein.'),
        ], 1),
        write('Three questions', 'Answer for the parking letter.', [
            ('Was ist der Vorwurf?', 'Sie hat in einer Feuerwehrzufahrt geparkt.'),
            ('Was muss sie bis wann tun?', 'Den Bogen binnen einer Woche zurücksenden.'),
        ], 1),
    ],
    'appositionen': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Wir sprachen mit Dr. Weber, die Leiterin des Instituts.', 'Wir sprachen mit Dr. Weber, der Leiterin des Instituts.'),
            ('Wir trafen Herrn Klein, unser neuer Nachbar.', 'Wir trafen Herrn Klein, unseren neuen Nachbarn.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('The conference takes place in Berlin, the German capital.', 'Die Tagung findet in Berlin, der deutschen Hauptstadt, statt.'),
        ], 1, not_german=True),
    ],
    'modalverben': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Er musste krank gewesen sein.', 'Er muss krank gewesen sein.'),
            ('Sie brauchen nicht kommen.', 'Sie brauchen nicht zu kommen.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('It must have rained in the night.', 'Es muss in der Nacht geregnet haben.'),
            ('The bus is probably late.', 'Der Bus dürfte Verspätung haben.'),
        ], 1, not_german=True),
    ],
    'passiv': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Er ist festgenommen geworden.', 'Er ist festgenommen worden.'),
            ('Auf der Hochzeit es wurde getanzt.', 'Auf der Hochzeit wurde getanzt.'),
        ], 1),
        write('Say it another way', 'Write it with lässt sich.', [
            ('Das Problem kann behoben werden.', 'Das Problem lässt sich beheben.'),
        ], 1),
    ],
    'adverbial': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Er blieb zu Hause, denn war er krank.', 'Er blieb zu Hause, denn er war krank.'),
            ('Er war krank; deshalb er blieb zu Hause.', 'Er war krank; deshalb blieb er zu Hause.'),
            ('Kaum war er angekommen, er rief an.', 'Kaum war er angekommen, da rief er an.'),
        ], 1),
        write('Three shapes', 'Write it with trotzdem.', [
            ('Obwohl es regnete, fand das Konzert statt.', 'Es regnete; trotzdem fand das Konzert statt.'),
        ], 1),
    ],
    'streit': [
        write('Say it politely hard', 'Write it with the phrase from the left page.', [
            ('Das stimmt nicht!', 'Da irren Sie sich gewaltig.'),
            ('Lassen Sie mich ausreden!', 'Wenn Sie mich ausreden ließen, …'),
        ], 1),
        gaps('About you', 'Concede a point, then say your but.', [('Das bestreite ich gar nicht. Aber', '.')], ABOUT),
    ],
    'eroerterung': [
        write('Frame it', 'Write the question in the Erörterung frame.', [
            ('Darf der Staat eingreifen?', 'Zu klären ist nicht, ob der Staat eingreifen darf, sondern unter welchen Bedingungen.'),
        ], 1),
        write('Which half?', 'Write the view the author rejects.', [
            ('Das Vergessen ist keine bloße Schwäche des Gedächtnisses, sondern vielmehr …', 'Das Vergessen ist eine bloße Schwäche des Gedächtnisses.'),
        ], 1),
    ],
    'dach': [
        write('In Germany', 'Write the word used in Germany.', [
            ('die Marillen', 'die Aprikosen'), ('das Velo', 'das Fahrrad'), ('heuer', 'dieses Jahr'), ('das Obers', 'die Sahne'),
        ], 2),
        write(MISTAKE, 'A Swiss notice. Write the word the Swiss way.', [
            ('Das Fahrrad darf nicht auf dem Trottoir parkiert werden.', 'Das Velo darf nicht auf dem Trottoir parkiert werden.'),
        ], 1),
    ],
    'rezension': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Der Roman handelt sich um einen Mann.', 'Der Roman handelt von einem Mann.'),
            ('Die Wendung bedeutet als Bild für die Familie.', 'Die Wendung lässt sich als Bild für die Familie deuten.'),
        ], 1),
        gaps('About you', 'Write a verdict on a book you have read.', [('Insgesamt erweist sich der Roman als', '.')], ABOUT),
    ],
    'lyrik': [
        write('The rhyme', 'Write the word that rhymes.', [
            ('Ameisen –', 'reisen'), ('Chaussee –', 'weh'), ('Wiesel –', 'Kiesel'),
        ], 3),
        gaps('About you', 'Write a big plan you gave up early.', [('Ich wollte', ', aber …')], ABOUT),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Es ist nur drei Uhr, noch früh.', 'Es ist erst drei Uhr, noch früh.'),
            ('Er starb bei einem Unfall ums Leben.', 'Er kam bei einem Unfall ums Leben.'),
            ('Die Unterschiede sind ambivalent und ändern nichts am Ergebnis.', 'Die Unterschiede sind marginal und ändern nichts am Ergebnis.'),
        ], 1),
        write('Plain words', 'Say what the speaker really means.', [
            ('„Wir melden uns.“', 'Eine Absage.'), ('„Die Aufgabe ist alles andere als leicht.“', 'Die Aufgabe ist sehr schwer.'),
        ], 1),
        gaps('About you', 'Write one idiom you can use at work.', [('', '.')], ABOUT),
    ],
    'review_2': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Gemäß der Vorschriften', 'Gemäß den Vorschriften'),
            ('Wir sprachen mit Dr. Weber, die Leiterin.', 'Wir sprachen mit Dr. Weber, der Leiterin.'),
            ('Er ist festgenommen geworden.', 'Er ist festgenommen worden.'),
        ], 1),
        write('Make it academic', 'Write it without “ich”.', [
            ('Ich glaube, die Zahlen steigen.', 'Es ist davon auszugehen, dass die Zahlen steigen.'),
        ], 1),
        gaps('About you', 'Write one sentence from an official letter you got.', [('', '.')], ABOUT),
    ],
    'review_3': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Der Roman handelt sich um einen Mann.', 'Der Roman handelt von einem Mann.'),
            ('Da irren Sie sich schön.', 'Da irren Sie sich gewaltig.'),
        ], 1),
        write('In Germany', 'Write the word used in Germany.', [('der Jänner', 'der Januar'), ('das Billett', 'die Fahrkarte')], 2),
        gaps('Your verdict', 'Write a verdict on this book.', [('Insgesamt erweist sich das Buch als', '.')], ABOUT),
    ],
}

MORE = {
    'review_1': [
        write(ENGLISH, ENGLISH_HOW, [
            ('Even the boss knew nothing.', 'Selbst der Chef wusste nichts.'),
            ('The reform was shelved.', 'Die Reform wurde auf die lange Bank geschoben.'),
        ], 1, not_german=True),
        gaps('About you', 'Write a sentence with ausgerechnet.', [('Ausgerechnet', '.')], ABOUT),
    ],
    'review_2': [
        write('Unpack it', 'Write it as a clause.', [
            ('nach der Schließung des Werks durch den Konzern', 'nachdem der Konzern das Werk geschlossen hatte'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('It must have rained in the night.', 'Es muss in der Nacht geregnet haben.'),
            ('The problem can be fixed.', 'Das Problem lässt sich beheben.'),
        ], 1, not_german=True),
        gaps('About you', 'Write one sentence with Sollten Sie …', [('Sollten Sie', '.')], ABOUT),
    ],
    'review_3': [
        write('The rhyme', 'Write the word that rhymes.', [('Ameisen –', 'reisen'), ('weise –', 'Reise')], 2),
        gaps('Your objection', 'Write the strongest objection to an idea.', [('Der gewichtigste Einwand lautet,', '.')], ABOUT),
        gaps('Your reading', 'Write what an object in a story stands for.', [('Das Motiv des … steht für', '.')], ABOUT),
    ],
}
for k, v in MORE.items():
    EXTRAS.setdefault(k, []).extend(v)

# Second round: pages that still had room.
ROUND2 = {
    'wortspiel': [
        gaps('der, die or das?', 'Write the article.', [
            ('', 'Leiter der Firma steht auf der Leiter.', 'Der'), ('Der Leiter der Firma steht auf', 'Leiter.', 'der'),
            ('Im Wald steht', 'Kiefer.', 'die'), ('Der Zahnarzt sieht sich', 'Kiefer an.', 'den'),
        ]),
        gaps('About you', 'Write a headline with a double meaning.', [('', '.')], ABOUT),
    ],
    'streit': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Wenn Sie mich ausreden lassen, käme ich auf diesen Punkt.', 'Wenn Sie mich ausreden ließen, käme ich auf diesen Punkt.'),
            ('Sie verwechseln Ursache und Behauptung.', 'Sie verwechseln Ursache und Wirkung.'),
        ], 1),
        write('Name the fault', 'Write the phrase for the fault in the argument.', [
            ('Nicht die Regel treibt die Mieten, sondern der Mangel.', 'Sie verwechseln Ursache und Wirkung.'),
            ('Sie setzen voraus, was Sie beweisen wollen.', 'Ihr Argument ist ein Zirkelschluss.'),
        ], 1),
    ],
    'appositionen': [
        gaps('The same case', 'Write the words in brackets in the right case.', [
            ('wegen des Streiks,', 'der längsten (einer)', 'eines'),
            ('Wir trafen Herrn Klein,', '. (unser neuer Nachbar)', 'unseren neuen Nachbarn'),
        ]),
        gaps('About you', 'Write about a person you know, with an apposition.', [('Ich kenne', ', …')], ABOUT),
    ],
    'modalverben': [
        write('Say it with a modal verb', 'Write it with soll, will or dürfte.', [
            ('Er war angeblich informiert.', 'Er soll informiert gewesen sein.'),
            ('Es steht zu erwarten, dass die Mieten steigen.', 'Die Mieten dürften steigen.'),
        ], 1),
        gaps('About you', 'Write something people say about a famous person.', [('Er soll', '.')], ABOUT),
    ],
    'passiv': [
        write('What is in focus?', 'Write action, result, duty or possibility.', [
            ('Die Fassade wird renoviert.', 'action'), ('Montags ist das Museum geschlossen.', 'result'),
            ('Der Antrag ist einzureichen.', 'duty'), ('Das Gerät ist reparierbar.', 'possibility'),
        ], 2),
        write(ENGLISH, ENGLISH_HOW, [
            ('The museum is closed on Mondays.', 'Montags ist das Museum geschlossen.'),
        ], 1, not_german=True),
    ],
    'dach': [
        write(ENGLISH, ENGLISH_HOW, [
            ('This year there are particularly many apricots. (Austria)', 'Heuer gibt es besonders viele Marillen.'),
        ], 1, not_german=True),
        gaps('About you', 'Write one Austrian or Swiss word you like.', [('', '.')], ABOUT),
    ],
    'redewendungen': [
        write(ENGLISH, ENGLISH_HOW, [
            ('The reform was shelved.', 'Die Reform wurde auf die lange Bank geschoben.'),
            ('Nobody can match her.', 'Niemand kann ihr das Wasser reichen.'),
        ], 1, not_german=True),
    ],
    'adverbial': [
        write('Make it one sentence', 'Write it with um … zu or damit.', [
            ('Sie lernte jeden Abend. Sie wollte die Prüfung bestehen.', 'Sie lernte jeden Abend, um die Prüfung zu bestehen.'),
        ], 1),
        gaps('About you', 'Write what you do every evening and why.', [('Ich', ', um … zu …')], ABOUT),
    ],
    'lyrik': [
        write('The effect', 'Say in German what the word does.', [
            ('„weise“', 'Eine Niederlage wird zur klugen Entscheidung.'),
        ], 1),
    ],
    'fremdwoerter': [
        gaps('About you', 'Write one Latin word you will use in an essay.', [('', '.')], ABOUT),
    ],
}
ROUND2_LEFT = {
    'review_1': [
        write(ENGLISH, ENGLISH_HOW, [
            ('We may possibly come a bit later.', 'Wir kommen eventuell etwas später.'),
            ('The end does not justify the means.', 'Der Zweck heiligt nicht die Mittel.'),
        ], 1, not_german=True),
        gaps('The article', 'Write der, die or das.', [('Die Regierung will', 'Steuer senken.', 'die'), ('Wir schwimmen im See.', 'See ist tief.', 'Der')]),
    ],
    'review_2': [
        write('Pack it', 'Write it as a noun phrase.', [('weil die Kosten stiegen', 'wegen steigender Kosten')], 1),
        write(ENGLISH, ENGLISH_HOW, [('The bus is probably late.', 'Der Bus dürfte Verspätung haben.')], 1, not_german=True),
        gaps('Write it formally', 'Write the plain word as officialese.', [('Sie müssen bis zum 15. Mai zahlen. → Der Betrag ist bis zum 15. Mai zu', '.', 'entrichten')]),
    ],
    'review_3': [
        write('Plain words', 'Say what the speaker really means.', [('Den leeren Koffer trug er in den Keller.', 'Er wird nicht mehr reisen – und das ist gut so.')], 1),
        write(ENGLISH, ENGLISH_HOW, [('You are gravely mistaken there.', 'Da irren Sie sich gewaltig.')], 1, not_german=True),
        gaps('Your opening', 'Write the first sentence of a review.', [('In ihrem Roman', '…')], ABOUT),
    ],
}
ROUND2_RIGHT = {
    'review_1': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Eine Vielzahl von Einwendungen sind eingegangen.', 'Eine Vielzahl von Einwendungen ist eingegangen.'),
            ('Mit seinem Lob hat er der Kollegin einen Bärendienst gemacht.', 'Mit seinem Lob hat er der Kollegin einen Bärendienst erwiesen.'),
        ], 1),
        write('One step up', 'Write it with the weightier phrase.', [('Alle Unterlagen sind sofort einzureichen.', 'Sämtliche Unterlagen sind umgehend einzureichen.')], 1),
        write('Plain words', 'Say what the speaker really means.', [('„Sie sind ja früh dran.“ (zu einer Person, die zu spät kommt)', 'Sie sind zu spät.')], 1),
        gaps('About you', 'Write a sentence with nicht unerheblich.', [('', 'nicht unerheblich.')], ABOUT),
        gaps('About you', 'Write a sentence with de facto.', [('De facto', '.')], ABOUT),
    ],
    'review_2': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Er blieb zu Hause, denn war er krank.', 'Er blieb zu Hause, denn er war krank.'),
            ('Die Sitzung erfolgt am Montag.', 'Die Sitzung findet am Montag statt.'),
            ('Zufolge dem Gutachten ist die Brücke nicht sicher.', 'Dem Gutachten zufolge ist die Brücke nicht sicher.'),
        ], 1),
        write('Unpack it', 'Write it with wenn or obwohl.', [('vorbehaltlich der Zustimmung →', 'wenn man zustimmt'), ('ungeachtet der Einwände →', 'obwohl es Einwände gibt')], 1),
        write('Say it another way', 'Write it with ist … zu.', [('Der Antrag muss bis Freitag eingereicht werden.', 'Der Antrag ist bis Freitag einzureichen.')], 1),
        gaps('About you', 'Write a sentence that starts with Kaum.', [('Kaum', ', da …')], ABOUT),
    ],
    'review_3': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Wenn Sie mich ausreden lassen, käme ich auf diesen Punkt.', 'Wenn Sie mich ausreden ließen, käme ich auf diesen Punkt.'),
            ('Die Wendung bedeutet als Bild für die Familie.', 'Die Wendung lässt sich als Bild für die Familie deuten.'),
        ], 1),
        write('In Germany', 'Write the word used in Germany.', [('die Marillen', 'die Aprikosen'), ('das Velo', 'das Fahrrad'), ('heuer', 'dieses Jahr'), ('die Matura', 'das Abitur')], 2),
        write('Name it', 'Write Ironie or Untertreibung.', [('„weise“', 'Ironie'), ('„den letzten Teil der Reise“', 'Untertreibung')], 2),
        gaps('About you', 'Concede a point, then say your but.', [('Das bestreite ich gar nicht. Aber', '.')], ABOUT),
        gaps('Your verdict', 'Write a verdict on a poem.', [('Das Gedicht lebt von', '.')], ABOUT),
    ],
}
for k, v in list(ROUND2.items()) + list(ROUND2_RIGHT.items()):
    EXTRAS.setdefault(k, []).extend(v)
for k, v in ROUND2_LEFT.items():
    EXTRAS_LEFT.setdefault(k, []).extend(v)
