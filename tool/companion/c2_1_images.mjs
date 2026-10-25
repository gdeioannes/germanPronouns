// Writes the picture prompts for the C2.1 study companion: its topic pictures
// (assets/images/companion_c2_1_manifest.json) and its new picture-dictionary
// words (added to the shared companion_dictionary_manifest.json).
// Then: node tool/gen-images.mjs --manifest <file> --no-link
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const hero = (id, prompt) => ({ id: `cp_c2_1_${id}`, prompt, aspect: '4:3', size: 800, transparent: true, trim: true });

// The cover prints across the whole page, so it is built at 2048px from the original (upscaled).
const images = [
	{ ...hero('cover', 'An elegant writer at an old wooden desk choosing between three fountain pens of different sizes laid out like tools, a pile of crumpled drafts at her feet, and a cat sitting on the dictionary with a monocle-like reflection on its eye. Papers have only wavy lines, no text. Natural skin colours.'), size: 2048 },
	hero('wirtschaft', 'A courtroom scene seen from the front: a judge with a gavel, two lawyers in robes shaking hands to settle, and a nervous businessman holding a falling bar chart made of cardboard; a pigeon sits on the judge’s bench. No text. Natural skin colours.'),
	hero('register', 'The same man shown three times side by side: in a hoodie lounging with a soft drink, in a smart shirt at a desk, and in a dinner suit giving a formal toast; his dog follows him dressed to match each outfit. Natural skin colours.'),
	hero('kollokationen', 'A football team in muddy shirts walking off the pitch after a bitter defeat, heads down, while the referee offers them an umbrella and a duck in the stands holds a tiny flag. Natural skin colours, no text.'),
	hero('konnotation', 'An old man holding one coin very carefully, seen twice: on the left with a warm golden glow and smiling friends, on the right in a cold blue light with a frowning neighbour. Natural skin colours.'),
	hero('abtoenung', 'A food critic at a restaurant table holding a fork up and judging a dish with a very precise, raised-eyebrow expression, while the chef peeks nervously from the kitchen door and a mouse waits for the leftovers. Natural skin colours.'),
	hero('sprichwoerter', 'A man in a small glass house about to throw a stone, then hesitating, while next door a sly fox has fallen into a pit it dug itself. Natural skin colours, no text.'),
	hero('komparation', 'Three city skylines side by side in a row, from small to very big, with a tiny tourist on a ladder measuring the tallest tower with a tape measure. No text, no numbers.'),
	hero('valenz', 'A town square memorial ceremony: people stand quietly with flowers before a simple stone, a mayor bows his head, and a small child holds her grandfather’s hand. Natural skin colours, no text.'),
	hero('komposita', 'A long train made of many carriages, each carriage a different object linked together (a book, a shop, a station, a clock), with the last carriage being a big locomotive at the front on the right. No text.'),
	hero('adjektive', 'A carpenter proudly presenting a masterly, finely carved wooden chair to a client, who checks it with a magnifying glass, while a squirrel tests the chair by sitting on it. Natural skin colours.'),
	hero('praefixe', 'A man at a kitchen table doing his tax return, surrounded by papers and a calculator, clearly realising he has made a big mistake, with his cat walking across the calculator keys. Papers have only lines. Natural skin colours.'),
	hero('konj2', 'A man on a mountain path who almost slipped, catching himself on a branch at the edge with one foot in the air, while a mountain goat watches calmly from a rock. Natural skin colours.'),
	hero('konnektoren', 'A businessman at a long table hesitating with a fountain pen above a contract, a stern lawyer on one side and a hopeful partner on the other, and a clock on the wall without numbers. Natural skin colours, no text.'),
	hero('umformung', 'A potter at a wheel reshaping a vase into a bowl, the same clay in a new shape, while a cat on the shelf watches a row of previous pots of different shapes. Natural skin colours.'),
	hero('konj1', 'A newspaper editor at a desk holding a telephone and taking careful notes, with a second reporter leaning in to listen, and a stack of newspapers with only lines on them. Natural skin colours, no text.'),
	hero('stilmittel', 'A city at dawn seen from a bridge: houses with closed shutters like sleeping eyes, a single lit window like a small island in the dark, traffic lights changing for nobody, and a pigeon on the railing. No text.'),
	hero('rede', 'A speaker at a lectern on a town square giving a passionate speech with one raised hand, a crowd listening, and a child on her father’s shoulders holding a balloon. No text on banners. Natural skin colours.'),
	hero('moderieren', 'A television panel discussion: a calm moderator in the middle raising one hand to stop a man and a woman who are both talking at once, with a cameraman in the foreground. No text. Natural skin colours.'),
	hero('satire', 'A town hall office with a huge modern touch screen on the wall, while the clerk below it uses a fax machine, a typewriter and a rubber stamp; a pigeon delivers a letter through the window. Screen blank, no text. Natural skin colours.'),
	hero('kurzgeschichte', 'A quiet kitchen in the morning: an old man sits at a table with one white cup, and opposite him an empty chair by the window with a blue cup on the windowsill; through the window a neighbour rolls a bin across the yard. Natural skin colours.'),
];
// The study-book style without its hex colour codes: Gemini sometimes paints a
// code like "#c9683b" into the picture when the prompt names it.
const style =
	JSON.parse(readFileSync(new URL('assets/images/companion_manifest.json', root), 'utf8')).style.replace(/\s*\(#[0-9a-fA-F]{6}\)/g, '') +
	' Never write any colour codes, hex values, numbers, labels or signatures anywhere in the picture.';
writeFileSync(new URL('assets/images/companion_c2_1_manifest.json', root), JSON.stringify({ style, images }, null, '\t') + '\n');

const words = {
	hobel: 'a wooden hand plane', schraubzwinge: 'a metal screw clamp', zollstock: 'a yellow folding carpenter’s rule, partly unfolded, without numbers',
	hobelbank: 'a wooden carpenter’s workbench with a vice', stemmeisen: 'a wood chisel', akkuschrauber: 'a cordless drill', saegebock: 'a wooden sawhorse',
	oelkaennchen: 'a small oil can with a long spout', saege: 'a hand saw', sense: 'a scythe', egge: 'a farm harrow with iron spikes',
	melkschemel: 'a three-legged milking stool', scheunentor: 'a big red barn door', wagenrad: 'a wooden cart wheel', wetterhahn: 'a weathercock on a pole, a metal rooster only, with no compass letters and no arrows',
	ferkel: 'a pink piglet', kalb: 'a calf', ziege: 'a goat', gans: 'a white goose', pumpe: 'an old green hand water pump', mistgabel: 'a pitchfork',
	taubenschlag: 'a wooden dovecote on a pole', strohballen: 'a round straw bale', tasse: 'a blue coffee cup', zuckerdose: 'a sugar bowl with a lid',
	fernglas: 'a pair of binoculars', faxgeraet: 'an old fax machine with a sheet of paper, no writing',
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
console.log(images.length, 'C2.1 pictures;', dict.images.length, 'dictionary entries');
