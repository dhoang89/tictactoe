import 'dart:math';

import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'eastern_chess.dart';
import 'eastern_board_arrow.dart';
import 'eastern_chess_board_controller.dart';
import 'eastern_constants.dart';

class EasternChessBoard extends StatefulWidget {
  /// An instance of [EasternChessBoardController] which holds the game and allows
  /// manipulating the board programmatically.
  final EasternChessBoardController controller;

  /// Size of chessboard
  final double? size;

  /// A boolean which checks if the user should be allowed to make moves
  final bool enableUserMoves;

  /// The color type of the board
  final BoardColor boardColor;

  final PlayerColor boardOrientation;

  final VoidCallback? onMove;

  final List<BoardArrow> arrows;

  const EasternChessBoard({
    Key? key,
    required this.controller,
    this.size,
    this.enableUserMoves = true,
    this.boardColor = BoardColor.brown,
    this.boardOrientation = PlayerColor.red,
    this.onMove,
    this.arrows = const [],
  }) : super(key: key);

  @override
  State<EasternChessBoard> createState() => _EasternChessBoardState();
}

class _EasternChessBoardState extends State<EasternChessBoard> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EasternChess>(
      valueListenable: widget.controller,
      builder: (context, game, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              AspectRatio(
                child: _getBoardImage(widget.boardColor),
                aspectRatio: .9,
              ),
              AspectRatio(
                aspectRatio: 0.9,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 9),
                  itemBuilder: (context, index) {
                    if (index > 80) {
                      var debug = 1;
                    }
                    var row = index ~/ 9;
                    var column = index % 9;
                    var boardRank = widget.boardOrientation == PlayerColor.black
                        ? '${row - 1}'
                        : '${(8 - row) + 1}';
                    var boardFile = widget.boardOrientation == PlayerColor.red
                        ? '${files[column]}'
                        : '${files[9 - column]}';

                    var squareName = '$boardFile$boardRank';
                    var pieceOnSquare = game.get(squareName);

                    var piece = BoardPiece(
                      squareName: squareName,
                      game: game,
                    );

                    var draggable = game.get(squareName) != null
                        ? Draggable<PieceMoveData>(
                      child: piece,
                      feedback: piece,
                      childWhenDragging: SizedBox(),
                      data: PieceMoveData(
                        squareName: squareName,
                        pieceType:
                        pieceOnSquare?.type.toUpperCase() ?? 'P',
                        pieceColor: pieceOnSquare?.color ?? Color.RED,
                      ),
                    )
                        : Container();

                    var dragTarget =
                    DragTarget<PieceMoveData>(builder: (context, list, _) {
                      return draggable;
                    }, onWillAccept: (pieceMoveData) {
                      return widget.enableUserMoves ? true : false;
                    }, onAccept: (PieceMoveData pieceMoveData) async {
                      // A way to check if move occurred.
                      Color moveColor = game.turn;
                      widget.controller.makeMove(
                        from: pieceMoveData.squareName,
                        to: squareName,
                      );
                      if (game.turn != moveColor) {
                        widget.onMove?.call();
                      }
                    });

                    return dragTarget;
                  },
                  itemCount: 90,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
              // if (widget.arrows.isNotEmpty)
              //   IgnorePointer(
              //     child: AspectRatio(
              //       aspectRatio: 1.0,
              //       child: CustomPaint(
              //         child: Container(),
              //         painter:
              //         _ArrowPainter(widget.arrows, widget.boardOrientation),
              //       ),
              //     ),
              //   ),
            ],
          ),
        );
      },
    );
  }

  /// Returns the board image
  Image _getBoardImage(BoardColor color) {
    switch (color) {
      case BoardColor.brown:
        return Image.asset(
          "assets/images/brown_board.png",
          fit: BoxFit.cover,
        );
      case BoardColor.darkBrown:
        return Image.asset(
          "images/dark_brown_board.png",
          package: 'flutter_chess_board',
          fit: BoxFit.cover,
        );
      case BoardColor.green:
        return Image.asset(
          "images/green_board.png",
          package: 'flutter_chess_board',
          fit: BoxFit.cover,
        );
      case BoardColor.orange:
        return Image.asset(
          "assets/images/brown_board.png",
          fit: BoxFit.cover,
        );
    }
  }
}

class BoardPiece extends StatelessWidget {
  final String squareName;
  final EasternChess game;

  const BoardPiece({
    Key? key,
    required this.squareName,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget imageToDisplay;
    var square = game.get(squareName);

    if (game.get(squareName) == null) {
      return Container();
    }

    String piece = (square?.color == Color.RED ? 'r' : 'b') +
        (square?.type.toUpperCase() ?? 'P');

    switch (piece) {
      case "rP":
        imageToDisplay = WhitePawn();
        break;
      case "rR":
        imageToDisplay = WhiteRook();
        break;
      case "rN":
        imageToDisplay = WhiteKnight();
        break;
      case "rB":
        imageToDisplay = WhiteBishop();
        break;
      case "rA":
        imageToDisplay = WhiteQueen();
        break;
      case "rK":
        imageToDisplay = WhiteKing();
        break;
      case "bP":
        imageToDisplay = BlackPawn();
        break;
      case "bR":
        imageToDisplay = BlackRook();
        break;
      case "bN":
        imageToDisplay = BlackKnight();
        break;
      case "bB":
        imageToDisplay = BlackBishop();
        break;
      case "bA":
        imageToDisplay = BlackQueen();
        break;
      case "bK":
        imageToDisplay = BlackKing();
        break;
      default:
        imageToDisplay = WhitePawn();
    }

    return imageToDisplay;
  }
}

class PieceMoveData {
  final String squareName;
  final String pieceType;
  final Color pieceColor;

  PieceMoveData({
    required this.squareName,
    required this.pieceType,
    required this.pieceColor,
  });
}

class _ArrowPainter extends CustomPainter {
  List<BoardArrow> arrows;
  PlayerColor boardOrientation;

  _ArrowPainter(this.arrows, this.boardOrientation);

  @override
  void paint(Canvas canvas, Size size) {
    var blockSize = size.width / 9;
    var halfBlockSize = size.width / 18;

    for (var arrow in arrows) {
      var startFile = files.indexOf(arrow.from[0]);
      var startRank = int.parse(arrow.from[1]) - 1;
      var endFile = files.indexOf(arrow.to[0]);
      var endRank = int.parse(arrow.to[1]) - 1;

      int effectiveRowStart = 0;
      int effectiveColumnStart = 0;
      int effectiveRowEnd = 0;
      int effectiveColumnEnd = 0;

      if (boardOrientation == PlayerColor.black) {
        effectiveColumnStart = 8 - startFile;
        effectiveColumnEnd = 8 - endFile;
        effectiveRowStart = startRank;
        effectiveRowEnd = endRank;
      } else {
        effectiveColumnStart = startFile;
        effectiveColumnEnd = endFile;
        effectiveRowStart = 8 - startRank;
        effectiveRowEnd = 8 - endRank;
      }

      var startOffset = Offset(
          ((effectiveColumnStart + 1) * blockSize) - halfBlockSize,
          ((effectiveRowStart + 1) * blockSize) - halfBlockSize);
      var endOffset = Offset(
          ((effectiveColumnEnd + 1) * blockSize) - halfBlockSize,
          ((effectiveRowEnd + 1) * blockSize) - halfBlockSize);

      var yDist = 0.8 * (endOffset.dy - startOffset.dy);
      var xDist = 0.8 * (endOffset.dx - startOffset.dx);

      var paint = Paint()
        ..strokeWidth = halfBlockSize * 0.8
        ..color = arrow.color;

      canvas.drawLine(startOffset,
          Offset(startOffset.dx + xDist, startOffset.dy + yDist), paint);

      var slope =
          (endOffset.dy - startOffset.dy) / (endOffset.dx - startOffset.dx);

      var newLineSlope = -1 / slope;

      var points = _getNewPoints(
          Offset(startOffset.dx + xDist, startOffset.dy + yDist),
          newLineSlope,
          halfBlockSize);
      var newPoint1 = points[0];
      var newPoint2 = points[1];

      var path = Path();

      path.moveTo(endOffset.dx, endOffset.dy);
      path.lineTo(newPoint1.dx, newPoint1.dy);
      path.lineTo(newPoint2.dx, newPoint2.dy);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  List<Offset> _getNewPoints(Offset start, double slope, double length) {
    if (slope == double.infinity || slope == double.negativeInfinity) {
      return [
        Offset(start.dx, start.dy + length),
        Offset(start.dx, start.dy - length)
      ];
    }

    return [
      Offset(start.dx + (length / sqrt(1 + (slope * slope))),
          start.dy + ((length * slope) / sqrt(1 + (slope * slope)))),
      Offset(start.dx - (length / sqrt(1 + (slope * slope))),
          start.dy - ((length * slope) / sqrt(1 + (slope * slope)))),
    ];
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) {
    return arrows != oldDelegate.arrows;
  }
}
