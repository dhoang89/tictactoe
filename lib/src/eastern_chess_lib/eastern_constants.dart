const files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'];

/// Enum which stores board types
enum BoardColor {
  brown,
  darkBrown,
  orange,
  green,
}

enum PlayerColor {
  red,
  black,
}

enum BoardPieceType { Pawn, Rook, Knight, Bishop, Advisor, King, Canon }

RegExp squareRegex = RegExp("^[A-I|a-i][1-9]\$");
