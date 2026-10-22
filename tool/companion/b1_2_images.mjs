// Writes the picture prompts for the B1.2 study companion: its topic pictures
// (assets/images/companion_b1_2_manifest.json) and its new picture-dictionary
// words (added to the shared companion_dictionary_manifest.json).
// Then: node tool/gen-images.mjs --manifest <file> --no-link
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const hero = (id, prompt) => ({ id: `cp_b1_2_${id}`, prompt, aspect: '4:3', size: 800, transparent: true, trim: true });

const images = [
	hero('cover', 'A friendly picture-book scene of storytelling: a grandfather in an armchair tells a story with big gestures to two children on the rug; above them a story bubble shows a small knight and a friendly dragon having tea; the family cat listens wide-eyed. All people have natural skin colours.'),
	hero('technik', 'An office worker in panic in front of a computer with a completely black screen, holding a coffee cup, while a colleague calmly hands him a laptop; on the desk a cat sits on the keyboard looking innocent. Screens are blank.'),
	hero('praet_reg', 'An old diary lying open on a wooden desk next to a fountain pen and a cup of tea, with a small pressed flower between the pages; a cat sleeps beside it. The pages have only wavy lines, no letters.'),
	hero('praet_unreg', 'A cheerful man walks home in the evening carrying a bag of shopping, and a little dog follows him carrying the last baguette in its mouth; a street lamp and a house with a lit window behind them.'),
	hero('plusquamperfekt', 'A man running onto a railway platform with his suitcase, out of breath, just as the last carriage of the train disappears in the distance; a pigeon on the platform looks at him sympathetically. Signs are blank.'),
	hero('temporal', 'A kitchen at dinner time: a woman stirs a pot on the stove while a man lays the table with plates and forks, and a child waits at the table with a napkin tied round her neck; the dog waits under the table.'),
	hero('passiv', 'A big building site seen from the front: a yellow crane lifts a beam, workers in helmets build a wall, another paints a window frame, and a cat in a tiny helmet supervises from a pile of bricks.'),
	hero('passiv_modal', 'A restaurant door with a closed sign hanging on it (the sign blank), a man in front of it holding his stomach, hungry and disappointed; inside, through the window, the tables are already laid and a waiter waves apologetically.'),
	hero('n_dekl', 'A student with a backpack shaking hands with an older gentleman in a hat in front of a plain brick building with no sign; a neighbour waves from a window, and a boy rides past on a bicycle. Natural skin colours, no text.'),
	hero('zweck', 'A woman jogging in a park early in the morning with headphones, a piggy bank under her arm as if she were saving money while running; a squirrel jogs beside her.'),
	hero('relativ_dat', 'A street of houses seen from the front: in one window a woman whose dog barks at a postman, in another a man reading, on the pavement a red car parked in front of a house, and children chalk on the ground.'),
	hero('konnektoren', 'Two friends at a crossroads with a signpost pointing in two directions (signs blank), one holding a map and one holding an umbrella and sunglasses at the same time, trying to decide.'),
	hero('wuensche', 'A man standing at a bus stop in pouring rain without an umbrella, soaked, looking at a poster on the bus shelter wall that shows only a sunny beach, no text; his umbrella can be seen lying at home in a small thought bubble.'),
	hero('trotz_wegen', 'A family having a picnic on a blanket in the rain, all wearing raincoats and smiling stubbornly, eating sandwiches under umbrellas; their dog sits in a puddle, delighted.'),
	hero('partizip', 'A living room: a laughing child on a rug, a sleeping dog on the sofa, a boiling kettle on a small stove in the corner with steam, and an open window with curtains blowing.'),
	hero('partikeln', 'Two friends meeting by surprise in a supermarket aisle, both pointing at each other with wide, happy surprise, each holding a shopping basket; a small child in a trolley looks on. Product labels blank.'),
	hero('wortbildung', 'Three people side by side: a sportswoman in running clothes with a medal, an artist with a paint palette in front of an easel, and a scientist in a lab coat holding a test tube — all waving.'),
	hero('geschichte', 'A woman on a rainy street whose umbrella has been turned inside out by the wind, while a kind stranger offers her his own umbrella; a dog in a yellow raincoat watches from a doorway.'),
];
// The study-book style without its hex colour codes: Gemini sometimes paints a
// code like "#c9683b" into the picture when the prompt names it.
const style =
	JSON.parse(readFileSync(new URL('assets/images/companion_manifest.json', root), 'utf8')).style.replace(/\s*\(#[0-9a-fA-F]{6}\)/g, '') +
	' Never write any colour codes, hex values, numbers, labels or signatures anywhere in the picture.';
writeFileSync(new URL('assets/images/companion_b1_2_manifest.json', root), JSON.stringify({ style, images }, null, '\t') + '\n');

const words = {
	maus: 'a computer mouse', tastatur: 'a computer keyboard', festplatte: 'an external hard drive', kopfhoerer: 'a pair of headphones',
	kamera: 'a photo camera', ladegeraet: 'a phone charger with its cable', usbstick: 'a USB stick', handy: 'a smartphone with a blank screen',
	bruecke: 'a stone bridge over a river', kran: 'a yellow construction crane, drawn large', baustelle: 'a small building site with bricks, a cement mixer and a barrier',
	ritter: 'a friendly knight in armour holding a shield', drache: 'a friendly green dragon', krone: 'a golden crown',
	dieb: 'a cartoon burglar in a striped jumper and black mask, sneaking with a bag', polizei: 'a police officer in a German green-and-blue uniform and cap',
	gluehbirne: 'a light bulb', stau: 'a traffic jam seen from the front at a slight angle, cars close together filling the picture, drawn large', sturm: 'a stormy sky with dark clouds, wind and bending trees',
	fenster: 'a window with open shutters', tuer: 'a wooden front door', muell: 'a rubbish bin with a full bag', formular: 'a paper form with empty boxes and lines, no writing',
	wecker: 'an old ringing alarm clock', wasser: 'a glass of water', sportler: 'a sportsman running', kuenstler: 'an artist painting at an easel',
};
const dictPath = new URL('assets/images/companion_dictionary_manifest.json', root);
const dict = existsSync(dictPath) ? JSON.parse(readFileSync(dictPath, 'utf8')) : { images: [] };
dict.style = style;
for (const [w, p] of Object.entries(words)) {
	const id = `cpd_${w}`;
	if (!dict.images.some((i) => i.id === id))
		dict.images.push({ id, prompt: `One object alone, centred, nothing else in the picture, no text: ${p}.`, aspect: '1:1', size: 800, transparent: true, trim: true });
}
writeFileSync(dictPath, JSON.stringify(dict, null, '\t') + '\n');
console.log(images.length, 'B1.2 pictures;', dict.images.length, 'dictionary entries');
