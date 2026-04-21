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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Align(alignment: Alignment.bottomCenter, child: const Text('Flutter Demo'),),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Calculator', icon: Icon(Icons.calculate)),
              Tab(text: 'Wikipedia', icon: Icon(Icons.public)),
              // Tab(text: 'Coming Soon', icon: Icon(Icons.upcoming)),
              Tab(text: 'Game', icon: Icon(Icons.grid_on)),
              // Tab(text: 'Wordle', icon: Icon(Icons.gamepad)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CalculatorScreen(), 
            WikipediaScreen(), 
            GamePage() /*ComingSoonScreen()*/, 
            // Tile("First wiget", .miss)
          ],
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
          _ => Colors.white
        },
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300)
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
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: Column(
        spacing: 5.0, 
        children: [
          for (var guess in _game.guesses) 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var letter in guess) 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
                    child: Tile(letter.char, letter.type)
            )
              ],
            ),
          GuessInput(
            onSubmitGuess: (guess) {
             setState(() {
               _game.guess(guess);
             });
            },
          )
        ]
      )
    );  
  }
}

class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _onSubmit() {
    onSubmitGuess(_textEditingController.text.trim());
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35)))
              ),
              controller: _textEditingController,
              autofocus: true,
              onSubmitted: (value) {
                _onSubmit();
              },
            )
          )
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: _onSubmit, 
          icon: const Icon(Icons.arrow_circle_up)
        )
      ],
    );
  }
}