import 'package:flutter/material.dart';
import '../eastern_chess_lib/flutter_eastern_chess_board.dart';

class EastChessBoard extends StatefulWidget {
  const EastChessBoard({Key? key}) : super(key: key);

  @override
  State<EastChessBoard> createState() => _EastChessBoardState();
}

class _EastChessBoardState extends State<EastChessBoard> {
  EasternChessBoardController controller = EasternChessBoardController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eastern Chess'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: EasternChessBoard(
                controller: controller,
                boardColor: BoardColor.orange,
                arrows: [
                  BoardArrow(
                    from: 'd2',
                    to: 'd4',
                    //color: Colors.red.withOpacity(0.5),
                  ),
                  BoardArrow(
                    from: 'e7',
                    to: 'e5',
                    color: Colors.red.withOpacity(0.7),
                  ),
                ],
                boardOrientation: PlayerColor.red,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<EasternChess>(
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
