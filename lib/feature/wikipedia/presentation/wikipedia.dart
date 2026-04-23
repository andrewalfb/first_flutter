import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _wikipediaSummaryUrl = Uri.parse(
  'https://en.wikipedia.org/api/rest_v1/page/summary/Flutter_(software)',
);

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
    } catch (error) {
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
