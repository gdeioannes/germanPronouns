// Where a photo's overlay text sits. The image model cannot draw text, so a
// photo that must say something (a flyer, a bill, a departures board) is drawn
// with a blank surface and the words are laid over it here. Boxes are
// [left, top, width, height] in percent of the picture, measured on the
// generated images; one box holds all lines, or several boxes hold one line
// each (three receipts, three forms). A photo without an entry gets a label
// card across its lower part.

export type OverlayStyle = 'flyer' | 'ink' | 'chalk' | 'led' | 'label' | 'note' | 'cctv';
export type Box = [number, number, number, number];

export interface OverlaySpec {
	boxes: Box[];
	style: OverlayStyle;
	/** Rotate the text a little, like paper pinned by hand. */
	tilt?: number;
}

export const OVERLAYS: Record<string, OverlaySpec> = {
	match_flyer: { boxes: [[26, 22, 49, 24]], style: 'flyer', tilt: -1.5 },
	match_brandt_receipts: { boxes: [[12, 45, 17, 32], [42, 45, 17, 32], [71, 45, 17, 32]], style: 'ink' },
	match_briefkasten_letter: { boxes: [[33, 30, 36, 34]], style: 'ink', tilt: -1 },
	match_brueckner_forms: { boxes: [[14, 55, 20, 12], [40, 55, 20, 12], [66, 55, 20, 12]], style: 'label' },
	match_deniz_prices: { boxes: [[10, 20, 80, 42]], style: 'chalk' },
	match_eichhoernchen_sign: { boxes: [[20, 16, 32, 20]], style: 'ink' },
	match_eigentuemer_rules: { boxes: [[27, 12, 26, 30]], style: 'ink' },
	match_fridolin_ad: { boxes: [[17, 12, 52, 52]], style: 'ink', tilt: -1 },
	match_graf_rules: { boxes: [[32, 20, 32, 34]], style: 'ink' },
	match_grog_museum: { boxes: [[28, 34, 44, 30]], style: 'label' },
	match_hotline_letter: { boxes: [[20, 60, 62, 30]], style: 'ink' },
	match_kevin_board: { boxes: [[8, 28, 84, 46]], style: 'led' },
	match_kevin_clock: { boxes: [[17, 16, 56, 24]], style: 'led' },
	match_ki_log: { boxes: [[8, 64, 84, 30]], style: 'label' },
	match_klara_kamera: { boxes: [[6, 6, 60, 14]], style: 'cctv' },
	match_koehler_door: { boxes: [[40, 20, 38, 34]], style: 'label' },
	match_kuckuck_note: { boxes: [[33, 52, 40, 32]], style: 'note', tilt: 2 },
	match_lena_pricelist: { boxes: [[24, 56, 56, 26]], style: 'label' },
	match_lukas_bottles: { boxes: [[10, 84, 24, 10], [40, 84, 24, 10], [71, 84, 24, 10]], style: 'label' },
	match_moni_scale: { boxes: [[42, 65, 15, 8]], style: 'led' },
	match_mueller_calendar: { boxes: [[36, 19, 28, 26]], style: 'ink' },
	match_nebel_forecast: { boxes: [[8, 62, 84, 30]], style: 'ink' },
	match_nebenkosten_blatt: { boxes: [[17, 34, 52, 44]], style: 'ink' },
	match_praxis_kalender: { boxes: [[10, 74, 80, 22]], style: 'label' },
	match_wagner_ticket: { boxes: [[10, 64, 80, 32]], style: 'label' },
	match_wagner_board: { boxes: [[19, 38, 62, 34]], style: 'led' },
	match_weihnachtsmann_board: { boxes: [[11, 59, 23, 16], [41, 59, 23, 16], [68, 59, 23, 16]], style: 'label' },
	match_wg_rules: { boxes: [[31, 18, 38, 36]], style: 'ink' }
};

export const DEFAULT_OVERLAY: OverlaySpec = { boxes: [[8, 60, 84, 32]], style: 'label' };

/** "Links: Bürostuhl – 189 €" in the left receipt's own box needs no "Links:". */
export function boxLine(line: string): string {
	return line.replace(/^(Links|Mitte|Rechts|Gelb|Blau|Rot|Grün):\s*/, '');
}
