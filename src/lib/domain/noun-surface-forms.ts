// Inflected German noun forms mapped back to the dictionary entry they belong
// to. Ported verbatim from lib/data/noun_lookup.dart.
//
// A sentence says "Nachbarn", "Kinder", "Hauses"; the shared collection is keyed
// by "Nachbar", "Kind", "Haus". Only forms that differ from the dictionary form
// need an entry here — everything else is found directly.

export const NOUN_SURFACE_FORMS: Record<string, string> = {
	// Genitive singular (-s/-es)
	Arztes: 'Arzt',
	Lehrers: 'Lehrer',
	Bruders: 'Bruder',
	Freundes: 'Freund',
	Hundes: 'Hund',
	Mannes: 'Mann',
	Chefs: 'Chef',
	Vaters: 'Vater',
	Kindes: 'Kind',
	Tieres: 'Tier',
	Babys: 'Baby',
	Autos: 'Auto',
	Hauses: 'Haus',
	Haustiers: 'Haustier',
	// Plurals
	Kinder: 'Kind',
	Freunde: 'Freund',
	Bücher: 'Buch',
	Töchter: 'Tochter',
	Nachbarn: 'Nachbar',
	Kollegen: 'Kollege',
	// Plurals & inflected forms from the Pronouns & Articles quiz sentences
	Tauben: 'Taube',
	Pinguine: 'Pinguin',
	Pinguinen: 'Pinguin',
	Zwillinge: 'Zwilling',
	Touristen: 'Tourist',
	Mitarbeitern: 'Mitarbeiter',
	Spielern: 'Spieler',
	Tablets: 'Tablet',
	Brieffreunde: 'Brieffreund',
	Brieffreunden: 'Brieffreund',
	Witze: 'Witz',
	Profis: 'Profi',
	Katzen: 'Katze',
	Keksen: 'Keks',
	Regeln: 'Regel',
	Hausaufgaben: 'Hausaufgabe',
	Ohren: 'Ohr',
	Stunden: 'Stunde',
	Pausen: 'Pause',
	Namen: 'Name',
	Gästen: 'Gast',
	Schülern: 'Schüler',
};
