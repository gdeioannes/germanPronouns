<script lang="ts">
	// The words on a photo (see overlays.ts): laid over the blank sign, paper or
	// screen the picture was drawn with, sized to fit its box. `ratio` is the
	// picture's height / width, once it has loaded.
	import { boxLine, DEFAULT_OVERLAY, OVERLAYS } from './overlays';

	let { image, lines, ratio = 1 }: { image: string; lines: string[]; ratio?: number } = $props();

	const spec = $derived(OVERLAYS[image] ?? DEFAULT_OVERLAY);
	/** Line groups per box: all lines in one box, or one line per box. */
	const groups = $derived(
		spec.boxes.length > 1 ? spec.boxes.map((_, i) => (lines[i] ? [boxLine(lines[i])] : [])) : [lines]
	);

	/**
	 * The largest font size (in cqw, percent of the photo's width) at which the
	 * lines fit the box, wrapping at word breaks; LED boards don't wrap. Labels
	 * and notes keep some padding inside the box.
	 */
	function size(box: number[], group: string[]): number {
		const [, , w, h] = box;
		const style = spec.style;
		const padded = style === 'label' || style === 'note';
		const width = w * (padded ? 0.84 : 0.96);
		const height = h * ratio * (padded ? 0.8 : 0.95); // the box's height, in percent of the width
		const mono = style === 'ink' || style === 'led' || style === 'flyer' || style === 'cctv';
		const glyph = style === 'led' ? 0.68 : mono ? 0.62 : 0.53;
		const top = style === 'led' ? 9 : 7;
		for (let fs = top; fs > 1.3; fs -= 0.1) {
			const perLine = Math.floor(width / (fs * glyph));
			let lines = 0;
			let fits = true;
			group.forEach((line, k) => {
				// The flyer's headline is set larger.
				const scale = style === 'flyer' && k === 0 ? 1.35 : 1;
				const cap = Math.floor(perLine / scale);
				const words = line.split(/\s+/);
				if (words.some((word) => word.length > cap)) fits = false;
				if (style === 'led' && line.length > cap) fits = false;
				// Greedy word wrap.
				let count = 1;
				let used = 0;
				for (const word of words) {
					if (used && used + 1 + word.length > cap) {
						count++;
						used = word.length;
					} else used += (used ? 1 : 0) + word.length;
				}
				lines += count * scale;
			});
			if (fits && lines * fs * 1.22 <= height) return fs;
		}
		return 1.3;
	}
</script>

{#each spec.boxes as box, i (i)}
	{#if groups[i]?.length}
		<span
			class="ov {spec.style}"
			aria-hidden="true"
			style:left="{box[0]}%"
			style:top="{box[1]}%"
			style:width="{box[2]}%"
			style:height="{box[3]}%"
			style:font-size="{size(box, groups[i])}cqw"
			style:transform={spec.tilt ? `rotate(${spec.tilt}deg)` : undefined}
		>
			{#each groups[i] as line, k (k)}<span class:first={k === 0 && groups[i].length > 2}>{line}</span>{/each}
		</span>
	{/if}
{/each}

<style>
	.ov {
		position: absolute;
		display: flex;
		flex-direction: column;
		justify-content: center;
		gap: 0.15em;
		line-height: 1.15;
		overflow: hidden;
		pointer-events: none;
		text-align: left;
	}
	.first {
		font-weight: 800;
		letter-spacing: 0.03em;
	}
	.flyer {
		align-items: center;
		text-align: center;
		gap: 0;
		color: #111;
		font-family: 'Courier New', ui-monospace, monospace;
		font-weight: 700;
	}
	.flyer .first {
		font-family: Impact, 'Arial Black', sans-serif;
		font-size: 1.35em;
		letter-spacing: 0.04em;
		margin-bottom: 0.2em;
	}
	.ink {
		color: #1f2a3a;
		font-family: 'Courier New', ui-monospace, monospace;
		font-weight: 700;
	}
	.chalk {
		align-items: center;
		text-align: center;
		color: #f5f2e8;
		font-family: 'Comic Sans MS', 'Segoe Print', cursive;
		text-shadow: 0 0 1px rgb(255 255 255 / 0.4);
	}
	.led {
		align-items: center;
		text-align: center;
		color: #ffcf4a;
		font-family: 'Courier New', ui-monospace, monospace;
		font-weight: 700;
		text-shadow: 0 0 0.3em rgb(255 190 40 / 0.7);
		white-space: pre;
	}
	.label {
		padding: 0.35em 0.5em;
		border-radius: 0.3em;
		background: rgb(255 253 246 / 0.94);
		border: 1px solid rgb(31 58 95 / 0.35);
		box-shadow: 0 0.15em 0.5em rgb(0 0 0 / 0.18);
		color: #1f2a3a;
		font-weight: 600;
		align-items: center;
		text-align: center;
	}
	.note {
		padding: 0.4em 0.5em;
		background: #fff3a6;
		box-shadow: 0 0.2em 0.5em rgb(0 0 0 / 0.2);
		color: #2a2a2a;
		font-family: 'Segoe Print', 'Comic Sans MS', cursive;
	}
	.cctv {
		color: #fff;
		font-family: 'Courier New', ui-monospace, monospace;
		font-weight: 700;
		text-shadow: 0 0 2px #000, 0 0 4px #000;
		justify-content: flex-start;
	}
</style>
