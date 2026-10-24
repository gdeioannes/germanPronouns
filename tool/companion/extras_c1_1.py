# Extra exercises for the C1.1 book: they fill the free space on each practice page and review page.
# Merged by kit.write_book when tool/companion/c1_1.py runs (rules: docs/study_companion_guide.md).
from kit import gaps, match, write  # noqa: F401

MISTAKE = 'Each sentence has one mistake. Write the sentence correctly.'
GERMAN = 'Write it in German.'

EXTRAS = {
    'bildung': [
        write('Say it with the noun', 'Write it as a noun phrase.', [
            ('die Daten auswerten', 'die Auswertung der Daten'),
            ('das Gehirn untersuchen', 'die Untersuchung des Gehirns'),
            ('die Studie im Mai durchführen', 'die Durchführung der Studie im Mai'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Nach dem Durchführung der Studie kam das Team zu einer Schlussfolgerung.', 'Nach der Durchführung der Studie kam das Team zu einer Schlussfolgerung.'),
            ('Musik aktiviert mehrere Bereiche des Gehirn gleichzeitig.', 'Musik aktiviert mehrere Bereiche des Gehirns gleichzeitig.'),
            ('Ein Beleg ist mehr als ein Nachweis.', 'Ein Nachweis ist mehr als ein Beleg.'),
            ('Das Team hat die Annahme lange untersuchen.', 'Das Team hat die Annahme lange untersucht.'),
        ], 1),
        write('Translate', GERMAN, [
            ('Research on the brain is only at the beginning.', 'Die Forschung zum Gehirn steht erst am Anfang.'),
            ('The evaluation took three weeks, the conclusion three days.', 'Die Auswertung dauerte drei Wochen, die Schlussfolgerung drei Tage.'),
        ], 1, not_german=True),
    ],
    'nominalisierung': [
        write('Find the mistake', MISTAKE, [
            ('Wegen der schnellen Reaktion die Firma blieb der Schaden klein.', 'Wegen der schnellen Reaktion der Firma blieb der Schaden klein.'),
            ('Die Lösung dem Problem war überraschend einfach.', 'Die Lösung des Problems war überraschend einfach.'),
            ('Nach der Ankunft vom Zug ging alles sehr schnell.', 'Nach der Ankunft des Zuges ging alles sehr schnell.'),
            ('Die Änderung des Gesetz kam drei Jahre zu spät.', 'Die Änderung des Gesetzes kam drei Jahre zu spät.'),
            ('Die Entscheidung von der Regierung kam spät.', 'Die Entscheidung der Regierung kam spät.'),
        ], 1),
        write('Translate', GERMAN, [
            ('The government’s proposal surprised nobody.', 'Der Vorschlag der Regierung überraschte niemanden.'),
            ('After the arrival of the train, the team agreed on a plan.', 'Nach der Ankunft des Zuges einigte sich das Team auf einen Plan.'),
            ('The loss was small, the growth was big.', 'Der Verlust war klein, das Wachstum war groß.'),
            ('The solution to the problem was the dog.', 'Die Lösung des Problems war der Hund.'),
            ('Because of the delay, the cat missed the train.', 'Wegen der Verspätung verpasste die Katze den Zug.'),
        ], 1, not_german=True),
    ],
    'verbalisierung': [
        write('Say it with a clause', 'Write it with weil, obwohl, nachdem or indem.', [
            ('Wegen des Regens blieben wir zu Hause.', 'Weil es regnete, blieben wir zu Hause.'),
            ('Trotz der Warnung ging er ohne Jacke los.', 'Obwohl man ihn gewarnt hatte, ging er ohne Jacke los.'),
            ('Durch tägliches Üben wurde auch der Hund besser.', 'Indem er täglich übte, wurde auch der Hund besser.'),
            ('Nach dem Essen ging der Hund schlafen.', 'Nachdem der Hund gegessen hatte, ging er schlafen.'),
        ], 1),
        write('Translate', GERMAN, [
            ('In case of fire, leave the building. The cat is already outside.', 'Im Falle eines Brandes verlassen Sie das Gebäude. Die Katze ist schon draußen.'),
            ('Despite the warning, many set off.', 'Trotz der Warnung fuhren viele los.'),
        ], 1, not_german=True),
    ],
    'genitiv': [
        write('Find the mistake', MISTAKE, [
            ('Mangels Beweise wurde der Angeklagte freigesprochen.', 'Mangels Beweisen wurde der Angeklagte freigesprochen.'),
            ('Anlässlich dem Jubiläum wurde eine Ausstellung eröffnet.', 'Anlässlich des Jubiläums wurde eine Ausstellung eröffnet.'),
            ('Zufolge dem Bericht sind die Kosten gestiegen.', 'Dem Bericht zufolge sind die Kosten gestiegen.'),
            ('Gemäß der Vorschriften ist Rauchen hier verboten.', 'Gemäß den Vorschriften ist Rauchen hier verboten.'),
            ('Seitens die Regierung gab es keine Einwände.', 'Seitens der Regierung gab es keine Einwände.'),
        ], 1),
        write('Say it like a contract', 'Write it with mangels, ungeachtet, bezüglich or anlässlich.', [
            ('Weil es keine Beweise gab, wurde er freigesprochen.', 'Mangels Beweisen wurde er freigesprochen.'),
            ('Obwohl es Kritik gab, wurde das Gesetz verabschiedet.', 'Ungeachtet der Kritik wurde das Gesetz verabschiedet.'),
            ('Zu Ihrer Anfrage: Wir teilen Ihnen Folgendes mit.', 'Bezüglich Ihrer Anfrage teilen wir Ihnen Folgendes mit.'),
            ('Weil die Firma hundert Jahre alt wird, gibt es Kuchen.', 'Anlässlich des hundertjährigen Jubiläums der Firma gibt es Kuchen.'),
            ('Weil die Lage schwierig ist, bleiben wir zu Hause.', 'Angesichts der schwierigen Lage bleiben wir zu Hause.'),
        ], 1),
    ],
    'kasus': [
        write('Find the mistake', MISTAKE, [
            ('Die Leitung ist sich die Risiken bewusst.', 'Die Leitung ist sich der Risiken bewusst.'),
            ('Kann ich dir behilflich sein, Frau Weber?', 'Kann ich Ihnen behilflich sein, Frau Weber?'),
            ('Das Sofa ist nur einem Euro wert.', 'Das Sofa ist nur einen Euro wert.'),
            ('Sie hat große Zweifel auf der Studie.', 'Sie hat große Zweifel an der Studie.'),
        ], 1),
        write('Translate', GERMAN, [
            ('I am grateful to the team.', 'Ich bin dem Team dankbar.'),
            ('The cat is aware of its power.', 'Die Katze ist sich ihrer Macht bewusst.'),
            ('The bridge is 300 metres long.', 'Die Brücke ist 300 Meter lang.'),
        ], 1, not_german=True),
    ],
    'fvg': [
        write('Say it in specialist German', 'Write it with a noun and a light verb.', [
            ('Wir benutzen das Verfahren.', 'Wir bringen das Verfahren zur Anwendung.'),
            ('Wir schließen das Projekt im Mai ab.', 'Wir bringen das Projekt im Mai zum Abschluss.'),
            ('Wir danken Ihnen sehr.', 'Wir möchten Ihnen unseren Dank zum Ausdruck bringen.'),
            ('Die Stadt gibt den Vereinen Räume.', 'Die Stadt stellt den Vereinen Räume zur Verfügung.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Das neue Verfahren bringt ab Montag zur Anwendung.', 'Das neue Verfahren kommt ab Montag zur Anwendung.'),
            ('Die Verordnung hat am 1. Januar in Kraft getreten.', 'Die Verordnung ist am 1. Januar in Kraft getreten.'),
            ('Wir bitten Sie, unseren Vorschlag in Erwägung ziehen.', 'Wir bitten Sie, unseren Vorschlag in Erwägung zu ziehen.'),
            ('Der Hund hat sein Können unter Beweis gebracht.', 'Der Hund hat sein Können unter Beweis gestellt.'),
        ], 1),
    ],
    'tempus': [
        write('Find the mistake', MISTAKE, [
            ('Als der Redner begann, haben die meisten schon stundenlang gewartet.', 'Als der Redner begann, hatten die meisten schon stundenlang gewartet.'),
            ('Er ging aus dem Haus, nachdem er gegessen hat.', 'Er ging aus dem Haus, nachdem er gegessen hatte.'),
            ('Bis Freitag wurden wir fertig sein.', 'Bis Freitag werden wir fertig sein.'),
        ], 1),
        write('Tell it in writing', 'Write it in the Präteritum, the tense of a written story.', [
            ('Der Hund hat die Zeitung gelesen und hat Kaffee getrunken.', 'Der Hund las die Zeitung und trank Kaffee.'),
            ('Sie ist um Mitternacht nach Hause gekommen.', 'Sie kam um Mitternacht nach Hause.'),
            ('Wir sind ins Kino gegangen und haben Eis gegessen.', 'Wir gingen ins Kino und aßen Eis.'),
        ], 1),
        write('Translate', GERMAN, [
            ('The hall was full. Suddenly the light goes out.', 'Der Saal war voll. Plötzlich geht das Licht aus.'),
            ('We surveyed 300 people. The result has surprised us.', 'Wir befragten 300 Personen. Das Ergebnis hat uns überrascht.'),
            ('Water boils at 100 degrees.', 'Wasser kocht bei 100 Grad.'),
        ], 1, not_german=True),
    ],
    'review_1': [
        write('Unfold it', 'Write it as a clause with a verb.', [
            ('wegen der schnellen Reaktion der Firma', 'weil die Firma schnell reagierte'),
            ('nach Erhalt Ihrer Nachricht', 'nachdem wir Ihre Nachricht erhalten hatten'),
            ('bei Regen', 'wenn es regnet'),
            ('durch tägliches Üben', 'indem man täglich übt'),
            ('trotz der Warnung', 'obwohl man gewarnt hatte'),
        ], 1),
        gaps('Light verbs and cases', 'Write the missing word.', [
            ('Die Stadt', 'den Vereinen Räume zur Verfügung.', 'stellt'),
            ('Wir möchten unseren Dank zum Ausdruck', '.', 'bringen'),
            ('Sie war sich', 'Sieges sicher.', 'des'),
            ('Kann ich', 'behilflich sein, Frau Weber?', 'Ihnen'),
            ('', 'Beweisen wurde der Angeklagte freigesprochen.', 'Mangels'),
            ('Die Verordnung ist am 1. Januar in Kraft', '.', 'getreten'),
        ]),
        write('The little words', 'Write the German little word.', [
            ('on the occasion of', 'anlässlich'), ('for lack of', 'mangels'), ('regardless of', 'ungeachtet'), ('in view of', 'angesichts'),
            ('regarding', 'bezüglich'), ('on the part of', 'seitens'),
        ], 2, not_german=True),
        gaps('About you', 'Finish the sentences about yourself.', [
            ('Ich bin mir', 'bewusst.'), ('Ich bin', 'dankbar.'), ('Mein Zimmer ist', 'lang.'),
        ], 'About you.'),
    ],
    'passiversatz': [
        write('Say it another way', 'Write it with a passive substitute: sein + zu, sich lassen, bekommen or gehören.', [
            ('Das Formular muss ausgefüllt werden.', 'Das Formular ist auszufüllen.'),
            ('Das Gerät kann leicht bedient werden.', 'Das Gerät lässt sich leicht bedienen.'),
            ('Ihm wurde ein Hund geschenkt.', 'Er bekam einen Hund geschenkt.'),
            ('Das muss verboten werden!', 'Das gehört verboten!'),
            ('Das Buch wird gut verkauft.', 'Das Buch verkauft sich gut.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Die Unterlagen sind bis Freitag einreichen.', 'Die Unterlagen sind bis Freitag einzureichen.'),
            ('Ihm bekam das Buch geschenkt.', 'Er bekam das Buch geschenkt.'),
            ('Die Tür öffnet automatisch sich.', 'Die Tür öffnet sich automatisch.'),
            ('Alle Probleme sind sofort dem Support zu melden werden.', 'Alle Probleme sind sofort dem Support zu melden.'),
        ], 1),
    ],
    'bar_lich': [
        write('One word for a clause', 'Write it with a -bar or -lich word.', [
            ('Die Daten kann man jederzeit abrufen.', 'Die Daten sind jederzeit abrufbar.'),
            ('Man kann die Argumentation gut nachvollziehen.', 'Die Argumentation ist gut nachvollziehbar.'),
            ('Diesen Fehler kann man verzeihen.', 'Dieser Fehler ist verzeihlich.'),
            ('Man kann das Problem nicht lösen.', 'Das Problem ist unlösbar.'),
            ('Dieses Ende kann man nicht glauben.', 'Dieses Ende ist unglaublich.'),
        ], 1),
        write('Translate', GERMAN, [
            ('The prices are affordable, the cake is unbelievable.', 'Die Preise sind erschwinglich, der Kuchen ist unglaublich.'),
            ('The effect was immediately noticeable.', 'Die Wirkung war sofort spürbar.'),
            ('Coffee is indispensable.', 'Kaffee ist unentbehrlich.'),
            ('Your claim is hardly tenable.', 'Ihre These ist kaum haltbar.'),
        ], 1, not_german=True),
    ],
    'partizipialattribut': [
        write('Say it another way', 'Write the relative clause as a participle before the noun.', [
            ('die Mieten, die seit Jahren steigen', 'die seit Jahren steigenden Mieten'),
            ('der Antrag, den man noch prüfen muss', 'der noch zu prüfende Antrag'),
            ('die Reform, die geplant wurde', 'die geplante Reform'),
            ('die Delegation, die gestern angekommen ist', 'die gestern angekommene Delegation'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Die seit Jahren steigende Mieten sind ein Problem.', 'Die seit Jahren steigenden Mieten sind ein Problem.'),
            ('Die zu erwartende Folgen sind klar.', 'Die zu erwartenden Folgen sind klar.'),
            ('Der geplante Reform kommt im Mai.', 'Die geplante Reform kommt im Mai.'),
        ], 1),
        write('Translate', GERMAN, [
            ('the expected consequences', 'die zu erwartenden Folgen'),
            ('the sales achieved last year', 'die im letzten Jahr erzielten Umsätze'),
            ('the delegation that arrived yesterday', 'die gestern angekommene Delegation'),
        ], 1, not_german=True),
    ],
    'partizipialsatz': [
        write('Say it shorter', 'Write it with a participle at the start.', [
            ('Während sie lächelte, verließ sie den Raum.', 'Lächelnd verließ sie den Raum.'),
            ('Als er in Berlin angekommen war, suchte er ein Hotel.', 'In Berlin angekommen, suchte er ein Hotel.'),
            ('Weil er von der Reise erschöpft war, ging er ins Bett.', 'Von der Reise erschöpft, ging er ins Bett.'),
            ('Weil sie gut vorbereitet war, ging sie ruhig in die Prüfung.', 'Gut vorbereitet, ging sie ruhig in die Prüfung.'),
            ('Weil das Publikum vom Ergebnis beeindruckt war, applaudierte es.', 'Vom Ergebnis beeindruckt, applaudierte das Publikum.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Lächelnd öffnete sich die Tür.', 'Lächelnd öffnete sie die Tür.'),
            ('In Berlin angekommen, er suchte ein Hotel.', 'In Berlin angekommen, suchte er ein Hotel.'),
            ('Schweigend, hörten alle zu.', 'Schweigend hörten alle zu.'),
            ('Lächelnd, verließ sie den Raum.', 'Lächelnd verließ sie den Raum.'),
            ('Gut vorbereitet, war die Prüfung leicht für sie.', 'Gut vorbereitet, fand sie die Prüfung leicht.'),
        ], 1),
    ],
    'attribute': [
        write('Find the mistake', MISTAKE, [
            ('Wir sprachen mit Dr. Weber, die Leiterin des Instituts.', 'Wir sprachen mit Dr. Weber, der Leiterin des Instituts.'),
            ('Wir trafen Herrn Braun, der Leiter der Abteilung.', 'Wir trafen Herrn Braun, den Leiter der Abteilung.'),
            ('Wir sprachen mit Herrn Braun, den Leiter der Abteilung.', 'Wir sprachen mit Herrn Braun, dem Leiter der Abteilung.'),
            ('Dr. Weber, der Leiterin des Instituts, ist heute nicht da.', 'Dr. Weber, die Leiterin des Instituts, ist heute nicht da.'),
        ], 1),
        write('Translate', GERMAN, [
            ('the recently published results of the study', 'die kürzlich veröffentlichten Ergebnisse der Studie'),
            ('We met Dr Weber, the head of the institute.', 'Wir trafen Dr. Weber, die Leiterin des Instituts.'),
            ('The evaluation of the survey took several months.', 'Die Auswertung der Befragung dauerte mehrere Monate.'),
        ], 1, not_german=True),
    ],
    'grafik': [
        write('Find the mistake', MISTAKE, [
            ('Der Anteil ist von 40 bis 60 Prozent gestiegen.', 'Der Anteil ist von 40 auf 60 Prozent gestiegen.'),
            ('Von 40 auf 50 Prozent: das ist ein Anstieg um 10 Prozent.', 'Von 40 auf 50 Prozent: das ist ein Anstieg um 10 Prozentpunkte.'),
            ('Der Rückgang von 40 auf 60 Prozent war groß.', 'Der Anstieg von 40 auf 60 Prozent war groß.'),
            ('Die Zahl der Stipendien ist nahezu konstant gestiegen.', 'Die Zahl der Stipendien ist nahezu konstant geblieben.'),
            ('Die Grafik gibt Auskunft von den Mieten.', 'Die Grafik gibt Auskunft über die Mieten.'),
        ], 1),
        write('Translate', GERMAN, [
            ('The graph gives information about rents.', 'Die Grafik gibt Auskunft über die Mieten.'),
            ('What is striking is that the share has halved.', 'Auffällig ist, dass sich der Anteil halbiert hat.'),
            ('In comparison, the number of cats has remained constant.', 'Im Vergleich dazu ist die Zahl der Katzen konstant geblieben.'),
            ('From 40 to 50 per cent is ten percentage points.', 'Von 40 auf 50 Prozent sind zehn Prozentpunkte.'),
        ], 1, not_german=True),
    ],
    'review_2': [
        write('Say it another way', 'Write it another way: with sein + zu, -bar or a participle.', [
            ('Das Formular muss ausgefüllt werden.', 'Das Formular ist auszufüllen.'),
            ('Man kann das Problem lösen.', 'Das Problem ist lösbar.'),
            ('die Umfrage, die vor zwei Jahren durchgeführt wurde', 'die vor zwei Jahren durchgeführte Umfrage'),
            ('Als er in Berlin angekommen war, rief er an.', 'In Berlin angekommen, rief er an.'),
        ], 1),
        gaps('Which form?', 'Write the word in brackets in the form the sentence needs.', [
            ('Die Wirkung war sofort', '. (spüren)', 'spürbar'),
            ('', 'verließ sie den Raum. (lächeln)', 'Lächelnd'),
            ('die', 'Folgen (erwarten, can)', 'zu erwartenden'),
            ('Das Buch', 'sich gut. (verkaufen)', 'verkauft'),
            ('Das entspricht einem Anstieg', 'zwanzig Prozentpunkte. (von, auf or um?)', 'um'),
            ('Er bekam die Unterlagen per Post', '. (zuschicken)', 'zugeschickt'),
        ]),
        write('Translate', GERMAN, [
            ('She got the prize handed to her.', 'Sie bekam den Preis überreicht.'),
            ('Having arrived in Berlin, he looked for a hotel.', 'In Berlin angekommen, suchte er ein Hotel.'),
            ('The novel reads easily.', 'Der Roman liest sich leicht.'),
            ('We spoke to Mr Braun, the head of the department.', 'Wir sprachen mit Herrn Braun, dem Leiter der Abteilung.'),
        ], 1, not_german=True),
        gaps('About you', 'Finish the sentences about yourself.', [
            ('Für mich ist', 'unentbehrlich.'), ('Bei mir zu Hause gehört', 'verboten.'), ('Ein Problem, das sich nicht lösen lässt:', '.'),
        ], 'About you.'),
    ],
    'konnektoren': [
        write('Find the mistake', MISTAKE, [
            ('Sofern ich Zeit habe, ich helfe dir.', 'Sofern ich Zeit habe, helfe ich dir.'),
            ('Wir nehmen das Angebot an, zumal ist es günstig.', 'Wir nehmen das Angebot an, zumal es günstig ist.'),
            ('Er kann kaum schreiben, geschweige denn lesen.', 'Er kann kaum lesen, geschweige denn schreiben.'),
            ('Soweit ich weiß, er ist verreist.', 'Soweit ich weiß, ist er verreist.'),
            ('Ich helfe dir, sofern habe ich Zeit.', 'Ich helfe dir, sofern ich Zeit habe.'),
        ], 1),
        write('Translate', GERMAN, [
            ('I’ll come, provided there are no objections.', 'Ich komme, sofern keine Einwände bestehen.'),
            ('We should take the coffee, especially as it is free.', 'Wir sollten den Kaffee nehmen, zumal er kostenlos ist.'),
            ('He can hardly boil an egg, let alone cook a meal.', 'Er kann kaum ein Ei kochen, geschweige denn ein Essen.'),
            ('As far as I know, the conference is on Monday.', 'Soweit ich weiß, ist die Konferenz am Montag.'),
        ], 1, not_german=True),
    ],
    'adverbien': [
        write('Find the mistake', MISTAKE, [
            ('Die Annahme ist widerlegt; mithin das Modell muss geändert werden.', 'Die Annahme ist widerlegt; mithin muss das Modell geändert werden.'),
            ('Die Daten sind lückenhaft; gleichwohl ein Trend zeigt sich.', 'Die Daten sind lückenhaft; gleichwohl zeigt sich ein Trend.'),
            ('Das Ergebnis ist schwach; immerhin es ist besser als im Vorjahr.', 'Das Ergebnis ist schwach; immerhin ist es besser als im Vorjahr.'),
            ('Die Theorie überzeugt; hingegen die Praxis bleibt schwierig.', 'Die Theorie überzeugt; hingegen bleibt die Praxis schwierig.'),
        ], 1),
        write('Climb the register', 'Write it with the academic word: gleichwohl, mithin, hingegen or demnach.', [
            ('Das Wetter war schlecht. Trotzdem gingen wir schwimmen.', 'Das Wetter war schlecht; gleichwohl gingen wir schwimmen.'),
            ('Alle sind müde, deshalb machen wir Pause.', 'Alle sind müde; mithin machen wir Pause.'),
            ('Er liebt Kaffee, sie dagegen trinkt nur Tee.', 'Er liebt Kaffee, sie hingegen trinkt nur Tee.'),
            ('Laut Studie sinkt der Verbrauch, also wirken die Maßnahmen.', 'Laut Studie sinkt der Verbrauch; demnach wirken die Maßnahmen.'),
        ], 1),
    ],
    'adverbial_1': [
        write('Another column', 'Write it with a noun phrase: vor, wegen, bei or zur.', [
            ('Bevor wir essen, kochen wir.', 'Vor dem Essen kochen wir.'),
            ('Weil es regnete, blieb der Hund im Bett.', 'Wegen des Regens blieb der Hund im Bett.'),
            ('Wenn es regnet, spielen wir drinnen.', 'Bei Regen spielen wir drinnen.'),
            ('Um die Qualität zu verbessern, arbeitet das Team mehr.', 'Zur Verbesserung der Qualität arbeitet das Team mehr.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Regnet es, wir bleiben zu Hause.', 'Regnet es, bleiben wir zu Hause.'),
            ('Nimm einen Schirm, sonst du wirst nass.', 'Nimm einen Schirm, sonst wirst du nass.'),
            ('Nach wir gegessen hatten, gingen wir spazieren.', 'Nachdem wir gegessen hatten, gingen wir spazieren.'),
        ], 1),
        write('Translate', GERMAN, [
            ('Should it snow, we’ll stay in bed.', 'Sollte es schneien, bleiben wir im Bett.'),
            ('Take an umbrella, otherwise the dog gets wet.', 'Nimm einen Schirm, sonst wird der Hund nass.'),
        ], 1, not_german=True),
    ],
    'adverbial_2': [
        write('Find the mistake', MISTAKE, [
            ('Mein Bruder ist älter wie ich.', 'Mein Bruder ist älter als ich.'),
            ('Es kam anders, wie wir dachten.', 'Es kam anders, als wir dachten.'),
            ('Trotz es regnete, gingen wir spazieren.', 'Obwohl es regnete, gingen wir spazieren.'),
            ('Er tut, als ob er wüsste nichts.', 'Er tut, als ob er nichts wüsste.'),
            ('Sie ist so alt als ich.', 'Sie ist so alt wie ich.'),
        ], 1),
        write('Say it another way', 'Write it with the word in brackets.', [
            ('Obwohl es kalt war, gingen wir schwimmen. (trotz)', 'Trotz der Kälte gingen wir schwimmen.'),
            ('Infolge des Regens wurde die Straße gesperrt. (sodass)', 'Es regnete stark, sodass die Straße gesperrt wurde.'),
            ('Während der Norden nass ist, ist der Süden trocken. (im Gegensatz zu)', 'Im Gegensatz zum Norden ist der Süden trocken.'),
            ('Weil es stark regnete, wurde die Straße gesperrt. (infolge)', 'Infolge des starken Regens wurde die Straße gesperrt.'),
        ], 1),
    ],
    'zweiteilig': [
        write('Find the mistake', MISTAKE, [
            ('Weder die Firma hat reagiert, noch hat sie geantwortet.', 'Weder hat die Firma reagiert, noch hat sie geantwortet.'),
            ('Zwar die Wohnung ist teuer, aber sie ist schön.', 'Zwar ist die Wohnung teuer, aber sie ist schön.'),
            ('Sowohl die Stadt als auch das Land beteiligt sich an den Kosten.', 'Sowohl die Stadt als auch das Land beteiligen sich an den Kosten.'),
            ('Die Studie ist gut, aber lässt sie Fragen offen.', 'Die Studie ist gut, aber sie lässt Fragen offen.'),
            ('Einerseits die Arbeit ist interessant, andererseits ist sie schwierig.', 'Einerseits ist die Arbeit interessant, andererseits ist sie schwierig.'),
        ], 1),
        write('Translate', GERMAN, [
            ('Both the cat and the dog sleep on the sofa.', 'Sowohl die Katze als auch der Hund schlafen auf dem Sofa.'),
            ('On the one hand the flat is cheap, on the other hand it is far away.', 'Einerseits ist die Wohnung günstig, andererseits ist sie weit weg.'),
            ('The longer the conference lasts, the more tired we get.', 'Je länger die Konferenz dauert, desto müder werden wir.'),
            ('Neither the city nor the state pays.', 'Weder die Stadt noch das Land zahlt.'),
        ], 1, not_german=True),
    ],
    'darstellen': [
        write('Translate', GERMAN, [
            ('In the following, I would like to go into three aspects.', 'Im Folgenden möchte ich auf drei Aspekte eingehen.'),
            ('This can be illustrated by the example of my grandmother.', 'Dies lässt sich am Beispiel meiner Großmutter verdeutlichen.'),
            ('In addition, the coffee is cold.', 'Hinzu kommt, dass der Kaffee kalt ist.'),
            ('That brings me to the end.', 'Damit komme ich zum Schluss.'),
        ], 1, not_german=True),
        gaps('Your own talk', 'Plan a short talk on a topic you like. Finish each sentence.', [
            ('Ich werde zunächst', '.'), ('anschließend', '.'), ('und abschließend', '.'), ('Daraus ergibt sich, dass', '.'),
        ], 'About you.'),
    ],
    'zusammenfassung': [
        write('Find the mistake', MISTAKE, [
            ('Der Beitrag befasst mit der Aufmerksamkeit.', 'Der Beitrag befasst sich mit der Aufmerksamkeit.'),
            ('Die Verfasserin vertritt die Auffassung, der Effekt ist überschätzt worden.', 'Die Verfasserin vertritt die Auffassung, der Effekt sei überschätzt worden.'),
            ('Der Beitrag befasst sich mit der Langeweile, und ich finde ihn toll.', 'Der Beitrag befasst sich mit der Langeweile.'),
            ('Der Autor vertritt der Auffassung, dass Musik wichtig ist.', 'Der Autor vertritt die Auffassung, dass Musik wichtig ist.'),
        ], 1),
        write('Whose claim?', 'Write it as the source’s claim, in the Konjunktiv I.', [
            ('Das Telefon stört die Konzentration. (so der Autor)', 'Das Telefon störe die Konzentration, so der Autor.'),
            ('Langeweile ist gut für die Kreativität. (so die Verfasserin)', 'Langeweile sei gut für die Kreativität, so die Verfasserin.'),
            ('Wir haben zu wenig Zeit. (so der Redner)', 'Wir hätten zu wenig Zeit, so der Redner.'),
            ('Musik ist gut für das Gehirn. (so die Verfasserin)', 'Musik sei gut für das Gehirn, so die Verfasserin.'),
            ('Das Smartphone ist schuld. (so der Redner)', 'Das Smartphone sei schuld, so der Redner.'),
        ], 1),
    ],
    'review_3': [
        write('Find the mistake', MISTAKE, [
            ('Sofern es regnet, wir bleiben zu Hause.', 'Sofern es regnet, bleiben wir zu Hause.'),
            ('Die Daten sind lückenhaft; dennoch ein Trend zeigt sich.', 'Die Daten sind lückenhaft; dennoch zeigt sich ein Trend.'),
            ('Mein Kaffee ist besser wie deiner.', 'Mein Kaffee ist besser als deiner.'),
            ('Zwar ist das Hotel teuer, aber ist es schön.', 'Zwar ist das Hotel teuer, aber es ist schön.'),
            ('Es kam anders, wie wir erwartet hatten.', 'Es kam anders, als wir erwartet hatten.'),
        ], 1),
        write('Unfold it', 'Write it with the word in brackets.', [
            ('Trotz der Kälte gingen wir schwimmen. (obwohl)', 'Obwohl es kalt war, gingen wir schwimmen.'),
            ('Durch geringeres Heizen spart man Energie. (indem)', 'Indem man weniger heizt, spart man Energie.'),
            ('Bei Regen bleiben wir zu Hause. (sollte)', 'Sollte es regnen, bleiben wir zu Hause.'),
        ], 1),
        gaps('Which word?', 'Write the missing word.', [
            ('Er kann kaum lesen,', 'schreiben.', 'geschweige denn'),
            ('Je länger die Verhandlungen dauern,', 'geringer wird die Chance.', 'desto'),
            ('Man spart Energie,', 'man weniger heizt.', 'indem'),
            ('', 'kommt, dass die Mieten gestiegen sind.', 'Hinzu'),
            ('Der Beitrag', 'sich mit der Langeweile.', 'befasst'),
            ('Sowohl der Hund', 'die Katze schlafen hier.', 'als auch'),
        ]),
        write('Translate', GERMAN, [
            ('Should it rain, the dog stays at home.', 'Sollte es regnen, bleibt der Hund zu Hause.'),
            ('Neither did he call, nor did he write.', 'Weder hat er angerufen, noch hat er geschrieben.'),
            ('In summary, it can be said that there is no simple solution.', 'Zusammenfassend lässt sich sagen, dass es keine einfache Lösung gibt.'),
            ('As far as I know, he is away.', 'Soweit ich weiß, ist er verreist.'),
        ], 1, not_german=True),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        write('Find the mistake', MISTAKE, [
            ('Wegen die schnelle Reaktion der Firma blieb der Schaden klein.', 'Wegen der schnellen Reaktion der Firma blieb der Schaden klein.'),
            ('Trotz des Regens, wir fuhren los.', 'Trotz des Regens fuhren wir los.'),
            ('Sie war sich dem Sieg sicher.', 'Sie war sich des Sieges sicher.'),
            ('Die Stadt kommt den Vereinen Räume zur Verfügung.', 'Die Stadt stellt den Vereinen Räume zur Verfügung.'),
        ], 1),
        write('Fold it', 'Write it as a noun phrase.', [
            ('Nachdem er angekommen war, rief er an.', 'Nach seiner Ankunft rief er an.'),
            ('Weil es keine Beweise gab, wurde er freigesprochen.', 'Mangels Beweisen wurde er freigesprochen.'),
            ('Obwohl man ihn gewarnt hatte, fuhr er los.', 'Trotz der Warnung fuhr er los.'),
            ('Bevor das Flugzeug abflog, aß er ein Eis.', 'Vor dem Abflug aß er ein Eis.'),
        ], 1),
        write('Translate', GERMAN, [
            ('The new procedure comes into use on Monday.', 'Das neue Verfahren kommt ab Montag zur Anwendung.'),
            ('Midnight. Suddenly there is a knock.', 'Mitternacht. Plötzlich klopft es.'),
            ('The management is aware of the risks.', 'Die Leitung ist sich der Risiken bewusst.'),
            ('I refer to your letter of 12 May.', 'Ich nehme Bezug auf Ihr Schreiben vom 12. Mai.'),
        ], 1, not_german=True),
    ],
    'review_2': [
        write('Find the mistake', MISTAKE, [
            ('Das Gerät lässt leicht sich bedienen.', 'Das Gerät lässt sich leicht bedienen.'),
            ('Ihr bekam den Preis überreicht.', 'Sie bekam den Preis überreicht.'),
            ('Die zu erwartende Folgen sind klar.', 'Die zu erwartenden Folgen sind klar.'),
            ('Lächelnd öffnete sich die Tür.', 'Lächelnd öffnete sie die Tür.'),
            ('Wir trafen Herrn Braun, der Leiter der Abteilung.', 'Wir trafen Herrn Braun, den Leiter der Abteilung.'),
            ('Das Buch verkauft gut sich.', 'Das Buch verkauft sich gut.'),
        ], 1),
        write('Unpack it', 'Write it as a relative clause.', [
            ('die seit Jahren steigenden Mieten', 'die Mieten, die seit Jahren steigen'),
            ('die geplante Reform', 'die Reform, die geplant wurde'),
            ('der noch zu prüfende Antrag', 'der Antrag, der noch geprüft werden muss'),
            ('die gestern angekommene Delegation', 'die Delegation, die gestern angekommen ist'),
            ('die zu erwartenden Folgen', 'die Folgen, die zu erwarten sind'),
        ], 1),
        write('Translate', GERMAN, [
            ('The data can be retrieved at any time.', 'Die Daten sind jederzeit abrufbar.'),
            ('The costs are manageable.', 'Die Kosten sind überschaubar.'),
            ('The share has risen from 40 to 60 per cent.', 'Der Anteil ist von 40 auf 60 Prozent gestiegen.'),
            ('Smiling, she left the room.', 'Lächelnd verließ sie den Raum.'),
            ('All problems are to be reported to support at once.', 'Alle Probleme sind sofort dem Support zu melden.'),
        ], 1, not_german=True),
    ],
    'review_3': [
        write('Say it another way', 'Write it with the word in brackets.', [
            ('Wenn es regnet, bleiben wir zu Hause. (verb first)', 'Regnet es, bleiben wir zu Hause.'),
            ('Obwohl es regnete, gingen wir. (trotz)', 'Trotz des Regens gingen wir.'),
            ('Das Wetter war schlecht. Trotzdem gingen wir. (gleichwohl)', 'Das Wetter war schlecht; gleichwohl gingen wir.'),
            ('Langeweile ist gut. (so die Verfasserin)', 'Langeweile sei gut, so die Verfasserin.'),
            ('Er ging, ohne sich zu verabschieden. (ohne)', 'Er ging ohne Abschied.'),
        ], 1),
        gaps('Pairs', 'Write the missing half.', [
            ('Sowohl die Stadt', 'das Land beteiligen sich.', 'als auch'),
            ('Zum einen fehlt es an Personal,', 'sind die Räume veraltet.', 'zum anderen'),
            ('Einerseits ist die Wohnung schön,', 'ist sie teuer.', 'andererseits'),
            ('Weder hat er angerufen,', 'hat er geschrieben.', 'noch'),
        ]),
        write('Translate', GERMAN, [
            ('In the following, I would like to go into two aspects.', 'Im Folgenden möchte ich auf zwei Aspekte eingehen.'),
            ('He is as old as me, but taller than me.', 'Er ist so alt wie ich, aber größer als ich.'),
            ('The author holds the view that boredom is important.', 'Der Autor vertritt die Auffassung, dass Langeweile wichtig ist.'),
        ], 1, not_german=True),
        gaps('About you', 'Finish the sentences about yourself.', [
            ('Ich lerne Deutsch, zumal', '.'), ('Sofern ich Zeit habe,', '.'), ('Ich kann kaum', ', geschweige denn …'),
        ], 'About you.'),
    ],
}
