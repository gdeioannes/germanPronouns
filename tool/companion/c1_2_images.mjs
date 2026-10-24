// Writes the picture prompts for the C1.2 study companion: its topic pictures
// (assets/images/companion_c1_2_manifest.json) and its new picture-dictionary
// words (added to the shared companion_dictionary_manifest.json).
// Then: node tool/gen-images.mjs --manifest <file> --no-link
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const hero = (id, prompt) => ({ id: `cp_c1_2_${id}`, prompt, aspect: '4:3', size: 800, transparent: true, trim: true });

// The cover prints across the whole page, so it is built at 2048px from the original (upscaled).
const images = [
	{ ...hero('cover', 'A theatre stage with the red curtain half open: an actress in a long dress raises one eyebrow and whispers something behind her hand to the audience, while a prompter’s head peeks out of the little box at the front of the stage with a finger on his lips; in the front row a dog in a bow tie listens very seriously. No text anywhere. Natural skin colours.'), size: 2048 },
	hero('kultur', 'A theatre audience in a small modern theatre after a play: half the people stand and applaud enthusiastically, the other half look puzzled and scratch their heads, and an elderly critic in the middle writes in a notebook with a raised eyebrow. Natural skin colours, no text.'),
	hero('vermutung', 'A man standing outside a house at night looking up at a lit window and drawing conclusions, holding his chin thoughtfully; a cat on the windowsill looks back at him as if it knows everything. Natural skin colours.'),
	hero('hoerensagen', 'An empty golden picture frame on a museum wall where a painting used to be, two visitors whispering to each other, and a museum guard with a magnifying glass inspecting the empty frame; a mouse peeks out from behind the frame. No text. Natural skin colours.'),
	hero('konj1', 'A radio reporter with a microphone and headphones interviewing a volunteer who carries a crate of vegetables outside a plain brick hall with no sign and no writing on it, other volunteers loading a small van in the background, and an old man waving from a bench. No text. Natural skin colours.'),
	hero('abschwaechen', 'A meeting room where a man in a suit politely raises one finger to disagree, smiling diplomatically, while across the table a colleague has drawn an enormous, absurd chart on a flipchart; a potted plant in the corner seems to lean away. No text or numbers. Natural skin colours.'),
	hero('kritik', 'A delivery man arriving at a wedding with a huge cake that has slid sideways in its box, the bride and groom looking at it with polite disappointment, and the best man’s dog already licking the cream off the side. Natural skin colours.'),
	hero('ironie', 'A family on a beach holiday standing in pouring rain in their swimsuits with an umbrella, the father giving a forced thumbs-up with a deadpan face, while a seagull sits dry under the umbrella. Natural skin colours.'),
	hero('vorsilben', 'A tourist lost in a maze of narrow old streets, holding an upside-down map, while a pigeon on a wall points the right way with its wing. No text. Natural skin colours.'),
	hero('praefixe', 'A small car that has just knocked over a wooden post in a car park, the driver getting out with an embarrassed face, while another car in the background drives carefully around a second post. Natural skin colours, no text.'),
	hero('nachsilben', 'A family tree drawn as a real tree in a garden, with small framed portraits hanging from its branches like fruit, and a child on a ladder adding a new portrait at the top; a squirrel holds one of the frames. Portraits are simple faces. Natural skin colours.'),
	hero('numerus', 'A lecture hall seen from the front: a very diverse group of students of all ages greets a new lecturer, who waves back; one student has brought a parrot on her shoulder. Natural skin colours, no text.'),
	hero('redewendungen', 'A literal picture of an idiom: an office worker pushing a pile of files onto a very long wooden bench that disappears into the distance, while a colleague sweeps a little pile of papers under a rug. No text. Natural skin colours.'),
	hero('relativ', 'An old professor in a library helping a young author carry a stack of books up a ladder, the two of them working together, while a cat sleeps on the top shelf. No text on books. Natural skin colours.'),
	hero('kohaesion', 'A long chain of people passing buckets of water hand to hand from a lake to a small burning bonfire, each person turning to the next; a dog carries a tiny bucket at the end of the line. Natural skin colours.'),
	hero('umformung', 'A tailor in her workshop turning a long coat into a short jacket on a dressmaker’s dummy, scissors in hand, with the cut-off fabric becoming a little coat for a dachshund that waits patiently. Natural skin colours.'),
	hero('bericht', 'A street under renovation with a cordoned-off trench, workers laying new pipes, a site manager with a clipboard and a hard hat taking notes, and a duck family walking through the closed street. No text on signs. Natural skin colours.'),
	hero('register', 'A young man at his desk with two screens: on one he types a casual chat while slouching in a hoodie, on the other he sits upright in a shirt and tie writing a formal e-mail — the same man shown twice side by side. Screens blank. Natural skin colours.'),
	hero('redemittel', 'A woman giving a talk on a small stage in front of a projected screen showing only a tree and a thermometer drawing, the audience attentive, and one listener fanning herself because it is hot. No text or numbers. Natural skin colours.'),
	hero('forum', 'Two friends in a café: one is talking warmly, the other keeps glancing at her phone which lights up on the table; the cappuccino between them has a heart in the foam. Screen blank. Natural skin colours.'),
	hero('literatur', 'A woman sitting on a wide windowsill at dusk with her knees drawn up, holding an opened letter, looking out over darkening rooftops while the street lamps come on; a cat sits beside her. The letter has only wavy lines. Natural skin colours.'),
];
// The study-book style without its hex colour codes: Gemini sometimes paints a
// code like "#c9683b" into the picture when the prompt names it.
const style =
	JSON.parse(readFileSync(new URL('assets/images/companion_manifest.json', root), 'utf8')).style.replace(/\s*\(#[0-9a-fA-F]{6}\)/g, '') +
	' Never write any colour codes, hex values, numbers, labels or signatures anywhere in the picture.';
writeFileSync(new URL('assets/images/companion_c1_2_manifest.json', root), JSON.stringify({ style, images }, null, '\t') + '\n');

const words = {
	aktenvernichter: 'a paper shredder with strips of paper coming out', briefablage: 'a stacked letter tray with blank papers, no writing or marks on them', aktenschrank: 'a metal filing cabinet with drawers',
	stativ: 'a camera tripod', leinwand: 'a pull-down projection screen, blank', beamer: 'a small video projector', megafon: 'a megaphone',
	aquarium: 'a small aquarium with two fish and a plant', locher: 'a hole punch', tacker: 'a stapler',
	roentgengeraet: 'an airport X-ray baggage scanner with a suitcase going in', fluggastbruecke: 'an airport jet bridge connected to the side of a plane',
	triebwerk: 'a jet engine seen from the side, hanging under a piece of aeroplane wing', kinderwagen: 'a pram', reisepass: 'a closed passport with a plain cover, no writing',
	bordkarte: 'a boarding pass ticket with only lines and boxes, no writing', umschlag: 'a sealed paper envelope with no writing', tuerkette: 'a door chain on a door slightly open',
	laterne: 'a street lamp, lit', herd: 'an old cast-iron wood stove', parkbank: 'a park bench', pfosten: 'a thin painted metal bollard post standing upright on pavement',
	faehre: 'a small car ferry on water', gemaelde: 'a framed oil painting of a landscape', wappen: 'a coat of arms shield with a lion, no letters',
	lederkoffer: 'a heavy brown leather briefcase',
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
console.log(images.length, 'C1.2 pictures;', dict.images.length, 'dictionary entries');
