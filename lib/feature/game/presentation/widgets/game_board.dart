import 'package:flutter/material.dart';

import '../../game.dart';
import '../tile.dart';
import 'game_layout.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key, required this.guesses});

  final List<Word> guesses;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          children: guesses.map((guess) => GameBoardRow(guess: guess)).toList(),
        ),
      ),
    );
  }
}

class GameBoardRow extends StatelessWidget {
  const GameBoardRow({super.key, required this.guess});

  final Word guess;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: guess
          .map(
            (letter) => Padding(
              padding: const EdgeInsets.all(GameLayout.tilePadding),
              child: SizedBox(
                width: GameLayout.tileWidth,
                height: GameLayout.tileWidth,
                child: Tile(letter.char, letter.type),
              ),
            ),
          )
          .toList(),
    );
  }
}
