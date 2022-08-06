import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class WChessBoard extends StatefulWidget {
  const WChessBoard({Key? key}) : super(key: key);

  @override
  State<WChessBoard> createState() => _WChessBoardState();
}

class _WChessBoardState extends State<WChessBoard> {
  ChessBoardController controller = ChessBoardController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ChessBoard(
                controller: controller,
                boardColor: BoardColor.orange,
                arrows: [],
                boardOrientation: PlayerColor.white,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Chess>(
              valueListenable: controller,
              builder: (context, game, _) {
                return Text(
                  controller.getSan().fold(
                    '',
                        (previousValue, element) =>
                    previousValue + '\n' + (element ?? ''),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
