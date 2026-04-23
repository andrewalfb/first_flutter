import 'package:get_it/get_it.dart';

import '../../feature/game/game.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  sl.registerLazySingleton(() => GameDatabase());
  sl.registerLazySingleton(() => const GameEngine());
  sl.registerLazySingleton<GameLocalDataSource>(
    () => SqfliteGameLocalDataSource(sl()),
  );
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(localDataSource: sl(), gameEngine: sl()),
  );
}
