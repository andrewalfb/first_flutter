

import 'package:flutter/material.dart';

import '../game.dart';
import 'tile.dart'; 

abstract class GameLayout {
  static const double tileWidth = 60.0;
  static const double tilePadding = 2.5;
  static const int wordLength = 5;
  static const double boardPadding = 16.0;

  static double get totalBoardWidth => 
      (tileWidth + (tilePadding * 2)) * wordLength;
}

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
        // 1. Game Board Section (Centered)
        Expanded(
          child: Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                children: _game.guesses.map((guess) => _buildRow(guess)).toList(),
              ),
            ),
          ),
        ),

        // 2. Input Section (Matched to Game Width)
        _buildInputSection(),

      ],
    );
  }
  
  Widget _buildRow(Word guess) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: guess.map((letter) => Padding(
        padding: const EdgeInsets.all(GameLayout.tilePadding),
        child: SizedBox(
          width: GameLayout.tileWidth,
          height: GameLayout.tileWidth,
          child: Tile(letter.char, letter.type),
        ),
      )).toList(),
    );
  }

  Widget _buildInputSection() {
    const int lettersPerWord = 5;
    // Total width = (Tile + Padding on both sides) * Number of letters
    const double gameBoardWidth = (GameLayout.tileWidth + (GameLayout.tilePadding * 2)) * lettersPerWord;
    
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center( // Centers the constrained input field
          child: SizedBox(
            width: gameBoardWidth, // Matches the grid width exactly
            child: GuessInput(
              onSubmitGuess: (guess) {
                setState(() => _game.guess(guess));
              },
            ),
          ),
        ),
      ),
   );
}

}

class GuessInput extends StatefulWidget {
  const GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  @override
  State<GuessInput> createState() => _GuessInputState();
}

class _GuessInputState extends State<GuessInput> {
  // Controllers live here in State so they aren't destroyed on rebuild
  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitGuess(text);
      _textEditingController.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to top because of the counter
      children: [
        Expanded(
          child: TextField(
            focusNode: _focusNode,
            controller: _textEditingController,
            maxLength: 5,
            autofocus: true,
            onSubmitted: (_) => _onSubmit(),
            decoration: InputDecoration(
              labelText: 'Enter your guess',
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: _onSubmit,
                  icon: const Icon(Icons.arrow_circle_up, size: 32),
                  color: Colors.deepPurple,
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}