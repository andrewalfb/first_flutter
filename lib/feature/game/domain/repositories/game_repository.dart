import '../entities/game_session.dart';

abstract class GameRepository {
  Future<GameSession> getCurrentGame();

  Future<GameSession> startNewGame({int? seed});

  Future<GameSession> submitGuess(String guess);

  Future<void> clearCurrentGame();
}
