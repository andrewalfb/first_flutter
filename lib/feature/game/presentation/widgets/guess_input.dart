import 'package:flutter/material.dart';

import 'game_layout.dart';

class GuessInputSection extends StatelessWidget {
  const GuessInputSection({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: SizedBox(
            width: GameLayout.totalBoardWidth,
            child: GuessInput(onSubmitGuess: onSubmitGuess),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
