import 'dart:math';

import '../constants/game_constants.dart';
import '../entities/game_session.dart';
import '../entities/hit_type.dart';
import '../entities/word.dart';

class GameEngine {
  const GameEngine();

  GameSession createNewGame({
    int numAllowedGuesses = defaultNumGuesses,
    int? seed,
  }) {
    final hiddenWord = seed == null ? _randomWord() : _wordFromSeed(seed);
    return GameSession.initial(
      hiddenWord: hiddenWord,
      numAllowedGuesses: numAllowedGuesses,
      seed: seed,
    );
  }

  bool isLegalGuess(String guess) {
    return allLegalGuesses.contains(guess.trim().toLowerCase());
  }

  Word matchGuess({required Word hiddenWord, required String guess}) {
    final normalizedGuess = guess.trim().toLowerCase();
    final hiddenCopy = Word.fromString(hiddenWord.toString());
    return _evaluateGuess(Word.fromString(normalizedGuess), hiddenCopy);
  }

  GameSession submitGuess(GameSession session, String guess) {
    if (session.didWin || session.didLose) {
      return session;
    }

    final normalizedGuess = guess.trim().toLowerCase();
    if (!isLegalGuess(normalizedGuess)) {
      return session;
    }

    final result = matchGuess(
      hiddenWord: session.hiddenWord,
      guess: normalizedGuess,
    );
    final updatedGuesses = List<Word>.from(session.guesses);
    final activeIndex = updatedGuesses.indexWhere((word) => word.isEmpty);
    if (activeIndex == -1) {
      return session;
    }

    updatedGuesses[activeIndex] = result;
    return session.copyWith(guesses: updatedGuesses);
  }

  Word _randomWord() {
    final rand = Random();
    final nextWord = legalWords[rand.nextInt(legalWords.length)];
    return Word.fromString(nextWord);
  }

  Word _wordFromSeed(int seed) {
    return Word.fromString(legalWords[seed % legalWords.length]);
  }

  Word _evaluateGuess(Word guess, Word other) {
    for (var i = 0; i < guess.length; i++) {
      if (other[i].char == guess[i].char) {
        guess[i] = (char: guess[i].char, type: HitType.hit);
        other[i] = (char: other[i].char, type: HitType.removed);
      }
    }

    for (var i = 0; i < other.length; i++) {
      final targetLetter = other[i];
      if (targetLetter.type != HitType.none) continue;

      for (var j = 0; j < guess.length; j++) {
        final guessedLetter = guess[j];
        if (guessedLetter.type != HitType.none) continue;
        if (guessedLetter.char == targetLetter.char) {
          guess[j] = (char: guessedLetter.char, type: HitType.partial);
          other[i] = (char: targetLetter.char, type: HitType.removed);
          break;
        }
      }
    }

    for (var i = 0; i < guess.length; i++) {
      if (guess[i].type == HitType.none) {
        guess[i] = (char: guess[i].char, type: HitType.miss);
      }
    }

    return guess;
  }
}
