import 'dart:collection';

import 'hit_type.dart';

typedef Letter = ({String char, HitType type});

class Word with IterableMixin<Letter> {
  Word(List<Letter> letters) : _letters = List<Letter>.from(letters);

  factory Word.empty({int length = 5}) {
    return Word(List<Letter>.filled(length, (char: '', type: HitType.none)));
  }

  factory Word.fromString(String guess) {
    final list = guess.toLowerCase().split('');
    final letters = list
        .map((String char) => (char: char, type: HitType.none))
        .toList();
    return Word(letters);
  }

  factory Word.fromSerialized(List<dynamic> data) {
    return Word(
      data
          .map(
            (item) => (
              char: item['char'] as String,
              type: HitType.values.byName(item['type'] as String),
            ),
          )
          .toList(),
    );
  }

  final List<Letter> _letters;

  @override
  Iterator<Letter> get iterator => _letters.iterator;

  @override
  bool get isEmpty => every((letter) => letter.char.isEmpty);

  @override
  bool get isNotEmpty => !isEmpty;

  Letter operator [](int i) => _letters[i];

  void operator []=(int i, Letter value) => _letters[i] = value;

  List<Map<String, dynamic>> toSerialized() {
    return _letters
        .map((letter) => {'char': letter.char, 'type': letter.type.name})
        .toList();
  }

  @override
  String toString() {
    return _letters.map((Letter c) => c.char).join().trim();
  }

  String toStringVerbose() {
    return _letters.map((l) => '${l.char} - ${l.type.name}').join('\n');
  }
}
