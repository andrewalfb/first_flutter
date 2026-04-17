import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _summary = 'Tap the button to load a Wikipedia summary.';
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

        setState(() {
          _summary = (summaryText != null && summaryText.isNotEmpty)
              ? summaryText
              : 'Wikipedia responded, but no summary text was found.';
        });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : _fetchWikipediaSummary,
                child: Text(
                  _isLoading ? 'Loading Wikipedia...' : 'Get Wikipedia Summary',
                ),
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 12),
              Text(
                _summary,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
