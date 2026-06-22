import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/utils/answer_normalization.dart';

void main() {
  group('stripDiacritics', () {
    test('folds German umlauts and ß', () {
      expect(stripDiacritics('schön'), 'schon');
      expect(stripDiacritics('Tür'), 'Tur');
      expect(stripDiacritics('Mädchen'), 'Madchen');
      expect(stripDiacritics('Straße'), 'Strasse');
      expect(stripDiacritics('Fuß'), 'Fuss');
    });

    test('folds Spanish/Latin accents', () {
      expect(stripDiacritics('cómo'), 'como');
      expect(stripDiacritics('español'), 'espanol');
      expect(stripDiacritics('árbol'), 'arbol');
      expect(stripDiacritics('garçon'), 'garcon');
    });

    test('leaves plain ASCII untouched', () {
      expect(stripDiacritics('hello world'), 'hello world');
    });
  });

  group('normalizeAnswer', () {
    test('strict mode lower-cases and trims only', () {
      expect(normalizeAnswer('  Schön ', relaxed: false), 'schön');
    });

    test('relaxed mode also strips diacritics', () {
      expect(normalizeAnswer('  Schön ', relaxed: true), 'schon');
    });

    test('relaxed mode makes accent-only differences match', () {
      // A learner without the right keyboard typing the plain letters.
      expect(
        normalizeAnswer('strasse', relaxed: true),
        normalizeAnswer('Straße', relaxed: true),
      );
      // The same typing would not match the accented answer in strict mode.
      expect(
        normalizeAnswer('strasse', relaxed: false) ==
            normalizeAnswer('Straße', relaxed: false),
        isFalse,
      );
    });

    test('relaxed mode ignores ? ! and the Spanish ¿ ¡', () {
      final correct = normalizeAnswer('¿Cómo estás?', relaxed: true);
      expect(normalizeAnswer('como estas', relaxed: true), correct);
      expect(normalizeAnswer('Cómo estás!', relaxed: true), correct);
      // Strict mode keeps the punctuation, so the bare form would not match.
      expect(
        normalizeAnswer('como estas', relaxed: false) ==
            normalizeAnswer('¿Cómo estás?', relaxed: false),
        isFalse,
      );
    });

    test('a correctly-accented answer still matches in relaxed mode', () {
      final correct = normalizeAnswer('cómo', relaxed: true);
      expect(normalizeAnswer('cómo', relaxed: true), correct);
      expect(normalizeAnswer('como', relaxed: true), correct);
    });
  });
}
