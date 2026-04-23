import '../../domain/entities/game_session.dart';
import '../../domain/entities/word.dart';

class GameSessionModel extends GameSession {
  const GameSessionModel({
    required super.hiddenWord,
    required super.guesses,
    required super.numAllowedGuesses,
    super.seed,
  });

  factory GameSessionModel.fromEntity(GameSession session) {
    return GameSessionModel(
      hiddenWord: session.hiddenWord,
      guesses: session.guesses,
      numAllowedGuesses: session.numAllowedGuesses,
      seed: session.seed,
    );
  }

  factory GameSessionModel.fromJson(Map<String, dynamic> json) {
    return GameSessionModel(
      hiddenWord: Word.fromSerialized(json['hiddenWord'] as List<dynamic>),
      guesses: (json['guesses'] as List<dynamic>)
          .map((item) => Word.fromSerialized(item as List<dynamic>))
          .toList(),
      numAllowedGuesses: json['numAllowedGuesses'] as int,
      seed: json['seed'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hiddenWord': hiddenWord.toSerialized(),
      'guesses': guesses.map((guess) => guess.toSerialized()).toList(),
      'numAllowedGuesses': numAllowedGuesses,
      'seed': seed,
    };
  }
}
