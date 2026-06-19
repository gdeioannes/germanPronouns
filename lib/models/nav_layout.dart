/// Serializable description of the left navigation drawer's organization — the
/// groups (sections) and the items within them. This is the editable twin of
/// what used to be hardcoded in `app_drawer.dart` + `section_catalog.dart`, so
/// a teacher can reorder/rename groups and move quizzes between them from the
/// back office. Stored in the content database and shipped in the seed.
library;

/// What a [NavGroup] renders.
enum NavGroupType {
  /// A list of quiz [NavItem]s (each opens a quiz by its `QuizContent.id`).
  quizzes,

  /// A list of built-in link [NavItem]s (`'wordLibrary'` / `'settings'`).
  links,

  /// The dynamic Quest (CEFR) chain — rendered by the drawer; items ignored.
  questChain,

  /// The dynamic noun-category chain — rendered by the drawer; items ignored.
  nounChain,
}

NavGroupType _groupTypeFromName(String? name) {
  for (final t in NavGroupType.values) {
    if (t.name == name) return t;
  }
  return NavGroupType.quizzes;
}

/// One entry in a [NavGroup].
class NavItem {
  const NavItem({
    required this.ref,
    this.titleOverride,
    this.iconKey,
    this.colorIndex,
    this.hidden = false,
  });

  /// For a `quizzes` group, a `QuizContent.id`. For a `links` group, a built-in
  /// destination key (`'wordLibrary'` / `'settings'`).
  final String ref;

  /// Overrides the default title (the quiz's own title / the link's name).
  final String? titleOverride;

  /// Key into `navIconChoices`; null uses the default icon.
  final String? iconKey;

  /// Index into `kSectionAccentColors`; null uses a derived color.
  final int? colorIndex;

  /// When true the item is hidden from learners (kept in the layout).
  final bool hidden;

  NavItem copyWith({
    String? ref,
    String? titleOverride,
    String? iconKey,
    int? colorIndex,
    bool? hidden,
  }) => NavItem(
    ref: ref ?? this.ref,
    titleOverride: titleOverride ?? this.titleOverride,
    iconKey: iconKey ?? this.iconKey,
    colorIndex: colorIndex ?? this.colorIndex,
    hidden: hidden ?? this.hidden,
  );

  Map<String, dynamic> toJson() => {
    'ref': ref,
    if (titleOverride != null) 'titleOverride': titleOverride,
    if (iconKey != null) 'iconKey': iconKey,
    if (colorIndex != null) 'colorIndex': colorIndex,
    if (hidden) 'hidden': true,
  };

  factory NavItem.fromJson(Map<String, dynamic> json) => NavItem(
    ref: json['ref'] as String,
    titleOverride: json['titleOverride'] as String?,
    iconKey: json['iconKey'] as String?,
    colorIndex: json['colorIndex'] as int?,
    hidden: json['hidden'] as bool? ?? false,
  );
}

/// One section group in the drawer.
class NavGroup {
  const NavGroup({
    required this.id,
    required this.title,
    required this.type,
    this.items = const [],
  });

  /// Stable id (so reordering/renaming doesn't lose identity).
  final String id;
  final String title;
  final NavGroupType type;
  final List<NavItem> items;

  NavGroup copyWith({String? title, NavGroupType? type, List<NavItem>? items}) =>
      NavGroup(
        id: id,
        title: title ?? this.title,
        type: type ?? this.type,
        items: items ?? this.items,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type.name,
    if (items.isNotEmpty) 'items': [for (final i in items) i.toJson()],
  };

  factory NavGroup.fromJson(Map<String, dynamic> json) => NavGroup(
    id: json['id'] as String,
    title: json['title'] as String,
    type: _groupTypeFromName(json['type'] as String?),
    items: [
      for (final i in (json['items'] as List?) ?? const [])
        NavItem.fromJson(i as Map<String, dynamic>),
    ],
  );
}

/// The full ordered drawer layout.
class NavLayout {
  const NavLayout({required this.groups});

  final List<NavGroup> groups;

  NavLayout copyWith({List<NavGroup>? groups}) =>
      NavLayout(groups: groups ?? this.groups);

  Map<String, dynamic> toJson() => {
    'groups': [for (final g in groups) g.toJson()],
  };

  factory NavLayout.fromJson(Map<String, dynamic> json) => NavLayout(
    groups: [
      for (final g in (json['groups'] as List?) ?? const [])
        NavGroup.fromJson(g as Map<String, dynamic>),
    ],
  );
}

/// Built-in link refs for `links` groups.
const String kWordLibraryRef = 'wordLibrary';
const String kSettingsRef = 'settings';

/// The default drawer layout — reproduces the previously-hardcoded structure,
/// so the app looks identical until a teacher edits it. Used as the seed/
/// fallback for `ContentRepository.navLayout()`. Pure data (no Flutter), so the
/// seed-generator tool can use it too.
const NavLayout defaultNavLayout = NavLayout(
  groups: [
    NavGroup(id: 'quest', title: 'QUEST · A1', type: NavGroupType.questChain),
    NavGroup(id: 'nouns', title: 'NOUN CATEGORIES', type: NavGroupType.nounChain),
    NavGroup(
      id: 'quizzes',
      title: 'QUIZZES',
      type: NavGroupType.quizzes,
      items: [
        NavItem(ref: 'article'),
        NavItem(ref: 'pronoun'),
        NavItem(ref: 'pronoun_article'),
        NavItem(ref: 'preposition'),
      ],
    ),
    NavGroup(
      id: 'more',
      title: 'MORE',
      type: NavGroupType.links,
      items: [NavItem(ref: kWordLibraryRef), NavItem(ref: kSettingsRef)],
    ),
  ],
);
