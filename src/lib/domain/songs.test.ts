import { describe, expect, it } from "vitest";
import { SONGS, songDeckCard } from "./songs";
import { songDescription, songLd, songTitle } from "$lib/seo";

describe("SONGS registry", () => {
  it("every song has a route, a recording and lyrics", () => {
    for (const s of SONGS) {
      expect(s.href).toMatch(/^\/song\//);
      expect(s.audio).toMatch(/^\/audio\/songs\/.+\.mp3$/);
      expect(s.sections.length).toBeGreaterThan(0);
      expect(
        s.sections.some((sec) => sec.lines.some((l) => l.lang === "de")),
      ).toBe(true);
    }
  });
});

describe("songDeckCard", () => {
  const never = () => false;
  it("deals the level song once, and not after it was heard or skipped", () => {
    const card = songDeckCard(
      "de_cert_a1",
      "A1.1",
      new Set(),
      () => true,
      never,
    );
    expect(card?.kind).toBe("song");
    expect(card?.quiz.id).toBe("song:ich_bin_max");
    expect(
      songDeckCard("de_cert_a1", "A1.2", new Set(), () => true, never),
    ).toBeNull();
    expect(
      songDeckCard(
        "de_cert_a1",
        "A1.1",
        new Set(),
        () => true,
        () => true,
      ),
    ).toBeNull();
  });
  it("moves on to the next song once the first was skipped, respecting its after gate", () => {
    const skipped = new Set(["song:ich_bin_max"]);
    expect(
      songDeckCard("de_cert_a1", "A1.1", skipped, () => true, never)?.quiz.id,
    ).toBe("song:der_die_das");
    expect(
      songDeckCard("de_cert_a1", "A1.1", skipped, () => false, never),
    ).toBeNull();
    expect(
      songDeckCard(
        "de_cert_a1",
        "A1.1",
        new Set([...skipped, "song:der_die_das"]),
        () => true,
        never,
      ),
    ).toBeNull();
  });
});

describe("song pages describe themselves to search engines", () => {
  it("keeps every title and description inside what a result shows", () => {
    for (const s of SONGS) {
      // A result shows roughly 60-70 characters of title, 155 of description.
      expect(songTitle(s).length).toBeLessThanOrEqual(70);
      expect(songDescription(s).length).toBeLessThanOrEqual(155);
      // The song's own name has to survive the clipping: it is what is searched.
      expect(songTitle(s)).toContain(s.title);
      expect(songDescription(s).length).toBeGreaterThan(70);
    }
  });

  it("gives every song its own title — a shared one splits its ranking", () => {
    const titles = SONGS.map(songTitle);
    expect(new Set(titles).size).toBe(titles.length);
  });

  it("names the grammar it teaches in its structured data", () => {
    for (const s of SONGS) {
      const ld = songLd(s, "German Course A1–C2") as Record<string, unknown>;
      expect(ld["@type"]).toContain("MusicRecording");
      expect(ld.teaches).toEqual(s.teaches);
      expect(ld.url).toBe(`https://languagequiz.org${s.href}`);
      expect(ld.isAccessibleForFree).toBe(true);
    }
  });
});
