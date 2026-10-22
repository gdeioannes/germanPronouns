# Builds assets/content/companion/de_cert_a1/b1_2.json — the B1.2 study companion.
# Run: python -I tool/companion/b1_2.py   (rules: docs/study_companion_guide.md)
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kit  # noqa: E402
from kit import (a, arrow, box, build, circle, cols, flow, gaps, match, pictures, q, review, sl, slots,  # noqa: E402,F401
                 spread, table, tags_ex, tiles, timeline, words, write)

kit.HERO_PREFIX = 'cp_b1_2_'
OUT = os.path.join(os.path.dirname(__file__), '..', '..', 'assets', 'content', 'companion', 'de_cert_a1', 'b1_2.json')
Q = 'quest_b1_2_'
spreads = []


def sort_ex(title, instruction, columns, words_in_cols):
    return {'title': title, 'instruction': instruction, 'kind': 'sort', 'columns': columns,
            'words': [w for w, _ in words_in_cols], 'answers': [c for _, c in words_in_cols]}


# ---- 1 · Technik & Medien ------------------------------------------------------------
spreads.append(spread(
    'technik', 'Technik & Medien', 'Download, save, switch it off and on again',
    'The German you need when your phone, your laptop or the office printer gives up.',
    Q + 'technik',
    [
        build('Up and down', [
            (['herunter', 'laden'], 'herunterladen', 'download'), (['hoch', 'laden'], 'hochladen', 'upload'),
            (['ein', 'schalten'], 'einschalten', 'switch on'), (['aus', 'schalten'], 'ausschalten', 'switch off'),
            (['an', 'schließen'], 'anschließen', 'connect'), (['neu', 'starten'], 'neu starten', 'restart'),
        ], 'Most of them split: Ich lade die App herunter.'),
        table('Things and their gender', ['der', 'die', 'das'], [
            ['der Bildschirm', 'die Datei', 'das Gerät'], ['der Drucker', 'die Festplatte', 'das Passwort'],
            ['der Akku', 'die Nachricht', 'das Programm'], ['der Laptop', 'die App', 'das WLAN'],
        ], genders=True),
        table('When it goes wrong', ['', '~'], [
            ['Der Bildschirm bleibt schwarz.', 'the screen stays black'], ['Das Programm stürzt ab.', 'the program crashes'],
            ['Die Verbindung ist weg.', 'the connection is gone'], ['Ich habe das Passwort vergessen.', 'I forgot the password'],
        ]),
        words('Words for the practice page', [
            ('speichern', 'to save'), ('drucken', 'to print'), ('löschen', 'to delete'), ('der Kundendienst', 'customer service'),
            ('die Präsentation', 'presentation'), ('die Kunden', 'customers'), ('leihen · sie lieh', 'to lend · lent'),
            ('kaputt', 'broken'), ('die Kollegin', 'colleague'), ('das Dokument', 'document'),
            ('bleiben · blieb', 'to stay · stayed'), ('anrufen · rief an', 'to call · called'),
        ], 3),
    ],
    [
        gaps('The right word', 'Write the missing word.', [
            ('Ich muss die Datei noch', '.', 'speichern'), ('Kannst du die App', '?', 'herunterladen'),
            ('Ich habe dir eine', 'geschickt.', 'Nachricht'), ('Der', 'von meinem Laptop ist kaputt.', 'Bildschirm'),
            ('Ich habe mein', 'schon wieder vergessen.', 'Passwort'), ('Kannst du das Dokument bitte', '?', 'drucken'),
        ]),
        circle('A bad morning', 'Listen to the story. Circle what you hear.', [
            ('Der Bildschirm blieb', ['schwarz', 'weiß'], '.', 'schwarz'),
            ('Herr Klein rief den', ['Kundendienst', 'Chef'], 'an.', 'Kundendienst'),
            ('Er hatte die Datei an seine', ['Kollegin', 'Frau'], 'geschickt.', 'Kollegin'),
            ('Die', ['Festplatte', 'Maus'], 'war kaputt.', 'Festplatte'),
        ], 1) | {'listen': True},
    ],
    ['name the things on my desk with der, die, das',
     'say what I do: speichern, herunterladen, ausschalten',
     'explain what has gone wrong'],
    listen=Q + 'lesen_technik',
))

# ---- 2 · sagte, brachte -----------------------------------------------------------------
spreads.append(spread(
    'praet_reg', 'sagte, brachte', 'The written past: -te',
    'Stories, reports and CVs are written in this past: one -te for most verbs, and nine that change their vowel too.',
    Q + 'praet_reg',
    [
        build('Stem + -te', [
            (['lern', ('te', 'suffix')], 'lernte', 'lernen'), (['kauf', ('te', 'suffix')], 'kaufte', 'kaufen'),
            (['arbeit', ('ete', 'suffix')], 'arbeitete', 'arbeiten — after -t an extra e'),
            (['brach', ('te', 'suffix')], 'brachte', 'bringen — a new vowel too'),
            (['dach', ('te', 'suffix')], 'dachte', 'denken'), (['wuss', ('te', 'suffix')], 'wusste', 'wissen'),
        ], 'ich and er are the same: ich lernte, er lernte.'),
        table('lernen in the past', ['ich', 'du', 'er · sie · es', 'wir', 'ihr', 'sie · Sie'], [
            ['lern*te*', 'lern*test*', 'lern*te*', 'lern*ten*', 'lern*tet*', 'lern*ten*'],
        ]),
        cols(
            tiles('The mixed four: -ennen', [
                ('kannte', 'kennen'), ('nannte', 'nennen'), ('rannte', 'rennen'), ('brannte', 'brennen'),
            ], 2, note='New vowel and -te.'),
            box('tip', 'Write it, don’t say it',
                'In speech Germans use the Perfekt (*ich habe gearbeitet*). Write this past in stories and CVs: *Von 2015 bis 2019 arbeitete ich …*'),
        ),
        words('Words for the practice page', [
            ('lachen', 'to laugh'), ('schicken', 'to send'), ('das Dorf', 'village'), ('die Vokabeln', 'vocabulary'),
            ('niemand', 'nobody'), ('früher', 'in the past'), ('die Haltestelle', 'stop'),
        ], 4),
    ],
    [
        gaps('-te', 'Write the verb in the past.', [
            ('Er', 'am Wochenende. (arbeiten)', 'arbeitete'), ('Wir', 'in einem kleinen Dorf. (wohnen)', 'wohnten'),
            ('Ich', 'ihm einen Brief. (schicken)', 'schickte'), ('Das Kind', 'laut. (lachen)', 'lachte'),
            ('Er', 'mir Blumen. (bringen)', 'brachte'), ('Niemand', ', wo der Schlüssel war. (wissen)', 'wusste'),
            ('Früher', 'ich alle Nachbarn. (kennen)', 'kannte'), ('Als der Bus kam,', 'wir zur Haltestelle. (rennen)', 'rannten'),
        ]),
        write('Your CV', 'Write it in the written past.', [
            ('2015–2019: arbeiten in Köln', 'Von 2015 bis 2019 arbeitete ich in Köln.'),
            ('2019: lernen Deutsch', '2019 lernte ich Deutsch.'),
        ], 1),
    ],
    ['write the past with -te',
     'add -ete after -t and -d',
     'use brachte, dachte, wusste, kannte'],
))

# ---- 3 · ging, kam, sah ---------------------------------------------------------------
spreads.append(spread(
    'praet_unreg', 'ging, kam, sah', 'The past with a new vowel',
    'gehen – ging – gegangen: learn the three together, and the middle one is the story past.',
    Q + 'praet_unreg',
    [
        slots('Three forms, one verb', [
            ([('gehen', 'now'), {'de': 'ging', 'tag': 'story past', 'hot': True}, ('ist gegangen', 'Perfekt')], None),
            ([('finden', 'now'), {'de': 'fand', 'tag': 'story past', 'hot': True}, ('hat gefunden', 'Perfekt')], None),
            ([('fahren', 'now'), {'de': 'fuhr', 'tag': 'story past', 'hot': True}, ('ist gefahren', 'Perfekt')], None),
            ([('schreiben', 'now'), {'de': 'schrieb', 'tag': 'story past', 'hot': True}, ('hat geschrieben', 'Perfekt')], None),
        ], note='Say the three together; the middle one is new.'),
        table('Vowel families', ['change', 'examples'], [
            ['ei → ie', 'bleiben – blieb · schreiben – schrieb'], ['i → a', 'finden – fand · trinken – trank'],
            ['e → a', 'geben – gab · sehen – sah · essen – aß'], ['a → u', 'fahren – fuhr · tragen – trug'],
            ['a → ie', 'schlafen – schlief · fallen – fiel'], ['on their own', 'gehen – ging · kommen – kam · stehen – stand'],
        ]),
        box('tip', 'No ending for ich and er',
            '*ich ging, er ging* — nothing added. The plural adds -en: *wir gingen, sie gingen*.'),
        words('Words for the practice page', [
            ('ankommen · sie kam an', 'to arrive'), ('das Licht', 'light'), ('der Salat', 'salad'), ('der letzte Bus', 'the last bus'),
        ], 4),
    ],
    [
        gaps('The story past', 'Write the verb in the past.', [
            ('Er', 'nach Hause. (gehen)', 'ging'), ('Sie', 'spät an. (ankommen)', 'kam'),
            ('Ich', 'ein Licht im Fenster. (sehen)', 'sah'), ('Wir', 'den Schlüssel nicht. (finden)', 'fanden'),
            ('Er', 'mir das Buch. (geben)', 'gab'), ('Wir', 'mit dem Zug nach Wien. (fahren)', 'fuhren'),
            ('Er', 'den letzten Bus. (nehmen)', 'nahm'), ('Sie', 'nur einen Salat. (essen)', 'aß'),
        ]),
        match('Which verb?', 'Draw a line from the past to the verb.', [
            ('blieb', 'bleiben'), ('trank', 'trinken'), ('trug', 'tragen'), ('schlief', 'schlafen'), ('stand', 'stehen'),
        ], [2, 4, 0, 3, 1]),
    ],
    ['recognise ging, kam, sah, fuhr',
     'know the vowel families',
     'learn each verb as three forms'],
))

# ---- 4 · hatte gemacht ----------------------------------------------------------------
spreads.append(spread(
    'plusquamperfekt', 'Der Zug war schon abgefahren', 'One step further back',
    'Als ich ankam, war der Zug schon abgefahren: the past before the past.',
    Q + 'plusquamperfekt',
    [
        timeline('Two steps back', [
            ('Der Zug war schon abgefahren.', 'first: hatte / war + past form', -3),
            ('Als ich am Bahnhof ankam, …', 'then: the story past', -1.5),
            ('Ich erzähle es dir.', 'now', 0),
        ], note='The earlier thing takes the helper in the past.'),
        slots('hatte or war + the past form', [
            (sl('Wir', 'hatten!', 'schon', 'gegessen.!'), 'haben-verbs'),
            (sl('Der Zug', 'war!', 'schon', 'abgefahren.!'), 'sein-verbs: moving, changing'),
            (sl('Nachdem', 'wir gegessen', 'hatten,!', 'gingen!', 'wir spazieren.'), 'nachdem: the earlier step'),
        ]),
        box('tip', 'schon is the signal',
            'When *schon* or *bereits* appears in a past story, the verb is usually this form: *Er war schon gegangen.*'),
        words('Words for the practice page', [
            ('bestehen · bestanden', 'to pass (an exam)'), ('verschwinden · verschwunden', 'to disappear'),
            ('feiern · sie feiert', 'to celebrate'), ('der Dieb', 'thief'), ('die Polizei', 'police'), ('die Prüfung', 'exam'), ('zweimal', 'twice'),
            ('wir kamen', 'we came'), ('umziehen · umgezogen', 'to move house'),
        ], 4),
    ],
    [
        gaps('The helper', 'Write hatte or war in the right form.', [
            ('Nachdem wir gegessen', ', gingen wir spazieren.', 'hatten'), ('Als ich ankam,', 'der Zug schon abgefahren.', 'war'),
            ('Sie', 'den Film schon zweimal gesehen.', 'hatte'), ('Als die Polizei kam,', 'der Dieb schon verschwunden.', 'war'),
            ('Als wir nach Hause kamen,', 'die Kinder schon eingeschlafen.', 'waren'),
        ]),
        write('First, then', 'Tell it in the past. Join with nachdem: the first thing takes hatte or war.', [
            ('Sie besteht die Prüfung. Sie feiert.', 'Nachdem sie die Prüfung bestanden hatte, feierte sie.'),
            ('Er zieht nach Berlin um. Er lernt neue Leute kennen.', 'Nachdem er nach Berlin umgezogen war, lernte er neue Leute kennen.'),
        ], 1),
    ],
    ['say what had happened before',
     'choose hatte or war',
     'join two past events with nachdem'],
))

# ---- 5 · nachdem, bevor, während -----------------------------------------------------------
spreads.append(spread(
    'temporal', 'nachdem, bevor, während', 'Putting events in order',
    'Before, after, while, since, until: one little word each — and the verb goes to the end.',
    Q + 'temporalsaetze',
    [
        timeline('Where each word sits', [
            ('nachdem', 'after — the other thing came first', -2),
            ('während', 'while — at the same time', (-0.5, 0.5)),
            ('bevor', 'before — the other thing comes later', 2),
            ('seit', 'since — and still', (-3, 0)),
            ('bis', 'until', (0, 3)),
        ], note='Each mark is the other event; the dotted line is the main one.'),
        table('In a sentence — verb last', ['', '~'], [
            ['Nachdem wir gegessen hatten, gingen wir.', 'after'], ['Bevor ich gehe, rufe ich an.', 'before'],
            ['Während sie kocht, deckt er den Tisch.', 'while'], ['Seit ich hier wohne, habe ich kein Auto.', 'since — present tense'],
            ['Warte, bis ich komme.', 'until'], ['Sobald der Bus kommt, fahren wir los.', 'as soon as'],
        ]),
        words('Words for the practice page', [
            ('den Tisch decken', 'to lay the table'), ('losfahren', 'to set off'), ('zurück', 'back'),
            ('auf dem Land', 'in the country'), ('ausschalten · schaltete aus', 'to switch off'), ('frühstücken', 'to have breakfast'),
        ], 3),
    ],
    [
        gaps('Which word?', 'Write nachdem, bevor, während, seit, bis or sobald.', [
            ('', 'wir gegessen hatten, gingen wir aus.', 'Nachdem'), ('', 'ich ins Bett gehe, lese ich noch.', 'Bevor'),
            ('', 'sie kocht, deckt er den Tisch.', 'Während'), ('', 'ich hier wohne, habe ich kein Auto mehr.', 'Seit'),
            ('Warte bitte,', 'ich zurück bin.', 'bis'), ('', 'der Bus kommt, fahren wir los.', 'Sobald'),
        ]),
        write('Before or after?', 'Join the two sentences with the word in brackets.', [
            ('Ich frühstücke. Ich gehe zur Arbeit. (bevor)', 'Bevor ich zur Arbeit gehe, frühstücke ich.'),
            ('Er schrieb die E-Mail. Er schaltete den Computer aus. (nachdem)', 'Nachdem er die E-Mail geschrieben hatte, schaltete er den Computer aus.'),
        ], 1),
    ],
    ['put events in order with nachdem, bevor, während',
     'use seit with the present',
     'say until and as soon as'],
))

# ---- 6 · wird gebaut, wurde gebaut -------------------------------------------------------
spreads.append(spread(
    'passiv', 'wird gebaut, wurde gebaut', 'The passive — now and in the past',
    'Hier wird ein Haus gebaut, das Haus wurde 1990 gebaut: say what gets done without naming who does it.',
    Q + 'passiv',
    [
        slots('From active to passive', [
            ([('Der Mechaniker', 'who'), {'de': 'repariert', 'hot': True}, ('das Auto.', 'what')], 'active'),
            ([('Das Auto', 'what'), {'de': 'wird', 'hot': True}, ('vom Mechaniker', 'who — or leave it out'), {'de': 'repariert.', 'hot': True}], 'passive'),
            ([('Das Haus', 'what'), {'de': 'wurde', 'hot': True}, '1990', {'de': 'gebaut.', 'hot': True}], 'passive, in the past'),
        ], note='The thing moves to the front; who did it can go.'),
        table('wird or wurde', ['', 'now', 'in the past'], [
            ['one thing', 'wird gebaut', 'wurde gebaut'], ['more than one', 'werden gebaut', 'wurden gebaut'],
        ]),
        tiles('History and the news', [
            ('gegründet', 'founded'), ('erfunden', 'invented'), ('entdeckt', 'discovered'),
            ('zerstört', 'destroyed'), ('abgesagt', 'cancelled'), ('eröffnet', 'opened'),
        ], 6),
        words('Words for the practice page', [
            ('das Jahrhundert', 'century'), ('der Sturm', 'storm'), ('die Firma', 'company'), ('begrüßen', 'to welcome'),
            ('der Müll', 'rubbish'), ('servieren', 'to serve'), ('die Verspätung', 'delay'), ('das Gleis', 'platform'),
            ('das Bordrestaurant', 'dining car'), ('am Platz', 'at your seat'), ('die Sprachen', 'languages'),
            ('wegen des Sturms', 'because of the storm'), ('geschlossen', 'closed'), ('die Getränke', 'drinks'),
        ], 4),
    ],
    [
        gaps('wird or wurde', 'Write wird, werden, wurde or wurden.', [
            ('In der Schweiz', 'vier Sprachen gesprochen.', 'werden'), ('Das Auto', 'gerade repariert.', 'wird'),
            ('Das Haus', '1990 gebaut.', 'wurde'), ('Das Telefon', 'im 19. Jahrhundert erfunden.', 'wurde'),
            ('Die Fenster', 'letzte Woche geputzt.', 'wurden'), ('Das Konzert', 'wegen des Sturms abgesagt.', 'wurde'),
        ]),
        circle('At the station', 'Listen to the announcement. Circle what you hear.', [
            ('Der Zug hat etwa', ['zwanzig', 'zehn'], 'Minuten Verspätung.', 'zwanzig'),
            ('Er fährt heute von Gleis', ['sieben', 'vier'], 'ab.', 'sieben'),
            ('Das Bordrestaurant ist heute', ['geschlossen', 'geöffnet'], '.', 'geschlossen'),
            ('Getränke werden am Platz', ['verkauft', 'gebracht'], '.', 'verkauft'),
        ], 1) | {'listen': True},
    ],
    ['say what gets done with wird',
     'say what was done with wurde',
     'understand an announcement'],
    listen=Q + 'hoeren_durchsage',
))

# ---- 7 · muss gemacht werden, ist geschlossen ------------------------------------------------
spreads.append(spread(
    'passiv_modal', 'muss gemacht werden', 'Rules on signs — and the state that is left',
    'Hier darf nicht geparkt werden; die Tür ist geschlossen: the passive with a helper, and the state after the action.',
    Q + 'passiv_modal_intro',
    [
        slots('With a helper: the past form + werden at the end', [
            (sl('Das Auto', 'muss!', 'repariert werden.!'), 'must be repaired'),
            (sl('Hier', 'darf!', 'nicht', 'geparkt werden.!'), 'may not be parked'),
            (sl('Das Haus', 'ist!', 'gebaut worden.!'), 'has been built: worden, not geworden'),
        ]),
        flow('wird or ist?', q('Is it happening right now?',
                               a('wird', 'Der Tisch wird gedeckt.'), a('ist', 'Der Tisch ist gedeckt.')),
             note='Could you say fertig, offen or zu instead? Then ist.'),
        table('The state that is left', ['action (werden)', 'state (sein)'], [
            ['Die Tür wird geschlossen.', 'Die Tür ist geschlossen. = zu'],
            ['Das Fenster wird geöffnet.', 'Das Fenster ist geöffnet. = offen'],
            ['Der Tisch wird gedeckt.', 'Der Tisch ist gedeckt. = fertig'],
        ]),
        words('Words for the practice page', [
            ('das Formular', 'form'), ('lösen', 'to solve'), ('abschließen', 'to lock'), ('sperren · gesperrt', 'to close off'),
            ('reservieren', 'to reserve'), ('der Ruhetag', 'closing day'), ('überweisen', 'to transfer (money)'),
            ('per E-Mail', 'by e-mail'), ('das Restaurant', 'restaurant'), ('dienstags', 'on Tuesdays'),
        ], 4),
    ],
    [
        gaps('Helper + werden', 'Write the past form + werden.', [
            ('Das Auto muss', '. (reparieren)', 'repariert werden'), ('Das Formular kann per E-Mail', '. (schicken)', 'geschickt werden'),
            ('Hier darf nicht', '. (parken)', 'geparkt werden'), ('Die Rechnung muss heute', '. (bezahlen)', 'bezahlt werden'),
        ]),
        circle('Action or state?', 'Circle the right word.', [
            ('Das Restaurant', ['ist', 'wird'], 'heute geschlossen — dienstags haben wir Ruhetag.', 'ist'),
            ('Setzt euch, der Tisch', ['ist', 'wird'], 'gerade gedeckt.', 'wird'),
            ('Die Rechnung', ['ist', 'wird'], 'schon bezahlt.', 'ist'),
            ('Für heute Abend', ['sind', 'werden'], 'alle Tische reserviert.', 'sind'),
        ], 1),
    ],
    ['read rules: Hier darf nicht geparkt werden',
     'say the passive with a helper',
     'tell wird (action) from ist (state)'],
))

# ---- Review 1 · topics 1–7 ---------------------------------------------------------------
spreads.append(review(
    'review_1', 'Topics 1–7', 'Nothing new here — only what you know. Do both pages without looking back, then check.',
    Q + 'sprechen_kurzcheck',
    [
        gaps('The story past', 'Write the verb in the story past.', [
            ('Er', 'nach Hause. (gehen)', 'ging'), ('Wir', 'in Köln. (wohnen)', 'wohnten'),
            ('Sie', 'mir Blumen. (bringen)', 'brachte'), ('Ich', 'den Schlüssel nicht. (finden)', 'fand'),
        ]),
        gaps('Before and after', 'Write the missing word.', [
            ('', 'wir gegessen hatten, gingen wir.', 'Nachdem'), ('Als ich ankam,', 'der Zug schon abgefahren.', 'war'),
        ]),
    ],
    [
        gaps('Passive', 'Write the missing word.', [
            ('Das Haus', '1990 gebaut.', 'wurde'), ('Hier darf nicht geparkt', '.', 'werden'), ('Die Tür', 'schon geschlossen — sie ist zu.', 'ist'),
        ]),
        match('At the computer', 'Draw a line from the problem to the fix.', [
            ('Der Bildschirm bleibt schwarz.', 'Den Computer neu starten.'),
            ('Ich habe das Passwort vergessen.', 'Den Kundendienst anrufen.'),
            ('Die Datei ist zu groß.', 'Die Datei hochladen.'),
        ], [1, 2, 0]),
    ],
))

# ---- 8 · mit dem Kollegen -----------------------------------------------------------------
spreads.append(spread(
    'n_dekl', 'mit dem Kollegen', 'The nouns that grow an -n',
    'der Kollege, but mit dem Kollegen: a small group of masculine nouns takes -n everywhere except as the subject.',
    Q + 'n_deklination',
    [
        build('Bare only as the subject', [
            (['der', 'Student'], 'der Student', 'wer?'), (['den', 'Student', ('en', 'suffix')], 'den Studenten', 'wen?'),
            (['dem', 'Student', ('en', 'suffix')], 'dem Studenten', 'wem?'), (['des', 'Student', ('en', 'suffix')], 'des Studenten', 'wessen?'),
        ], 'And all plural forms: die Studenten.'),
        table('Who belongs', ['ending', 'examples'], [
            ['-e (people, animals)', 'der Kollege, der Kunde, der Junge, der Neffe, der Affe'],
            ['-ent, -ant, -ist, -at', 'der Student, der Präsident, der Praktikant, der Tourist, der Soldat'],
            ['and a few more', 'der Herr, der Mensch, der Nachbar, der Bär'],
        ], 'All masculine.'),
        box('watch', 'der Herr',
            'den *Herrn*, dem *Herrn* — but the plural is *die Herren*. On a letter: *Herrn* Müller.'),
        words('Words for the practice page', [
            ('der Präsident', 'president'), ('die Hand geben', 'to shake hands'), ('der Flur', 'hall'), ('dort', 'there'),
        ], 4),
    ],
    [
        gaps('-n or not?', 'Write the noun in brackets with or without -(e)n.', [
            ('Ich kenne den', '. (Student)', 'Studenten'), ('Ich helfe dem', '. (Junge)', 'Jungen'),
            ('Das ist das Auto des', '. (Kollege)', 'Kollegen'), ('Wir sprechen mit dem', '. (Nachbar)', 'Nachbarn'),
            ('Ich sehe einen', 'auf der Straße. (Mensch)', 'Menschen'), ('Fragen Sie den', 'dort! (Herr)', 'Herrn'),
            ('Der', 'ist nett. (Kollege)', 'Kollege'),
        ]),
        circle('Subject or not?', 'Circle the right form.', [
            ('Der', ['Kunde', 'Kunden'], 'ist König.', 'Kunde'), ('Wir helfen dem', ['Kunde', 'Kunden'], '.', 'Kunden'),
        ]),
    ],
    ['add -n to Kollege, Student, Herr …',
     'keep them bare as the subject',
     'write to Herrn Müller'],
))

# ---- 9 · um … zu, damit, indem, sodass --------------------------------------------------
spreads.append(spread(
    'zweck', 'um … zu, damit, indem', 'What for, how — and with what result',
    'Ich lerne Deutsch, um hier zu arbeiten: one little question tells you which word to use.',
    Q + 'damit_umzu',
    [
        flow('um … zu or damit?', q('Does the same person do both?',
                                    a('um … zu', 'Ich lerne, um zu arbeiten.'), a('damit', '…, damit meine Kinder stolz sind.'))),
        table('Four questions, four words', ['question', 'word', 'like this'], [
            ['Wozu? (what for)', 'um … zu · damit', 'Ich spare, um ein Auto zu kaufen.'],
            ['Wie? (how)', 'indem', 'Ich spare, indem ich selbst koche.'],
            ['Mit welcher Folge? (result)', 'sodass', 'Es regnete, sodass die Straße gesperrt wurde.'],
            ['Wie? (without)', 'ohne … zu · statt … zu', 'Sie ging, ohne etwas zu sagen.'],
        ]),
        slots('so …, dass', [
            (sl('Er', 'war!', 'so müde,', 'dass', 'er', 'einschlief.!'), 'so before the describing word'),
        ]),
        words('Words for the practice page', [
            ('sparen', 'to save'), ('erreichen', 'to catch, reach'), ('stolz', 'proud'), ('verpassen', 'to miss'),
            ('Energie verbrauchen', 'to use energy'), ('fit bleiben', 'to stay fit'), ('die Luft', 'air'),
            ('der Stress', 'stress'), ('die Pause', 'break'), ('verpassten', 'missed'), ('Sport machen', 'to do sport'), ('eine kurze Pause', 'a short break'),
        ], 3),
    ],
    [
        gaps('Which word?', 'Write um, damit, indem or sodass.', [
            ('Ich lerne Deutsch,', 'hier zu arbeiten.', 'um'), ('Ich lerne Deutsch,', 'meine Kinder stolz sind.', 'damit'),
            ('Ich spare Geld,', 'ich selbst koche.', 'indem'), ('Der Bus kam zu spät,', 'wir den Zug verpassten.', 'sodass'),
            ('Er spricht langsam,', 'alle ihn verstehen.', 'damit'), ('Sie bleibt fit,', 'sie jeden Tag Rad fährt.', 'indem'),
        ]),
        gaps('Less stress', 'Listen to the podcast and fill in the notes.', [
            ('Sport: schon', 'Minuten am Tag', 'zwanzig'), ('Das Handy: eine', 'vor dem Schlafen aus', 'Stunde'),
            ('Jeden Tag eine kurze', '', 'Pause'),
        ]) | {'listen': True},
    ],
    ['say what for with um … zu or damit',
     'say how with indem',
     'say the result with sodass'],
    listen=Q + 'hoeren_podcast',
))

# ---- 10 · dessen, deren -------------------------------------------------------------------
spreads.append(spread(
    'relativ_dat', 'dessen, deren', 'Whose — and the rest of the relative words',
    'Die Frau, deren Auto vor dem Haus steht: only three new words — denen, dessen, deren.',
    Q + 'relativ_dat',
    [
        table('The whole table', ['~', 'der', 'die', 'das', 'plural'], [
            ['wer?', 'der', 'die', 'das', 'die'], ['wen?', 'den', 'die', 'das', 'die'],
            ['wem?', 'dem', 'der', 'dem', '*denen*'], ['wessen?', '*dessen*', '*deren*', '*dessen*', '*deren*'],
        ], 'Three new words; the rest is the article.', genders=True),
        slots('whose: no article after it', [
            (sl('der Kollege,', 'dessen!', 'Frau Ärztin', 'ist'), 'his wife'),
            (sl('die Frau,', 'deren!', 'Auto vor dem Haus', 'steht'), 'her car'),
            (sl('die Nachbarn,', 'deren!', 'Hund immer', 'bellt'), 'their dog'),
        ], note='The word before the comma decides dessen or deren.'),
        words('Words for the practice page', [
            ('bellen', 'to bark'), ('die Buchhaltung', 'accounts'), ('teilen', 'to share'), ('vertrauen', 'to trust'),
            ('die Nachbarin', 'neighbour'),
        ], 3),
    ],
    [
        gaps('Which word?', 'Write dem, der, denen, dessen or deren.', [
            ('Das ist der Mann,', 'ich geholfen habe.', 'dem'), ('Die Frau,', 'Auto vor dem Haus steht, ist meine Nachbarin.', 'deren'),
            ('Das sind die Freunde,', 'ich am meisten vertraue.', 'denen'), ('Der Kollege,', 'Frau Ärztin ist, arbeitet in der Buchhaltung.', 'dessen'),
            ('Das Kind,', 'Eltern noch arbeiten, wartet in der Schule.', 'dessen'), ('Die Kollegin, mit', 'ich das Büro teile, kommt aus Polen.', 'der'),
        ]),
    ],
    ['say whose with dessen and deren',
     'use denen in the plural',
     'build one long sentence instead of two'],
))

# ---- 11 · zwar … aber -----------------------------------------------------------------------
spreads.append(spread(
    'konnektoren', 'zwar … aber', 'Pairs that make an argument sound structured',
    'Both … and, either … or, the more … the better: six pairs that make any argument sound organised.',
    Q + 'konnektoren_zweiteilig',
    [
        table('Six pairs', ['pair', '~'], [
            ['sowohl … als auch', 'both … and'], ['nicht nur … sondern auch', 'not only … but also'],
            ['entweder … oder', 'either … or'], ['weder … noch', 'neither … nor'],
            ['zwar … aber', 'true, … but'], ['je … desto', 'the … the'],
        ]),
        slots('je … desto: two orders', [
            (sl('Je mehr', 'ich', 'übe,!', 'desto besser', 'werde!', 'ich.'), 'je: verb last · desto: verb next'),
        ]),
        box('tip', 'weder … noch is already “no”',
            'Ich habe *weder* Zeit *noch* Geld — no nicht, no kein.'),
        words('Words for the practice page', [
            ('klug', 'clever'), ('fleißig', 'hard-working'), ('üben', 'to practise'), ('die Reise', 'trip'),
        ], 4),
    ],
    [
        gaps('The other half', 'Write the missing half of the pair.', [
            ('Sie spricht sowohl Deutsch', 'Englisch.', 'als auch'), ('Er ist nicht nur klug,', 'fleißig.', 'sondern auch'),
            ('Wir fahren entweder mit dem Zug', 'mit dem Auto.', 'oder'), ('Ich habe weder Zeit', 'Geld.', 'noch'),
            ('Das Hotel ist zwar teuer,', 'sehr schön.', 'aber'), ('Je mehr ich übe,', 'besser werde ich.', 'desto'),
        ]),
        gaps('Your argument', 'Finish the sentence.', [('Deutsch ist zwar schwer, aber', '.')], 'About you.'),
    ],
    ['use both … and, either … or, neither … nor',
     'concede a point with zwar … aber',
     'say the more … the better'],
))

# ---- 12 · Hätte ich doch …! -------------------------------------------------------------
spreads.append(spread(
    'wuensche', 'Hätte ich doch …!', 'If only — wishes about the past',
    'Missed the train, forgot the umbrella? Hätte ich doch …! Wäre ich nur …!',
    Q + 'irreale_wuensche',
    [
        build('hätte or wäre + the past form', [
            (['hätte', 'gelernt'], 'Hätte ich doch mehr gelernt!', 'haben-verbs'),
            (['wäre', 'geblieben'], 'Wäre ich nur zu Hause geblieben!', 'sein-verbs'),
            (['wäre', 'losgefahren'], 'Wären wir bloß früher losgefahren!', 'moving: sein'),
        ], 'Same helper as the Perfekt — with dots.'),
        table('Now or then?', ['now', 'then'], [
            ['Wäre ich doch reich!', 'Wäre ich doch reich gewesen!'], ['Hätte ich doch Zeit!', 'Hätte ich doch Zeit gehabt!'],
        ], 'Add the past form to push the wish into the past.'),
        slots('Two shapes', [
            (sl('Hätte!', 'ich', 'doch mehr', 'gelernt!'), 'verb first'),
            (sl('Wenn', 'ich doch mehr', 'gelernt', 'hätte!!'), 'wenn: verb last'),
        ]),
        words('Words for the practice page', [
            ('bloß', 'only'), ('losfahren · losgefahren', 'to set off'), ('anrufen · angerufen', 'to call'), ('sagen · gesagt', 'to say'),
        ], 3),
    ],
    [
        gaps('If only!', 'Write hätte or wäre.', [
            ('', 'ich doch mehr Zeit gehabt!', 'Hätte'), ('', 'ich nur zu Hause geblieben!', 'Wäre'),
            ('', 'wir bloß früher losgefahren!', 'Wären'), ('', 'sie doch nur angerufen!', 'Hätte'),
            ('', 'er doch gekommen!', 'Wäre'), ('', 'ich das bloß nicht gesagt!', 'Hätte'),
        ]),
        write('A sigh', 'Write a wish about the past.', [
            ('Ich habe nicht gelernt.', 'Hätte ich doch gelernt!'), ('Wir sind spät losgefahren.', 'Wären wir doch früher losgefahren!'),
        ], 1),
    ],
    ['wish things had been different',
     'choose hätte or wäre',
     'tell a wish now from a wish about the past'],
))

# ---- 13 · trotz des Regens ---------------------------------------------------------------------
spreads.append(spread(
    'trotz_wegen', 'trotz des Regens', 'Three ways to say one thing',
    'Obwohl es regnet — es regnet, trotzdem — trotz des Regens: the shortest is the most written.',
    Q + 'trotz_wegen',
    [
        slots('Three ways to say one thing', [
            (sl('Obwohl', 'es', 'regnet,!', 'gehen!', 'wir raus.'), 'a clause'),
            (sl('Es regnet,', 'trotzdem', 'gehen!', 'wir raus.'), 'an adverb'),
            (sl('Trotz des Regens', 'gehen!', 'wir raus.'), 'a little word + des'),
        ], note='Remember the genitive from B1.1.'),
        table('The same with because', ['clause', 'adverb', 'little word'], [
            ['weil es regnet', 'deshalb', 'wegen des Regens'], ['obwohl es regnet', 'trotzdem', 'trotz des Regens'],
            ['während ich arbeite', '', 'während der Arbeit'],
        ]),
        box('tip', 'In speech: wegen dem Wetter',
            'People often say *wegen dem* — you will hear it everywhere. Write *wegen des Wetters*.'),
        words('Words for the practice page', [
            ('der Stau', 'traffic jam'), ('die Erkältung', 'cold'), ('die Kosten', 'costs'), ('buchen', 'to book'),
            ('telefonieren', 'to phone'), ('des Films · des Staus', 'of the film · of the jam'),
        ], 3),
    ],
    [
        gaps('trotz, wegen, während', 'Write the little word and des or der.', [
            ('', 'Regens bleiben wir zu Hause. (because of)', 'Wegen des'), ('', 'Regens gehen wir spazieren. (despite)', 'Trotz des'),
            ('', 'Films darf man nicht telefonieren. (during)', 'Während des'), ('', 'Staus kamen wir zu spät. (because of)', 'Wegen des'),
            ('', 'Ferien ist das Büro geschlossen. (during)', 'Während der'),
        ]),
        write('Say it shorter', 'Say it with trotz or wegen.', [
            ('Obwohl er erkältet war, ging er zur Arbeit.', 'Trotz seiner Erkältung ging er zur Arbeit.'),
            ('Weil es einen Sturm gab, wurde das Konzert abgesagt.', 'Wegen des Sturms wurde das Konzert abgesagt.'),
        ], 1),
    ],
    ['say because of, despite, during with des and der',
     'say one thing in three ways',
     'write the short form in a formal text'],
))

# ---- 14 · das lachende Kind --------------------------------------------------------------------
spreads.append(spread(
    'partizip', 'das lachende Kind', 'Doing or done: verbs as describing words',
    'das lachende Kind, die geöffnete Tür: -end for doing, ge- for done — and then the usual ending.',
    Q + 'partizip_adj_intro',
    [
        flow('-end or ge-?', q('Is it doing it right now?', a('-end', 'das kochende Wasser'), a('ge-', 'das gekochte Wasser')),
             note='boiling or boiled?'),
        build('Verb + -end / ge- + ending', [
            (['lach', ('end', 'joint'), ('e', 'suffix')], 'das lachende Kind', 'laughing'),
            (['schlaf', ('end', 'joint'), ('e', 'suffix')], 'der schlafende Hund', 'sleeping'),
            ([('ge', 'joint'), 'öffnet', ('e', 'suffix')], 'die geöffnete Tür', 'opened'),
            (['verloren', ('en', 'suffix')], 'die verlorenen Schlüssel', 'lost'),
        ], '-end = -ing, ge- = -ed.'),
        words('Words for the practice page', [
            ('der Schoß', 'lap'), ('Vorsicht!', 'careful!'), ('der Lärm', 'noise'), ('wiederfinden', 'to find again'),
            ('aufwachen', 'to wake up'), ('kalte Luft', 'cold air'), ('soll', 'should'),
        ], 3),
    ],
    [
        gaps('Doing or done?', 'Write the word in brackets as -end or ge-, with its ending.', [
            ('Das', 'Kind sitzt auf dem Schoß der Mutter. (lachen)', 'lachende'), ('Vorsicht,', 'Wasser! (kochen)', 'kochendes'),
            ('Trinken Sie nur', 'Wasser. (kochen → ge-)', 'gekochtes'), ('Sei leise, der', 'Hund soll nicht aufwachen. (schlafen)', 'schlafende'),
            ('Durch die', 'Tür kam kalte Luft. (öffnen → ge-)', 'geöffnete'), ('Die', 'Kinder machen viel Lärm. (spielen)', 'spielenden'),
        ]),
        write('Shorter', 'Say it in two words.', [
            ('das Kind, das lacht', 'das lachende Kind'), ('die Tür, die geöffnet wurde', 'die geöffnete Tür'),
            ('der Brief, der geschrieben wurde', 'der geschriebene Brief'),
        ], 1),
    ],
    ['turn a verb into a describing word',
     'tell -end (doing) from ge- (done)',
     'add the usual ending'],
))

# ---- 15 · denn, doch, ja, mal ------------------------------------------------------------------
spreads.append(spread(
    'partikeln', 'denn, doch, ja, mal', 'The tiny words that make you sound human',
    'Was machst du denn hier? Komm doch mit! — small, unstressed, in the middle: they turn grammar into conversation.',
    Q + 'modalpartikeln_intro',
    [
        slots('In the middle, never stressed', [
            (sl('Was', 'machst', 'du', 'denn!', 'hier?'), 'curious, friendly'),
            (sl('Komm', 'doch!', 'mit!'), 'go on!'),
            (sl('Das', 'ist', 'ja!', 'toll!'), 'how nice!'),
            (sl('Schau', 'mal!', 'hier!'), 'just'),
        ], note='After the verb and the pronouns.'),
        table('What each one adds', ['word', 'adds', '~'], [
            ['denn', 'interest', 'in questions: Wo warst du denn?'], ['doch', 'encouragement or “you know this”', 'Setz dich doch! Das ist doch klar!'],
            ['ja', '“as you know”, surprise', 'Du weißt ja … · Das ist ja toll!'], ['mal', 'casually, just', 'Warte mal!'],
            ['eigentlich', 'by the way', 'Kommst du eigentlich mit?'],
        ]),
        box('tip', 'doch alone = yes!',
            'Answering a no-question with yes: Kommst du nicht? — *Doch!*'),
        words('Words for the practice page', [('unmöglich', 'impossible'), ('sich setzen · setz dich!', 'to sit down')], 2),
    ],
    [
        circle('Which little word?', 'Circle the word that fits.', [
            ('Was machst du', ['denn', 'mal'], 'hier?', 'denn'), ('Setz dich', ['doch', 'denn'], '!', 'doch'),
            ('Ich habe', ['ja', 'denn'], 'keine Zeit, das weißt du.', 'ja'), ('Schau', ['mal', 'denn'], 'hier.', 'mal'),
            ('Kommst du', ['eigentlich', 'mal'], 'mit?', 'eigentlich'), ('Das ist', ['doch', 'denn'], 'unmöglich!', 'doch'),
        ]),
        circle('Yes!', 'Circle the right yes.', [
            ('Kommst du nicht mit? —', ['Doch!', 'Ja!'], '', 'Doch!'), ('Kommst du mit? —', ['Doch!', 'Ja!'], '', 'Ja!'),
        ], 1),
    ],
    ['add denn, doch, ja, mal to sound natural',
     'put them in the middle, unstressed',
     'answer a no-question with doch'],
))

# ---- 16 · -heit, -keit, -schaft ----------------------------------------------------------------
spreads.append(spread(
    'wortbildung', '-heit, -keit, -schaft', 'Four endings that always mean die',
    'Gesundheit, Möglichkeit, Freundschaft, Entscheidung: see the ending and you know it’s die.',
    Q + 'wortbildung',
    [
        build('The die-quartet', [
            (['gesund', ('heit', 'suffix')], 'die Gesundheit', 'health'), (['möglich', ('keit', 'suffix')], 'die Möglichkeit', 'possibility'),
            (['Freund', ('schaft', 'suffix')], 'die Freundschaft', 'friendship'), (['entscheid', ('ung', 'suffix')], 'die Entscheidung', 'decision'),
        ], '-keit after -ig, -lich, -bar: die Freundlichkeit, die Schwierigkeit.'),
        table('People', ['ending', 'examples'], [
            ['-ler', 'der Sportler, der Künstler, der Wissenschaftler'], ['-ant, -ent', 'der Praktikant, der Student — with -n (topic 8)'],
            ['-ist', 'der Journalist, der Tourist'],
        ], 'For a woman: -in. die Sportlerin.'),
        words('Words for the practice page', [
            ('die Meinung', 'opinion'), ('die Erfahrung', 'experience'), ('die Wissenschaft', 'science'), ('forschen', 'to research'),
            ('halten · gehalten', 'to last'), ('das Leben', 'life'), ('entscheiden', 'to decide'), ('online', 'online'),
            ('die beiden', 'the two of them'),
        ], 3),
    ],
    [
        gaps('Build the word', 'Write the noun with its article.', [
            ('Für mich ist', 'das Wichtigste im Leben. (gesund)', 'die Gesundheit'), ('Ich habe', 'getroffen. (entscheiden)', 'eine Entscheidung'),
            ('Vielen Dank für Ihre', '! (freundlich)', 'Freundlichkeit'), ('Gibt es', ', den Kurs online zu machen? (möglich)', 'eine Möglichkeit'),
            ('', 'zwischen den beiden hat dreißig Jahre gehalten. (Freund)', 'Die Freundschaft'),
        ]),
        sort_ex('der or die?', 'Write each word in its column.', ['der', 'die'], [
            ('Sportler', 0), ('Gesundheit', 1), ('Journalist', 0), ('Möglichkeit', 1), ('Praktikant', 0), ('Meinung', 1),
        ]),
    ],
    ['know that -heit, -keit, -ung, -schaft mean die',
     'build nouns from describing words',
     'name people with -ler, -ant, -ist'],
))

# ---- 17 · Etwas ist schiefgegangen ---------------------------------------------------------------
spreads.append(spread(
    'geschichte', 'Etwas ist schiefgegangen', 'Telling a story in writing',
    'Am Anfang, plötzlich, zum Glück, am Ende: four signposts and the written past carry any story.',
    Q + 'schreiben_geschichte',
    [
        slots('The shape of a story', [
            ([('Am Anfang …', 'set the scene'), ('Plötzlich …', 'something happens'), ('Zum Glück …', 'the rescue'),
              {'de': 'Am Ende …', 'tag': 'how it ended', 'hot': True}], None),
        ]),
        table('Which past where?', ['', 'past form', 'example'], [
            ['the story', 'sagte, ging (topics 2–3)', 'Ich ging zum Bahnhof.'],
            ['what came before', 'hatte / war + past form (topic 4)', 'Der Zug war schon abgefahren.'],
            ['states and feelings', 'war, hatte', 'Ich war sehr nervös.'],
        ]),
        box('tip', 'Don’t slip into the present',
            'The most common mistake in a written story is switching to the present halfway. Check every verb before you finish.'),
        words('Words for the practice page', [
            ('plötzlich', 'suddenly'), ('zum Glück', 'luckily'), ('nervös', 'nervous'), ('schiefgehen', 'to go wrong'),
            ('der Regenschirm', 'umbrella'), ('nass', 'wet'), ('ganz ruhig', 'quite calm'),
        ], 3),
    ],
    [
        gaps('Put it in the past', 'Write the verb in the story past.', [
            ('Am Anfang', 'ich ganz ruhig. (sein)', 'war'), ('Dann', 'ich zum Bahnhof. (gehen)', 'ging'),
            ('Plötzlich', 'es stark. (regnen)', 'regnete'), ('Zum Glück', 'mir eine Frau ihren Regenschirm. (geben)', 'gab'),
        ]),
        gaps('Your story', 'Write a short story about something that went wrong.', [
            ('Am Anfang', '.'), ('Plötzlich', '.'), ('Zum Glück', '.'), ('Am Ende', '.'),
        ], 'About you — every verb in the story past.'),
    ],
    ['tell a story in four steps',
     'keep every verb in the past',
     'say what had happened before'],
))

# ---- Review 2 · topics 8–17 -----------------------------------------------------------------
spreads.append(review(
    'review_2', 'Topics 8–17', 'The second half of the book, all at once. No looking back until you have done both pages.',
    Q + 'wortschatz',
    [
        gaps('Small words', 'Write the missing word.', [
            ('Ich helfe dem', '. (Kollege)', 'Kollegen'), ('Ich lerne Deutsch,', 'hier zu arbeiten.', 'um'),
            ('Die Frau,', 'Auto dort steht, ist nett.', 'deren'), ('Ich habe weder Zeit', 'Geld.', 'noch'),
        ]),
    ],
    [
        gaps('More', 'Write the missing word.', [
            ('', 'ich doch mehr gelernt!', 'Hätte'), ('', 'des Regens gehen wir spazieren.', 'Trotz'),
            ('Das', 'Kind schläft. (lachen)', 'lachende'), ('Was machst du', 'hier?', 'denn'),
        ]),
        match('Which article?', 'Draw a line from the word to its article.', [
            ('Freundschaft', 'die'), ('Sportler', 'der'), ('Möglichkeit', 'die'), ('Tourist', 'der'),
        ], [0, 1, 2, 3]),
    ],
))

book = {
    'title': 'Erzählen & Begründen',
    'cover': 'cp_b1_2_cover',
    'welcome': [
        'This book is the paper half of B1.2. Every topic gets two facing pages: the **left page** teaches — tables, diagrams, the few rules that matter — and the **right page** is yours to write on.',
        'It carries on from the earlier books. Words you learned there are not taught again; where a topic builds on something from before, a small note brings it back.',
        'Work with a pencil and say every German word out loud as you write it. When a page has a **Listen** code, scan it with your phone camera to hear the German.',
        'The answers are at the back. Do a whole page first, then check, and circle what you got wrong — those circles are next week’s revision. Tick an **I can** line only when you could do it tomorrow without the book.',
    ],
    'names': ['Lena', 'Max', 'Paul', 'Mia', 'Tom', 'Anna', 'Lisa', 'Lea', 'Rocky', 'Klein', 'Brandt', 'Fischer', 'Müller',
              'Hamburg', 'Rom', 'Bonn', 'Berlin', 'Wien', 'Polen', 'Köln'],
    'spreads': spreads,
    'overview': {'title': 'B1.2 at a glance', 'blocks': [
        table('The story past', ['', 'now', 'story past', 'Perfekt'], [
            ['-te', 'lernen', 'lernte', 'hat gelernt'], ['new vowel + -te', 'bringen', 'brachte', 'hat gebracht'],
            ['new vowel', 'gehen', 'ging', 'ist gegangen'], ['one step further back', '', 'hatte gelernt · war gegangen', ''],
        ]),
        table('The passive', ['', 'action', 'state'], [
            ['now', 'wird gebaut', 'ist gebaut'], ['past', 'wurde gebaut', 'war gebaut'],
            ['with a helper', 'muss gebaut werden', ''], ['Perfekt', 'ist gebaut worden', ''],
        ]),
        cols(
            table('Verb last', ['', '~'], [
                ['nachdem · bevor · während', 'time'], ['seit · bis · sobald', 'time'], ['damit · indem · sodass', 'what for, how, result'],
            ]),
            table('Whose', ['', 'der', 'die', 'das', 'plural'], [
                ['wessen?', 'dessen', 'deren', 'dessen', 'deren'], ['wem? (plural)', '', '', '', 'denen'],
            ], genders=True),
        ),
    ]},
    'dictionary': kit.dictionary(
        'Thirty-two words from this book. Cover the German, look at the picture, say the word **with its article**.', [
            ('die Maus', 'mouse', 'cpd_maus'), ('die Tastatur', 'keyboard', 'cpd_tastatur'), ('die Festplatte', 'hard drive', 'cpd_festplatte'),
            ('der Kopfhörer', 'headphones', 'cpd_kopfhoerer'), ('die Kamera', 'camera', 'cpd_kamera'), ('das Ladegerät', 'charger', 'cpd_ladegeraet'),
            ('der USB-Stick', 'USB stick', 'cpd_usbstick'), ('das Handy', 'mobile phone', 'cpd_handy'), ('der Drucker', 'printer', 'cpd_drucker'),
            ('die Brücke', 'bridge', 'cpd_bruecke'), ('der Kran', 'crane', 'cpd_kran'), ('die Baustelle', 'building site', 'cpd_baustelle'),
            ('der Ritter', 'knight', 'cpd_ritter'), ('der Drache', 'dragon', 'cpd_drache'), ('die Krone', 'crown', 'cpd_krone'),
            ('das Schloss', 'castle', 'cpd_schloss'), ('der Dieb', 'thief', 'cpd_dieb'), ('die Polizei', 'police', 'cpd_polizei'),
            ('das Telefon', 'telephone', 'cpd_telefon'), ('die Glühbirne', 'light bulb', 'cpd_gluehbirne'), ('der Stau', 'traffic jam', 'cpd_stau'),
            ('der Sturm', 'storm', 'cpd_sturm'), ('das Fenster', 'window', 'cpd_fenster'), ('die Tür', 'door', 'cpd_tuer'),
            ('der Müll', 'rubbish', 'cpd_muell'), ('das Formular', 'form', 'cpd_formular'), ('der Wecker', 'alarm clock', 'cpd_wecker'),
            ('das Wasser', 'water', 'cpd_wasser'), ('der Sportler', 'athlete', 'cpd_sportler'), ('der Künstler', 'artist', 'cpd_kuenstler'),
            ('die Zeitung', 'newspaper', 'cpd_zeitung'), ('der Regenschirm', 'umbrella', 'cpd_regenschirm'),
        ]),
    'credits': [
        {'what': 'Illustrations and picture dictionary', 'source': 'Drawn for this book with Google Gemini', 'licence': '© languagequiz.org'},
    ],
}

kit.write_book(OUT, book)
