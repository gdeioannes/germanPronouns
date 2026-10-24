// Writes the picture prompts for the B2.2 study companion: its topic pictures
// (assets/images/companion_b2_2_manifest.json) and its new picture-dictionary
// words (added to the shared companion_dictionary_manifest.json).
// Then: node tool/gen-images.mjs --manifest <file> --no-link
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const hero = (id, prompt) => ({ id: `cp_b2_2_${id}`, prompt, aspect: '4:3', size: 800, transparent: true, trim: true });

// The cover prints across the whole page, so it is built at 2048px from the original (upscaled).
const images = [
	{ ...hero('cover', 'A dreamy picture-book scene: a woman sits on a park bench daydreaming, and above her head a big thought bubble shows three possible lives side by side — herself as an astronaut, as a baker with a giant cake, and lying in a hammock on a beach; a pigeon next to her on the bench has its own small thought bubble with a single bread roll. Natural skin colours.'), size: 2048 },
	hero('umwelt', 'A family on a balcony separating their rubbish into three bins, a solar panel on the railing and a wind turbine in the distance; the grandfather proudly holds up one single plastic bottle like a trophy while the cat sleeps inside the paper bin. Natural skin colours.'),
	hero('irreal', 'A man in a small flat holding a lottery ticket and daydreaming; a big thought bubble above him shows the same man on a yacht with a captain’s hat, and his dog in the bubble wears sunglasses. In the real room the dog sits beside him with an empty food bowl. Tickets and papers are blank.'),
	hero('konj2_verg', 'A woman running onto a railway platform just as the train leaves, a pigeon sitting on her suitcase; on the platform her flatmate holds up the alarm clock she forgot to set, shrugging. Signs and clock faces have no numbers. Natural skin colours.'),
	hero('als_ob', 'An office: a young intern stands on a chair giving orders with a pointing finger and a paper crown, as if he were the boss, while the real boss, an older woman, quietly brings him a cup of coffee and raises an eyebrow. Papers are blank. Natural skin colours.'),
	hero('vermutung', 'A front door with an empty doorstep and a man in a dressing gown looking puzzled at it, while in the background a delivery van drives away and a dog runs off happily with the parcel in its mouth. No text on the parcel or the van.'),
	hero('sollen', 'Two neighbours whispering over a garden fence, pointing at a man walking past in a very ordinary jumper carrying a shopping bag; in a little thought bubble above them the same man wears a top hat and sits on a pile of gold coins. Natural skin colours.'),
	hero('partikeln', 'A friendly grandmother at a kitchen table pushing a huge cake towards a guest who is already full, holding his stomach; the cat on the chair has cream on its whiskers. Natural skin colours.'),
	hero('genitiv_praep', 'A post office counter with a closed shutter and a man outside looking at his wrist watch, while a snail with a tiny parcel on its shell waits patiently next to him. Signs are blank and the watch has no numbers.'),
	hero('nominalisierung', 'A noisy stairwell in an apartment building: on every landing a neighbour is talking, shouting or running about, and on the top floor a man with a book covers his ears; his goldfish in its bowl also covers its eyes with its fins. Natural skin colours.'),
	hero('nominalstil', 'Two pictures in one scene: on the left a football pitch in pouring rain with the players huddled under one umbrella; on the right the same pitch in sunshine with the ball being chased by a dog. Natural skin colours.'),
	hero('fvg', 'A serious meeting of a company board around a long table; everyone looks at a large chart on the wall, and the chairwoman has to make a decision between two doors at the back of the room, one with a ribbon, one with a cat sleeping in front of it. The chart and doors carry no text or numbers. Natural skin colours.'),
	hero('partizip_attribut', 'A city bridge being opened: a mayor cuts a ribbon with huge scissors, a small band plays, and a duck is the first to walk across the new bridge, very proud. Natural skin colours, no text.'),
	hero('passiversatz', 'A man trying to open a jam jar with all his strength, red in the face, while a small child next to him opens it easily with one twist; the dog waits for the jam. Labels are blank. Natural skin colours.'),
	hero('adjektivbildung', 'A sunny, cheerful garden party: a very friendly woman hands out lemonade, a patient man holds a ladder for a cat in a tree, and a child pulls a funny face behaving childishly. Natural skin colours.'),
	hero('konzessiv', 'A family walking stubbornly through pouring rain on a hiking path, all smiling under raincoats and hoods, and the dog wears tiny rain boots; above them one single black cloud follows only them while the rest of the sky is blue. Natural skin colours.'),
	hero('adversativ', 'A map-like picture of a country split in two: the north half under rain clouds with people holding umbrellas, the south half sunny and dry with a person sunbathing and a camel. No text or letters. Natural skin colours.'),
	hero('relativ', 'A cosy bedroom at night: a man sleeps peacefully in a dark, cool room with the curtains closed and his phone left in a drawer, while a cat in the corner is wide awake staring at a glowing tablet. Natural skin colours.'),
	hero('verweiswoerter', 'A young woman counting coins from a big piggy bank on a table, and behind her through the window the small old car she has just bought, with a bow on its roof and a squirrel sitting on the bonnet. Natural skin colours.'),
	hero('indefinit', 'A schoolroom where a teacher holds up one single pen and asks the class; every child holds up an empty hand except one tiny child at the back holding up a whole box of pens. Natural skin colours.'),
	hero('beschwerde', 'A woman sitting at a kitchen table writing a letter with a determined face; behind her a washing machine leaks water across the floor and a rubber duck floats past. The letter has only wavy lines. Natural skin colours.'),
];
// The study-book style without its hex colour codes: Gemini sometimes paints a
// code like "#c9683b" into the picture when the prompt names it.
const style =
	JSON.parse(readFileSync(new URL('assets/images/companion_manifest.json', root), 'utf8')).style.replace(/\s*\(#[0-9a-fA-F]{6}\)/g, '') +
	' Never write any colour codes, hex values, numbers, labels or signatures anywhere in the picture.';
writeFileSync(new URL('assets/images/companion_b2_2_manifest.json', root), JSON.stringify({ style, images }, null, '\t') + '\n');

const words = {
	solaranlage: 'a solar panel on a small metal stand on grass, no sun in the picture', windrad: 'a white wind turbine with three blades', heizkoerper: 'a white radiator with a thermostat knob',
	giesskanne: 'a watering can', rauchmelder: 'a round white smoke detector fixed to a piece of ceiling, seen at an angle from below, with a small red light', buegeleisen: 'a clothes iron', steckdosenleiste: 'a power strip with several sockets and a cable',
	einmachglas: 'a glass preserving jar with a lid and a rubber ring, filled with red jam', waschmaschine: 'a front-loading washing machine', plastiktuete: 'a plastic shopping bag',
	muelltonne: 'a wheelie bin with a lid', batterie: 'a cylindrical AA battery lying on its side, with the small raised button at one end, plain with no writing', eisbaer: 'a polar bear standing on an ice floe', biene: 'a honey bee, drawn large',
	baum: 'a leafy tree', mikroskop: 'a microscope', reagenzglas: 'a test tube with blue liquid', bunsenbrenner: 'a Bunsen burner with a small flame',
	trichter: 'a laboratory funnel', pinzette: 'a pair of tweezers', lupe: 'a magnifying glass', teleskop: 'a telescope on a tripod',
	fossil: 'a spiral ammonite fossil in stone', feuerloescher: 'a red fire extinguisher', schutzbrille: 'a pair of clear safety goggles',
	globus: 'a globe on a stand', waage: 'a pair of old balance scales',
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
console.log(images.length, 'B2.2 pictures;', dict.images.length, 'dictionary entries');
