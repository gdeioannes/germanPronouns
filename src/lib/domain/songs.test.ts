import { describe, expect, it } from "vitest";
import { SONGS, songDeckCard } from "./songs";

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
