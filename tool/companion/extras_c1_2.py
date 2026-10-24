# Extra exercises for the C1.2 book: they fill the free space on each practice page and review page.
# Merged by kit.write_book when tool/companion/c1_2.py runs (rules: docs/study_companion_guide.md).
from kit import gaps, write  # noqa: F401

MISTAKE = 'Each sentence has one mistake. Write the sentence correctly.'
GERMAN = 'Write it in German.'

EXTRAS = {
    'kultur': [
        write('Find the mistake', MISTAKE, [
            ('Die Begeisterung auf das Stück war groß.', 'Die Begeisterung für das Stück war groß.'),
            ('Der Film ist eine Auseinandersetzung an der Frage, wie Medien uns prägen.', 'Der Film ist eine Auseinandersetzung mit der Frage, wie Medien uns prägen.'),
            ('Die Kritik für die Inszenierung war groß.', 'Die Kritik an der Inszenierung war groß.'),
            ('Die Anspielungen an die Gegenwart blieben umstritten.', 'Die Anspielungen auf die Gegenwart blieben umstritten.'),
        ], 1),
        write('The precise word', 'Write it with a more precise word from the left page.', [
            ('Das Stück war gut.', 'Das Stück war gelungen. (or: überzeugend)'),
            ('Der Film war interessant.', 'Der Film war vielschichtig. (or: aufschlussreich, anregend)'),
            ('Die Inszenierung war schwierig.', 'Die Inszenierung war anspruchsvoll.'),
            ('Die Ausstellung war schlecht.', 'Die Ausstellung war oberflächlich.'),
        ], 1),
    ],
    'vermutung': [
        write('Find the mistake', MISTAKE, [
            ('Die Straße ist nass – es muss geregnet sein.', 'Die Straße ist nass – es muss geregnet haben.'),
            ('Sie könnte schon gegangen haben.', 'Sie könnte schon gegangen sein.'),
            ('Er dürfte den Bus verpasst sein.', 'Er dürfte den Bus verpasst haben.'),
        ], 1),
        write('Say it with a modal', 'Write it with muss, dürfte or könnte.', [
            ('Wahrscheinlich steht er im Stau.', 'Er dürfte im Stau stehen.'),
            ('Ich bin sicher: Sie ist verreist.', 'Sie muss verreist sein.'),
            ('Es ist möglich, dass sie schon schläft.', 'Sie könnte schon schlafen.'),
        ], 1),
        write('Translate', GERMAN, [
            ('The post is piling up – they must be on holiday.', 'Die Post stapelt sich – sie müssen im Urlaub sein.'),
            ('That can’t be true!', 'Das kann nicht wahr sein!'),
            ('He should have been here long ago.', 'Er müsste längst hier sein.'),
        ], 1, not_german=True),
    ],
    'hoerensagen': [
        write('Say it with soll or will', 'Write it in one sentence with soll or will.', [
            ('Man sagt, der Händler hat das Gemälde legal erworben.', 'Der Händler soll das Gemälde legal erworben haben.'),
            ('Er behauptet, er ist den Marathon in drei Stunden gelaufen.', 'Er will den Marathon in drei Stunden gelaufen sein.'),
            ('Angeblich wurde das Bild gestohlen.', 'Das Bild soll gestohlen worden sein.'),
            ('Man sagt, die Katze ist reich.', 'Die Katze soll reich sein.'),
            ('Sie behauptet, sie hat den Täter erkannt.', 'Sie will den Täter erkannt haben.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Er will von nichts gewusst.', 'Er will von nichts gewusst haben.'),
            ('Das Bild soll gestohlen sein worden.', 'Das Bild soll gestohlen worden sein.'),
            ('Der Minister soll zurückgetreten haben.', 'Der Minister soll zurückgetreten sein.'),
            ('Der Zeuge soll den Täter erkannt haben, behauptet er selbst.', 'Der Zeuge will den Täter erkannt haben.'),
            ('Die Katze will reich sein, sagen alle.', 'Die Katze soll reich sein.'),
        ], 1),
    ],
    'konj1': [
        write('Find the mistake', 'Each sentence is a formal report with one mistake. Write it correctly.', [
            ('Er sagte, er hätte keine Zeit.', 'Er sagte, er habe keine Zeit.'),
            ('Die Befragten gaben an, sie haben kaum Vertrauen.', 'Die Befragten gaben an, sie hätten kaum Vertrauen.'),
            ('Sie fragte, ob die Finanzierung gesichert ist.', 'Sie fragte, ob die Finanzierung gesichert sei.'),
            ('Der Arzt sagte, er soll sich schonen.', 'Der Arzt sagte, er solle sich schonen.'),
        ], 1),
        write('Report it', 'Write it as reported speech in the Konjunktiv I.', [
            ('„Wir sind auf Unterstützung angewiesen.“', 'Sie sagten, sie seien auf Unterstützung angewiesen.'),
            ('„Das Ehrenamt kann den Sozialstaat nicht ersetzen.“', 'Sie sagte, das Ehrenamt könne den Sozialstaat nicht ersetzen.'),
            ('„Fassen Sie sich bitte kurz.“', 'Er bat, man möge sich kurz fassen.'),
        ], 1),
    ],
    'abschwaechen': [
        write('Soften it', 'Say it at the right strength.', [
            ('Das stimmt nicht.', 'Ich wage zu bezweifeln, dass das stimmt.'),
            ('Sie haben unrecht.', 'In gewisser Weise haben Sie recht, aber …'),
            ('Das ist ein Skandal.', 'Das ist, gelinde gesagt, überraschend.'),
            ('Der Ansatz ist nicht tragfähig.', 'Der Ansatz dürfte kaum tragfähig sein.'),
            ('Ihr Hund ist laut.', 'Ihr Hund ist, gelinde gesagt, nicht ganz leise.'),
            ('Die Daten sind falsch.', 'Die Daten dürften kaum zutreffen.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Vermutlich dürfte das stimmen.', 'Das dürfte stimmen. (or: Das stimmt vermutlich.)'),
            ('Ich wage zu bezweifeln, dass das nicht stimmt.', 'Ich wage zu bezweifeln, dass das stimmt.'),
            ('Es könnte durchaus sein, dass ich irre mich.', 'Es könnte durchaus sein, dass ich mich irre.'),
            ('Das dürfte vermutlich stimmen.', 'Das dürfte stimmen. (or: Das stimmt vermutlich.)'),
        ], 1),
    ],
    'kritik': [
        write('Find the mistake', MISTAKE, [
            ('Sie haben früher kommen sollen.', 'Sie hätten früher kommen sollen.'),
            ('Das hätte vermieden können werden.', 'Das hätte vermieden werden können.'),
            ('Das war ein Problem, weil der Bericht geschickt werden sollen hätte.', 'Das war ein Problem, weil der Bericht hätte geschickt werden sollen.'),
            ('Es wäre ratsam gewesen, die Frist vorher klären.', 'Es wäre ratsam gewesen, die Frist vorher zu klären.'),
        ], 1),
        write('Criticise, then recommend', 'Write the criticism with hätten … müssen, then a recommendation with künftig.', [
            ('Sie haben die Kunden nicht informiert.', 'Sie hätten die Kunden informieren müssen. Künftig sollten Sie sie rechtzeitig informieren.'),
            ('Sie haben die Unterlagen nicht vollständig eingereicht.', 'Sie hätten die Unterlagen vollständig einreichen müssen. Künftig sollten Sie alles vollständig einreichen.'),
        ], 1),
        write('Translate', GERMAN, [
            ('That could have been avoided.', 'Das hätte vermieden werden können.'),
            ('In your place I would have asked.', 'An Ihrer Stelle hätte ich nachgefragt.'),
            ('You should have fed the cat.', 'Du hättest die Katze füttern sollen.'),
        ], 1, not_german=True),
    ],
    'ironie': [
        write('What it really means', 'Write what the speaker really means, in plain German.', [
            ('Na, das ist ja großartig gelaufen.', 'Das ist schlecht gelaufen.'),
            ('Du bist aber früh dran! (zu jemandem, der zu spät kommt)', 'Du bist zu spät.'),
            ('Das war nicht ganz optimal.', 'Das war schlecht.'),
            ('Schön wär’s!', 'Leider ist es nicht so.'),
        ], 1),
        write('Translate', GERMAN, [
            ('Where on earth are you?', 'Wo bleibst du denn?'),
            ('Don’t you DARE touch that!', 'Fass das JA nicht an!'),
            ('If only I had more time!', 'Wenn ich nur mehr Zeit hätte!'),
            ('You didn’t lie, did you?', 'Hast du etwa gelogen?'),
        ], 1, not_german=True),
    ],
    'review_1': [
        gaps('Which word?', 'Write the missing word.', [
            ('Er', 'längst hier sein. (by rights)', 'müsste'),
            ('Sie', 'schon gegangen sein. (possibly)', 'könnte'),
            ('Er behauptet, er war krank. → Er', 'krank gewesen sein.', 'will'),
            ('Der Arzt sagte, er', 'sich schonen. (sollen)', 'solle'),
            ('Ich', 'zu bezweifeln, dass das stimmt.', 'wage'),
            ('Es wäre ratsam', ', die Frist zu klären.', 'gewesen'),
        ]),
        write('What it really means', 'Write what the speaker really means, in plain German.', [
            ('Das ist, gelinde gesagt, überraschend.', 'Das ist ein Skandal.'),
            ('Das dürfte kaum zutreffen.', 'Das ist falsch.'),
            ('Na, das hast du ja großartig hinbekommen.', 'Das hast du schlecht gemacht.'),
            ('Da möchte ich mich ungern festlegen.', 'Ich weiß es nicht. (or: Ich sage dazu nichts.)'),
        ], 1),
        write('Translate', GERMAN, [
            ('People say the island is overcrowded in summer.', 'Die Insel soll im Sommer überfüllt sein.'),
            ('He claims he ran the marathon.', 'Er will den Marathon gelaufen sein.'),
            ('You should have come earlier.', 'Sie hätten früher kommen sollen.'),
            ('That must be true.', 'Das muss wahr sein.'),
        ], 1, not_german=True),
        gaps('About you', 'Finish the sentences about yourself.', [
            ('Mein Nachbar soll', '.'), ('Ich hätte gestern', 'sollen.'), ('Künftig sollte ich', '.'),
        ], 'About you.'),
    ],
    'vorsilben': [
        write('Find the mistake', MISTAKE, [
            ('Ich beantworte auf die Frage.', 'Ich beantworte die Frage.'),
            ('Ich antworte die Frage.', 'Ich antworte auf die Frage.'),
            ('Wir haben den Antrag schon bearbeiten.', 'Wir haben den Antrag schon bearbeitet.'),
            ('Die Katze hat die Vase zerbrochen und ist entkommt.', 'Die Katze hat die Vase zerbrochen und ist entkommen.'),
        ], 1),
        write('Say it with be-', 'Write it with a be- verb and no little word.', [
            ('Ich antworte auf die E-Mail.', 'Ich beantworte die E-Mail.'),
            ('Sie wohnt in einem kleinen Haus.', 'Sie bewohnt ein kleines Haus.'),
            ('Wir arbeiten an dem Antrag.', 'Wir bearbeiten den Antrag.'),
        ], 1),
        write('Translate', GERMAN, [
            ('I got lost in the city.', 'Ich habe mich in der Stadt verlaufen.'),
        ], 1, not_german=True),
    ],
    'praefixe': [
        write('Find the mistake', MISTAKE, [
            ('Wegen des Staus hat er die Stadt umgefahren.', 'Wegen des Staus hat er die Stadt umfahren.'),
            ('Er hat den Pfosten umfahren, jetzt ist er kaputt.', 'Er hat den Pfosten umgefahren, jetzt ist er kaputt.'),
            ('Er hat den Brief ins Deutsche übergesetzt.', 'Er hat den Brief ins Deutsche übersetzt.'),
            ('Wir haben mit der Fähre übersetzt.', 'Wir sind mit der Fähre übergesetzt.'),
        ], 1),
        write('Translate', GERMAN, [
            ('He knocked the post down.', 'Er hat den Pfosten umgefahren.'),
            ('He drove round the city.', 'Er hat die Stadt umfahren.'),
            ('She saw through the trick at once.', 'Sie hat den Trick sofort durchschaut.'),
            ('Please repeat the question.', 'Bitte wiederholen Sie die Frage.'),
        ], 1, not_german=True),
        write('Picture it', 'Write the verb in brackets in the Perfekt.', [
            ('Der Pfosten ist kaputt. Er … (umfahren)', 'Er hat ihn umgefahren.'),
            ('Wir sind jetzt auf der anderen Seite. Wir … (übersetzen)', 'Wir sind übergesetzt.'),
        ], 1),
    ],
    'nachsilben': [
        write('One word', 'Write it as one describing word.', [
            ('ein Tag ohne Wolken', 'ein wolkenloser Tag'),
            ('Getränke ohne Alkohol', 'alkoholfreie Getränke'),
            ('Er hat keine Arbeit.', 'Er ist arbeitslos.'),
            ('Man kann das Projekt durchführen.', 'Das Projekt ist durchführbar.'),
        ], 1),
        write('Translate', GERMAN, [
            ('Her calm surprised me.', 'Ihre Gelassenheit hat mich überrascht.'),
            ('Don’t be childish!', 'Sei nicht kindisch!'),
            ('Loneliness is a big problem.', 'Die Einsamkeit ist ein großes Problem.'),
        ], 1, not_german=True),
    ],
    'numerus': [
        write('Find the mistake', MISTAKE, [
            ('Die Eltern ist im Urlaub.', 'Die Eltern sind im Urlaub.'),
            ('Das Gepäck sind sehr schwer.', 'Das Gepäck ist sehr schwer.'),
            ('Ich habe ein Möbel gekauft.', 'Ich habe ein Möbelstück gekauft.'),
            ('Die Leute ist sehr nett.', 'Die Leute sind sehr nett.'),
            ('Liebe Studierender!', 'Liebe Studierende!'),
        ], 1),
        write('Words for everyone', 'Write it with a word for everyone.', [
            ('Liebe Studenten!', 'Liebe Studierende!'),
            ('Die Lehrer bitten um Ruhe.', 'Die Lehrkräfte bitten um Ruhe.'),
            ('Alle Kollegen bekommen ein Eis.', 'Alle Kolleginnen und Kollegen bekommen ein Eis.'),
            ('Die Teilnehmer sind müde.', 'Die Teilnehmenden sind müde.'),
        ], 1),
    ],
    'redewendungen': [
        write('Say it with an idiom', 'Write it with an idiom from the left page.', [
            ('Er verschiebt die Arbeit immer wieder.', 'Er schiebt die Arbeit auf die lange Bank.'),
            ('Genau so ist es!', 'Damit haben Sie den Nagel auf den Kopf getroffen.'),
            ('Du irrst dich.', 'Du bist auf dem Holzweg.'),
            ('Die Firma versteckt den Fehler.', 'Die Firma kehrt den Fehler unter den Teppich.'),
            ('Mit seinem Antrag startet er eine Debatte.', 'Mit seinem Antrag bringt er eine Debatte ins Rollen.'),
        ], 1),
        write('Find the mistake', 'One word in each idiom is wrong. Write the idiom correctly.', [
            ('Er hat den Nagel auf den Fuß getroffen.', 'Er hat den Nagel auf den Kopf getroffen.'),
            ('Er schenkt dem Kunden reinen Kaffee ein.', 'Er schenkt dem Kunden reinen Wein ein.'),
            ('Wir sitzen alle im selben Zug.', 'Wir sitzen alle im selben Boot.'),
            ('Er ist ins Fettnäpfchen gefallen.', 'Er ist ins Fettnäpfchen getreten.'),
            ('Die Reform wurde auf die kurze Bank geschoben.', 'Die Reform wurde auf die lange Bank geschoben.'),
        ], 1),
    ],
    'relativ': [
        write('Find the mistake', MISTAKE, [
            ('der Autor, mit der Hilfe dessen ich das Buch schrieb', 'der Autor, mit dessen Hilfe ich das Buch schrieb'),
            ('die Kollegen, auf dessen Unterstützung ich zähle', 'die Kollegen, auf deren Unterstützung ich zähle'),
            ('Er sagte ab, das alle enttäuschte.', 'Er sagte ab, was alle enttäuschte.'),
            ('Er hat bestanden, auf was wir gehofft hatten.', 'Er hat bestanden, worauf wir gehofft hatten.'),
        ], 1),
        write('Join them', 'Write one sentence with a relative clause.', [
            ('Das ist die Professorin. Mit ihrer Hilfe kam das Projekt zustande.', 'Das ist die Professorin, mit deren Hilfe das Projekt zustande kam.'),
            ('Das ist der Autor. Auf seine Antwort warte ich noch.', 'Das ist der Autor, auf dessen Antwort ich noch warte.'),
            ('Er hat angerufen. Damit hatte niemand gerechnet.', 'Er hat angerufen, womit niemand gerechnet hatte.'),
        ], 1),
        write('Translate', GERMAN, [
            ('He came on time, which surprised everyone.', 'Er kam pünktlich, was alle überraschte.'),
            ('the country I come from', 'das Land, woher ich stamme'),
            ('the professor whose help I count on', 'die Professorin, auf deren Hilfe ich zähle'),
        ], 1, not_german=True),
    ],
    'review_2': [
        gaps('Which word?', 'Write the word in brackets in the form the sentence needs.', [
            ('Ich habe den Brief schon', '. (antworten, be-)', 'beantwortet'),
            ('Wir haben uns im Wald', '. (laufen, ver-)', 'verlaufen'),
            ('Wir sind mit der Fähre', '. (übersetzen)', 'übergesetzt'),
            ('Er reagierte mit großer', '. (gelassen)', 'Gelassenheit'),
            ('In den', 'der Stadt ist der Eintritt kostenlos. (Museum)', 'Museen'),
            ('Das ist die Professorin, mit', 'Hilfe das Projekt zustande kam.', 'deren'),
        ]),
        write('Build the noun', 'Write the noun with -heit or -keit, with its article.', [
            ('einsam', 'die Einsamkeit'), ('krank', 'die Krankheit'), ('durchführbar', 'die Durchführbarkeit'), ('gleichgültig', 'die Gleichgültigkeit'),
        ], 2),
        write('Translate', GERMAN, [
            ('My parents are on holiday.', 'Meine Eltern sind im Urlaub.'),
            ('Dear colleagues, …', 'Liebe Kolleginnen und Kollegen, …'),
            ('That hits the nail on the head.', 'Das trifft den Nagel auf den Kopf.'),
            ('He came late, which nobody had expected.', 'Er kam spät, womit niemand gerechnet hatte.'),
            ('Dear students!', 'Liebe Studierende!'),
        ], 1, not_german=True),
        gaps('About you', 'Finish the sentences about yourself.', [
            ('Ich schiebe gern', 'auf die lange Bank.'), ('Ich habe mich einmal in', 'verlaufen.'), ('Ich bin dankbar für', '.'), ('Ich finde es kindisch, wenn', '.'),
        ], 'About you.'),
    ],
    'kohaesion': [
        write('Don’t repeat it', 'Write the second sentence without repeating the noun.', [
            ('Es gibt ein Problem. Das Problem ist alt.', 'Es gibt ein Problem. Diese Schwierigkeit ist alt.'),
            ('Man will die Prüfung verschieben. Das Verschieben wäre teuer.', 'Man will die Prüfung verschieben. Ein solcher Schritt wäre teuer.'),
            ('Zwei Vorschläge: A ist teuer. B ist billig.', 'Ersterer ist teuer, Letzterer ist billig.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Zwei Vorschläge: Letzterer wurde abgelehnt, Letzterer angenommen.', 'Zwei Vorschläge: Ersterer wurde abgelehnt, Letzterer angenommen.'),
            ('Ein solches Schritt wäre teuer.', 'Ein solcher Schritt wäre teuer.'),
            ('Zum einen wegen der Energie, zum zweiten wegen der Löhne.', 'Zum einen wegen der Energie, zum anderen wegen der Löhne.'),
        ], 1),
        write('Translate', GERMAN, [
            ('Such a step would be risky.', 'Ein solcher Schritt wäre riskant.'),
            ('Indeed, costs have doubled.', 'Tatsächlich haben sich die Kosten verdoppelt.'),
            ('The following must be noted: the cat is the boss.', 'Dabei ist Folgendes zu beachten: Die Katze ist der Chef.'),
        ], 1, not_german=True),
    ],
    'umformung': [
        write('Rephrase', 'Write it another way: participle, sein + zu, sich lassen or trotz.', [
            ('das Produkt, das von der Firma hergestellt wird', 'das von der Firma hergestellte Produkt'),
            ('die Reisenden, die seit Stunden warten', 'die seit Stunden wartenden Reisenden'),
            ('Man muss die Regeln beachten.', 'Die Regeln sind zu beachten.'),
            ('Man kann das Problem lösen.', 'Das Problem lässt sich lösen.'),
            ('Obwohl die Anwohner Widerstand leisteten, wurde der Tunnel gebaut.', 'Trotz des Widerstands der Anwohner wurde der Tunnel gebaut.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('das von der Firma hergestellt Produkt', 'das von der Firma hergestellte Produkt'),
            ('Die Regeln sind beachten.', 'Die Regeln sind zu beachten.'),
            ('Das Problem lässt sich gelöst.', 'Das Problem lässt sich lösen.'),
        ], 1),
        write('Translate', GERMAN, [
            ('The rules are to be followed.', 'Die Regeln sind zu beachten.'),
            ('the tunnel planned by the city', 'der von der Stadt geplante Tunnel'),
            ('the product made by the company', 'das von der Firma hergestellte Produkt'),
        ], 1, not_german=True),
    ],
    'bericht': [
        write('Say it in the report style', 'Write it with a noun phrase.', [
            ('Weil es stark regnete, verzögerte sich der Beginn.', 'Wegen starker Regenfälle verzögerte sich der Beginn.'),
            ('Bevor die Sanierung begann, wurden die Anwohner informiert.', 'Vor Beginn der Sanierung wurden die Anwohner informiert.'),
            ('Um die Anwohner zu schützen, wurde die Straße gesperrt.', 'Zum Schutz der Anwohner wurde die Straße gesperrt.'),
            ('Obwohl die Kosten stiegen, gingen die Arbeiten weiter.', 'Trotz steigender Kosten gingen die Arbeiten weiter.'),
            ('Weil die Materialpreise gestiegen sind, wird es teurer.', 'Wegen des Anstiegs der Materialpreise wird es teurer.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Wegen fehlender Unterlagen verzögerte der Beginn.', 'Wegen fehlender Unterlagen verzögerte sich der Beginn.'),
            ('Trotz starker Regenfälle die Arbeiten gingen weiter.', 'Trotz starker Regenfälle gingen die Arbeiten weiter.'),
            ('Die Kostenüberschreitung ist auf dem Anstieg der Materialpreise zurückzuführen.', 'Die Kostenüberschreitung ist auf den Anstieg der Materialpreise zurückzuführen.'),
            ('Nach Erneuerung die Leitungen wurde die Straße geöffnet.', 'Nach Erneuerung der Leitungen wurde die Straße geöffnet.'),
            ('Vor Beginn die Arbeiten wurden die Anwohner informiert.', 'Vor Beginn der Arbeiten wurden die Anwohner informiert.'),
        ], 1),
    ],
    'register': [
        write('Make it formal', 'Write it for a formal e-mail.', [
            ('Kannst du mir mal die Daten schicken?', 'Könnten Sie mir bitte die Daten zukommen lassen?'),
            ('Sorry, dass ich so spät antworte.', 'Bitte entschuldigen Sie, dass ich so spät antworte.'),
            ('Das geht so echt nicht.', 'In dieser Form ist das nicht umsetzbar.'),
            ('Ruf an, wenn du Fragen hast.', 'Für Rückfragen stehe ich Ihnen jederzeit zur Verfügung.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Sehr geehrte Frau Roth, kannst du mir helfen?', 'Sehr geehrte Frau Roth, können Sie mir helfen?'),
            ('Dieser Punkt bedarf die Klärung.', 'Dieser Punkt bedarf der Klärung.'),
            ('Ich halte die Lösung bedenklich.', 'Ich halte die Lösung für bedenklich.'),
        ], 1),
        write('Translate', GERMAN, [
            ('Would it be possible for you to send me the documents?', 'Wäre es Ihnen möglich, mir die Unterlagen zukommen zu lassen?'),
            ('This point needs clarification.', 'Dieser Punkt bedarf der Klärung.'),
            ('I consider the proposed solution questionable.', 'Ich halte die vorgeschlagene Lösung für bedenklich.'),
        ], 1, not_german=True),
    ],
    'redemittel': [
        write('Find the mistake', MISTAKE, [
            ('Ich vertrete die Auffassung, dass überwiegen die Vorteile.', 'Ich vertrete die Auffassung, dass die Vorteile überwiegen.'),
            ('Mein Vortrag befasst mit dem Homeoffice.', 'Mein Vortrag befasst sich mit dem Homeoffice.'),
            ('Dies dürfte auf die Kosten zurückzuführen.', 'Dies dürfte auf die Kosten zurückzuführen sein.'),
        ], 1),
        gaps('Your position', 'Take a position on working from home. Finish the sentences.', [
            ('Ich vertrete die Auffassung, dass', '.'), ('Zwar lässt sich einwenden, dass', ', doch …'),
        ], 'About you.'),
    ],
    'forum': [
        write('Firm, not rude', 'Write it firmly and politely.', [
            ('Geben Sie mir sofort mein Geld zurück!', 'Ich fordere Sie daher auf, mir den Betrag bis spätestens 15. März zu erstatten.'),
            ('Antworten Sie endlich!', 'Ich hoffe auf eine zeitnahe Rückmeldung.'),
            ('Ihr habt alle unrecht!', 'Dem möchte ich entgegenhalten, dass …'),
        ], 1),
        write('Translate', GERMAN, [
            ('I read the posts so far with interest.', 'Mit Interesse habe ich die bisherigen Beiträge gelesen.'),
            ('I am turning to you because the washing machine is broken.', 'Ich wende mich an Sie, da die Waschmaschine kaputt ist.'),
            ('How do you see it?', 'Wie seht ihr das?'),
            ('Otherwise I shall be forced to take legal action.', 'Andernfalls sehe ich mich gezwungen, rechtliche Schritte einzuleiten.'),
        ], 1, not_german=True),
    ],
    'literatur': [
        write('Say it with a participle', 'Start the sentence with a participle.', [
            ('Sie hatte den Brief in der Hand und trat ans Fenster.', 'Den Brief in der Hand haltend, trat sie ans Fenster.'),
            ('Sie hatte die Knie an die Brust gezogen und saß da.', 'Die Knie an die Brust gezogen, saß sie da.'),
            ('Während sie Tee trank, las sie den Brief.', 'Tee trinkend, las sie den Brief.'),
        ], 1),
        write('Find the mistake', MISTAKE, [
            ('Den Umschlag in der Hand haltend, trat sie ins Fenster.', 'Den Umschlag in der Hand haltend, trat sie ans Fenster.'),
            ('Lächelnd, öffnete der Fremde die Tür.', 'Lächelnd öffnete der Fremde die Tür.'),
            ('Den Umschlag in der Hand haltend, öffnete sich die Tür.', 'Den Umschlag in der Hand haltend, öffnete sie die Tür.'),
        ], 1),
        write('Translate', GERMAN, [
            ('Holding the envelope, she went to the window.', 'Den Umschlag haltend, trat sie ans Fenster.'),
            ('At midnight there was a knock at the door.', 'Um Mitternacht klopfte es an der Tür.'),
        ], 1, not_german=True),
    ],
    'review_3': [
        gaps('Which word?', 'Write the missing word.', [
            ('Zwei Vorschläge: Ersterer wurde abgelehnt,', 'angenommen.', 'Letzterer'),
            ('Die Regeln sind', '. (beachten)', 'zu beachten'),
            ('', 'starker Regenfälle gingen die Arbeiten weiter.', 'Trotz'),
            ('Dieser Punkt bedarf der', '.', 'Klärung'),
            ('Die Daten', 'von einer bundesweiten Umfrage.', 'stammen'),
            ('Ich', 'mich an Sie, da …', 'wende'),
            ('Ich halte die Lösung', 'bedenklich.', 'für'),
        ]),
        write('Make it formal', 'Write it for a formal letter.', [
            ('Kannst du mir die Unterlagen schicken?', 'Könnten Sie mir bitte die Unterlagen zukommen lassen?'),
            ('Find ich nicht gut.', 'Ich halte das für bedenklich.'),
            ('Machen Sie das sofort!', 'Ich fordere Sie daher auf, dies bis spätestens Freitag zu erledigen.'),
            ('Sonst gehe ich zum Anwalt!', 'Andernfalls sehe ich mich gezwungen, rechtliche Schritte einzuleiten.'),
        ], 1),
        write('Translate', GERMAN, [
            ('Such an approach would be expensive.', 'Ein solches Vorgehen wäre teuer.'),
            ('Due to missing documents, the start was delayed.', 'Wegen fehlender Unterlagen verzögerte sich der Beginn.'),
            ('My talk deals with the heat in the city.', 'Mein Vortrag befasst sich mit der Hitze in der Stadt.'),
            ('Dear Ms Roth, …', 'Sehr geehrte Frau Roth, …'),
        ], 1, not_german=True),
        gaps('About you', 'Write a short complaint about something that went wrong. Finish the sentences.', [
            ('Ich wende mich an Sie, da', '.'), ('Ich fordere Sie daher auf,', '.'), ('Ich hoffe auf', '.'),
        ], 'About you.'),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        write('Find the mistake', MISTAKE, [
            ('Er dürfte den Zug verpasst sein.', 'Er dürfte den Zug verpasst haben.'),
            ('Die Insel will im Sommer überfüllt sein.', 'Die Insel soll im Sommer überfüllt sein.'),
            ('Er sagte, er hat keine Zeit.', 'Er sagte, er habe keine Zeit.'),
            ('Sie haben den Bericht früher schicken sollen.', 'Sie hätten den Bericht früher schicken sollen.'),
            ('Hast du denn gelogen? Das glaube ich nicht!', 'Hast du etwa gelogen? Das glaube ich nicht!'),
            ('Der Film zeigt, wie die Medien unsere Sicht prägt.', 'Der Film zeigt, wie die Medien unsere Sicht prägen.'),
        ], 1),
        write('Say it another way', 'Write it with the word in brackets.', [
            ('Wahrscheinlich hat er den Bus verpasst. (dürfte)', 'Er dürfte den Bus verpasst haben.'),
            ('Man sagt, sie ist reich. (soll)', 'Sie soll reich sein.'),
            ('„Ich bin krank“, sagte er. (sei)', 'Er sagte, er sei krank.'),
            ('Das ist falsch. (dürfte kaum)', 'Das dürfte kaum zutreffen.'),
            ('Sie haben nicht nachgefragt. (an Ihrer Stelle)', 'An Ihrer Stelle hätte ich nachgefragt.'),
        ], 1),
        write('Translate', GERMAN, [
            ('The light is on – he must be at home.', 'Das Licht brennt – er muss zu Hause sein.'),
            ('He is said to have acquired the painting legally.', 'Er soll das Gemälde legal erworben haben.'),
            ('She asked whether the funding was secured.', 'Sie fragte, ob die Finanzierung gesichert sei.'),
            ('That should have been avoided.', 'Das hätte vermieden werden sollen.'),
            ('It might have rained.', 'Es könnte geregnet haben.'),
        ], 1, not_german=True),
    ],
    'review_2': [
        write('Find the mistake', MISTAKE, [
            ('Wir antworten die E-Mail morgen.', 'Wir beantworten die E-Mail morgen.'),
            ('Wegen des Staus hat er die Stadt umgefahren.', 'Wegen des Staus hat er die Stadt umfahren.'),
            ('Die Ferien ist leider vorbei.', 'Die Ferien sind leider vorbei.'),
            ('Das Gepäck sind schon gepackt.', 'Das Gepäck ist schon gepackt.'),
            ('Die Reform wurde auf den langen Tisch geschoben.', 'Die Reform wurde auf die lange Bank geschoben.'),
            ('der Autor, mit deren Hilfe ich das Buch schrieb', 'der Autor, mit dessen Hilfe ich das Buch schrieb'),
        ], 1),
        write('Say it another way', 'Write it with the word in brackets.', [
            ('Getränke ohne Alkohol (-frei)', 'alkoholfreie Getränke'),
            ('Die Lehrer bitten um Ruhe. (Lehrkraft)', 'Die Lehrkräfte bitten um Ruhe.'),
            ('Er schiebt die Arbeit immer wieder auf. (Bank)', 'Er schiebt die Arbeit auf die lange Bank.'),
            ('Er sagte ab. Das enttäuschte alle. (was)', 'Er sagte ab, was alle enttäuschte.'),
            ('Man kann das Projekt durchführen. (-bar)', 'Das Projekt ist durchführbar.'),
        ], 1),
        write('Translate', GERMAN, [
            ('She reached her goal.', 'Sie hat ihr Ziel erreicht.'),
            ('He translated the letter.', 'Er hat den Brief übersetzt.'),
            ('You are on the wrong track.', 'Du bist auf dem Holzweg.'),
            ('the museums of the city', 'die Museen der Stadt'),
            ('The costs are high.', 'Die Kosten sind hoch.'),
        ], 1, not_german=True),
    ],
    'review_3': [
        write('Find the mistake', MISTAKE, [
            ('Ein solches Schritt wäre riskant.', 'Ein solcher Schritt wäre riskant.'),
            ('Das Problem lässt sich gelöst.', 'Das Problem lässt sich lösen.'),
            ('Wegen fehlender Unterlagen verzögerte der Beginn.', 'Wegen fehlender Unterlagen verzögerte sich der Beginn.'),
            ('Sehr geehrte Frau Roth, kannst du mir helfen?', 'Sehr geehrte Frau Roth, können Sie mir helfen?'),
            ('Ich vertrete die Auffassung, dass überwiegen die Vorteile.', 'Ich vertrete die Auffassung, dass die Vorteile überwiegen.'),
            ('Lächelnd, öffnete sie den Brief.', 'Lächelnd öffnete sie den Brief.'),
        ], 1),
        write('Say it another way', 'Write it with the word in brackets.', [
            ('Man muss die Regeln beachten. (sind … zu)', 'Die Regeln sind zu beachten.'),
            ('die Kosten, die ständig steigen (steigend)', 'die ständig steigenden Kosten'),
            ('Weil Unterlagen fehlten, … (wegen)', 'Wegen fehlender Unterlagen …'),
            ('Sorry, dass ich so spät antworte. (entschuldigen)', 'Bitte entschuldigen Sie, dass ich so spät antworte.'),
            ('Ihr habt alle unrecht! (entgegenhalten)', 'Dem möchte ich entgegenhalten, dass …'),
            ('Kannst du mal die Daten schicken? (zukommen lassen)', 'Könnten Sie mir bitte die Daten zukommen lassen?'),
        ], 1),
        write('Translate', GERMAN, [
            ('The tunnel planned by the city is expensive.', 'Der von der Stadt geplante Tunnel ist teuer.'),
            ('This could be due to the heat.', 'Dies dürfte auf die Hitze zurückzuführen sein.'),
            ('For questions I am available at any time.', 'Für Rückfragen stehe ich Ihnen jederzeit zur Verfügung.'),
            ('Holding the letter, she went to the door.', 'Den Brief haltend, trat sie an die Tür.'),
            ('Indeed, the costs have doubled.', 'Tatsächlich haben sich die Kosten verdoppelt.'),
        ], 1, not_german=True),
    ],
}
