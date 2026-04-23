

import 'package:flutter/material.dart';

import '../game.dart';
import 'widgets/game_board.dart';
import 'widgets/guess_input.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GameBoard(guesses: _game.guesses),
        ),
        GuessInputSection(
          onSubmitGuess: (guess) {
            setState(() => _game.guess(guess));
          },
        ),
      ],
    );
  }
}
