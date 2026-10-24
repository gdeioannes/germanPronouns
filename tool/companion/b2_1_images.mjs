// Writes the picture prompts for the B2.1 study companion: its topic pictures
// (assets/images/companion_b2_1_manifest.json) and its new picture-dictionary
// words (added to the shared companion_dictionary_manifest.json).
// Then: node tool/gen-images.mjs --manifest <file> --no-link
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const hero = (id, prompt) => ({ id: `cp_b2_1_${id}`, prompt, aspect: '4:3', size: 800, transparent: true, trim: true });

// The cover prints across the whole page, so it is built at 2048px from the original (upscaled).
const images = [
	{ ...hero('cover', 'A lively town-hall debate seen from the audience: a woman at a lectern makes her point with a raised finger, a man at a second lectern answers with open hands, a moderator in the middle holds a microphone, and in the front row a grandmother takes notes while her small dog holds up a tiny blank sign of its own. No text anywhere, signs blank. Natural skin colours.'), size: 2048 },
	hero('gesellschaft', 'A polling station: people queue to drop folded ballot papers into a ballot box, a young woman votes for the first time proudly, and an old man has brought his cat, which sits on the ballot box. Papers and boxes have no writing. Natural skin colours.'),
	hero('konj1', 'A newspaper reporter with a notepad interviews a minister in a suit on the steps of a grand building, while a pigeon on the steps holds a tiny notepad too and seems to take notes. No text on anything. Natural skin colours.'),
	hero('konj1_verg', 'A witness, an elderly woman with a shopping bag, tells a police officer what she saw, gesturing at a bicycle lying on the pavement; the officer writes it down, and a dog next to them acts out the accident by lying on its back. Natural skin colours.'),
	hero('indirekt_fragen', 'A curious child at a kitchen table asking a tired father many questions, with small question-mark-free thought bubbles showing a train, a moon and a dinosaur; the father holds his head, and the cat looks equally curious. Natural skin colours.'),
	hero('verben_praep', 'A woman at a bus stop waiting impatiently and looking at her watch, while a snail next to her waits calmly with a tiny suitcase. The watch has no numbers. Natural skin colours.'),
	hero('adjektive_praep', 'A proud mother clapping at a school stage where her small daughter takes a bow after a show, and the daughter’s dog in the audience also claps its paws. Natural skin colours.'),
	hero('nomen_praep', 'A man standing at the edge of a swimming pool on a diving board, clearly afraid of the water, while a duck in the pool waves at him encouragingly. Natural skin colours.'),
	hero('modalpassiv', 'A busy repair scene: a plumber fixes a leaking pipe under a sink, water spraying, while the owner holds a bucket and a goldfish in a bowl on the counter watches nervously. Natural skin colours.'),
	hero('passiv_perfekt', 'A finished new house with a ribbon on its door and the builders celebrating with their helmets in the air, while the old shed next to it is being carried away by a very small determined dog. Natural skin colours.'),
	hero('zustandspassiv', 'A shop door at nine in the morning: a shopkeeper turns the key to open the shop, a queue of eager customers waits outside, and the first in the queue is a cat with a shopping basket. Signs are blank. Natural skin colours.'),
	hero('passiv_subjektlos', 'A cheerful village party in a hall: people dancing, laughing and eating at long tables, a band on a small stage, and a dog dancing on its hind legs in the middle of the dance floor. Natural skin colours.'),
	hero('lassen', 'A hairdresser cutting a man’s hair in a salon chair while the man reads a magazine, and next to him his dog sits in a second chair having its fur trimmed by another hairdresser. Magazine pages blank. Natural skin colours.'),
	hero('partizip_adj', 'A railway platform in the evening: a train arriving, a barking dog on the platform, playing children, and the setting sun behind the station. No text on the train or signs. Natural skin colours.'),
	hero('nachsilben', 'A friendly scene of three things in a row: a tourist with a camera and sunglasses, a girl holding a small house-shaped birdhouse, and a scientist proudly holding a document; a pigeon sits on the birdhouse. Natural skin colours.'),
	hero('konnektoren', 'A couple leaving a shop carrying a huge, clearly too expensive sofa between them, both happy anyway, while their small dog sits on top of the sofa like a king. Natural skin colours.'),
	hero('mittelfeld', 'A woman cycling to work in the morning along a tree-lined road with her briefcase in the front basket, and a squirrel sitting on the briefcase enjoying the ride. Natural skin colours.'),
	hero('nominal', 'A family stuck at home on a rainy day looking out of the window at the rain, while the dog has already put on its raincoat and waits by the door with its lead in its mouth. Natural skin colours.'),
	hero('infinitiv', 'A student at a desk late at night studying hard with books and a lamp, hoping to pass; her cat has fallen asleep on an open book. Book pages have only wavy lines. Natural skin colours.'),
	hero('brauchen', 'A host at a front door waving away a guest who has brought a huge pile of presents and food, saying it was not necessary, while the host’s dog happily takes one of the parcels. Natural skin colours.'),
	hero('stellungnahme', 'A woman at a kitchen table writing a letter to the newspaper with great determination, a newspaper open beside her, and outside the window a small park with a single tree where a bird watches her. The newspaper and letter have only wavy lines. Natural skin colours.'),
];
// The study-book style without its hex colour codes: Gemini sometimes paints a
// code like "#c9683b" into the picture when the prompt names it.
const style =
	JSON.parse(readFileSync(new URL('assets/images/companion_manifest.json', root), 'utf8')).style.replace(/\s*\(#[0-9a-fA-F]{6}\)/g, '') +
	' Never write any colour codes, hex values, numbers, labels or signatures anywhere in the picture.';
writeFileSync(new URL('assets/images/companion_b2_1_manifest.json', root), JSON.stringify({ style, images }, null, '\t') + '\n');

const words = {
	kronleuchter: 'a crystal chandelier', tischklingel: 'a silver desk bell, the kind on a hotel reception counter', gaestebuch: 'a thick open guest book with a ribbon and a pen, pages with only lines',
	gepaeckwagen: 'a brass hotel luggage trolley with two suitcases on it', koffer: 'a suitcase with a handle', klavier: 'an upright piano',
	schirmstaender: 'an umbrella stand with two umbrellas in it', wasserspender: 'an office water cooler with a big blue bottle on top', blumentopf: 'a terracotta flowerpot with a green plant',
	ueberwachungskamera: 'a white security camera on a wall bracket', bagger: 'a yellow digger', betonmischer: 'a small orange cement mixer',
	schubkarre: 'a wheelbarrow', geruest: 'a section of metal scaffolding with planks', helm: 'a yellow hard hat', wasserwaage: 'a spirit level with a green bubble',
	hammer: 'a hammer', leiter: 'a wooden ladder', mikrofon: 'a microphone on a stand', wahlurne: 'a transparent ballot box with a slot on top and folded paper ballots visible inside, plain with no writing',
	stimmzettel: 'a ballot paper with empty boxes, one box marked with a cross, no other writing', fahne: 'a plain flag in one colour on a flagpole, no symbols',
	briefkasten: 'a yellow German postbox, plain with no writing', radio: 'an old radio with a dial and two knobs', ei: 'a brown hen egg standing in a small egg cup',
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
console.log(images.length, 'B2.1 pictures;', dict.images.length, 'dictionary entries');
