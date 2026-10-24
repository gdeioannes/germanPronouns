# Extra exercises for the B2.1 study companion: they fill the free space on each practice page
# (EXTRAS) and on each review's left page (EXTRAS_LEFT). Merged by kit.write_book; rules in
# docs/study_companion_guide.md (teach before asking, every answer in the key, paper wording).
from kit import circle, gaps, write

MISTAKE = 'Find the mistake'
MISTAKE_I = 'Each sentence has one mistake. Write it correctly.'
TRANSLATE = 'In German'
TRANSLATE_I = 'Write it in German.'


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


EXTRAS = {
    # ---- Part 1 ----------------------------------------------------------------------------
    'gesellschaft': [
        write(TRANSLATE, TRANSLATE_I, [
            ('The parliament passes a new law.', 'Das Parlament beschließt ein neues Gesetz.'),
            ('The citizens elect a new government.', 'Die Bürger wählen eine neue Regierung.'),
            ('The opponents warn of higher taxes.', 'Die Gegner warnen vor höheren Steuern.'),
            ('The government’s dog welcomes the law.', 'Der Hund der Regierung begrüßt das Gesetz.'),
        ], 1, not_german=True),
        write(MISTAKE, MISTAKE_I, [
            ('Die Partei hat die Wahl gewinnt.', 'Die Partei hat die Wahl gewonnen.'),
            ('Die Gegner warnen auf höheren Kosten.', 'Die Gegner warnen vor höheren Kosten.'),
            ('Die Bürger wählt eine neue Regierung.', 'Die Bürger wählen eine neue Regierung.'),
        ], 1),
    ],
    'konj1': [
        write(MISTAKE, 'In the paper, each sentence has one mistake. Write it correctly.', [
            ('Er sagt, er ist krank.', 'Er sagt, er sei krank.'),
            ('Der Minister sagte, die Lage war ernst.', 'Der Minister sagte, die Lage sei ernst.'),
            ('Die Experten sagten, sie haben keine Lösung.', 'Die Experten sagten, sie hätten keine Lösung.'),
            ('Der Chef meint, er müsst noch arbeiten.', 'Der Chef meint, er müsse noch arbeiten.'),
            ('Er sagt, es gibt keine Lösung.', 'Er sagt, es gebe keine Lösung.'),
        ], 1),
        write('Report it', 'Start with Sie sagte, … .', [
            ('„Ich habe keine Zeit.“', 'Sie sagte, sie habe keine Zeit.'),
            ('„Ich kann morgen nicht kommen.“', 'Sie sagte, sie könne morgen nicht kommen.'),
            ('„Es gibt keine schnelle Lösung.“', 'Sie sagte, es gebe keine schnelle Lösung.'),
            ('„Mein Chef ist schon wieder im Urlaub.“', 'Sie sagte, ihr Chef sei schon wieder im Urlaub.'),
            ('„Die Experten haben keinen Plan.“', 'Sie sagte, die Experten hätten keinen Plan.'),
        ], 1),
    ],
    'konj1_verg': [
        write('Report the past', 'Start with Er sagte, … .', [
            ('„Ich habe den Unfall gesehen.“', 'Er sagte, er habe den Unfall gesehen.'),
            ('„Ich bin sofort stehen geblieben.“', 'Er sagte, er sei sofort stehen geblieben.'),
            ('„Ich konnte nicht schlafen.“', 'Er sagte, er habe nicht schlafen können.'),
        ], 1),
        write(MISTAKE, MISTAKE_I, [
            ('Der Zeuge sagte, er sei den Unfall gesehen.', 'Der Zeuge sagte, er habe den Unfall gesehen.'),
            ('Sie fragte, wenn ich mitkomme.', 'Sie fragte, ob ich mitkomme.'),
            ('Der Zeuge sagte, er habe sofort stehen geblieben.', 'Der Zeuge sagte, er sei sofort stehen geblieben.'),
        ], 1),
    ],
    'indirekt_fragen': [
        write(MISTAKE, MISTAKE_I, [
            ('Er fragt, ob ich komme morgen.', 'Er fragt, ob ich morgen komme.'),
            ('Sie fragte, wo wohne ich.', 'Sie fragte, wo ich wohne.'),
            ('Ich weiß nicht, ob stimmt das.', 'Ich weiß nicht, ob das stimmt.'),
            ('Er wollte wissen, auf was ich warte.', 'Er wollte wissen, worauf ich warte.'),
        ], 1),
        write('Say it another way', 'Start with Ich weiß nicht, … .', [
            ('„Wo wohnt der Journalist?“', 'Ich weiß nicht, wo der Journalist wohnt.'),
            ('„Stimmt das wirklich?“', 'Ich weiß nicht, ob das wirklich stimmt.'),
            ('„Worauf wartet der Bus?“', 'Ich weiß nicht, worauf der Bus wartet.'),
            ('„Mit wem wohnt deine Katze?“', 'Ich weiß nicht, mit wem deine Katze wohnt.'),
        ], 1),
        gaps('About you', 'Finish the sentence.', [('Ich frage mich oft, ob', '.')], 'About you.'),
    ],
    'verben_praep': [
        write(MISTAKE, MISTAKE_I, [
            ('Ich warte für den Bus.', 'Ich warte auf den Bus.'),
            ('Das hängt auf der Zeit ab.', 'Das hängt von der Zeit ab.'),
            ('Ich freue mich über den Urlaub nächste Woche.', 'Ich freue mich auf den Urlaub nächste Woche.'),
            ('Wir haben in der Konferenz teilgenommen.', 'Wir haben an der Konferenz teilgenommen.'),
            ('Sie interessiert sich an Musik.', 'Sie interessiert sich für Musik.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('I am waiting for the train.', 'Ich warte auf den Zug.'),
            ('She is looking forward to the holiday.', 'Sie freut sich auf den Urlaub.'),
            ('We thanked them for the invitation.', 'Wir haben uns für die Einladung bedankt.'),
            ('My cat dreams of a bigger flat.', 'Meine Katze träumt von einer größeren Wohnung.'),
            ('He is thinking of selling the house.', 'Er denkt daran, das Haus zu verkaufen.'),
        ], 1, not_german=True),
    ],
    'adjektive_praep': [
        write(MISTAKE, MISTAKE_I, [
            ('Sie ist stolz von dem Team.', 'Sie ist stolz auf das Team.'),
            ('Ich bin interessiert für Musik.', 'Ich bin an Musik interessiert.'),
            ('Wir sind mit dem Ergebnis stolz.', 'Wir sind mit dem Ergebnis zufrieden.'),
            ('Die Region ist bekannt mit dem Käse.', 'Die Region ist für den Käse bekannt.'),
            ('Wir sind gespannt für das Ergebnis.', 'Wir sind gespannt auf das Ergebnis.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('He is responsible for the budget.', 'Er ist für das Budget verantwortlich.'),
            ('I agree with the proposal.', 'Ich bin mit dem Vorschlag einverstanden.'),
            ('We are curious about the result.', 'Wir sind gespannt auf das Ergebnis.'),
            ('The dog is very proud of its new hat.', 'Der Hund ist sehr stolz auf seinen neuen Hut.'),
            ('My boss is never satisfied with anything.', 'Mein Chef ist nie mit etwas zufrieden.'),
        ], 1, not_german=True),
    ],
    'nomen_praep': [
        write(MISTAKE, MISTAKE_I, [
            ('Mein Interesse für Politik ist groß.', 'Mein Interesse an Politik ist groß.'),
            ('Die Kritik auf der Regierung wächst.', 'Die Kritik an der Regierung wächst.'),
            ('Ich habe keine Lust für den Kurs.', 'Ich habe keine Lust auf den Kurs.'),
        ], 1),
        write('Unpack the phrase', 'Write a sentence with a verb.', [
            ('der Einfluss der Medien auf die Wahl', 'Die Medien beeinflussen die Wahl.'),
            ('die Kritik der Opposition an der Regierung', 'Die Opposition kritisiert die Regierung.'),
            ('die Teilnahme der Schüler am Kurs', 'Die Schüler nehmen am Kurs teil.'),
            ('die Bitte der Katze um mehr Käse', 'Die Katze bittet um mehr Käse.'),
        ], 1),
        gaps('About you', 'Finish the sentences.', [
            ('Ich habe große Lust auf', '.'), ('Ich habe keine Angst vor', '.'),
        ], 'About you.'),
    ],
    'review_1': [
        gaps('The little word', 'Write the missing little word.', [
            ('Ich denke oft', 'meinen Urlaub.', 'an'), ('Sie hat sich', 'die Stelle beworben.', 'um'),
            ('Er ist verantwortlich', 'das Budget.', 'für'), ('Die Kritik', 'der Regierung wächst.', 'an'),
            ('Ich habe keine Lust', 'den Kurs.', 'auf'), ('Das hängt', 'der Zeit ab.', 'von'),
        ]),
        write('Say it another way', 'Start with Ich weiß nicht, … .', [
            ('„Kommt der Bus?“', 'Ich weiß nicht, ob der Bus kommt.'),
            ('„Womit fährt er?“', 'Ich weiß nicht, womit er fährt.'),
            ('„Wovon lebt der Journalist?“', 'Ich weiß nicht, wovon der Journalist lebt.'),
            ('„Mit wem wohnt sie?“', 'Ich weiß nicht, mit wem sie wohnt.'),
        ], 1),
        gaps('da(r)-', 'Write the da(r)-word.', [
            ('Ich freue mich', ', dass du kommst.', 'darauf'),
            ('Sie ärgert sich', ', dass der Bus Verspätung hat.', 'darüber'),
            ('Er ist stolz', ', dass er die Prüfung bestanden hat.', 'darauf'),
            ('Wir kümmern uns', ', dass alles rechtzeitig ankommt.', 'darum'),
        ]),
        gaps('About you', 'Finish the sentences.', [
            ('Ich freue mich schon auf', '.'), ('Ich ärgere mich oft über', '.'),
        ], 'About you.'),
    ],

    # ---- Part 2 ----------------------------------------------------------------------------
    'modalpassiv': [
        write(MISTAKE, MISTAKE_I, [
            ('Die Anträge muss bis Freitag eingereicht werden.', 'Die Anträge müssen bis Freitag eingereicht werden.'),
            ('Der Vertrag musste unterschreiben werden.', 'Der Vertrag musste unterschrieben werden.'),
            ('Hier darf nicht rauchen werden.', 'Hier darf nicht geraucht werden.'),
            ('Das Problem muss gelöst wird.', 'Das Problem muss gelöst werden.'),
        ], 1),
        write('In the passive', 'Write it in the passive.', [
            ('Man muss das Formular bis Freitag ausfüllen.', 'Das Formular muss bis Freitag ausgefüllt werden.'),
            ('Man musste den Flug wegen des Sturms streichen.', 'Der Flug musste wegen des Sturms gestrichen werden.'),
            ('Man sollte die Regeln beachten.', 'Die Regeln sollten beachtet werden.'),
            ('Man konnte das Auto nicht reparieren.', 'Das Auto konnte nicht repariert werden.'),
            ('Man darf den Vertrag nicht unterschreiben.', 'Der Vertrag darf nicht unterschrieben werden.'),
        ], 1),
    ],
    'passiv_perfekt': [
        write(MISTAKE, MISTAKE_I, [
            ('Das Haus ist 1990 gebaut geworden.', 'Das Haus ist 1990 gebaut worden.'),
            ('Die Briefe haben schon verschickt worden.', 'Die Briefe sind schon verschickt worden.'),
            ('Ich weiß, dass der Fehler ist behoben worden.', 'Ich weiß, dass der Fehler behoben worden ist.'),
        ], 1),
        write('In the Perfekt', 'Write it with ist … worden.', [
            ('Der Dieb wurde gestern gefunden.', 'Der Dieb ist gestern gefunden worden.'),
            ('Die Rechnung wurde bezahlt.', 'Die Rechnung ist bezahlt worden.'),
            ('Die Fehler wurden korrigiert.', 'Die Fehler sind korrigiert worden.'),
        ], 1),
    ],
    'zustandspassiv': [
        write(MISTAKE, MISTAKE_I, [
            ('Das Auto ist gerade repariert.', 'Das Auto wird gerade repariert.'),
            ('Der Tisch wird schon gedeckt, wir können essen.', 'Der Tisch ist schon gedeckt, wir können essen.'),
            ('Als wir ankamen, wurde das Museum schon geschlossen.', 'Als wir ankamen, war das Museum schon geschlossen.'),
            ('Der Brief wurde durch den Chef geschrieben.', 'Der Brief wurde vom Chef geschrieben.'),
        ], 1),
        write('The result', 'The action is over. Write the state with ist.', [
            ('Der Tisch wird gedeckt.', 'Der Tisch ist gedeckt.'),
            ('Das Museum wird geschlossen.', 'Das Museum ist geschlossen.'),
            ('Das Auto wird repariert.', 'Das Auto ist repariert.'),
            ('Das Gesetz wird beschlossen.', 'Das Gesetz ist beschlossen.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('The shop is opened at nine.', 'Das Geschäft wird um neun geöffnet.'),
            ('When we arrived, the table was already laid.', 'Als wir ankamen, war der Tisch schon gedeckt.'),
            ('The car is being repaired right now.', 'Das Auto wird gerade repariert.'),
            ('The cake was eaten by the dog.', 'Der Kuchen wurde vom Hund gegessen.'),
        ], 1, not_german=True),
    ],
    'passiv_subjektlos': [
        write(MISTAKE, MISTAKE_I, [
            ('Er wird geholfen.', 'Ihm wird geholfen.'),
            ('Hier es wird getanzt.', 'Hier wird getanzt.'),
            ('Sonntags werden nicht gearbeitet.', 'Sonntags wird nicht gearbeitet.'),
            ('Die Gewinner wurde gratuliert.', 'Den Gewinnern wurde gratuliert.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('People dance here.', 'Hier wird getanzt.'),
            ('Nobody answered me.', 'Mir wurde nicht geantwortet.'),
            ('On Sundays nobody works — not even the cat.', 'Sonntags wird nicht gearbeitet – nicht einmal von der Katze.'),
        ], 1, not_german=True),
    ],
    'lassen': [
        write(MISTAKE, MISTAKE_I, [
            ('Ich habe mir die Haare schneiden gelassen.', 'Ich habe mir die Haare schneiden lassen.'),
            ('Ich habe den Schirm zu Hause lassen.', 'Ich habe den Schirm zu Hause gelassen.'),
            ('Er lasst die Kinder spielen.', 'Er lässt die Kinder spielen.'),
            ('Ich habe mein Auto repariert lassen.', 'Ich habe mein Auto reparieren lassen.'),
            ('Sie hat uns lange warten gelassen.', 'Sie hat uns lange warten lassen.'),
        ], 1),
        write('Get it done', 'Someone else does it. Write it with lassen.', [
            ('Jemand schneidet mir die Haare.', 'Ich lasse mir die Haare schneiden.'),
            ('Jemand übersetzt den Brief für uns.', 'Wir lassen den Brief übersetzen.'),
            ('Jemand renoviert unsere Wohnung.', 'Wir lassen unsere Wohnung renovieren.'),
            ('Jemand näht meinem Hund ein Kleid.', 'Ich lasse meinem Hund ein Kleid nähen.'),
            ('Jemand repariert das Fenster.', 'Ich lasse das Fenster reparieren.'),
        ], 1),
    ],
    'partizip_adj': [
        write(MISTAKE, 'Each one has a word in the wrong place. Write it correctly.', [
            ('Der Hund bellende erschreckte die Kinder.', 'Der bellende Hund erschreckte die Kinder.'),
            ('die steigenden seit Jahren Preise', 'die seit Jahren steigenden Preise'),
            ('der ankommende um acht Uhr Zug', 'der um acht Uhr ankommende Zug'),
        ], 1),
        write('Unfold it', 'Write it as a relative clause.', [
            ('die von der Firma eingeladenen Gäste', 'die Gäste, die von der Firma eingeladen wurden'),
            ('das gestern zerbrochene Fenster', 'das Fenster, das gestern zerbrochen wurde'),
        ], 1),
        write('Fold it', 'Put the clause before the noun.', [
            ('der Hund, der im Park bellt', 'der im Park bellende Hund'),
            ('das Auto, das vor der Schule geparkt wurde', 'das vor der Schule geparkte Auto'),
        ], 1),
    ],
    'nachsilben': [
        write(MISTAKE, 'Each sentence has the wrong article. Write it correctly.', [
            ('Die Tourismus wächst.', 'Der Tourismus wächst.'),
            ('Der Konferenz beginnt um neun.', 'Die Konferenz beginnt um neun.'),
            ('Der Zentrum der Stadt ist schön.', 'Das Zentrum der Stadt ist schön.'),
            ('Das Irrtum war teuer.', 'Der Irrtum war teuer.'),
            ('Der Freiheit ist wichtig.', 'Die Freiheit ist wichtig.'),
        ], 1),
        circle('More endings', 'Circle the right article.', [
            ('', ['die', 'der'], 'Energie', 'die'), ('', ['der', 'das'], 'Instrument', 'das'),
            ('', ['der', 'die'], 'Lehrling', 'der'), ('', ['die', 'das'], 'Erlebnis', 'das'),
            ('', ['das', 'die'], 'Natur', 'die'), ('', ['der', 'das'], 'Autor', 'der'),
        ], 2),
    ],
    'review_2': [
        gaps('Ending and all', 'Write the verb in brackets as -end or ge-, with its ending.', [
            ('Die', 'Preise ärgern alle. (steigen)', 'steigenden'),
            ('Zum Frühstück gibt es ein', 'Ei. (kochen)', 'gekochtes'),
            ('Das', 'Fenster ist noch nicht repariert. (zerbrechen)', 'zerbrochene'),
            ('Der', 'Hund will nur spielen. (bellen)', 'bellende'),
        ]),
        circle('Which form?', 'Circle the right form.', [
            ('Das Museum', ['ist', 'wird'], 'sonntags geschlossen.', 'ist'),
            ('Die Straße', ['wird', 'ist'], 'gerade repariert.', 'wird'),
            ('Ich habe den Schirm im Auto', ['gelassen', 'lassen'], '.', 'gelassen'),
            ('Hier', ['wird', 'werden'], 'viel gelacht.', 'wird'),
        ], 1),
        write('Get it done', 'Write it with lassen.', [
            ('Jemand repariert mein Fahrrad.', 'Ich lasse mein Fahrrad reparieren.'),
            ('Jemand übersetzt den Vertrag.', 'Wir lassen den Vertrag übersetzen.'),
            ('Das kann gelöst werden.', 'Das lässt sich lösen.'),
        ], 1),
        gaps('About you', 'Finish the sentence.', [
            ('Bei uns zu Hause wird oft', '.'),
        ], 'About you.'),
    ],

    # ---- Part 3 ----------------------------------------------------------------------------
    'konnektoren': [
        write(MISTAKE, MISTAKE_I, [
            ('Es war teuer. Trotzdem wir haben es gekauft.', 'Es war teuer. Trotzdem haben wir es gekauft.'),
            ('Nimm einen Schirm, sonst du wirst nass.', 'Nimm einen Schirm, sonst wirst du nass.'),
            ('Er hat viel gelernt. Folglich er bestand die Prüfung.', 'Er hat viel gelernt. Folglich bestand er die Prüfung.'),
            ('Obwohl es war teuer, haben wir es gekauft.', 'Obwohl es teuer war, haben wir es gekauft.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('The flat is small. Besides, it is expensive.', 'Die Wohnung ist klein. Außerdem ist sie teuer.'),
            ('Hurry up, or else we’ll miss the train.', 'Beeil dich, sonst verpassen wir den Zug.'),
            ('He didn’t come. Instead, he sent his dog.', 'Er kam nicht. Stattdessen schickte er seinen Hund.'),
        ], 1, not_german=True),
    ],
    'mittelfeld': [
        write(MISTAKE, 'Each sentence has a word in the wrong place. Write it correctly.', [
            ('Ich gebe ihm es.', 'Ich gebe es ihm.'),
            ('Sie fährt nach Rom morgen.', 'Sie fährt morgen nach Rom.'),
            ('Er ist nicht gestern gekommen.', 'Er ist gestern nicht gekommen.'),
            ('Wir fahren mit dem Zug wegen des Regens.', 'Wir fahren wegen des Regens mit dem Zug.'),
            ('Ich habe gezeigt ihm die Fotos.', 'Ich habe ihm die Fotos gezeigt.'),
        ], 1),
        write('Put it in order', 'Write the sentence in the usual order.', [
            ('Ich fahre (nach Berlin · morgen · mit dem Zug).', 'Ich fahre morgen mit dem Zug nach Berlin.'),
            ('Sie geht (in den Park · jeden Tag · mit dem Hund).', 'Sie geht jeden Tag mit dem Hund in den Park.'),
            ('Wir blieben (im Bett · wegen des Regens · am Sonntag).', 'Wir blieben am Sonntag wegen des Regens im Bett.'),
        ], 1),
    ],
    'nominal': [
        write('Say it shorter', 'Write it with wegen, dank, nach or bei.', [
            ('Weil du geholfen hast, haben wir es geschafft.', 'Dank deiner Hilfe haben wir es geschafft.'),
            ('Weil es kalt war, blieben wir zu Hause.', 'Wegen der Kälte blieben wir zu Hause.'),
            ('Nachdem wir gegessen hatten, gingen wir spazieren.', 'Nach dem Essen gingen wir spazieren.'),
            ('Als er ankam, weinte der Hund vor Freude.', 'Bei seiner Ankunft weinte der Hund vor Freude.'),
        ], 1),
        write(MISTAKE, MISTAKE_I, [
            ('Vor Neugier öffnete sie den Brief.', 'Aus Neugier öffnete sie den Brief.'),
            ('Sie zitterte aus Kälte.', 'Sie zitterte vor Kälte.'),
            ('Bei seine Ankunft klatschten alle.', 'Bei seiner Ankunft klatschten alle.'),
            ('Wegen dem Sturm fiel der Strom aus.', 'Wegen des Sturms fiel der Strom aus.'),
        ], 1),
    ],
    'infinitiv': [
        write(MISTAKE, MISTAKE_I, [
            ('Ich hoffe, dass die Prüfung zu bestehen.', 'Ich hoffe, die Prüfung zu bestehen.'),
            ('Ich spare, um meine Tochter studieren kann.', 'Ich spare, damit meine Tochter studieren kann.'),
            ('Er verspricht, zu kommen morgen.', 'Er verspricht, morgen zu kommen.'),
            ('Wir haben vergessen, die Nachbarn zu einladen.', 'Wir haben vergessen, die Nachbarn einzuladen.'),
            ('Er ging, ohne dass zu grüßen.', 'Er ging, ohne zu grüßen.'),
        ], 1),
        write('Join them', 'Join with um … zu, damit, ohne … zu or ohne dass.', [
            ('Ich lerne Deutsch. Ich will in Wien arbeiten.', 'Ich lerne Deutsch, um in Wien zu arbeiten.'),
            ('Ich spare. Mein Hund soll ein Sofa bekommen.', 'Ich spare, damit mein Hund ein Sofa bekommt.'),
            ('Er ging. Er sagte nichts.', 'Er ging, ohne etwas zu sagen.'),
            ('Sie nahm das Auto. Ihr Mann wusste nichts davon.', 'Sie nahm das Auto, ohne dass ihr Mann davon wusste.'),
        ], 1),
    ],
    'brauchen': [
        write(MISTAKE, MISTAKE_I, [
            ('Du brauchst nicht kommen.', 'Du brauchst nicht zu kommen.'),
            ('Du brauchst morgen zu kommen.', 'Du musst morgen kommen.'),
            ('Du darfst keine Angst zu haben.', 'Du brauchst keine Angst zu haben.'),
            ('Er braucht nur hier unterschreiben.', 'Er braucht nur hier zu unterschreiben.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('You don’t have to cook today.', 'Du brauchst heute nicht zu kochen.'),
            ('You mustn’t park here.', 'Du darfst hier nicht parken.'),
            ('You only need to sign here.', 'Sie brauchen nur hier zu unterschreiben.'),
            ('We didn’t have to wait.', 'Wir brauchten nicht zu warten.'),
            ('The cat doesn’t need to take a jacket.', 'Die Katze braucht keine Jacke mitzunehmen.'),
        ], 1, not_german=True),
    ],
    'stellungnahme': [
        write(MISTAKE, MISTAKE_I, [
            ('Meiner Ansicht nach, dass die Vorteile überwiegen.', 'Meiner Ansicht nach überwiegen die Vorteile.'),
            ('Dafür spricht, dass man spart Zeit.', 'Dafür spricht, dass man Zeit spart.'),
            ('Zwar spart man Zeit, und der Austausch fehlt.', 'Zwar spart man Zeit, aber der Austausch fehlt.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('In my view, the city centre should be car-free.', 'Meiner Ansicht nach sollte die Innenstadt autofrei sein.'),
            ('In conclusion, both sides are right.', 'Zusammenfassend lässt sich sagen, dass beide Seiten recht haben.'),
        ], 1, not_german=True),
    ],
    'review_3': [
        gaps('Which connector?', 'Write trotzdem, sonst, deshalb, außerdem or stattdessen.', [
            ('Der Film war lang.', 'war er spannend.', 'Trotzdem'),
            ('Wir müssen gehen,', 'verpassen wir den Bus.', 'sonst'),
            ('Er hatte kein Geld.', 'blieb er zu Hause.', 'Deshalb'),
            ('Die Wohnung ist klein.', 'ist sie laut.', 'Außerdem'),
            ('Sie kam nicht.', 'schickte sie ihre Katze.', 'Stattdessen'),
            ('Es regnete.', 'blieben wir zu Hause.', 'Deshalb'),
        ]),
        write('zu or dass?', 'Write it with zu if you can — if not, keep dass.', [
            ('Ich hoffe, dass ich bald Urlaub habe.', 'Ich hoffe, bald Urlaub zu haben.'),
            ('Er verspricht, dass er pünktlich kommt.', 'Er verspricht, pünktlich zu kommen.'),
            ('Wir hoffen, dass ihr kommt.', 'Wir hoffen, dass ihr kommt.'),
            ('Sie bittet mich, dass ich warte.', 'Sie bittet mich zu warten.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('You don’t need to come.', 'Du brauchst nicht zu kommen.'),
            ('In my opinion, the advantages outweigh.', 'Meiner Meinung nach überwiegen die Vorteile.'),
            ('I save so that my daughter can study.', 'Ich spare, damit meine Tochter studieren kann.'),
            ('Because of the rain, the dog stayed in bed.', 'Wegen des Regens blieb der Hund im Bett.'),
        ], 1, not_german=True),
        gaps('Your view', 'Should everyone work from home? Write your view.', [
            ('Dafür spricht, dass', '.'), ('Dagegen lässt sich einwenden, dass', '.'), ('Meiner Ansicht nach', '.'),
        ], 'About you.'),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        write(MISTAKE, MISTAKE_I, [
            ('Sie sagte, sie hat keine Zeit.', 'Sie sagte, sie habe keine Zeit.'),
            ('Er fragte, wenn ich morgen komme.', 'Er fragte, ob ich morgen komme.'),
            ('Sie wollte wissen, wo wohnst du.', 'Sie wollte wissen, wo du wohnst.'),
            ('Ich warte seit einer Stunde für den Bus.', 'Ich warte seit einer Stunde auf den Bus.'),
            ('Er ist stolz von dem Ergebnis.', 'Er ist stolz auf das Ergebnis.'),
        ], 1),
        write('Report it', 'Start with Er sagte, … or Er fragte, … .', [
            ('„Ich bin krank.“', 'Er sagte, er sei krank.'),
            ('„Hast du Zeit?“', 'Er fragte, ob ich Zeit habe.'),
            ('„Ich habe den Zug verpasst.“', 'Er sagte, er habe den Zug verpasst.'),
            ('„Warte bitte!“', 'Er sagte, ich solle warten.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('I am looking forward to the weekend.', 'Ich freue mich auf das Wochenende.'),
            ('She is interested in politics.', 'Sie interessiert sich für Politik.'),
            ('His interest in politics is small.', 'Sein Interesse an Politik ist gering.'),
            ('We are satisfied with the result.', 'Wir sind mit dem Ergebnis zufrieden.'),
        ], 1, not_german=True),
    ],
    'review_2': [
        write(MISTAKE, MISTAKE_I, [
            ('Die Fehler sind korrigiert geworden.', 'Die Fehler sind korrigiert worden.'),
            ('Das Formular müssen ausgefüllt werden.', 'Das Formular muss ausgefüllt werden.'),
            ('Hier es wird nicht gearbeitet.', 'Hier wird nicht gearbeitet.'),
            ('Er wird nicht geantwortet.', 'Ihm wird nicht geantwortet.'),
            ('Wir haben die Wohnung renovieren gelassen.', 'Wir haben die Wohnung renovieren lassen.'),
            ('Der Konferenz war lang.', 'Die Konferenz war lang.'),
        ], 1),
        write('In the passive', 'Write it in the passive.', [
            ('Man muss die Regeln beachten.', 'Die Regeln müssen beachtet werden.'),
            ('Man hat das Haus 1990 gebaut.', 'Das Haus ist 1990 gebaut worden.'),
            ('Man hilft dem Kind.', 'Dem Kind wird geholfen.'),
            ('Man arbeitet hier sonntags nicht.', 'Hier wird sonntags nicht gearbeitet.'),
        ], 1),
        write(TRANSLATE, TRANSLATE_I, [
            ('I am having my car repaired.', 'Ich lasse mein Auto reparieren.'),
            ('The shop is closed.', 'Das Geschäft ist geschlossen.'),
            ('The contract has been signed.', 'Der Vertrag ist unterschrieben worden.'),
            ('The barking dog has eaten my egg.', 'Der bellende Hund hat mein Ei gegessen.'),
            ('People laughed a lot at the party.', 'Auf der Party wurde viel gelacht.'),
        ], 1, not_german=True),
    ],
    'review_3': [
        write(MISTAKE, MISTAKE_I, [
            ('Es war kalt. Trotzdem wir gingen spazieren.', 'Es war kalt. Trotzdem gingen wir spazieren.'),
            ('Ich gebe ihm es morgen.', 'Ich gebe es ihm morgen.'),
            ('Wegen dem Regen blieben wir zu Hause.', 'Wegen des Regens blieben wir zu Hause.'),
            ('Ich spare, um mein Sohn studieren kann.', 'Ich spare, damit mein Sohn studieren kann.'),
            ('Ihr braucht nicht warten.', 'Ihr braucht nicht zu warten.'),
            ('Meiner Meinung nach, dass das stimmt.', 'Meiner Meinung nach stimmt das.'),
        ], 1),
        write('Say it shorter', 'Write it with wegen, nach, dank or bei.', [
            ('Weil es regnete, blieben wir zu Hause.', 'Wegen des Regens blieben wir zu Hause.'),
            ('Nachdem wir gegessen hatten, gingen wir.', 'Nach dem Essen gingen wir.'),
            ('Weil du geholfen hast, ist alles fertig.', 'Dank deiner Hilfe ist alles fertig.'),
            ('Als er ankam, weinte die Katze vor Freude.', 'Bei seiner Ankunft weinte die Katze vor Freude.'),
        ], 1),
        write('Put it in order', 'Write the sentence in the usual order.', [
            ('Sie fährt (nach Leipzig · morgen · mit dem Bus).', 'Sie fährt morgen mit dem Bus nach Leipzig.'),
            ('Er ging (zur Arbeit · gestern · zu Fuß).', 'Er ging gestern zu Fuß zur Arbeit.'),
            ('Ich habe (die Fotos · ihr · gestern) gezeigt.', 'Ich habe ihr gestern die Fotos gezeigt.'),
            ('Kannst du (mir · es) geben?', 'Kannst du es mir geben?'),
        ], 1),
        gaps('About you', 'Finish the sentences.', [
            ('Ich lerne Deutsch, um', '.'), ('Morgen brauche ich nicht', '.'),
        ], 'About you.'),
    ],
}
