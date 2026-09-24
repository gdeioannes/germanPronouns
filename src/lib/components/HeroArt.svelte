<script lang="ts">
	// The landing page's backdrop: a Bauhaus composition in the brand colours —
	// circle, half-disc, quarter-disc and bars — with a few German words set in
	// the display serif, as if pinned to a classroom wall. Pure inline SVG, so
	// it costs no request, scales to any screen and stays sharp.
</script>

<svg class="art" viewBox="0 0 640 560" aria-hidden="true" focusable="false">
	<!-- The card sits over the middle of this box, so every shape and word is
	     placed in the margins around it, where it stays visible. -->

	<!-- navy circle, top right, with a greeting on it -->
	<g class="float-a">
		<circle cx="520" cy="118" r="118" fill="#1f3a5f" />
		<text x="462" y="92" class="word" font-size="40" fill="#ffffff">Hallo!</text>
	</g>

	<!-- ochre bars, top left -->
	<g class="float-b">
		<rect x="70" y="42" width="130" height="16" rx="3" fill="#a9802a" />
		<rect x="70" y="70" width="88" height="16" rx="3" fill="#a9802a" opacity="0.7" />
		<rect x="70" y="98" width="110" height="16" rx="3" fill="#a9802a" opacity="0.45" />
	</g>
	<text x="232" y="104" class="word" font-size="24" fill="#1f3a5f" opacity="0.6">Tschüss</text>

	<!-- ring, left edge -->
	<circle class="float-c" cx="34" cy="286" r="30" fill="none" stroke="#c9683b" stroke-width="9" />

	<!-- terracotta half-disc, bottom left -->
	<g class="float-b">
		<path d="M 40 560 A 160 160 0 0 1 360 560 Z" fill="#c9683b" />
		<text x="118" y="530" class="word" font-size="28" fill="#ffffff">Guten Tag</text>
	</g>

	<text x="370" y="448" class="word" font-size="17" fill="#1f3a5f" opacity="0.55">der · die · das</text>

	<!-- forest quarter-disc, bottom right -->
	<g class="float-c">
		<path d="M 640 560 L 640 390 A 170 170 0 0 0 470 560 Z" fill="#3f5d45" />
		<text x="548" y="536" class="word" font-size="24" fill="#ffffff">Danke</text>
	</g>
</svg>

<style>
	.word {
		font-family: 'Source Serif 4 Variable', 'Source Serif 4', Georgia, serif;
		font-weight: 700;
	}

	.art {
		display: block;
		width: 100%;
		height: auto;
		overflow: visible;
	}

	/* A slow drift, so the page feels alive without anything demanding
	   attention. Disabled with reduced motion via the global rule. */
	.float-a,
	.float-b,
	.float-c {
		transform-box: fill-box;
		transform-origin: center;
		animation: drift 14s ease-in-out infinite alternate;
	}

	.float-b {
		animation-duration: 18s;
		animation-delay: -4s;
	}

	.float-c {
		animation-duration: 22s;
		animation-delay: -9s;
	}

	@keyframes drift {
		from {
			transform: translate(0, 0) rotate(0deg);
		}
		to {
			transform: translate(6px, -8px) rotate(2deg);
		}
	}
</style>
