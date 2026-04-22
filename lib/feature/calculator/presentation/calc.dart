import 'package:flutter/material.dart';

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
