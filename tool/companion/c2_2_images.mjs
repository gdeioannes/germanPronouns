// Writes the picture prompts for the C2.2 study companion: its topic pictures
// (assets/images/companion_c2_2_manifest.json) and its new picture-dictionary
// words (added to the shared companion_dictionary_manifest.json).
// Then: node tool/gen-images.mjs --manifest <file> --no-link
import { existsSync, readFileSync, writeFileSync } from 'node:fs';

const root = new URL('../../', import.meta.url);
const hero = (id, prompt) => ({ id: `cp_c2_2_${id}`, prompt, aspect: '4:3', size: 800, transparent: true, trim: true });

// The cover prints across the whole page, so it is built at 2048px from the original (upscaled).
const images = [
	{ ...hero('cover', 'A woman reading a thick open book in a deep armchair by a window at dusk; from the lines of the book small paper birds rise and fly out of the window, while her cat sits on the windowsill trying to catch one. The pages show only wavy lines, no text. Natural skin colours.'), size: 2048 },
	hero('philosophie', 'An old philosopher in a long coat on a park bench, weighing a heavy book in one hand and an ice cream cone in the other with a very serious face, while a pigeon at his feet eats the ice cream drips. Natural skin colours, no text.'),
	hero('fokus', 'A stage seen from the front with one bright spotlight falling on a small surprised man in a suit among a row of other people standing in the dark; a cat in the corner operates the spotlight. Natural skin colours, no text.'),
	hero('anspielung', 'A living room late in the evening: a hostess in a dressing gown stands by the open door holding the guests’ coats, pointedly looking at a wall clock without numbers, while the two guests on the sofa keep chatting happily and the dog has already fallen asleep. Natural skin colours.'),
	hero('paraphrase', 'A tailor fitting the same plain grey sentence-shaped ribbon onto three mannequins, each one dressed more elegantly than the last, from a T-shirt to a dinner suit, while a mouse holds the pins. No letters on the ribbon. Natural skin colours.'),
	hero('wortspiel', 'A cook in a white hat standing in a courtroom in front of a judge, holding up a steaming bowl of soup as evidence, while the jury members lean forward to sniff it. No text. Natural skin colours.'),
	hero('redewendungen', 'A long wooden bench in an old office corridor piled high with dusty files and folders, with a clerk pushing yet another file onto it with a broom, and a cat asleep on top of the pile. Papers have only lines. Natural skin colours.'),
	hero('fremdwoerter', 'A scholar in a library in front of a Roman marble bust, both wearing the same round glasses; the scholar is taking notes, and the bust seems to raise one marble eyebrow. Natural skin colours, no text.'),
	hero('wissenschaft', 'A researcher in a white coat at a blackboard full of simple drawn graphs without numbers, carefully pointing with a long stick while a lab rat on the desk takes notes on a tiny notepad. Natural skin colours, no text, no numbers.'),
	hero('praepositionen', 'A notary at a big desk pressing an enormous rubber stamp onto a contract, while a nervous client and his parrot watch; the parrot holds a tiny pen. Papers have only lines. Natural skin colours.'),
	hero('nominalstil', 'A man packing a whole sofa, a lamp and a bicycle into one small suitcase, sitting on the lid to close it, while his wife watches with folded arms. Natural skin colours, no text.'),
	hero('behoerde', 'A small red car parked in front of a fire station door; a fire engine waits behind it with its crew standing around with their arms folded, and a traffic warden writes a ticket while a dalmatian sniffs the car tyre. No text, no numbers on the plates. Natural skin colours.'),
	hero('appositionen', 'An award ceremony on a stage: a woman receives a trophy and a bunch of flowers, and next to her stands a man holding a large blank name sign pointing at her, while a dog in a bow tie applauds with its paws. No text. Natural skin colours.'),
	hero('modalverben', 'Two neighbours whispering across a garden fence and pointing at a third house, where a man in a dressing gown waters his flowers in the rain with a watering can. Natural skin colours, no text.'),
	hero('passiv', 'A museum entrance with a big closed door and a sign without text; workers on a scaffold renovate the façade, and a visitor with a guidebook sits on the steps waiting, while a pigeon sits on his hat. Natural skin colours.'),
	hero('adverbial', 'An open-air concert in the rain: a string quartet keeps playing under umbrellas held by their audience, and a duck in a raincoat sits in the front row. Natural skin colours, no text.'),
	hero('streit', 'A television debate: two politicians at separate lecterns talk at the same time with raised hands, a calm moderator between them holds up a sand timer, and a cameraman in the foreground tries not to laugh. No text. Natural skin colours.'),
	hero('eroerterung', 'A woman at a desk arguing with herself: she sits on the left side of the desk and also stands on the right side in the same clothes, both pointing at an open notebook with only lines, while her cat watches the two of them. Natural skin colours.'),
	hero('dach', 'A market stall in the Alps with apricots, potatoes and tomatoes, a stallholder in a traditional hat weighing apricots, and a cyclist with a bicycle buying a basket of apricots; a mountain goat tries to steal a tomato. No text, no price signs. Natural skin colours.'),
	hero('rezension', 'An old man standing on a small ladder in a bedroom lifting down a brown leather suitcase from the top of a wardrobe, while his wife watches from the bed holding a teacup. No text, no writing on the luggage tag. Natural skin colours.'),
	hero('lyrik', 'Two tiny ants with tiny backpacks and a map sitting exhausted on a cobbled country road, rubbing their legs, a signpost without text pointing far away, and a snail passing them confidently. No text.'),
];
// The study-book style without its hex colour codes: Gemini sometimes paints a
// code like "#c9683b" into the picture when the prompt names it.
const style =
	JSON.parse(readFileSync(new URL('assets/images/companion_manifest.json', root), 'utf8')).style.replace(/\s*\(#[0-9a-fA-F]{6}\)/g, '') +
	' Never write any colour codes, hex values, numbers, labels or signatures anywhere in the picture.';
writeFileSync(new URL('assets/images/companion_c2_2_manifest.json', root), JSON.stringify({ style, images }, null, '\t') + '\n');

const words = {
	sekretaer: 'an antique wooden writing bureau with a fold-down desk and small drawers', paravent: 'a folding screen with three painted panels',
	standuhr: 'a tall wooden grandfather clock with a pendulum, no numbers on the face', ritterruestung: 'a suit of armour standing upright',
	ohrensessel: 'a green wingback armchair', schaukelpferd: 'a wooden rocking horse', spinnrad: 'an old wooden spinning wheel',
	grammophon: 'a gramophone with a big brass horn', naehmaschine: 'an old black sewing machine with a hand wheel', fernrohr: 'a brass telescope on a wooden tripod',
	harfe: 'a golden harp', faecher: 'an open hand fan', truhe: 'a wooden chest with iron bands', schachbrett: 'a chessboard with a few chess pieces',
	butterfass: 'a wooden butter churn with a plunger', moerser: 'a stone mortar with a pestle', akkordeon: 'an accordion',
	vogelkaefig: 'an empty round brass birdcage', hufeisen: 'an iron horseshoe', kaffeemuehle: 'an old wooden coffee grinder with a crank handle',
	petroleumlampe: 'an old oil lamp with a glass chimney', leuchtturm: 'a red and white lighthouse', kutter: 'a small fishing boat',
	anker: 'a ship’s anchor', rettungsring: 'a red and white life ring', poller: 'a black iron bollard on a quay with a rope around it',
	seilwinde: 'a hand winch with a rope', schiffsglocke: 'a plain brass ship’s bell hanging from a bracket, plain metal with no face, no eyes, no mouth', steuerrad: 'a wooden ship’s wheel',
	hummerkorb: 'a lobster pot made of netting and wood', boje: 'a red buoy floating', fass: 'a wooden barrel',
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
console.log(images.length, 'C2.2 pictures;', dict.images.length, 'dictionary entries');
