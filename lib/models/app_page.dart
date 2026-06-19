/// Identifies which top-level page is currently shown, so the drawer can
/// highlight it and the app can reopen on the last-visited page.
///
/// Lives in models/ (not the widget layer) so data configs can set
/// `QuizConfig.currentPage` without depending on widgets — this keeps the
/// section catalog free of a catalog → drawer → catalog import cycle.
enum AppPage {
  pronouns,
  articles,
  nounsArticles,
  pronounsAndArticles,
  prepositions,
  wordLibrary,
  settings,
}

/// Looks up an [AppPage] by its enum name (as persisted via
/// `NounSettings.setLastPage`), or null if [name] doesn't match any page.
AppPage? appPageFromName(String? name) {
  for (final page in AppPage.values) {
    if (page.name == name) return page;
  }
  return null;
}
