import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/utils/speech_match.dart';

void main() {
  group('normalizeForSpeech', () {
    test('lowercases, strips punctuation, collapses whitespace', () {
      expect(normalizeForSpeech('  Die Rechnung, BITTE!  '), 'die rechnung bitte');
    });

    test('maps umlauts and ß to ASCII digraphs', () {
      expect(normalizeForSpeech('Tschüß'), 'tschuess');
      expect(normalizeForSpeech('Apotheke schön groß'), 'apotheke schoen gross');
    });

    test('ß and ss normalize to the same thing', () {
      expect(normalizeForSpeech('Straße'), normalizeForSpeech('Strasse'));
    });
  });

  group('matchesSpoken', () {
    test('accepts an exact phrase ignoring case/punctuation', () {
      expect(matchesSpoken('Hallo!', 'Hallo'), isTrue);
      expect(matchesSpoken('die rechnung bitte', 'Die Rechnung, bitte'), isTrue);
    });

    test('accepts umlaut/ß spelling differences', () {
      expect(matchesSpoken('Tschuess', 'Tschüss'), isTrue);
      expect(matchesSpoken('Gruesse', 'Grüße'), isTrue);
    });

    test('accepts when the recognizer adds or drops a leading word', () {
      expect(matchesSpoken('ähm, Guten Appetit', 'Guten Appetit!'), isTrue);
      expect(matchesSpoken('Bahnhof', 'Wo ist der Bahnhof?'), isTrue);
    });

    test('tolerates a minor mis-hearing within threshold', () {
      // One letter off in a long phrase clears the 0.8 similarity bar.
      expect(matchesSpoken('Ich brauche einen Artz', 'Ich brauche einen Arzt'),
          isTrue);
    });

    test('rejects an unrelated phrase', () {
      expect(matchesSpoken('Guten Morgen', 'Wo ist die Apotheke'), isFalse);
      expect(matchesSpoken('', 'Danke'), isFalse);
    });

    test('rejects an empty target', () {
      expect(matchesSpoken('anything', ''), isFalse);
    });
  });
}
