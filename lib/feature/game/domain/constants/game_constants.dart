const defaultNumGuesses = 5;

const legalWords = <String>['aback', 'abase', 'abate', 'abbey', 'abbot'];

const legalGuesses = <String>[
  'aback',
  'abase',
  'abate',
  'abbey',
  'abbot',
  'abhor',
  'abide',
  'abled',
  'abode',
  'abort',
];

const List<String> allLegalGuesses = [...legalWords, ...legalGuesses];
