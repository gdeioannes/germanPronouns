// The voice chain's fallback, and when it tells the learner the connection is
// why they are hearing the device voice.
import { afterEach, describe, expect, it, vi } from 'vitest';
import { ChainedTtsProvider, onConnectionFallback, type TtsProvider } from './speech';

function fake(name: string, speaks: boolean): TtsProvider & { calls: number } {
	return {
		name,
		calls: 0,
		async isAvailable() {
			return true;
		},
		async speak() {
			this.calls++;
			return speaks;
		},
		async stop() {}
	};
}

const OPTIONS = { locale: 'de-DE' };

describe('ChainedTtsProvider', () => {
	afterEach(() => vi.unstubAllGlobals());

	it('plays the recording when there is one, without a notice', async () => {
		const [recorded, cloud, device] = [fake('r', true), fake('c', true), fake('d', true)];
		const notice = vi.fn();
		const off = onConnectionFallback(notice);
		await new ChainedTtsProvider(recorded, cloud, device).speak('Hallo!', OPTIONS);
		off();
		expect([recorded.calls, cloud.calls, device.calls]).toEqual([1, 0, 0]);
		expect(notice).not.toHaveBeenCalled();
	});

	it('uses the cloud voice for an unrecorded text, without a notice', async () => {
		const [recorded, cloud, device] = [fake('r', false), fake('c', true), fake('d', true)];
		const notice = vi.fn();
		const off = onConnectionFallback(notice);
		await new ChainedTtsProvider(recorded, cloud, device).speak('Hallo!', OPTIONS);
		off();
		expect([cloud.calls, device.calls]).toEqual([1, 0]);
		expect(notice).not.toHaveBeenCalled();
	});

	it('offline: skips the cloud, speaks with the device voice and tells the learner', async () => {
		vi.stubGlobal('navigator', { onLine: false });
		const [recorded, cloud, device] = [fake('r', false), fake('c', true), fake('d', true)];
		const notice = vi.fn();
		const off = onConnectionFallback(notice);
		await new ChainedTtsProvider(recorded, cloud, device).speak('Hallo!', OPTIONS);
		off();
		expect([cloud.calls, device.calls]).toEqual([0, 1]);
		expect(notice).toHaveBeenCalledOnce();
	});

	it("offline-only is the learner's choice, not trouble: no notice", async () => {
		vi.stubGlobal('navigator', { onLine: false });
		const [recorded, cloud, device] = [fake('r', false), fake('c', true), fake('d', true)];
		const notice = vi.fn();
		const off = onConnectionFallback(notice);
		await new ChainedTtsProvider(recorded, cloud, device, () => true).speak('Hallo!', OPTIONS);
		off();
		expect([cloud.calls, device.calls]).toEqual([0, 1]);
		expect(notice).not.toHaveBeenCalled();
	});

	it('online but the cloud cannot answer (e.g. text too long): no notice', async () => {
		const [recorded, cloud, device] = [fake('r', false), fake('c', false), fake('d', true)];
		const notice = vi.fn();
		const off = onConnectionFallback(notice);
		await new ChainedTtsProvider(recorded, cloud, device).speak('Hallo!', OPTIONS);
		off();
		expect(device.calls).toBe(1);
		expect(notice).not.toHaveBeenCalled();
	});
});
