// Writes the picture prompts for the B1.1 study companion: its topic pictures
// (assets/images/companion_b1_1_manifest.json) and its new picture-dictionary
// words (added to the shared companion_dictionary_manifest.json).
// Then: node tool/gen-images.mjs --manifest <file> --no-link
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const hero = (id, prompt) => ({ id: `cp_b1_1_${id}`, prompt, aspect: '4:3', size: 800, transparent: true, trim: true });

const images = [
	hero('cover', 'A friendly picture-book scene of a lively discussion at a café table: four friends of different ages talk with lively gestures over coffee and cake, one dreamily imagining a beach in a thought bubble, one pointing at a newspaper; under the table a dog listens with its head tilted. The newspaper has blank columns, no writing.'),
	hero('arbeit', 'A small friendly office: a woman at a desk with a laptop, a colleague bringing two cups of coffee, a printer spitting out paper, and an office dog asleep in a basket under the desk wearing a tiny lanyard.'),
	hero('adj_bestimmt', 'A shop window with three coats on mannequins — a big red one, a small blue one, a long green one — and a woman outside pointing at the big red coat, while her small dog points its nose at the small blue one.'),
	hero('adj_unbestimmt', 'A flea-market table full of things: an old lamp, a new teddy bear, a big clock, a small vase; a young man holds up a strange old hat, and a cat sits on the table pretending to be for sale.'),
	hero('adj_nullartikel', 'A bakery counter with fresh bread rolls, a jug of warm milk and steaming strong coffee; a happy baker hands a fresh loaf across the counter, and a sparrow on the counter steals a crumb.'),
	hero('adj_komparativ', 'Two flats side by side seen from the front like a doll\'s house: a tiny cramped one with a man squeezed in, and a big bright one next door with a balcony and plants; the man looks enviously through the wall at the bigger flat where a cat stretches out lazily.'),
	hero('adj_nomen', 'A big family wedding photo in a garden: the bride and groom in the middle, grandparents, aunts, uncles, cousins and children around them, everyone smiling, and the family dog in the front row wearing a bow tie.'),
	hero('konj2_wuerde', 'A woman at her office desk on a rainy day, daydreaming: a big thought bubble above her shows her lying in a hammock on a sunny beach; on her desk a small cactus wears tiny sunglasses.'),
	hero('konj2_haette', 'A man at a bus stop counting a few coins in his hand and dreaming: a thought bubble above him shows him driving a red sports car with a dog in goggles beside him.'),
	hero('futur', 'A fortune teller at a little round table looking into a crystal ball, while a young couple lean forward eagerly; inside the ball a tiny picture of a house with a garden, and a cat on the table is trying to look into the ball too.'),
	hero('relativ', 'An open-plan office seen from the front: a colleague waters plants, another talks on the phone, a third eats a sandwich at her desk, and a man in the middle waves at the viewer as if introducing them all.'),
	hero('genitiv', 'A colourful house with a blue door and a red roof on a rainy day; in front of it a man holds an umbrella over his car instead of over himself, and his neighbour\'s cat watches from a dry window.'),
	hero('konjunktionen', 'A grown-up woman on a sofa looking at an old photo album; floating above her, like a memory bubble, a scene of her as a little girl building a sandcastle with her father on a beach.'),
	hero('falls_da', 'A hiker at the start of a mountain path, carefully packing an umbrella, a raincoat, sunglasses, sunscreen and a sandwich into a huge backpack for every possible weather, while the sky above is perfectly clear and a goat watches, unimpressed.'),
	hero('infinitiv_zu', 'A young man in pyjamas trying very hard to get up early: three alarm clocks ringing around his bed, one arm reaching out, while his cat sits on his chest keeping him down.'),
	hero('es', 'On a winter street, a woman with rosy cheeks and natural skin colour is wrapped in a thick blanket and scarf, shivering, next to a man in shorts and a T-shirt happily eating an ice cream; between them a small dog wears a knitted jumper.'),
	hero('verben_praep', 'A young woman waiting at a train station with a big bunch of flowers, looking at her watch; behind her a whole crowd of pigeons also waits in a neat line, looking in the same direction.'),
	hero('email', 'A young man at a laptop writing an e-mail, a cup of coffee beside him; his cat lies across half the keyboard, and a small bird on the window sill peeks at the screen. The screen is blank, no writing.'),
];
writeFileSync(new URL('assets/images/companion_b1_1_manifest.json', root), JSON.stringify({ images }, null, '\t') + '\n');

const words = {
	lebenslauf: 'a one-page CV with a small photo box and blank lines, no writing', vertrag: 'a signed contract with blank lines and a pen, no writing',
	schreibtisch: 'an office desk with a drawer', drucker: 'an office printer', ordner: 'a ring binder folder', laptop: 'an open laptop with a blank screen',
	kaffeemaschine: 'a coffee machine', bildschirm: 'a computer monitor with a blank screen', telefon: 'a desk telephone', akku: 'a phone battery pack with a charging cable',
	balkon: 'a balcony with flower boxes on a house wall', milch: 'a glass bottle of milk', brot: 'a loaf of bread', kaffee: 'a cup of coffee',
	hochzeit: 'a wedding couple, the bride with a veil and the groom in a suit', fuehrerschein: 'a driving licence card with a blank photo, no writing',
	krimi: 'a crime novel book with a magnifying glass on the cover, no title', gitarre: 'an acoustic guitar', grill: 'a small barbecue grill with sausages',
	konzert: 'a small concert stage with a band of three musicians', fahrkartenautomat: 'a train ticket machine with a blank screen, no writing',
	rente: 'an old couple sitting happily on a park bench', geld: 'some euro banknotes and coins, no numbers', bank: 'a bank building with columns, blank sign',
	anzug: 'a man\'s suit on a hanger', kuchen: 'a cake with one slice cut out', uhr: 'a wristwatch',
};
const dictPath = new URL('assets/images/companion_dictionary_manifest.json', root);
const dict = existsSync(dictPath) ? JSON.parse(readFileSync(dictPath, 'utf8')) : { images: [] };
for (const [w, p] of Object.entries(words)) {
	const id = `cpd_${w}`;
	if (!dict.images.some((i) => i.id === id))
		dict.images.push({ id, prompt: `One object alone, centred, nothing else in the picture: ${p}.`, aspect: '1:1', size: 800, transparent: true, trim: true });
}
writeFileSync(dictPath, JSON.stringify(dict, null, '\t') + '\n');
console.log(images.length, 'B1.1 pictures;', dict.images.length, 'dictionary entries');
