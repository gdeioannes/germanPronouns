import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/nav_layout_data.dart';
import 'package:german_pronouns_articles/models/nav_layout.dart';

Map<String, dynamic> _throughJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

void main() {
  test('NavLayout round-trips through JSON unchanged', () {
    final json = defaultNavLayout.toJson();
    final restored = NavLayout.fromJson(_throughJson(json));
    expect(restored.toJson(), json);
  });

  test('default layout reproduces the four groups + four quiz items', () {
    final groups = defaultNavLayout.groups;
    expect(groups.map((g) => g.type), [
      NavGroupType.questChain,
      NavGroupType.nounChain,
      NavGroupType.quizzes,
      NavGroupType.links,
    ]);

    final quizzes = groups.firstWhere((g) => g.type == NavGroupType.quizzes);
    expect(quizzes.items.map((i) => i.ref), [
      'article',
      'pronoun',
      'pronoun_article',
      'preposition',
    ]);

    final links = groups.firstWhere((g) => g.type == NavGroupType.links);
    expect(links.items.map((i) => i.ref), [
      kWordLibraryRef,
      kSettingsRef,
      kHowItWorksRef,
      kCoursesRef,
    ]);
  });

  test('NavGroup level survives JSON; absent when unset', () {
    const scoped = NavGroup(
      id: 'quest_a1_1',
      title: 'QUEST · A1.1',
      type: NavGroupType.questChain,
      level: 'A1.1',
    );
    expect(scoped.toJson()['level'], 'A1.1');
    expect(NavGroup.fromJson(scoped.toJson()).level, 'A1.1');

    const plain = NavGroup(id: 'q', title: 'Q', type: NavGroupType.questChain);
    expect(plain.toJson().containsKey('level'), isFalse);
    expect(NavGroup.fromJson(plain.toJson()).level, isNull);
  });

  test('NavGroup gated survives JSON; absent (false) when unset', () {
    const locked = NavGroup(
      id: 'a1_1',
      title: 'A1.1',
      type: NavGroupType.quizzes,
      gated: true,
    );
    expect(locked.toJson()['gated'], true);
    expect(NavGroup.fromJson(locked.toJson()).gated, isTrue);

    const open = NavGroup(id: 'q', title: 'Q', type: NavGroupType.quizzes);
    expect(open.toJson().containsKey('gated'), isFalse);
    expect(NavGroup.fromJson(open.toJson()).gated, isFalse);
  });

  test('NavItem overrides survive JSON; defaults stay sparse', () {
    const full = NavItem(
      ref: 'article',
      titleOverride: 'Mein Titel',
      iconKey: 'star',
      colorIndex: 2,
      hidden: true,
    );
    expect(NavItem.fromJson(full.toJson()).toJson(), full.toJson());

    // A bare item omits all optional keys.
    expect(const NavItem(ref: 'pronoun').toJson(), {'ref': 'pronoun'});
  });

  test('every quiz item references a curated icon key only when set', () {
    for (final group in defaultNavLayout.groups) {
      for (final item in group.items) {
        if (item.iconKey != null) {
          expect(navIconChoices.containsKey(item.iconKey), isTrue);
        }
      }
    }
  });
}
