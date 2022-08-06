import 'eastern_chess.dart';
import 'package:flutter/material.dart';
import 'eastern_constants.dart';

class EasternChessBoardController extends ValueNotifier<EasternChess> {
  late EasternChess game;

  factory EasternChessBoardController() => EasternChessBoardController._(EasternChess());

  factory EasternChessBoardController.fromGame(EasternChess game) =>
      EasternChessBoardController._(game);

  factory EasternChessBoardController.fromFEN(String fen) =>
      EasternChessBoardController._(EasternChess.fromFEN(fen));

  EasternChessBoardController._(EasternChess game)
      : game = game,
        super(game);

  /// Makes move on the board
  void makeMove({required String from, required String to}) {
    game.move({"from": from, "to": to}, null);
    notifyListeners();
  }


  /// Makes move on the board
  void makeMoveWithNormalNotation(String move) {
    game.move(move, null);
    notifyListeners();
  }

  void undoMove() {
    if (game.half_moves == 0) {
      return;
    }
    game.undo_move();
    notifyListeners();
  }

  void resetBoard() {
    game.reset();
    notifyListeners();
  }

  /// Clears board
  void clearBoard() {
    game.clear();
    notifyListeners();
  }

  /// Puts piece on a square
  void putPiece(BoardPieceType piece, String square, PlayerColor color) {
    game.put(_getPiece(piece, color), square);
    notifyListeners();
  }

  /// Loads a PGN
  void loadPGN(String pgn) {
    game.load_pgn(pgn);
    notifyListeners();
  }

  /// Loads a PGN
  void loadFen(String fen) {
    game.load(fen);
    notifyListeners();
  }

  bool isInCheck() {
    return game.in_check;
  }

  bool isCheckMate() {
    return game.in_checkmate;
  }

  bool isDraw() {
    return game.in_draw;
  }

  bool isStaleMate() {
    return game.in_stalemate;
  }

  bool isThreefoldRepetition() {
    return game.in_threefold_repetition;
  }

  bool isInsufficientMaterial() {
    return game.insufficient_material;
  }

  bool isGameOver() {
    return game.game_over;
  }

  String getAscii() {
    return game.ascii;
  }

  String getFen() {
    return game.fen;
  }

  List<String?> getSan() {
    return game.san_moves();
  }

  List<Piece?> getBoard() {
    return game.board;
  }

  List<Move> getPossibleMoves() {
    return game.moves({'asObjects': true}) as List<Move>;
  }

  int getMoveCount() {
    return game.move_number;
  }

  int getHalfMoveCount() {
    return game.half_moves;
  }

  /// Gets respective piece
  Piece _getPiece(BoardPieceType piece, PlayerColor color) {
    var convertedColor = color == PlayerColor.red ? Color.RED : Color.BLACK;

    switch (piece) {
      case BoardPieceType.Bishop:
        return Piece(PieceType.BISHOP, convertedColor);
      case BoardPieceType.Advisor:
        return Piece(PieceType.ADVISOR, convertedColor);
      case BoardPieceType.King:
        return Piece(PieceType.KING, convertedColor);
      case BoardPieceType.Knight:
        return Piece(PieceType.KNIGHT, convertedColor);
      case BoardPieceType.Pawn:
        return Piece(PieceType.PAWN, convertedColor);
      case BoardPieceType.Rook:
        return Piece(PieceType.ROOK, convertedColor);
      case BoardPieceType.Canon:
        return Piece(PieceType.CANON, convertedColor);
    }
  }
}
