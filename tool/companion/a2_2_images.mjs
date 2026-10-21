// Writes the picture prompts for the A2.2 study companion: its topic pictures
// (assets/images/companion_a2_2_manifest.json) and its new picture-dictionary
// words (added to the shared companion_dictionary_manifest.json).
// Then: node tool/gen-images.mjs --manifest <file> --no-link
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const hero = (id, prompt, aspect = '4:3') => ({ id, prompt, aspect, size: 800, transparent: true, trim: true });
const cat = (pos, text) => hero(`cp_a2_2_katze_${pos}`, `A round wicker basket and one small ginger cat, simple and clear, nothing else: ${text}`, '1:1');

const images = [
	hero('cp_a2_2_cover', 'A friendly picture-book scene of planning a day: a young couple at a kitchen table with a big blank wall calendar and a map, pointing at different places; their cat sits in the fruit bowl and their dog holds a leash in its mouth, ready to go. The calendar and map are blank, no writing.'),
	hero('cp_a2_2_wechsel_wo', 'A cosy living room seen straight from the front like a stage: a book lies on the table, a picture hangs on the wall, a lamp hangs above the table, shoes stand next to the door, and a cat sleeps under the sofa with only its tail sticking out.'),
	hero('cp_a2_2_wechsel_wohin', 'A woman busily tidying a room: she puts a vase on a shelf and hangs a picture on the wall, while behind her a dog happily carries the same shoes back out of the cupboard she just put them in.'),
	hero('cp_a2_2_reflexiv', 'A man in a bathroom in the morning, wet hair, looking at himself in the mirror and smiling; behind him his cat is washing itself in the sink in exactly the same pose. The mirror shows only his reflection.'),
	hero('cp_a2_2_weil_dass', 'A girl in bed with a thermometer in her mouth and a hot-water bottle, while through the window her friends wait outside with a football, looking disappointed; her dog sits on the bed wearing a tiny scarf in solidarity.'),
	hero('cp_a2_2_wenn_deshalb', 'A family at a window looking at heavy rain, holding a picnic basket; inside, they have spread the picnic blanket on the living-room floor and the dog is already eating the sandwiches.'),
	hero('cp_a2_2_indirekt', 'A polite tourist with a suitcase asking an older woman on a street corner for directions, holding a blank map upside down; the woman points the way kindly, and a pigeon on a lamppost points the other way with its wing. Signs are blank.'),
	hero('cp_a2_2_verben_praep', 'A young man waiting at a bus stop in the rain, thinking happily about a beach holiday shown in a big thought bubble above his head with palm trees and sun; next to him a snail waits for the bus too. The bus-stop sign is blank.'),
	hero('cp_a2_2_gesundheit', 'A friendly doctor in a white coat listening with a stethoscope to the chest of a man who has a big scarf and a red nose, while the small dog of the man sits on the next chair also holding out its paw to be examined.'),
	hero('cp_a2_2_kleidung', 'A clothes shop: a cheerful man steps out of a changing room wearing a winter coat that is much too big, the sleeves hanging far over his hands; a smiling shop assistant holds up a smaller coat for him.'),
	hero('cp_a2_2_ratschlaege', 'A grandmother giving advice to a tired student slumped at a desk with many books: she offers a cup of tea and points at the bed; the cat of the student is already asleep on the pillow, taking the advice.'),
	hero('cp_a2_2_relativ', 'A street of a small German town seen from the front: a man waters flowers on his balcony, a woman with a bicycle chats to a neighbour, children play with a ball, and a dog in a window watches everyone like a neighbourhood guard.'),
	hero('cp_a2_2_praeteritum', 'A fairy-tale scene: a small dog wearing a tiny crown stands in front of a castle on a hill with a key in its mouth, a forest behind; a royal cake sits on a table with one big bite missing.'),
	hero('cp_a2_2_passiv', 'A busy bakery seen from the front early in the morning: one baker takes bread out of the oven, another packs rolls into bags, a third cleans the counter, and a cat sits in the shop window among the fresh loaves pretending to be one. Signs are blank.'),
	hero('cp_a2_2_superlativ', 'A winners podium in a park with three animals: a small tortoise stands proudly on the highest step with a gold medal, a rabbit on the second and a greyhound on the third, both looking confused.'),
	hero('cp_a2_2_wortbildung', 'A friendly bus driver at the wheel of a yellow bus, a teacher at a blackboard with blank lines, and a shop assistant holding up a jumper — three working people side by side, each waving.'),
	hero('cp_a2_2_tekamolo', 'A young woman cycling along a riverside path towards a city skyline in the morning sun, a baguette sticking out of her bike basket, with a small dog riding in the basket wearing goggles.'),
	hero('cp_a2_2_datum_email', 'A young woman at a laptop writing happily, a wall calendar with one day circled in red behind her, a wrapped birthday present and balloons on the table; her cat walks across the keyboard. Screen and calendar are blank, no writing.'),
	cat('auf', 'the cat sits on top of the closed basket lid.'),
	cat('in', 'the cat sits inside the open basket, only its head and ears showing.'),
	cat('unter', 'the basket stands on two blocks and the cat lies underneath it.'),
	cat('neben', 'the cat sits on the floor right next to the basket, at its side.'),
	cat('vor', 'the cat sits on the floor in front of the basket, closer to the viewer.'),
	cat('hinter', 'the basket has a closed lid; the cat hides BEHIND it, only its ears and the top of its head peeking over the back of the basket and its tail sticking out at the side — not inside the basket.'),
];
writeFileSync(new URL('assets/images/companion_a2_2_manifest.json', root), JSON.stringify({ images }, null, '\t') + '\n');

const words = {
	korb: 'a round wicker basket', regal: 'a wooden bookshelf with a few books', vase: 'a vase with one flower',
	teppich: 'a patterned rug, seen from above at an angle', schrank: 'a wooden wardrobe', teller: 'an empty white plate',
	hemd: 'a shirt with a collar and buttons', pullover: 'a knitted jumper', schuhe: 'a pair of shoes', socken: 'a pair of socks',
	tshirt: 'a plain T-shirt', hut: 'a hat', rezept: 'a prescription slip with blank lines, no writing',
	medikament: 'a small medicine box and a blister pack of tablets, no writing', thermometer: 'a medical thermometer',
	pflaster: 'a sticking plaster', paket: 'a parcel tied with string, no writing', salz: 'a salt shaker',
	taxi: 'a cream-coloured taxi with a blank roof sign', fahrrad: 'a bicycle', schloss: 'a fairy-tale castle on a hill',
	wald: 'a small forest of trees', koenig: 'a king with a crown and a red cloak', dorf: 'a small village with a church tower and a few houses',
	elefant: 'an elephant', eis: 'an ice-cream cone with two scoops', bibliothek: 'a library with tall bookshelves and a reading table',
	schluessel: 'a key', einladung: 'an invitation card decorated with balloons, no writing', kalender: 'a wall calendar with blank boxes, no numbers',
	toilette: 'a toilet', fahrer: 'a bus driver in uniform and cap',
};
const dictPath = new URL('assets/images/companion_dictionary_manifest.json', root);
const dict = existsSync(dictPath) ? JSON.parse(readFileSync(dictPath, 'utf8')) : { images: [] };
for (const [w, p] of Object.entries(words)) {
	const id = `cpd_${w}`;
	if (!dict.images.some((i) => i.id === id))
		dict.images.push({ id, prompt: `One object alone, centred, nothing else in the picture: ${p}.`, aspect: '1:1', size: 800, transparent: true, trim: true });
}
writeFileSync(dictPath, JSON.stringify(dict, null, '\t') + '\n');
console.log(images.length, 'A2.2 pictures;', dict.images.length, 'dictionary entries');
