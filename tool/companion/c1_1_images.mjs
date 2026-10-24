// Writes the picture prompts for the C1.1 study companion: its topic pictures
// (assets/images/companion_c1_1_manifest.json) and its new picture-dictionary
// words (added to the shared companion_dictionary_manifest.json).
// Then: node tool/gen-images.mjs --manifest <file> --no-link
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const hero = (id, prompt) => ({ id: `cp_c1_1_${id}`, prompt, aspect: '4:3', size: 800, transparent: true, trim: true });

// The cover prints across the whole page, so it is built at 2048px from the original (upscaled).
const images = [
	{ ...hero('cover', 'A cosy old university library: a young woman at a long wooden table packs a huge pile of books into one small neat box labelled with nothing, while next to her a professor with a grey beard unpacks a tiny box into an enormous cloud of floating papers; an owl sits on the bookshelf above them looking amused. No text on books, boxes or papers. Natural skin colours.'), size: 2048 },
	hero('bildung', 'A small research team in a bright lab: one scientist looks through a microscope, another writes on a whiteboard full of simple drawings of arrows and circles (no letters or numbers), and a laboratory mouse in a tiny lab coat checks the results on a clipboard. Natural skin colours.'),
	hero('nominalisierung', 'A friendly office worker carefully folding a very long paper chain of little paper people into one small neat paper block on her desk, with a cat watching the paper chain hanging off the desk. No text. Natural skin colours.'),
	hero('verbalisierung', 'A man unpacking a small suitcase from which an impossibly long row of clothes, a lamp, a plant and a bicycle come out, the room filling up; his dog sits in the empty suitcase. Natural skin colours.'),
	hero('genitiv', 'A formal anniversary celebration in a town hall: a mayor with a chain of office cuts a large cake shaped like the town hall, guests in suits clap, and a small boy secretly takes the first piece. No text. Natural skin colours.'),
	hero('kasus', 'A helpful hotel porter in uniform bows and carries a guest’s three suitcases at once, while the guest, an elderly lady, carries only her small dog in a basket. Natural skin colours.'),
	hero('fvg', 'A serious official in a suit solemnly places a huge rubber stamp on a single document on a large desk, while behind him a cat has already stamped paw prints across a whole pile of papers. Papers have no writing. Natural skin colours.'),
	hero('tempus', 'A woman in bed at midnight, awake, holding her breath and staring at her bedroom door, while on the other side of the door, seen in a cut-away, it is only her dog politely knocking with its paw. Natural skin colours.'),
	hero('passiversatz', 'A child at a birthday table receiving a present from her grandmother, unwrapping a book, while the family dog has already received and unwrapped its own present: a slipper. Natural skin colours.'),
	hero('bar_lich', 'A man at a market stall looking surprised at a single, clearly affordable apple next to a huge, impossibly expensive golden pineapple under a glass dome; the stallholder polishes the dome proudly. No price signs or numbers. Natural skin colours.'),
	hero('partizipialattribut', 'An office desk with a tall stack of application folders waiting to be checked, a tired clerk with a magnifying glass on top of the pile, and a cat asleep in the outbox tray. Folders have no writing. Natural skin colours.'),
	hero('partizipialsatz', 'A traveller with a rolling suitcase arriving in a city square at night, looking up at a hotel with lit windows, a tired but smiling face; a pigeon is sleeping on top of his suitcase. Hotel sign blank. Natural skin colours.'),
	hero('attribute', 'A long queue of people at a museum entrance, each one taller than the last, with a small child at the very front holding everybody’s tickets; the guard looks along the endless line. No text. Natural skin colours.'),
	hero('grafik', 'A presenter standing next to a big bar chart on an easel whose bars rise from left to right like stairs, with a tiny climber with a rope and a flag on top of the highest bar; the audience in a few chairs watches. No numbers or labels on the chart. Natural skin colours.'),
	hero('konnektoren', 'Two teachers in a classroom with tablets on the desks: one enthusiastically shows a tablet to the class, the other holds up a thick paper book, and a pupil in the front row is secretly playing a game on his tablet. Screens blank. Natural skin colours.'),
	hero('adverbien', 'A man lying in a hammock in a garden doing nothing at all, looking at the clouds, with a little thought bubble full of colourful ideas, while his phone lies forgotten in the grass with a snail on it. Natural skin colours.'),
	hero('adverbial_1', 'A family at the front door deciding whether to go out: the father holds an umbrella and looks at the grey sky, the mother holds sunglasses, the child holds a kite, and the dog already wears rain boots. Natural skin colours.'),
	hero('adverbial_2', 'Two neighbours over a garden fence: on one side a perfect neat garden with straight rows of flowers, on the other side a wild jungle garden with a hammock, both owners smiling proudly at each other. Natural skin colours.'),
	hero('zweiteilig', 'A customer at a shop counter holding up a broken toaster with smoke coming out of it, the shop assistant shrugging with both hands, and a cat on the counter sniffing the smoke. Natural skin colours.'),
	hero('darstellen', 'A confident woman giving a presentation in a lecture hall, pointing to three simple pictures on a screen (a tree, a book, a lightbulb), with students taking notes and one student asleep on his folded arms. No text on the screen. Natural skin colours.'),
	hero('zusammenfassung', 'A student at a desk turning a gigantic thick book into a single small index card by writing, with a pile of crossed-out notes on the floor and a hamster running in its wheel on the desk. The card and book have only wavy lines. Natural skin colours.'),
];
// The study-book style without its hex colour codes: Gemini sometimes paints a
// code like "#c9683b" into the picture when the prompt names it.
const style =
	JSON.parse(readFileSync(new URL('assets/images/companion_manifest.json', root), 'utf8')).style.replace(/\s*\(#[0-9a-fA-F]{6}\)/g, '') +
	' Never write any colour codes, hex values, numbers, labels or signatures anywhere in the picture.';
writeFileSync(new URL('assets/images/companion_c1_1_manifest.json', root), JSON.stringify({ style, images }, null, '\t') + '\n');

const words = {
	infusionsstaender: 'a hospital drip stand with an infusion bag hanging from it', sauerstoffflasche: 'a green medical oxygen bottle on a small trolley',
	waermflasche: 'a red rubber hot-water bottle with a knitted cover', rollstuhl: 'a wheelchair', kruecke: 'one metal forearm crutch',
	stethoskop: 'a stethoscope', klemmbrett: 'a clipboard with a blank sheet of paper', kopfkissen: 'a white pillow',
	schnabeltasse: 'a plastic sippy cup with a spout and two handles, for adults in hospital', treteimer: 'a pedal bin',
	scheinwerfer: 'a theatre spotlight on a stand', peruecke: 'a curly blond wig on a plain smooth egg-shaped stand with no face', maske: 'a carnival mask',
	vorhang: 'a red theatre curtain, drawn large', trommel: 'a drum with two drumsticks', notenpult: 'a music stand with a blank sheet',
	kleiderstaender: 'a clothes rail with three colourful costumes', steckenpferd: 'a hobby horse, a horse head on a stick',
	nebelmaschine: 'a small smoke machine with a little cloud of fog', schminktisch: 'a make-up table with a mirror surrounded by light bulbs',
	tafel: 'a school blackboard with nothing written on it', lehrbuch: 'a closed thick textbook with a plain cover', urkunde: 'a rolled certificate tied with a red ribbon and a plain round red wax seal with no symbol on it, no writing',
	doktorhut: 'a black graduation cap with a tassel', tablet: 'a tablet computer with a blank screen', sanduhr: 'an hourglass',
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
console.log(images.length, 'C1.1 pictures;', dict.images.length, 'dictionary entries');
