// What the deck's intro card shows while the cards are dealt: one odd German
// word or one small cultural fact, picked at random on each load. The card
// shows only while the deck is not ready (a full page load, not the way back
// from a quiz) and stays up to five seconds unless swiped; a tap keeps it.
// Each entry should still read at a glance: a word and a short gloss, or one
// short sentence.

import { t, tk } from '$lib/i18n/t';

export type LoadingTip = { kind: 'word'; de: string; en: string } | { kind: 'tip'; en: string };

export const LOADING_TIPS: LoadingTip[] = [
	{ kind: 'word', de: 'Kummerspeck', en: tk('“Grief bacon”: the weight you gain eating your feelings.') },
	{ kind: 'word', de: 'Treppenwitz', en: tk('“Staircase joke”: the perfect reply you think of too late.') },
	{ kind: 'word', de: 'Drachenfutter', en: tk('“Dragon food”: the gift that calms an angry partner.') },
	{ kind: 'word', de: 'Schnapsidee', en: tk('“Schnapps idea”: a plan that only made sense after a drink.') },
	{ kind: 'word', de: 'Fremdschämen', en: tk('Being embarrassed for someone else.') },
	{ kind: 'word', de: 'Torschlusspanik', en: tk('“Gate-closing panic”: the fear that time is running out.') },
	{ kind: 'word', de: 'Backpfeifengesicht', en: tk('A face that is simply asking for a slap.') },
	{ kind: 'word', de: 'Ohrwurm', en: tk('“Ear worm”: a tune you cannot get out of your head.') },
	{ kind: 'word', de: 'Sitzfleisch', en: tk('“Sitting meat”: the patience to sit through something long.') },
	{ kind: 'word', de: 'Erklärbär', en: tk('“Explaining bear”: someone who explains everything, unasked.') },
	{ kind: 'word', de: 'Warmduscher', en: tk('“Warm showerer”: a softie.') },
	{ kind: 'word', de: 'der innere Schweinehund', en: tk('“The inner pig-dog”: the lazy voice that says skip today.') },
	{ kind: 'word', de: 'verschlimmbessern', en: tk('To make something worse by trying to improve it.') },
	{ kind: 'word', de: 'Handschuh', en: tk('“Hand shoe”: a glove.') },
	{ kind: 'word', de: 'Schildkröte', en: tk('“Shield toad”: a tortoise.') },
	{ kind: 'word', de: 'Stinktier', en: tk('“Stink animal”: a skunk.') },
	{ kind: 'word', de: 'Feierabend', en: tk('The moment work ends, said like a small celebration.') },
	{ kind: 'word', de: 'Fingerspitzengefühl', en: tk('“Fingertip feeling”: tact, a delicate touch.') },
	{ kind: 'word', de: 'Kopfkino', en: tk('“Head cinema”: the film your imagination plays.') },
	{ kind: 'word', de: 'Luftschloss', en: tk('“Air castle”: a daydream that will never be built.') },
	{ kind: 'word', de: 'Zungenbrecher', en: tk('“Tongue breaker”: Fischers Fritz fischt frische Fische.') },
	{ kind: 'tip', en: tk('Toast with eye contact. Look away and, they say, it is seven years of bad luck.') },
	{ kind: 'tip', en: tk('Never wish a German happy birthday early. It brings bad luck; wait for the day.') },
	{ kind: 'tip', en: tk('After a lecture, students knock on their desks instead of clapping.') },
	{ kind: 'tip', en: tk('“Mahlzeit!” is how colleagues greet each other in the corridor around lunchtime.') },
	{ kind: 'tip', en: tk('Sunday is a day of rest: most shops are shut, and mowing the lawn annoys the neighbours.') },
	{ kind: 'tip', en: tk('Bottles carry a deposit, Pfand. People leave empties beside bins for collectors.') },
	{ kind: 'tip', en: tk('Wait for the older person to offer “du”. Until then, it is “Sie”.') },
	{ kind: 'tip', en: tk('In Bavaria, Weißwurst is eaten before noon. Never after the church bells ring twelve.') },
	{ kind: 'tip', en: tk('Apfelschorle, apple juice with sparkling water, is the unofficial national drink.') },
	{ kind: 'tip', en: tk('Germans say “Daumen drücken”, press your thumbs, where English crosses fingers.') },

	// -- more words --------------------------------------------------------------
	{ kind: 'word', de: 'Kuddelmuddel', en: tk('A muddle, a hopeless mess.') },
	{ kind: 'word', de: 'Schadenfreude', en: tk('Joy at someone else’s bad luck.') },
	{ kind: 'word', de: 'Fernweh', en: tk('“Far-ache”: longing for places you have never been.') },
	{ kind: 'word', de: 'Zugzwang', en: tk('Having to move when every move makes things worse.') },
	{ kind: 'word', de: 'Weltschmerz', en: tk('“World pain”: sadness about the state of the world.') },
	{ kind: 'word', de: 'Handy', en: tk('A mobile phone. It sounds English; no English speaker says it.') },
	{ kind: 'word', de: 'Beamer', en: tk('A projector. In English, a BMW.') },
	{ kind: 'word', de: 'Gemütlichkeit', en: tk('Warm, cosy, unhurried comfort.') },
	{ kind: 'word', de: 'Lieblingsmensch', en: tk('“Favourite human”: the person you love most.') },
	{ kind: 'word', de: 'Brückentag', en: tk('“Bridge day”: the day off between a holiday and the weekend.') },
	{ kind: 'word', de: 'Schattenparker', en: tk('“Shadow parker”: someone who parks in the shade. A wimp.') },
	{ kind: 'word', de: 'Glühbirne', en: tk('“Glow pear”: a light bulb.') },
	{ kind: 'word', de: 'Faultier', en: tk('“Lazy animal”: a sloth.') },
	{ kind: 'word', de: 'Nacktschnecke', en: tk('“Naked snail”: a slug.') },
	{ kind: 'word', de: 'Staubsauger', en: tk('“Dust sucker”: a vacuum cleaner.') },
	{ kind: 'word', de: 'Flugzeug', en: tk('“Flying thing”: an aeroplane.') },
	{ kind: 'word', de: 'Kühlschrank', en: tk('“Cool cupboard”: a fridge.') },
	{ kind: 'word', de: 'Zahnfleisch', en: tk('“Tooth meat”: your gums.') },
	{ kind: 'word', de: 'Mundgeruch', en: tk('“Mouth smell”: bad breath.') },
	{ kind: 'word', de: 'Hüftgold', en: tk('“Hip gold”: a few extra kilos round the hips.') },
	{ kind: 'word', de: 'Geisterfahrer', en: tk('“Ghost driver”: someone driving the wrong way on the motorway.') },
	{ kind: 'word', de: 'Pantoffelheld', en: tk('“Slipper hero”: a man who is not the boss at home.') },
	{ kind: 'word', de: 'Dreikäsehoch', en: tk('“Three cheeses high”: a little kid.') },
	{ kind: 'word', de: 'Kabelsalat', en: tk('“Cable salad”: a tangle of wires.') },
	{ kind: 'word', de: 'Zappelphilipp', en: tk('“Fidget Philip”: a child who cannot sit still.') },
	{ kind: 'word', de: 'lebensmüde', en: tk('“Tired of life”: what you call someone doing something reckless.') },
	{ kind: 'word', de: 'Ohrenschmaus', en: tk('“Ear feast”: music that is a joy to hear.') },
	{ kind: 'word', de: 'Augenweide', en: tk('“Eye pasture”: a sight for sore eyes.') },
	{ kind: 'word', de: 'Hals- und Beinbruch!', en: tk('“Break your neck and your leg!”: good luck!') },
	{ kind: 'word', de: 'Tomaten auf den Augen haben', en: tk('“To have tomatoes on your eyes”: to miss the obvious.') },
	{ kind: 'word', de: 'Ich verstehe nur Bahnhof', en: tk('“I only understand train station”: it is all Greek to me.') },
	{ kind: 'word', de: 'Das ist nicht mein Bier', en: tk('“That is not my beer”: not my problem.') },
	{ kind: 'word', de: 'Da steppt der Bär', en: tk('“The bear is tap-dancing there”: it is a great party.') },
	{ kind: 'word', de: 'Jetzt geht’s um die Wurst', en: tk('“Now it’s about the sausage”: the moment that counts.') },
	{ kind: 'word', de: 'Ich glaub, mein Schwein pfeift', en: tk('“I think my pig is whistling”: I cannot believe it!') },
	{ kind: 'word', de: 'Schwein haben', en: tk('“To have pig”: to be lucky.') },
	{ kind: 'word', de: 'Kater', en: tk('“Tomcat”: also a hangover.') },
	{ kind: 'word', de: 'Morgenmuffel', en: tk('“Morning grump”: someone who is not a person before coffee.') },
	{ kind: 'word', de: 'Naschkatze', en: tk('“Nibble cat”: someone with a sweet tooth.') },
	{ kind: 'word', de: 'Eselsbrücke', en: tk('“Donkey bridge”: a memory trick.') },
	{ kind: 'word', de: 'Ohrfeige', en: tk('“Ear fig”: a slap in the face.') },
	{ kind: 'word', de: 'Wolkenkratzer', en: tk('“Cloud scratcher”: a skyscraper.') },
	{ kind: 'word', de: 'Gänsefüßchen', en: tk('“Little goose feet”: quotation marks.') },
	{ kind: 'word', de: 'Lampenfieber', en: tk('“Lamp fever”: stage fright.') },
	{ kind: 'word', de: 'Rabeneltern', en: tk('“Raven parents”: parents who neglect their children.') },
	{ kind: 'word', de: 'sturmfrei', en: tk('“Storm-free”: having the home to yourself while your parents are away.') },

	// -- more facts --------------------------------------------------------------
	{ kind: 'tip', en: tk('Germany has more than 1,500 kinds of sausage.') },
	{ kind: 'tip', en: tk('There are over 3,000 kinds of bread in Germany, and the bread culture is UNESCO heritage.') },
	{ kind: 'tip', en: tk('Every German noun starts with a capital letter, not only names.') },
	{ kind: 'tip', en: tk('“Gift” means poison in German. Be careful what you give.') },
	{ kind: 'tip', en: tk('In German, “Rock” is a skirt and “Mist” is manure.') },
	{ kind: 'tip', en: tk('Germans write 3,5 kg for three and a half kilos: a comma, not a point.') },
	{ kind: 'tip', en: tk('The German alphabet has four extra letters: ä, ö, ü and ß.') },
	{ kind: 'tip', en: tk('ß had no capital letter until 2017, when ẞ became official.') },
	{ kind: 'tip', en: tk('On their first school day, German children get a Schultüte: a big paper cone full of sweets.') },
	{ kind: 'tip', en: tk('Stoßlüften: Germans open the windows wide for a few minutes, several times a day, even in winter.') },
	{ kind: 'tip', en: tk('German has three words for “you”: du, ihr and Sie.') },
	{ kind: 'tip', en: tk('In many flats, quiet time starts at 10 pm: Nachtruhe. No drilling, no loud music.') },
	{ kind: 'tip', en: tk('Rubbish is sorted: paper, packaging in the yellow bin, food waste, glass by colour, and the rest.') },
	{ kind: 'tip', en: tk('Cash is still king: some cafés and shops take only cash.') },
	{ kind: 'tip', en: tk('Parts of the Autobahn have no speed limit; 130 km/h is only recommended.') },
	{ kind: 'tip', en: tk('Before eating: “Guten Appetit!” Before drinking: “Prost!”, with eye contact.') },
	{ kind: 'tip', en: tk('Order water in a restaurant and it usually comes sparkling. Ask for “still” if you want it flat.') },
	{ kind: 'tip', en: tk('Germans wait at a red light even on an empty road, especially if children are watching.') },
	{ kind: 'tip', en: tk('Kaffee und Kuchen: coffee and cake around three in the afternoon, above all on Sundays.') },
	{ kind: 'tip', en: tk('Christmas markets began in German towns in the Middle Ages; Dresden’s dates from 1434.') },
	{ kind: 'tip', en: tk('Carnival season starts on the 11th of November at 11:11.') },
	{ kind: 'tip', en: tk('In German the moon is masculine and the sun is feminine: der Mond, die Sonne.') },
	{ kind: 'tip', en: tk('A girl is neuter: das Mädchen. Every noun ending in -chen is “das”.') },
	{ kind: 'tip', en: tk('Germans count from the thumb. Hold up your thumb to order one beer.') },
	{ kind: 'tip', en: tk('Many Germans answer the phone with just their surname: “Müller?”') },
	{ kind: 'tip', en: tk('On your birthday you bring the cake to work yourself.') },
	{ kind: 'tip', en: tk('“Na?” can be a whole conversation. “Na?” How are you? “Na.” Fine.') },
	{ kind: 'tip', en: tk('Most foreign films are dubbed, and big stars keep the same German voice for decades.') }
];

const esc = (s: string) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

/**
 * One tip as the intro card's HTML. A word's gloss that opens with a literal
 * translation in quotes (“Grief bacon”: …) is split, so the literal reading
 * and the real meaning can be set apart. A faint watermark sits behind: the
 * word's first letter, or a German opening quote for a cultural fact.
 */
export function tipHtml(tip: LoadingTip): string {
	if (tip.kind === 'tip') {
		return (
			`<span class="tip-mark" aria-hidden="true">ß</span>` +
			`<span class="tip-kind">Gut zu wissen · ${esc(t('good to know'))}</span>` +
			`<span class="tip-fact">${esc(t(tip.en))}</span>`
		);
	}
	const en = t(tip.en);
	const literal = /^“(.+?)”:\s*(.+)$/.exec(en);
	const word = tip.de.replace(/^(der|die|das) /, '');
	// The longest of these words (Fingerspitzengefühl) must still fit one line
	// on a phone: the size steps down with the length, never breaking the word.
	const longest = Math.max(...tip.de.split(' ').map((w) => w.length));
	// A saying wraps over lines anyway, so it gets a smaller size of its own.
	const size = tip.de.includes(' ') ? ' phrase' : longest >= 17 ? ' xlong' : longest >= 13 ? ' long' : '';
	const meaning = literal ? literal[2].charAt(0).toUpperCase() + literal[2].slice(1) : en;
	return (
		`<span class="tip-mark" aria-hidden="true">${esc(word.charAt(0).toUpperCase())}</span>` +
		`<span class="tip-kind">Ein Wort · ${esc(t('a word'))}</span>` +
		`<strong class="tip-de${size}" lang="de">${esc(tip.de)}</strong>` +
		(literal ? `<em class="tip-literal">${esc(literal[1])}</em>` : '') +
		`<span class="tip-en">${esc(meaning)}</span>`
	);
}
