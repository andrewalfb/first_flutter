import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // --- Features: Game ---
  // Presentation Layer (Factories: New instance every time)
  // sl.registerFactory(() => GameBloc(submitGuess: sl()));

  // Domain Layer (UseCases)
  // sl.registerLazySingleton(() => SubmitGuessUseCase(sl()));

  // Data Layer (Repositories)
  // sl.registerLazySingleton<GameRepository>(
  //   () => GameRepositoryImpl(remoteDataSource: sl()),
  // );

  // --- Core / External ---
  // sl.registerLazySingleton(() => Dio()); // Network Client
}