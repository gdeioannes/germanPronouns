// Songs as deck citizens: a sing-along the swipe deck deals like an exercise
// card, and the course page lists inside its level. The registry holds what
// the deck, the lists and the song page need; the recording lives at
// static/audio/songs/<id>.mp3. Songs give no medals and never gate anything —
// they are a treat, like the story episodes (./stories.ts).

import type { QuizSummary } from "$lib/content/types";
import type { DeckCard } from "./deck";

/** One line of a song. */
export interface SongLine {
  text: string;
  /** The line's language: the page sets German lines bold. */
  lang: "de" | "en";
  /** What the German in the line means — a translation, shown as such, not a lyric. */
  gloss?: string;
}

export interface SongSection {
  /** "Verse 1: the airport", "Hook", "Bridge" … */
  title: string;
  /** A stage direction shown under the title, like "(everybody shouts the German)". */
  note?: string;
  lines: SongLine[];
}

export interface Song {
  id: string;
  courseId: string;
  /** The sub-level whose learners get the card (the song's material). */
  level: string;
  title: string;
  tagline: string;
  href: string;
  /** Served from static/: /audio/songs/<file>. */
  audio: string;
  /** The grammar and phrases the song drills, for the page's intro. */
  teaches: string[];
  sections: SongSection[];
  /**
   * Where the song sits in its sub-level: after this quiz. Absent = at the
   * start of the level.
   */
  after?: string;
  /** The exercise that drills what the song teaches; the page links to it. */
  quiz: string;
}

const de = (text: string, gloss: string): SongLine => ({ text, lang: "de", gloss });
const en = (text: string): SongLine => ({ text, lang: "en" });

export const SONGS: Song[] = [
  {
    id: "ich_bin_max",
    courseId: "de_cert_a1",
    level: "A1.1",
    title: "Ich bin Max",
    tagline:
      "A rap about landing in Berlin with zero German. Shout the hook, learn the sein table.",
    href: "/song/ich-bin-max",
    quiz: "quest_a1_1_sein_haben",
    audio: "/audio/songs/ich_bin_max.mp3",
    teaches: [
      "ich bin, du bist, er ist, sie ist, wir sind, ihr seid, sie sind",
      "Ich heiße … / Wie heißt du? / Woher kommst du?",
      "ich möchte … bitte / danke / bitte",
      "der, die, das",
      "Entschuldigung, wo ist …? / da drüben / nach links",
      "ja, nein, und du?",
    ],
    sections: [
      {
        title: "Intro",
        note: "spoken, airport announcement in the background",
        lines: [
          en("Welcome to Berlin. Please have your passport, your luggage,"),
          en("and at least one German word ready."),
          en("…I have zero. Let’s go."),
        ],
      },
      {
        title: "Verse 1: the airport",
        lines: [
          en("Landed in Berlin, I’m feeling fly,"),
          en("walked up to a lady and said “Hi!”"),
          de("She said „Guten Tag“, I said “Good… tag? Okay,”", "Guten Tag = good day, hello"),
          en("tagged her on the shoulder, she walked away."),
          en("I had one phrase from a YouTube clip:"),
          de("„Ich heiße Max“ – nailed it, that’s the ship!", "Ich heiße Max = my name is Max"),
          de("She said „Ich heiße Maria. Woher kommst du?“", "Woher kommst du? = where are you from?"),
          de("I panicked and said „Ich heiße Max“ again. Smooth.", "Ich heiße Max = my name is Max (yes, again)"),
        ],
      },
      {
        title: "Hook",
        note: "everybody shouts the German",
        lines: [
          de("Hallo! Hallo! Ich bin Max!", "Hello! Hello! I am Max!"),
          en("I don’t know what I’m saying but I’m saying it, relax!"),
          de("Ja, ja, ja! Nein, nein, nein!", "Yes, yes, yes! No, no, no!"),
          de("Ich bin hier, ich bin da, and I’m doing fine!", "ich bin hier = I am here · ich bin da = I am there"),
          de("(Doing fine? – Ja, ja, ja!)", "ja = yes"),
        ],
      },
      {
        title: "Verse 2: the bakery",
        lines: [
          en("Day two, bakery, I’m hungry, I’m brave,"),
          de("I pointed at a bun and said „Ich bin ein Brot.“", "Ich bin ein Brot = I am a bread (oops)"),
          en("Baker looked at me – “You are a bread?”"),
          de("„Ja!“ I said. „Ja! Ich bin ein Brot!“ and nodded my head.", "Ja! Ich bin ein Brot! = Yes! I am a bread!"),
          de("He said „Du bist kein Brot. Du möchtest ein Brot.“", "Du bist kein Brot = you are not a bread · Du möchtest ein Brot = you would like a bread"),
          de("Oh! Ich möchte – I would like – got it, boat.", "ich möchte = I would like"),
          de("„Ich möchte ein Brötchen, bitte!“ – finally, see?", "I would like a bread roll, please!"),
          de("„Das macht ein Euro.“ I paid him with three.", "Das macht ein Euro = that’s one euro"),
          de(
            "„Danke!“ – „Bitte!“ – wait, bitte’s “please” AND “you’re welcome”?",
            "danke = thank you · bitte = please, and also you’re welcome",
          ),
          de("German, pick one! …Danke. Bitte. Welcome.", "Danke. Bitte. = Thanks. You’re welcome."),
        ],
      },
      {
        title: "Hook",
        note: "everybody shouts the German",
        lines: [
          de("Hallo! Hallo! Ich bin Max!", "Hello! Hello! I am Max!"),
          en("I don’t know what I’m saying but I’m saying it, relax!"),
          de("Ja, ja, ja! Nein, nein, nein!", "Yes, yes, yes! No, no, no!"),
          de("Ich bin hier, ich bin da, and I’m doing fine!", "ich bin hier = I am here · ich bin da = I am there"),
        ],
      },
      {
        title: "Verse 3: the dog, the park, and the three hats",
        lines: [
          en("Day three, I learned that every noun wears a hat:"),
          de("der, die, das – the man, the woman, the… that?", "der / die / das = the (masculine / feminine / neuter)"),
          de("Der Hund – the dog, die Katze – the cat,", "der Hund = the dog · die Katze = the cat"),
          de("das Mädchen – the GIRL is a „das“? Explain that!", "das Mädchen = the girl (neuter, really)"),
          en("Lost in the park, I asked a guy real quick:"),
          de("„Entschuldigung, wo ist die Park?“ – he said „DER Park, kid.“", "Entschuldigung, wo ist der Park? = excuse me, where is the park?"),
          de("„Da drüben, nach links.“ I went right. Of course.", "da drüben = over there · nach links = to the left"),
          de("Ended up at the Bahnhof, hugging a horse.", "der Bahnhof = the station"),
          de("„Wo bist du?“ Maria called. „Ich bin… am Pferd.“", "Wo bist du? = where are you? · Ich bin am Pferd = I am at the horse"),
          en("She laughed so hard she dropped her phone. Totally worth it."),
        ],
      },
      {
        title: "Bridge: the dreaded table",
        note: "beat drops out, slow clap, Max is sweating",
        lines: [
          de("Ich bin – I am, that’s me, a mess.", "ich bin = I am"),
          de("Du bist – you are, Maria, yes.", "du bist = you are"),
          de("Er ist – he is, the baker, chill.", "er ist = he is"),
          de("Sie ist – she is, the lady from the airport, still.", "sie ist = she is"),
          de("Wir sind – we are, me and the horse,", "wir sind = we are"),
          de("Ihr seid – you all, you’re laughing, of course.", "ihr seid = you (all) are"),
          de("Sie sind – they are, the whole Berlin crew,", "sie sind = they are"),
          de("and I’m not a bread, I’m a human – und du?", "und du? = and you?"),
          de("(Und du? Und du? UND DU?!)", "And you? And you? AND YOU?!"),
        ],
      },
      {
        title: "Hook",
        note: "twice, crowd on every German word",
        lines: [
          de("Hallo! Hallo! Ich bin Max!", "Hello! Hello! I am Max!"),
          en("I don’t know what I’m saying but I’m saying it, relax!"),
          de("Ja, ja, ja! Nein, nein, nein!", "Yes, yes, yes! No, no, no!"),
          de("Ich bin hier, ich bin da, and I’m doing fine!", "ich bin hier = I am here · ich bin da = I am there"),
        ],
      },
      {
        title: "Outro",
        note: "spoken, airport again",
        lines: [
          en("Day seven. New guy at the counter. Looks lost. Looks like me."),
          de("He says “Hi.” I say „Hallo! Ich heiße Max. Wie heißt du?“", "Hallo! Ich heiße Max. Wie heißt du? = Hello! My name is Max. What’s your name?"),
          de("He says „…Ich heiße Max.“", "…Ich heiße Max = …my name is Max"),
          en("…Oh no. Here we go again."),
        ],
      },
    ],
  },
  {
    id: "der_die_das",
    courseId: "de_cert_a1",
    level: "A1.1",
    title: "Der, die, das",
    tagline:
      "One day in Berlin, rapped in English with every A1.1 noun wearing its article. Shout the DER, DIE, DAS.",
    href: "/song/der-die-das",
    quiz: "quest_a1_1_artikel",
    audio: "/audio/songs/der_die_das.mp3",
    after: "quest_a1_1_artikel",
    teaches: [
      "der, die, das — all 84 A1.1 nouns with their article",
      "men and -er jobs are der: Lehrer, Kellner, Verkäufer, Computer",
      "women and most -e words are die: Lampe, Katze, Küche, Schule",
      "-chen is always das: das Mädchen",
      "plural-only words are die: Eltern, Geschwister",
      "countries that keep die: die Schweiz, die Türkei, die USA",
    ],
    sections: [
      {
        title: "Hook",
        note: "everybody shouts the articles",
        lines: [
          de("DER, DIE, DAS – that’s the beat, that’s the bass,", "der, die, das = the (masculine, feminine, neuter)"),
          de("DER, DIE, DAS – put the article in place.", "der Artikel = the article"),
          de("Blue is DER, red is DIE, green is DAS,", "the app’s colours: blue = der, red = die, green = das"),
          en("say it with the noun and the word will last."),
        ],
      },
      {
        title: "Verse 1: waking up",
        lines: [
          de("DIE Uhr on the wall is ticking, it’s seven,", "die Uhr = the clock"),
          de("DIE Sonne comes up and DER Himmel’s blue heaven.", "die Sonne = the sun · der Himmel = the sky"),
          de("DAS Fenster is open, I feel the cold air,", "das Fenster = the window"),
          de("DAS Bett is so warm, but I can’t stay there.", "das Bett = the bed"),
          de("DIE Lampe still on from reading last night,", "die Lampe = the lamp"),
          de("DAS Buch on the floor, DIE Seite in sight.", "das Buch = the book · die Seite = the page"),
          de("I grab DER Schlüssel, I grab DIE Tasche,", "der Schlüssel = the key · die Tasche = the bag"),
          de("pat DER Hund on the head – he’s a good little Lasche.", "der Hund = the dog"),
          de("DIE Katze says nothing, she just looks mean,", "die Katze = the cat"),
          de("I open DIE Tür and step on the scene.", "die Tür = the door"),
        ],
      },
      {
        title: "Verse 2: breakfast with the family",
        lines: [
          de("In DIE Küche DER Tisch is set for ten,", "die Küche = the kitchen · der Tisch = the table"),
          de("DER Stuhl is wobbly, I fix it again.", "der Stuhl = the chair"),
          de("DER Vater makes coffee, DIE Mutter cuts DAS Brot,", "der Vater = the father · die Mutter = the mother · das Brot = the bread"),
          de("DER Apfel for me, DIE Banane – oh no, it’s gone, it’s not!", "der Apfel = the apple · die Banane = the banana"),
          de("DER Hunger is big and DER Durst is real,", "der Hunger = hunger · der Durst = thirst"),
          de("DER Bruder, DIE Schwester fight over the meal.", "der Bruder = the brother · die Schwester = the sister"),
          de("DER Ball rolls in, DER Junge did that,", "der Ball = the ball · der Junge = the boy"),
          de("DAS Mädchen laughs loud, DAS Kind cries „Wo ist DIE Katz’?“", "das Mädchen = the girl · das Kind = the child · Wo ist die Katze? = where is the cat?"),
          de("DER Opa, DIE Oma are sitting right there,", "der Opa = grandpa · die Oma = grandma"),
          de("DER Großvater jokes and DIE Großmutter stares.", "der Großvater = the grandfather · die Großmutter = the grandmother"),
          de("DIE Eltern say „Ruhe!“, DIE Geschwister go on,", "die Eltern = the parents · Ruhe! = quiet! · die Geschwister = the siblings"),
          de("DER Sohn gets a hug, DIE Tochter gets one.", "der Sohn = the son · die Tochter = the daughter"),
          de("DAS Jahr is still young, but DIE Zeit runs away,", "das Jahr = the year · die Zeit = time"),
          de("grab DER Schlüssel, we’re going – it’s a big day.", "der Schlüssel = the key"),
        ],
      },
      {
        title: "Hook",
        note: "everybody shouts the articles",
        lines: [
          de("DER, DIE, DAS – that’s the beat, that’s the bass,", "der, die, das = the (masculine, feminine, neuter)"),
          de("DER, DIE, DAS – put the article in place.", "der Artikel = the article"),
          de("Blue is DER, red is DIE, green is DAS,", "the app’s colours: blue = der, red = die, green = das"),
          en("say it with the noun and the word will last."),
        ],
      },
      {
        title: "Verse 3: into the city",
        lines: [
          de("DER Bus comes late, DER Bahnhof is packed,", "der Bus = the bus · der Bahnhof = the station"),
          de("DIE Stadt has DIE Million people, that’s a fact.", "die Stadt = the city · die Million = the million"),
          de("Every DER Einwohner walks like they’re late,", "der Einwohner = the inhabitant"),
          de("DER Kilometer is long, but DER Park is great.", "der Kilometer = the kilometre · der Park = the park"),
          de("DER Platz by the fountain, the pigeons attack,", "der Platz = the square"),
          de(
            "DER Supermarkt next, DER Verkäufer says „Was darf’s sein, mein Schatz?“",
            "der Supermarkt = the supermarket · der Verkäufer = the shop assistant · Was darf’s sein, mein Schatz? = what’ll it be, sweetheart?",
          ),
          de("DER Euro is gone, DIE Miete is due,", "der Euro = the euro · die Miete = the rent"),
          de("DIE Angst comes a little, then it passes through.", "die Angst = fear"),
          de("DAS Auto zooms past, DER Mann at the wheel,", "das Auto = the car · der Mann = the man"),
          de("DIE Frau on the bike shouts „Hey! Ist das real?“", "die Frau = the woman · Ist das real? = is that real?"),
          de("DIE Zahl on the ticket, DIE Nummer on the door,", "die Zahl = the number (figure) · die Nummer = the number (ID)"),
          de("DAS Haus with DER Nachbar who waves from the floor.", "das Haus = the house · der Nachbar = the neighbour"),
        ],
      },
      {
        title: "Verse 4: school, uni, office",
        lines: [
          de("DIE Schule at nine, DIE Uni at ten,", "die Schule = the school · die Uni = the university"),
          de("DAS Büro at twelve – I’m back here again.", "das Büro = the office"),
          de("DER Lehrer writes DAS Alphabet, letter by letter,", "der Lehrer = the teacher · das Alphabet = the alphabet"),
          de("DER Buchstabe „Ü“ – DER Umlaut makes it better.", "der Buchstabe = the letter · der Umlaut = the umlaut"),
          de("DER Schüler is sleepy, DER Student is late,", "der Schüler = the pupil · der Student = the student"),
          de("DER Computer freezes, man, DIE Zeit can’t wait.", "der Computer = the computer · die Zeit = time"),
          de("Write DER Vorname Kim, DER Nachname Schmidt,", "der Vorname = the first name · der Nachname = the surname"),
          de("DER Kollege says „Fertig?“ – I say „Noch nicht.“", "der Kollege = the colleague · Fertig? = done? · Noch nicht = not yet"),
        ],
      },
      {
        title: "Hook",
        note: "everybody shouts the articles",
        lines: [
          de("DER, DIE, DAS – that’s the beat, that’s the bass,", "der, die, das = the (masculine, feminine, neuter)"),
          de("DER, DIE, DAS – put the article in place.", "der Artikel = the article"),
          de("Blue is DER, red is DIE, green is DAS,", "the app’s colours: blue = der, red = die, green = das"),
          en("say it with the noun and the word will last."),
        ],
      },
      {
        title: "Verse 5: people of Berlin",
        lines: [
          de("DER Arzt says „Gesund!“, so I’m good to go,", "der Arzt = the doctor · Gesund! = healthy!"),
          de("DER Koch in the kitchen, DER Kellner says „Hallo“.", "der Koch = the cook · der Kellner = the waiter"),
          de("DER Journalist asks me where I come from,", "der Journalist = the journalist"),
          de("DER Amerikaner next to me says “Hey, I’m from… home.”", "der Amerikaner = the American"),
          de("DIE Schweiz, DIE Türkei, DIE USA keep DIE,", "die Schweiz = Switzerland · die Türkei = Turkey · die USA = the USA"),
          en("most countries have none – but these three, you see."),
          de("DER Freund calls me up, DIE Freundin is here,", "der Freund = the (male) friend · die Freundin = the (female) friend"),
          de("we sit in DER Park till the stars appear.", "der Park = the park"),
        ],
      },
      {
        title: "Verse 6: evening",
        lines: [
          de("DAS Kino is dark and DER Film is long,", "das Kino = the cinema · der Film = the film"),
          de("DAS Auto drives home, the radio’s on, this song.", "das Auto = the car"),
          de("DAS Fenster closed, DIE Lampe out, DAS Bett is near,", "das Fenster = the window · die Lampe = the lamp · das Bett = the bed"),
          de("DER, DIE, DAS – Kim’s day ends here.", "der, die, das = the, the, the"),
        ],
      },
      {
        title: "Outro",
        note: "call and response, the crowd answers",
        lines: [
          de("Mann? – DER! Frau? – DIE! Kind? – DAS!", "man? – der! woman? – die! child? – das!"),
          de("Hund? – DER! Katze? – DIE! Haus? – DAS!", "dog? – der! cat? – die! house? – das!"),
          de("Vater? – DER! Mutter? – DIE! Mädchen? – DAS!", "father? – der! mother? – die! girl? – das!"),
          en("DER, DIE, DAS – now you’ve got it fast."),
        ],
      },
    ],
  },
];

const ID_PREFIX = "song:";

/** The page's own "heard it" flag (persisted under song_<id>). */
export function songHeard(id: string): boolean {
  try {
    return (
      JSON.parse(localStorage.getItem(`song_${id}`) ?? "{}").heard === true
    );
  } catch {
    return false;
  }
}

export function markSongHeard(id: string, heard = true): void {
  try {
    localStorage.setItem(`song_${id}`, JSON.stringify({ heard }));
  } catch {
    /* storage unavailable: the card just comes round again */
  }
}

export function isSongCard(card: DeckCard): boolean {
  return card.quiz.id.startsWith(ID_PREFIX);
}

export function songCardHref(card: DeckCard): string | null {
  const song = SONGS.find((s) => `${ID_PREFIX}${s.id}` === card.quiz.id);
  return song?.href ?? null;
}

/**
 * The song card to shuffle into a dealt deck, or null: the course's next
 * song for the deck's sub-level — the first in registry order the learner
 * hasn't heard through or skipped. One per deal, like the story card.
 */
export function songDeckCard(
  courseId: string,
  level: string | null,
  skipped: Set<string>,
  /** Whether the learner reached a song's `after` quiz. */
  reached: (quizId: string) => boolean = () => true,
  heard: (id: string) => boolean = songHeard,
): DeckCard | null {
  const song = SONGS.find(
    (s) =>
      s.courseId === courseId &&
      s.level === level &&
      (!s.after || reached(s.after)) &&
      !skipped.has(`${ID_PREFIX}${s.id}`) &&
      !heard(s.id),
  );
  if (!song) return null;
  const quiz: QuizSummary = {
    id: `${ID_PREFIX}${song.id}`,
    type: "listening",
    title: song.title,
    storageKeyPrefix: "song",
    level: song.level,
    status: "live",
    covers: [],
  };
  return { kind: "song", quiz, reason: song.tagline };
}
