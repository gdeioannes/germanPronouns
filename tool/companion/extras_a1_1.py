# Extra exercises that fill the free space on A1.1's practice and review pages.
# Merged by kit.write_book; for A1.1 (no script): python -I tool/companion/apply_extras.py a1_1
from kit import gaps, write, circle, match  # noqa: F401

MISTAKE = 'One word is wrong in each sentence. Write the sentence correctly.'
TRANSLATE = 'Write it in German.'

EXTRAS = {
    'alphabet': [
        write('Say it in German', TRANSLATE, [
            ('How do you write that?', 'Wie schreibt man das?'),
            ('Can you spell that?', 'Können Sie das buchstabieren?'),
            ('I’ll spell it: L – E – N – A.', 'Ich buchstabiere: El – E – En – A.'),
        ], not_german=True),
    ],
    'praesens': [
        write('Find the mistake', MISTAKE, [
            ('Ich spielt gern Fußball.', 'Ich spiele gern Fußball.'),
            ('Lena trinken Kaffee.', 'Lena trinkt Kaffee.'),
        ], ncols=2),
    ],
    'vokalwechsel': [
        write('Find the mistake', MISTAKE, [
            ('Du fahrst gern Fahrrad.', 'Du fährst gern Fahrrad.'),
            ('Lena sprecht Englisch.', 'Lena spricht Englisch.'),
            ('Der Hund schlaft viel.', 'Der Hund schläft viel.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('You sleep a lot.', 'Du schläfst viel.'),
            ('What are you reading?', 'Was liest du?'),
        ], ncols=2, not_german=True),
    ],
    'artikel': [
        write('Find the mistake', MISTAKE, [
            ('Der Katze ist müde.', 'Die Katze ist müde.'),
            ('Das ist eine Tisch.', 'Das ist ein Tisch.'),
            ('Die Mädchen hat ein Pferd.', 'Das Mädchen hat ein Pferd.'),
        ]),
    ],
    'plural': [
        write('Say it in German', TRANSLATE, [
            ('two dogs', 'zwei Hunde'),
            ('three houses', 'drei Häuser'),
            ('ten keys', 'zehn Schlüssel'),
            ('four mobile phones', 'vier Handys'),
        ], ncols=2, not_german=True),
    ],
    'laender': [
        write('Find the mistake', MISTAKE, [
            ('Ich komme aus Schweiz.', 'Ich komme aus der Schweiz.'),
            ('Ich spreche Spanien.', 'Ich spreche Spanisch.'),
            ('Er kommt aus der USA.', 'Er kommt aus den USA.'),
            ('Sophie kommt aus Frankreich. Sie ist Franzose.', 'Sophie kommt aus Frankreich. Sie ist Französin.'),
        ]),
    ],
    'wo': [
        write('Find the mistake', MISTAKE, [
            ('Ich bin in der Büro.', 'Ich bin im Büro.'),
            ('Lena ist im Schule.', 'Lena ist in der Schule.'),
            ('Max ist am Arzt.', 'Max ist beim Arzt.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('The cat is under the table.', 'Die Katze ist unter dem Tisch.'),
            ('The ball is on the sofa.', 'Der Ball ist auf dem Sofa.'),
        ], ncols=2, not_german=True),
    ],
    'woerter': [
        write('Find the mistake', MISTAKE, [
            ('Der Haustür ist rot.', 'Die Haustür ist rot.'),
            ('Lena ist Lehrer.', 'Lena ist Lehrerin.'),
            ('Das Apfelkuchen ist gut.', 'Der Apfelkuchen ist gut.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('My friend (a woman) is a doctor.', 'Meine Freundin ist Ärztin.'),
            ('The children’s room is green.', 'Das Kinderzimmer ist grün.'),
            ('Is that a cake?', 'Ist das ein Kuchen?'),
        ], not_german=True),
    ],
    'review_1': [
        write('Now it’s Paul', 'Write each sentence about Paul: er instead of ich.', [
            ('Ich wohne in Wien.', 'Er wohnt in Wien.'),
            ('Ich habe ein Auto.', 'Er hat ein Auto.'),
            ('Ich bin zwanzig.', 'Er ist zwanzig.'),
            ('Ich lerne Deutsch.', 'Er lernt Deutsch.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('I am hungry.', 'Ich habe Hunger.'),
            ('We are from Austria.', 'Wir kommen aus Österreich.'),
        ], ncols=2, not_german=True),
    ],
    'review_2': [
        write('Make it a question', 'Put the verb first.', [
            ('Du sprichst Deutsch.', 'Sprichst du Deutsch?'),
            ('Lena fährt Fahrrad.', 'Fährt Lena Fahrrad?'),
            ('Ihr habt Kinder.', 'Habt ihr Kinder?'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('My brother is a teacher.', 'Mein Bruder ist Lehrer.'),
            ('The front door is purple.', 'Die Haustür ist lila.'),
            ('Grandma eats a lot of cake.', 'Die Oma isst viel Kuchen.'),
        ], not_german=True),
    ],
}

EXTRAS_LEFT = {
    'review_1': [
        write('Find the mistake', MISTAKE, [
            ('Ich bist müde.', 'Ich bin müde.'),
            ('Woher kommt du?', 'Woher kommst du?'),
            ('Wir habt Zeit.', 'Wir haben Zeit.'),
            ('Er heißen Max.', 'Er heißt Max.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('I am tired.', 'Ich bin müde.'),
            ('Do you have time?', 'Hast du Zeit?'),
            ('Lena likes playing football.', 'Lena spielt gern Fußball.'),
        ], not_german=True),
    ],
    'review_2': [
        write('Find the mistake', MISTAKE, [
            ('Er fahrt nach Berlin.', 'Er fährt nach Berlin.'),
            ('Ich habe zwei Hund.', 'Ich habe zwei Hunde.'),
            ('Wo kommst du? – Aus Spanien.', 'Woher kommst du? – Aus Spanien.'),
            ('Mein Schwester heißt Mia.', 'Meine Schwester heißt Mia.'),
        ]),
        write('Say it in German', TRANSLATE, [
            ('Where is the cat? – On the sofa.', 'Wo ist die Katze? – Auf dem Sofa.'),
            ('Paul is English.', 'Paul ist Engländer.'),
            ('I’m at the station.', 'Ich bin am Bahnhof.'),
            ('The girl has three horses.', 'Das Mädchen hat drei Pferde.'),
        ], not_german=True),
        write('Now there are more', 'Write it in the plural.', [
            ('Die Katze schläft.', 'Die Katzen schlafen.'),
            ('Das Kind liest.', 'Die Kinder lesen.'),
        ], ncols=2),
    ],
}
