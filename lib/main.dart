import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'game.dart';

final _wikipediaSummaryUrl = Uri.parse(
  'https://en.wikipedia.org/api/rest_v1/page/summary/Flutter_(software)',
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: isKeyboardVisible ? null : const Align(
              alignment: Alignment.bottomCenter,
              child: Text('Flutter Demo'),
            ),
            toolbarHeight: isKeyboardVisible ? 0 : kToolbarHeight,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Calculator', icon: Icon(Icons.calculate)),
                Tab(text: 'Wikipedia', icon: Icon(Icons.public)),
                Tab(text: 'Game', icon: Icon(Icons.grid_on)),
              ],
            ),
        ),
        body: TabBarView(
          children: [CalculatorScreen(), WikipediaScreen(), GamePage()],
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _firstNumberController = TextEditingController();
  final TextEditingController _secondNumberController = TextEditingController();
  String _result = 'Enter two numbers to calculate.';

  @override
  void dispose() {
    _firstNumberController.dispose();
    _secondNumberController.dispose();
    super.dispose();
  }

  void _calculate(String operator) {
    final firstValue = double.tryParse(_firstNumberController.text);
    final secondValue = double.tryParse(_secondNumberController.text);

    if (firstValue == null || secondValue == null) {
      setState(() {
        _result = 'Please enter valid numbers.';
      });
      return;
    }

    if (operator == '÷' && secondValue == 0) {
      setState(() {
        _result = 'Cannot divide by zero.';
      });
      return;
    }

    late final double calculation;

    switch (operator) {
      case '+':
        calculation = firstValue + secondValue;
      case '-':
        calculation = firstValue - secondValue;
      case '×':
        calculation = firstValue * secondValue;
      case '÷':
        calculation = firstValue / secondValue;
      default:
        calculation = 0;
    }

    setState(() {
      _result = 'Result: ${calculation.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _firstNumberController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'First number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _secondNumberController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Second number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _calculate('+'),
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: () => _calculate('-'),
                child: const Text('Subtract'),
              ),
              ElevatedButton(
                onPressed: () => _calculate('×'),
                child: const Text('Multiply'),
              ),
              ElevatedButton(
                onPressed: () => _calculate('÷'),
                child: const Text('Divide'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            _result,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class WikipediaScreen extends StatefulWidget {
  const WikipediaScreen({super.key});

  @override
  State<WikipediaScreen> createState() => _WikipediaScreenState();
}

class _WikipediaScreenState extends State<WikipediaScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _fetchWikipediaSummary() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(_wikipediaSummaryUrl);

      if (!mounted) {
        return;
      }

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final summaryText = body['extract'] as String?;
        final pageTitle = body['title'] as String? ?? 'Wikipedia Result';

        if (summaryText == null || summaryText.isEmpty) {
          setState(() {
            _errorMessage =
                'Wikipedia responded, but no summary text was found.';
          });
          return;
        }

        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) =>
                WikipediaResultScreen(title: pageTitle, summary: summaryText),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Request failed with status code ${response.statusCode}.';
        });
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage =
            'Could not reach Wikipedia. Check your internet connection and try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Open a Wikipedia page summary about Flutter software.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchWikipediaSummary,
              child: Text(
                _isLoading ? 'Loading Wikipedia...' : 'Open Wikipedia Result',
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 24),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class WikipediaResultScreen extends StatelessWidget {
  const WikipediaResultScreen({
    super.key,
    required this.title,
    required this.summary,
  });

  final String title;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  summary,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: switch (hitType) {
          .hit => Colors.green,
          .partial => Colors.yellow,
          .miss => Colors.grey,
          _ => Colors.white,
        },
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();
/* work variant with scroolview, but it is not good because of keyboard
  @override
  Widget build(BuildContext context) {
    return  Column(
         children: [
          Expanded(
            child: SingleChildScrollView(
                reverse: true,
                padding: const EdgeInsets.all(8),
                child: Column(
                  spacing: 5.0,
                  children: [
                    for (var guess in _game.guesses)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var letter in guess)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2.5,
                                vertical: 2.5,
                              ),
                              child: Tile(letter.char, letter.type),
                            ),
                        ],
                      ),
                      SafeArea(child: 
                        GuessInput(
                          onSubmitGuess: (guess) {
                            setState(() {
                              _game.guess(guess);
                            });
                          },
                        ),
                      ),
                  ],
                ),
            ),
          ),
        ],
      );
  }
*/
@override
Widget build(BuildContext context) {
  // Define your constants once to keep them in sync
  const double tileWidth = 60.0; 
  const double tilePadding = 2.5;
  const int lettersPerWord = 5;
  
  // Total width = (Tile + Padding on both sides) * Number of letters
  const double gameBoardWidth = (tileWidth + (tilePadding * 2)) * lettersPerWord;

  return Column(
    children: [
      // 1. Game Board Section (Centered)
      Expanded(
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              children: [
                for (var guess in _game.guesses)
                  Row(
                    children: [
                      for (var letter in guess)
                        Padding(
                          padding: const EdgeInsets.all(tilePadding),
                          child: SizedBox(
                            width: tileWidth, 
                            height: tileWidth, 
                            child: Tile(letter.char, letter.type)
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),

      // 2. Input Section (Matched to Game Width)
      SafeArea(
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
      ),
    ],
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