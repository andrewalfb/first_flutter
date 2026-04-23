import 'package:flutter/material.dart';

import '../../../core/di/injection_container.dart';
import '../game.dart';
import 'widgets/game_board.dart';
import 'widgets/guess_input.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final GameRepository _repository = sl<GameRepository>();
  GameSession? _game;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    final game = await _repository.getCurrentGame();
    if (!mounted) return;
    setState(() {
      _game = game;
      _isLoading = false;
    });
  }

  Future<void> _submitGuess(String guess) async {
    final game = await _repository.submitGuess(guess);
    if (!mounted) return;
    setState(() {
      _game = game;
    });
  }

  Future<void> _startNewGame() async {
    final game = await _repository.startNewGame();
    if (!mounted) return;
    setState(() {
      _game = game;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _game == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              GameBoard(guesses: _game!.guesses),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: _startNewGame,
                  tooltip: 'Start new game',
                  icon: const Icon(Icons.refresh),
                ),
              ),
            ],
          ),
        ),
        GuessInputSection(onSubmitGuess: _submitGuess),
      ],
    );
  }
}
