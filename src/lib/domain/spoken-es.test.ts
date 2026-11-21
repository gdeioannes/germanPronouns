// Spanish noun templates (spoken.ts spanishLine): article, gender pairs, contractions, plural.
import { describe, expect, it } from 'vitest';
import { spanishLine } from './spoken';

describe('spanishLine', () => {
	it('picks the article and the gender pair', () => {
		expect(spanishLine('Es {a} {subject}.', 'una mesa')).toBe('Es una mesa.');
		expect(spanishLine('No es {a} {subject}.', 'un hombre')).toBe('No es un hombre.');
		expect(spanishLine('{El/La} {subject} está aquí.', 'una mesa')).toBe('La mesa está aquí.');
		expect(spanishLine('Es {mi/mi} {subject} {nuevo/nueva}.', 'un coche')).toBe('Es mi coche nuevo.');
	});
	it('contracts a el and de el', () => {
		expect(spanishLine('Voy a {el/la} {subject}.', 'un parque')).toBe('Voy al parque.');
		expect(spanishLine('Es la puerta de {el/la} {subject}.', 'un piso')).toBe('Es la puerta del piso.');
		expect(spanishLine('Voy a {el/la} {subject}.', 'una tienda')).toBe('Voy a la tienda.');
	});
	it('makes the plural', () => {
		expect(spanishLine('Veo dos {pl}.', 'una manzana')).toBe('Veo dos manzanas.');
		expect(spanishLine('Veo dos {pl}.', 'una flor')).toBe('Veo dos flores.');
		expect(spanishLine('Veo dos {pl}.', 'un lápiz')).toBe('Veo dos lápices.');
		expect(spanishLine('Veo dos {pl}.', 'una canción')).toBe('Veo dos canciones.');
		expect(spanishLine('Veo dos {pl}.', 'un autobús')).toBe('Veo dos autobuses.');
		expect(spanishLine('Veo dos {pl}.', 'una mesa nueva|mesas nuevas')).toBe('Veo dos mesas nuevas.');
	});
	it('uses a word that is not a noun as it is', () => {
		expect(spanishLine('{subject}: ayer no fue posible venir.', 'yo')).toBe('yo: ayer no fue posible venir.');
	});
});
