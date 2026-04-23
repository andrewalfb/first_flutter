import '../../domain/repositories/game_repository.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/services/game_engine.dart';
import '../datasources/game_local_data_source.dart';
import '../models/game_session_model.dart';

class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl({
    required GameLocalDataSource localDataSource,
    required GameEngine gameEngine,
  }) : _localDataSource = localDataSource,
       _gameEngine = gameEngine;

  final GameLocalDataSource _localDataSource;
  final GameEngine _gameEngine;

  @override
  Future<void> clearCurrentGame() {
    return _localDataSource.clearCurrentGame();
  }

  @override
  Future<GameSession> getCurrentGame() async {
    final storedSession = await _localDataSource.getCurrentGame();
    if (storedSession != null) {
      return storedSession;
    }

    final newSession = _gameEngine.createNewGame();
    await _localDataSource.saveCurrentGame(
      GameSessionModel.fromEntity(newSession),
    );
    return newSession;
  }

  @override
  Future<GameSession> startNewGame({int? seed}) async {
    final newSession = _gameEngine.createNewGame(seed: seed);
    await _localDataSource.saveCurrentGame(
      GameSessionModel.fromEntity(newSession),
    );
    return newSession;
  }

  @override
  Future<GameSession> submitGuess(String guess) async {
    final currentSession = await getCurrentGame();
    final updatedSession = _gameEngine.submitGuess(currentSession, guess);
    await _localDataSource.saveCurrentGame(
      GameSessionModel.fromEntity(updatedSession),
    );
    return updatedSession;
  }
}
