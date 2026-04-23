import 'word.dart';
import '../constants/game_constants.dart';
import 'hit_type.dart';

class GameSession {
  const GameSession({
    required this.hiddenWord,
    required this.guesses,
    required this.numAllowedGuesses,
    this.seed,
  });

  factory GameSession.initial({
    required Word hiddenWord,
    int numAllowedGuesses = defaultNumGuesses,
    int? seed,
  }) {
    return GameSession(
      hiddenWord: hiddenWord,
      guesses: List<Word>.generate(
        numAllowedGuesses,
        (_) => Word.empty(length: hiddenWord.length),
      ),
      numAllowedGuesses: numAllowedGuesses,
      seed: seed,
    );
  }

  final Word hiddenWord;
  final List<Word> guesses;
  final int numAllowedGuesses;
  final int? seed;

  Word get previousGuess {
    final index = guesses.lastIndexWhere((word) => word.isNotEmpty);
    return index == -1 ? Word.empty(length: hiddenWord.length) : guesses[index];
  }

  int get activeIndex => guesses.indexWhere((word) => word.isEmpty);

  int get guessesRemaining {
    if (activeIndex == -1) return 0;
    return numAllowedGuesses - activeIndex;
  }

  bool get didWin {
    if (guesses.first.isEmpty) return false;

    for (final letter in previousGuess) {
      if (letter.type != HitType.hit) return false;
    }

    return true;
  }

  bool get didLose => guessesRemaining == 0 && !didWin;

  GameSession copyWith({
    Word? hiddenWord,
    List<Word>? guesses,
    int? numAllowedGuesses,
    int? seed,
  }) {
    return GameSession(
      hiddenWord: hiddenWord ?? this.hiddenWord,
      guesses: guesses ?? this.guesses,
      numAllowedGuesses: numAllowedGuesses ?? this.numAllowedGuesses,
      seed: seed ?? this.seed,
    );
  }
}
