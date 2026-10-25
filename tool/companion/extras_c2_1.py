# Extra exercises that fill the C2.1 practice and review pages (rules: docs/study_companion_guide.md).
# Merged by kit.write_book when tool/companion/c2_1.py runs; fit_extras.py decides how many fit each page.
from kit import circle, gaps, write

MISTAKE = 'Find the mistake'
MISTAKE_HOW = 'Each sentence has one mistake. Write it correctly.'
ENGLISH = 'In German'
ENGLISH_HOW = 'Write it in German.'

EXTRAS = {
    'wirtschaft': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Gegen den Bescheid legte sie Einspruch an.', 'Gegen den Bescheid legte sie Einspruch ein.'),
            ('Mehrere Firmen meldeten Insolvenz ein.', 'Mehrere Firmen meldeten Insolvenz an.'),
            ('Vor Gericht machte man einen Vergleich.', 'Vor Gericht schloss man einen Vergleich.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('The central bank raised the interest rate.', 'Die Zentralbank hob den Zinssatz an.'),
            ('Parliament passed the law.', 'Das Parlament hat das Gesetz verabschiedet.'),
        ], 1, not_german=True),
    ],
    'register': [
        write('Move it down', 'Write it the way you would say it to a friend.', [
            ('Er hat das Schreiben erhalten.', 'Er hat den Brief gekriegt.'),
            ('Wir müssen das überprüfen.', 'Wir müssen das checken.'),
            ('Der Mitarbeiter ist verärgert.', 'Der Typ ist sauer.'),
        ], 1),
        write(MISTAKE, 'Each sentence mixes two levels. Write it all formal.', [
            ('Der Mitarbeiter hat das Schreiben gekriegt.', 'Der Mitarbeiter hat das Schreiben erhalten.'),
            ('Wir müssen die Mittel checken.', 'Wir müssen die Mittel überprüfen.'),
        ], 1),
    ],
    'kollokationen': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Die Regierung machte Maßnahmen.', 'Die Regierung ergriff Maßnahmen.'),
            ('Die Opposition gab scharfe Kritik.', 'Die Opposition übte scharfe Kritik.'),
            ('Die Mannschaft hatte eine herbe Niederlage.', 'Die Mannschaft erlitt eine herbe Niederlage.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('We have to take a risk.', 'Wir müssen ein Risiko eingehen.'),
            ('The citizens had doubts.', 'Die Bürger hegten Zweifel.'),
        ], 1, not_german=True),
    ],
    'konnotation': [
        write('Warm it up', 'Write the sentence with the warm word.', [
            ('Er ist geizig.', 'Er ist sparsam.'), ('Sie ist stur.', 'Sie ist standhaft.'), ('Er ist pedantisch.', 'Er ist gründlich.'),
        ], 3),
        write('What does the government say?', 'Write the word the government would use.', [
            ('Kürzung', 'Reform'), ('Problem', 'Herausforderung'), ('entlassen', 'freisetzen'),
        ], 3),
        gaps('About you', 'Describe a friend twice: once warm, once cold.', [
            ('Warm: Mein Freund ist', '.'), ('Cold: Mein Freund ist', '.'),
        ], 'About you.'),
    ],
    'abtoenung': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Der Plan ist gerade absurd. (downright)', 'Der Plan ist geradezu absurd.'),
            ('Das ist durchaus sicher. (not at all)', 'Das ist durchaus nicht sicher.'),
        ], 1),
        write('Say it with one word', 'Rewrite with keineswegs, durchaus or immerhin.', [
            ('Das ist sicher nicht billig.', 'Das ist keineswegs billig.'),
            ('Das Ergebnis ist bescheiden, aber es ist ein Anfang.', 'Das Ergebnis ist bescheiden; immerhin ist es ein Anfang.'),
        ], 1),
        gaps('Your verdict', 'Judge a film you know with one shading word.', [('Der Film war', '.')], 'About you.'),
    ],
    'sprichwoerter': [
        write('The whole proverb', 'Write the whole proverb.', [
            ('Wer anderen eine Grube gräbt …', 'Wer anderen eine Grube gräbt, fällt selbst hinein.'),
            ('Wer im Glashaus sitzt …', 'Wer im Glashaus sitzt, sollte nicht mit Steinen werfen.'),
            ('Viele Köche …', 'Viele Köche verderben den Brei.'),
        ], 1),
        write(ENGLISH, 'Write the German proverb.', [
            ('Pride comes before a fall.', 'Hochmut kommt vor dem Fall.'),
            ('Lies are soon found out.', 'Lügen haben kurze Beine.'),
        ], 1, not_german=True),
    ],
    'komparation': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Berlin ist eine der größte Städte Europas.', 'Berlin ist eine der größten Städte Europas.'),
            ('Die Lage ist bei weitem ernster wie angenommen.', 'Die Lage ist bei weitem ernster als angenommen.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('That was by far the best proposal.', 'Das war bei weitem der beste Vorschlag.'),
            ('The situation is far more serious than assumed.', 'Die Lage ist weitaus ernster als angenommen.'),
        ], 1, not_german=True),
    ],
    'valenz': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Man beschuldigte ihn von Betrug.', 'Man beschuldigte ihn des Betrugs.'),
            ('Er widersprach den Vorschlag.', 'Er widersprach dem Vorschlag.'),
            ('Das Projekt bedarf eine Erklärung.', 'Das Projekt bedarf einer Erklärung.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('The city commemorated the victims.', 'Die Stadt gedachte der Opfer.'),
            ('That cost him the post.', 'Das kostete ihn den Posten.'),
        ], 1, not_german=True),
    ],
    'komposita': [
        write('Decode it', 'Write what the compound means, from the right.', [
            ('die Prüfungsordnung', 'die Ordnung für die Prüfung'), ('das Bücherregal', 'das Regal für die Bücher'),
            ('die Bundesstraße', 'die Straße des Bundes'),
        ], 1),
        circle('The right joint', 'Circle the right compound.', [
            ('der', ['Kindergarten', 'Kindgarten'], '', 'Kindergarten'), ('die', ['Sonnenbrille', 'Sonnebrille'], '', 'Sonnenbrille'),
            ('das', ['Bücherregal', 'Buchregal'], '', 'Bücherregal'), ('die', ['Buchhandlung', 'Buchshandlung'], '', 'Buchhandlung'),
        ], 2),
    ],
    'adjektive': [
        write('Say it with one word', 'Write one describing word for the phrase.', [
            ('kann lernen', 'lernfähig'), ('man kann ihm glauben', 'glaubwürdig'), ('genau zum Termin', 'termingerecht'),
            ('wie ein Meister', 'meisterhaft'),
        ], 2),
        write(ENGLISH, ENGLISH_HOW, [
            ('A unique, masterly performance.', 'Eine einzigartige, meisterhafte Aufführung.'),
            ('The flat was renovated on time.', 'Die Wohnung wurde termingerecht renoviert.'),
        ], 1, not_german=True),
    ],
    'praefixe': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Die Ministerin will auf alle Fragen beantworten.', 'Die Ministerin will alle Fragen beantworten.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('I made a mistake in my tax return.', 'Ich habe mich bei der Steuererklärung verrechnet.'),
            ('The team won the victory in injury time.', 'Die Mannschaft hat sich den Sieg in der Nachspielzeit erkämpft.'),
        ], 1, not_german=True),
    ],
    'konj2': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Klar ist, dass er es wissen müssen hätte.', 'Klar ist, dass er es hätte wissen müssen.'),
            ('Ich hätte beinahe gestürzt.', 'Ich wäre beinahe gestürzt.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('If only I had listened to you earlier!', 'Hätte ich doch nur früher auf dich gehört!'),
            ('We almost missed the last train.', 'Um ein Haar hätten wir den letzten Zug verpasst.'),
        ], 1, not_german=True),
    ],
    'konnektoren': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Er kannte die Risiken; gleichwohl er unterschrieb.', 'Er kannte die Risiken; gleichwohl unterschrieb er.'),
            ('Wiewohl er kannte die Risiken, unterschrieb er.', 'Wiewohl er die Risiken kannte, unterschrieb er.'),
        ], 1),
        write('Say it another way', 'Rewrite with the word in brackets.', [
            ('Obwohl er die Risiken kannte, unterschrieb er. (gleichwohl)', 'Er kannte die Risiken; gleichwohl unterschrieb er.'),
            ('Er war im Ausland, deshalb kann er es nicht gewesen sein. (mithin)', 'Er war im Ausland; er kann es mithin nicht gewesen sein.'),
        ], 1),
    ],
    'umformung': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Das Formular ist auszufüllen. = Das Formular kann ausgefüllt werden.', 'Das Formular ist auszufüllen. = Das Formular muss ausgefüllt werden.'),
        ], 1),
    ],
    'konj1': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Die Ministerin erklärte, die Lage ist ernst.', 'Die Ministerin erklärte, die Lage sei ernst.'),
            ('Die Gewerkschaft teilte mit, die Beschäftigten haben genug Zugeständnisse gemacht.', 'Die Gewerkschaft teilte mit, die Beschäftigten hätten genug Zugeständnisse gemacht.'),
        ], 1),
        write('Report it', 'Write it as a report: Er sagte, …', [
            ('„Die Lage ist ernst.“', 'Er sagte, die Lage sei ernst.'), ('„Wir werden die Maßnahmen überprüfen.“', 'Er sagte, man werde die Maßnahmen überprüfen.'),
        ], 1),
    ],
    'stilmittel': [
        write('Name it and say what it does', 'Write the device and its effect.', [
            ('Die Märkte strafen ab.', 'Personifikation – sie macht die Märkte lebendig.'),
            ('Er versprach Aufbruch und lieferte Stillstand.', 'Antithese – sie schärft den Kontrast.'),
        ], 1),
        gaps('Your image', 'Describe your city at night: one simile and one metaphor.', [('Die Stadt ist wie', '.'), ('Die Stadt ist', '.')], 'About you.'),
    ],
    'rede': [
        write('Build the speech', 'Write the device the sentence shows.', [
            ('Wir brauchen Mut. Wir brauchen Ausdauer.', 'Anapher'), ('Nicht die Technik entscheidet, sondern der Mensch.', 'Antithese'),
            ('Wer von uns hätte das für möglich gehalten?', 'rhetorische Frage'),
        ], 1),
        gaps('Your opening', 'Write the first sentence of a speech about your city.', [('Stellen Sie sich eine Stadt vor, in der', '.')], 'About you.'),
    ],
    'moderieren': [
        write('Steer it', 'Write what the moderator says.', [
            ('You want a clear answer: yes or no.', 'Um es zuzuspitzen: … – ja oder nein?'),
            ('You want to interrupt Herr Brandt politely.', 'Darf ich Sie an dieser Stelle kurz unterbrechen, Herr Brandt?'),
            ('You want to sum up in one sentence.', 'Ich fasse zusammen: …'),
        ], 1, not_german=True),
    ],
    'satire': [
        write('What it really means', 'Write what the speaker really means.', [
            ('Das nennt man Transparenz.', 'Es ist keine Transparenz – man muss nur lange warten.'),
            ('Medienbruchfrei, das ist ein schönes Wort.', 'Das Wort klingt gut, aber es stimmt nicht.'),
        ], 1),
    ],
    'kurzgeschichte': [
        write('Plain words', 'Say in plain words what the gesture shows.', [
            ('Die blaue Tasse blieb leer.', 'Ruth fehlt ihm.'),
            ('Die Tasse stellte er auf die Fensterbank.', 'Ruth soll noch dabei sein – sie sah gern auf den Hof.'),
        ], 1),
    ],
    'review_1': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Die Regierung machte Maßnahmen.', 'Die Regierung ergriff Maßnahmen.'),
            ('Berlin ist eine der größte Städte Europas.', 'Berlin ist eine der größten Städte Europas.'),
            ('Mehrere Firmen meldeten Insolvenz ein.', 'Mehrere Firmen meldeten Insolvenz an.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('The plan is by no means fully developed.', 'Der Plan ist keineswegs ausgereift.'),
            ('He received the letter. (formal)', 'Er hat das Schreiben erhalten.'),
        ], 1, not_german=True),
    ],
    'review_2': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Man beschuldigte ihn von Betrug.', 'Man beschuldigte ihn des Betrugs.'),
            ('Ich hätte beinahe gestürzt.', 'Ich wäre beinahe gestürzt.'),
            ('Er kannte die Risiken; gleichwohl er unterschrieb.', 'Er kannte die Risiken; gleichwohl unterschrieb er.'),
        ], 1),
    ],
    'review_3': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Die Ministerin erklärte, die Lage ist ernst.', 'Die Ministerin erklärte, die Lage sei ernst.'),
            ('Die Stille liegt wie ein Tuch. → Metapher', 'Die Stille liegt wie ein Tuch. → Vergleich'),
        ], 1),
        gaps('Your verdict', 'Write one balanced sentence about a debate you know.', [('Ich fasse zusammen:', '.')], 'About you.'),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        write('Three levels', 'Write the word in the other two levels.', [
            ('kriegen', 'bekommen – erhalten'), ('checken', 'prüfen – überprüfen'), ('Kohle', 'Geld – Mittel'),
        ], 3),
        write(ENGLISH, ENGLISH_HOW, [
            ('one of the largest cities in Europe', 'eine der größten Städte Europas'), ('a good reason', 'ein triftiger Grund'),
        ], 1, not_german=True),
    ],
    'review_2': [
        write('Build the compound', 'Write it as one word.', [
            ('der Markt für Arbeit', 'der Arbeitsmarkt'), ('der Garten für Kinder', 'der Kindergarten'), ('die Stadt mit der Universität', 'die Universitätsstadt'),
        ], 3),
        write(ENGLISH, ENGLISH_HOW, [
            ('The city commemorated the victims.', 'Die Stadt gedachte der Opfer.'), ('If only I had listened to you!', 'Hätte ich doch nur auf dich gehört!'),
        ], 1, not_german=True),
    ],
    'review_3': [
        write('Report it', 'Write it as a report: Sie sagte, …', [
            ('„Die Lage ist ernst.“', 'Sie sagte, die Lage sei ernst.'), ('„Wir haben alles versucht.“', 'Sie sagte, man habe alles versucht.'),
        ], 1),
        write('Name the device', 'Write the device.', [
            ('Die Häuser haben ihre Augen geschlossen.', 'Personifikation'), ('zäh wie Kaugummi', 'Vergleich'), ('nicht unerheblich', 'Litotes'),
        ], 3),
    ],
}


# ---- a second round, for the pages that still had room ----------------------------------
MORE = {
    'kollokationen': [
        gaps('About you', 'Use a fixed pair about yourself.', [('Ich habe einmal ein Risiko', ', als …'), ('Ich hege Zweifel an', '.')], 'About you.'),
    ],
    'abtoenung': [
        write(ENGLISH, ENGLISH_HOW, [
            ('The performance was decidedly successful.', 'Die Aufführung war ausgesprochen gelungen.'),
            ('That is not exactly cheap.', 'Das ist nicht gerade billig.'),
        ], 1, not_german=True),
    ],
    'sprichwoerter': [
        write('Use it', 'Finish the sentence with a proverb that fits.', [
            ('Er hat gelogen, und jetzt wissen es alle –', 'Lügen haben kurze Beine.'),
            ('Ein starkes Quartal ist erfreulich, aber', 'eine Schwalbe macht noch keinen Sommer.'),
        ], 1),
        gaps('About you', 'Which proverb fits your week? Write it and say why.', [('', ', weil …')], 'About you.'),
    ],
    'komparation': [
        write('Grade it', 'Rewrite with the words in brackets.', [
            ('Der Vorschlag war gut. (mit Abstand)', 'Der Vorschlag war mit Abstand der beste.'),
            ('Die Lage ist ernst. (immer)', 'Die Lage wird immer ernster.'),
            ('Das Hotel ist teuer. (doppelt so … wie das andere)', 'Das Hotel ist doppelt so teuer wie das andere.'),
        ], 1),
        gaps('About you', 'Compare your city with another one.', [('Meine Stadt ist', 'als …')], 'About you.'),
    ],
    'valenz': [
        gaps('Dative only', 'Write the words in brackets in the right case.', [
            ('Er widersprach', '. (die Regierung)', 'der Regierung'), ('Das schadet', '. (die Partei)', 'der Partei'),
        ]),
    ],
    'komposita': [
        write(ENGLISH, ENGLISH_HOW, [
            ('the front door', 'die Haustür'), ('the tram', 'die Straßenbahn'), ('the picture book', 'das Bilderbuch'),
            ('the bookshelf', 'das Bücherregal'),
        ], 2, not_german=True),
        gaps('Build your own', 'Make two compounds from words you know, and give their article.', [('', ''), ('', '')], 'About you.'),
    ],
    'adjektive': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Er geht sorgenfrei mit Geld um – leider.', 'Er geht sorglos mit Geld um – leider.'),
            ('Das ist ein Zufall, merkwürdig im Sinn von: sehr gut.', 'Das ist ein merkwürdiger Zufall – sehr seltsam.'),
        ], 1),
        gaps('About you', 'Describe a person you trust with two of these words.', [('Meine Freundin ist', 'und …')], 'About you.'),
    ],
    'praefixe': [
        write('ver-, zer-, er-, ent-', 'Write what the verb means in German words.', [
            ('zerreißen', 'in Stücke reißen'), ('entkalken', 'den Kalk entfernen'), ('sich verrechnen', 'falsch rechnen'),
        ], 1),
    ],
    'konj2': [
        write('Politely', 'Say it with distance: use the Konjunktiv II.', [
            ('Ich habe eine Frage.', 'Ich hätte da eine Frage.'),
            ('Ist es möglich, den Termin zu verschieben?', 'Wäre es möglich, den Termin zu verschieben?'),
        ], 1),
        gaps('About you', 'Write a near-miss from your life.', [('Um ein Haar', '.')], 'About you.'),
    ],
    'konnektoren': [
        write(ENGLISH, ENGLISH_HOW, [
            ('We should accept the offer, especially as the terms are good.', 'Wir sollten das Angebot annehmen, zumal die Konditionen gut sind.'),
            ('He was abroad; consequently he cannot have done it.', 'Er war im Ausland; mithin kann er es nicht gewesen sein.'),
        ], 1, not_german=True),
    ],
    'umformung': [
        write('Rephrase', 'Write it in the other form.', [
            ('Die Stadt hat das Gebäude saniert. → Das Gebäude …', 'Das Gebäude ist von der Stadt saniert worden.'),
            ('Der Fehler kann leicht behoben werden. → Der Fehler …', 'Der Fehler lässt sich leicht beheben.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('The building has been renovated by the city.', 'Das Gebäude ist von der Stadt saniert worden.'),
            ('Because of the fallen demand …', 'Wegen der gesunkenen Nachfrage …'),
        ], 1, not_german=True),
    ],
    'stilmittel': [
        write('Plain words', 'Say the image in plain words.', [
            ('Die Stille liegt wie ein Tuch über den Straßen.', 'Es ist sehr still.'),
            ('Jedes Licht ist eine kleine Insel.', 'Nur wenige Menschen sind wach.'),
        ], 1),
    ],
    'rede': [
        write('Make it a speech', 'Rewrite with the device in brackets.', [
            ('Wir brauchen Mut und Ausdauer. (Anapher)', 'Wir brauchen Mut. Wir brauchen Ausdauer.'),
            ('Der Mensch entscheidet, die Technik nicht. (Antithese)', 'Nicht die Technik entscheidet, sondern der Mensch.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('Thank you for your attention.', 'Ich danke Ihnen für Ihre Aufmerksamkeit.'),
            ('We need courage. We need each other.', 'Wir brauchen Mut. Wir brauchen einander.'),
        ], 1, not_german=True),
    ],
    'moderieren': [
        write(MISTAKE, 'Each sentence is too blunt for a moderator. Write it politely.', [
            ('Herr Brandt, ruhig jetzt!', 'Darf ich Sie an dieser Stelle kurz unterbrechen, Herr Brandt?'),
            ('Ja oder nein, schnell!', 'Um es zuzuspitzen: ja oder nein?'),
        ], 1),
        gaps('Your panel', 'You moderate a panel on your city. Write your first two sentences.', [
            ('Ich begrüße Sie herzlich zu', '.'), ('Lassen Sie uns mit der Frage beginnen,', '.'),
        ], 'About you.'),
    ],
    'satire': [
        write('Spot the technique', 'Write which technique the sentence uses: mock praise, jargon taken literally, or a set-up.', [
            ('Das nennt man Transparenz.', 'mock praise'), ('Medienbruchfrei, das ist ein schönes Wort.', 'jargon taken literally'),
        ], 1),
        gaps('Your gloss', 'Praise something that does not work — in two sentences.', [('Unser Bus ist', '.'), ('Das nennt man', '.')], 'About you.'),
    ],
    'kurzgeschichte': [
        write('The story in plain words', 'Answer in one sentence.', [
            ('Wer ist Ruth?', 'Brenners Frau, die gestorben ist.'),
            ('Was will Katrin?', 'Dass er die Wohnung ansieht.'),
        ], 1),
        gaps('Your ending', 'Write one sentence that continues the story.', [('Am Donnerstag', '.')], 'About you.'),
    ],
    'review_1': [
        gaps('About you', 'Describe your job in a formal and a spoken way.', [('Formal:', '.'), ('Spoken:', '.')], 'About you.'),
    ],
    'review_2': [
        write('Rephrase', 'Write it in the other form.', [
            ('Das Problem kann gelöst werden. → Das Problem …', 'Das Problem lässt sich lösen.'),
        ], 1),
        write(ENGLISH, ENGLISH_HOW, [
            ('We almost missed the last train.', 'Um ein Haar hätten wir den letzten Zug verpasst.'),
            ('He made a mistake in his tax return.', 'Er hat sich bei der Steuererklärung verrechnet.'),
        ], 1, not_german=True),
        gaps('About you', 'Write one sentence with wiewohl and one with zumal.', [('Wiewohl', '.'), ('…, zumal', '.')], 'About you.'),
    ],
    'review_3': [
        write('Name it', 'Write the device.', [
            ('Wir brauchen Mut. Wir brauchen Geduld.', 'Anapher'), ('Er versprach Aufbruch und lieferte Stillstand.', 'Antithese'),
        ], 1),
        gaps('Your summary', 'Sum up a discussion you heard in one balanced sentence.', [('Ich fasse zusammen:', '.')], 'About you.'),
    ],
}
MORE_LEFT = {
    'review_1': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Der Plan ist gerade absurd.', 'Der Plan ist geradezu absurd.'),
        ], 1),
        gaps('About you', 'Write two fixed pairs you use at work.', [('', ''), ('', '')], 'About you.'),
    ],
    'review_2': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Das Projekt bedarf eine Erklärung.', 'Das Projekt bedarf einer Erklärung.'),
        ], 1),
        gaps('About you', 'Write two compounds you saw today.', [('', ''), ('', '')], 'About you.'),
    ],
    'review_3': [
        write('Plain words', 'Say what the speaker really means.', [
            ('Das nennt man Transparenz.', 'Es ist keine Transparenz.'), ('Die blaue Tasse blieb leer.', 'Ruth fehlt ihm.'),
        ], 1),
        gaps('Your opening', 'Write the first sentence of a speech.', [('Stellen Sie sich vor,', '.')], 'About you.'),
    ],
}
for k, v in MORE.items():
    EXTRAS.setdefault(k, []).extend(v)
for k, v in MORE_LEFT.items():
    EXTRAS_LEFT.setdefault(k, []).extend(v)

# Third round: the review pages still had room.
REVIEW = {
    'review_1': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Ein starkes Quartal ist erfreulich, aber eine Schwalbe macht noch kein Sommer.', 'Ein starkes Quartal ist erfreulich, aber eine Schwalbe macht noch keinen Sommer.'),
        ], 1),
        write('Rephrase', 'Write it in the other form.', [
            ('Das ist sicher nicht billig. → Das ist …', 'Das ist keineswegs billig.'),
        ], 1),
        gaps('About you', 'Write a proverb that fits your week.', [('', '.')], 'About you.'),
    ],
    'review_2': [
        circle('The right joint', 'Circle the right compound.', [
            ('der', ['Kindergarten', 'Kindgarten'], '', 'Kindergarten'), ('die', ['Buchhandlung', 'Buchshandlung'], '', 'Buchhandlung'),
        ], 2),
        write('Rephrase', 'Write it in the other form.', [
            ('kann lernen → …', 'lernfähig'), ('man kann ihm glauben → …', 'glaubwürdig'),
        ], 2),
        gaps('About you', 'Write one thing you almost did this year.', [('Um ein Haar', '.')], 'About you.'),
    ],
    'review_3': [
        write('Name it', 'Write the device.', [
            ('Wir brauchen Mut. Wir brauchen Geduld.', 'Anapher'),
        ], 1),
        write('Plain words', 'Say what the speaker really means.', [
            ('Die blaue Tasse blieb leer.', 'Ruth fehlt ihm.'),
        ], 1),
        gaps('Your summary', 'Sum up your book in one sentence.', [('Ich fasse zusammen:', '.')], 'About you.'),
        gaps('Your opening', 'Write the first sentence of a short story.', [('', '.')], 'About you.'),
    ],
}
REVIEW_LEFT = {
    'review_1': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Der Plan ist gerade absurd.', 'Der Plan ist geradezu absurd.'),
        ], 1),
        gaps('About you', 'Write two words that sound warm and two that sound cold.', [('', ''), ('', '')], 'About you.'),
    ],
    'review_2': [
        write(MISTAKE, MISTAKE_HOW, [
            ('Das Projekt bedarf eine Erklärung.', 'Das Projekt bedarf einer Erklärung.'),
            ('Die Ministerin will auf alle Fragen beantworten.', 'Die Ministerin will alle Fragen beantworten.'),
        ], 1),
        gaps('About you', 'Write one sentence with zumal.', [('…, zumal', '.')], 'About you.'),
    ],
    'review_3': [
        write('Rephrase', 'Write it in the other form.', [
            ('Das Problem kann gelöst werden. → Das Problem …', 'Das Problem lässt sich lösen.'),
        ], 1),
        gaps('Your opening', 'Write the first sentence of a speech.', [('Stellen Sie sich vor,', '.')], 'About you.'),
        gaps('Your summary', 'Sum up a discussion you heard.', [('Ich fasse zusammen:', '.')], 'About you.'),
    ],
}
for k, v in REVIEW.items():
    EXTRAS.setdefault(k, []).extend(v)
for k, v in REVIEW_LEFT.items():
    EXTRAS_LEFT.setdefault(k, []).extend(v)
