// Shared German grammar reference data used across the quiz data files, so
// each file doesn't keep its own private copy of these maps.

/// Definite article in the nominative for each grammatical gender:
/// 'm' → der, 'f' → die, 'n' → das.
const Map<String, String> baseArticles = {'m': 'der', 'f': 'die', 'n': 'das'};

/// English name of each grammatical gender.
const Map<String, String> genderNames = {
  'm': 'masculine',
  'f': 'feminine',
  'n': 'neuter',
};
