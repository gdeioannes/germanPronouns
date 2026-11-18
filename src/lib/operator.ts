/**
 * Who runs the site and publishes the books: the imprint on /legal and the
 * printed books' imprint read it from here. A German imprint needs a real
 * street address ("ladungsfähige Anschrift"); until it is filled in,
 * `hasAddress` is false and tool/kdp-package.mjs refuses to build the KDP files.
 */
export const OPERATOR = {
	name: 'Gabriel De Ioannes',
	street: '[Street and number]',
	city: '[Postcode and city]',
	country: 'Germany',
	email: 'gdeioannes@gmail.com'
};

export const hasAddress = !OPERATOR.street.startsWith('[') && !OPERATOR.city.startsWith('[');
