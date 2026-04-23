abstract class GameLayout {
  static const double tileWidth = 60.0;
  static const double tilePadding = 2.5;
  static const int wordLength = 5;
  static const double boardPadding = 16.0;

  static double get totalBoardWidth =>
      (tileWidth + (tilePadding * 2)) * wordLength;
}
