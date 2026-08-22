import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/services/ai_assistant.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a short prompt rides along in the ChatGPT URL', () {
    const prompt = 'Ask me 5 A1 questions about my daily routine.';
    expect(AiAssistant.chatGpt.prefills(prompt), isTrue);
    final url = AiAssistant.chatGpt.urlFor(prompt);
    expect(url.host, 'chatgpt.com');
    expect(url.queryParameters['q'], prompt);
  });

  test('a real-length exercise falls back to opening ChatGPT bare', () {
    // A rendered speaking exercise is ~3000 characters, which encodes well past
    // any safe URL length — this is the path that actually runs in the app.
    final prompt = 'x' * 3000;
    expect(AiAssistant.chatGpt.prefills(prompt), isFalse);
    final url = AiAssistant.chatGpt.urlFor(prompt);
    expect(url.hasQuery, isFalse);
    expect(url.toString(), 'https://chatgpt.com/');
  });

  test('percent-encoding counts towards the cap, not raw length', () {
    // Umlauts triple in length once encoded, so a prompt that looks short
    // enough can still overflow. Just under the cap raw, well over encoded.
    final prompt = 'ä' * 1500;
    expect(prompt.length, lessThan(AiAssistant.maxPrefillLength));
    expect(AiAssistant.chatGpt.prefills(prompt), isFalse);
  });

  test('Gemini has no prompt parameter, so it only ever opens bare', () {
    const prompt = 'short';
    expect(AiAssistant.gemini.prefills(prompt), isFalse);
    expect(
      AiAssistant.gemini.urlFor(prompt).toString(),
      'https://gemini.google.com/app',
    );
  });

  test('the chosen assistant is remembered by name', () async {
    SharedPreferences.setMockInitialValues({});
    await (await SharedPreferences.getInstance()).reload();

    expect(await AiAssistant.lastUsed(), isNull);
    await AiAssistant.gemini.remember();
    expect(await AiAssistant.lastUsed(), AiAssistant.gemini);
  });

  test('an unknown saved value degrades to no preference', () async {
    SharedPreferences.setMockInitialValues({
      AiAssistant.prefsKey: 'someAssistantWeDropped',
    });
    await (await SharedPreferences.getInstance()).reload();

    expect(await AiAssistant.lastUsed(), isNull);
  });
}
