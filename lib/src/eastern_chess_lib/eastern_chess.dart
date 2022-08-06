library eastern_chess;

import 'package:flutter/foundation.dart';

/*
 *  Eastern chess in dart
 *  Copyright (c) 2022, Duong Hoang (hoangngocmail@gmail.com)
 *  Released under the MIT license
 *  @author: Duong Hoang
 *
 *  Based on xiangqi.js
 *  Copyright (c) 2019-2020, lengyanyu258 (lengyanyu258@outlook.com)
 *  Released under the BSD-2-Clause license
 *  https://github.com/lengyanyu258/xiangqi.js/blob/master/LICENSE
 *
 *  Inspired on chess.dart
 *  Copyright (c) 2014, David Kopec (my first name at oaksnow dot com)
 *  Released under the MIT license
 *  https://github.com/davecom/chess.dart/blob/master/LICENSE
 *
 *  Based on chess.js
 *  Copyright (c) 2013, Jeff Hlywa (jhlywa@gmail.com)
 *  Released under the BSD license
 *  https://github.com/jhlywa/chess.js/blob/master/LICENSE
 */


class EasternChess {
  static const Color BLACK = Color.BLACK;
  static const Color RED = Color.RED;

  static const EMPTY = -1;

  static const int BITS_NORMAL = 1;
  static const int BITS_CAPTURE = 2;
  static const int BITS_EP_CAPTURE = 9;

  static const int RANK_1 = 8;
  static const int RANK_2 = 7;
  static const int RANK_3 = 6;
  static const int RANK_4 = 5;
  static const int RANK_5 = 4;
  static const int RANK_6 = 3;
  static const int RANK_7 = 2;
  static const int RANK_8 = 1;
  static const int RANK_9 = 0;

  static const PAWN = PieceType.PAWN;
  static const CANNON = PieceType.CANON;
  static const ROOK = PieceType.ROOK;
  static const KNIGHT = PieceType.KNIGHT;
  static const BISHOP = PieceType.BISHOP;
  static const ADVISER = PieceType.ADVISOR;
  static const KING = PieceType.KING;

  static const Map<String, PieceType> PIECE_TYPES = {
    'p': PieceType.PAWN,
    'n': PieceType.KNIGHT,
    'b': PieceType.BISHOP,
    'r': PieceType.ROOK,
    'a': PieceType.ADVISOR,
    'k': PieceType.KING,
    'c': PieceType.CANON
  };

  static const SYMBOLS = 'pcrnbakPCRNBAK';

  static const DEFAULT_POSITION = 'rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR r - - 0 1';

  static const List POSSIBLE_RESULTS = ['1-0', '0-1', '1/2-1/2', '*'];

  static const Map<Color, List<int>> PAWN_OFFSETS = {
    BLACK: [ 0x10, -0x01, 0x01],
    RED: [-0x10, -0x01, 0x01]
  };

  static const PIECE_OFFSETS = {
    CANNON: [-0x10, 0x10, -0x01, 0x01],
    ROOK: [-0x10, 0x10, -0x01, 0x01],
    KNIGHT: [-0x20 - 0x01, -0x20 + 0x01, 0x20 - 0x01, 0x20 + 0x01,
      -0x10 - 0x02, 0x10 - 0x02, -0x10 + 0x02, 0x10 + 0x02],
    BISHOP: [-0x20 - 0x02, 0x20 + 0x02, 0x20 - 0x02, -0x20 + 0x02],
    ADVISER: [-0x10 - 0x01, 0x10 + 0x01, 0x10 - 0x01, -0x10 + 0x01],
    KING: [-0x10, 0x10, -0x01, 0x01]
  };

  static const Map<String, String> FLAGS = {
    'NORMAL': 'n',
    'CAPTURE': 'c',
    'EP_CAPTURE': 'e'
  };

  static const Map<String, int> BITS = {
    'NORMAL': BITS_NORMAL,
    'CAPTURE': BITS_CAPTURE,
    'EP_CAPTURE': BITS_EP_CAPTURE,
  };

  static const Map SQUARES = {
    'a9': 0x00, 'b9': 0x01, 'c9': 0x02, 'd9': 0x03, 'e9': 0x04, 'f9': 0x05, 'g9': 0x06, 'h9': 0x07, 'i9': 0x08,
    'a8': 0x10, 'b8': 0x11, 'c8': 0x12, 'd8': 0x13, 'e8': 0x14, 'f8': 0x15, 'g8': 0x16, 'h8': 0x17, 'i8': 0x18,
    'a7': 0x20, 'b7': 0x21, 'c7': 0x22, 'd7': 0x23, 'e7': 0x24, 'f7': 0x25, 'g7': 0x26, 'h7': 0x27, 'i7': 0x28,
    'a6': 0x30, 'b6': 0x31, 'c6': 0x32, 'd6': 0x33, 'e6': 0x34, 'f6': 0x35, 'g6': 0x36, 'h6': 0x37, 'i6': 0x38,
    'a5': 0x40, 'b5': 0x41, 'c5': 0x42, 'd5': 0x43, 'e5': 0x44, 'f5': 0x45, 'g5': 0x46, 'h5': 0x47, 'i5': 0x48,
    'a4': 0x50, 'b4': 0x51, 'c4': 0x52, 'd4': 0x53, 'e4': 0x54, 'f4': 0x55, 'g4': 0x56, 'h4': 0x57, 'i4': 0x58,
    'a3': 0x60, 'b3': 0x61, 'c3': 0x62, 'd3': 0x63, 'e3': 0x64, 'f3': 0x65, 'g3': 0x66, 'h3': 0x67, 'i3': 0x68,
    'a2': 0x70, 'b2': 0x71, 'c2': 0x72, 'd2': 0x73, 'e2': 0x74, 'f2': 0x75, 'g2': 0x76, 'h2': 0x77, 'i2': 0x78,
    'a1': 0x80, 'b1': 0x81, 'c1': 0x82, 'd1': 0x83, 'e1': 0x84, 'f1': 0x85, 'g1': 0x86, 'h1': 0x87, 'i1': 0x88,
    'a0': 0x90, 'b0': 0x91, 'c0': 0x92, 'd0': 0x93, 'e0': 0x94, 'f0': 0x95, 'g0': 0x96, 'h0': 0x97, 'i0': 0x98
  };

  static const int SQUARES_A0 = 0x90;
  static const int SQUARES_A9 = 0x00;
  static const int SQUARES_I0 = 0x98;
  static const int SQUARES_I9 = 0x08;

  // Instance Variables
  List<Piece?> board = []..length = 256;
  ColorMap<int> kings = ColorMap(EMPTY);
  Color turn = RED;
  int half_moves = 0;
  int move_number = 1;
  List<GameState> history = [];
  List<GameState> futures = [];
  Map header = {};

  /// Constructor load default position
  ///
  EasternChess() {
    load(DEFAULT_POSITION);
  }

  /// Start with a position from a FEN
  EasternChess.fromFEN(String fen) {
    load(fen);
  }

  /// Deep copy of the current Chess instance
  EasternChess copy() {
    return EasternChess()
      ..board = List<Piece?>.from(board)
      ..kings = ColorMap<int>.clone(kings)
      ..turn = turn
      ..half_moves = half_moves
      ..move_number = move_number
      ..history = List<GameState>.from(history)
      ..header = Map.from(header);
  }

  /// Reset all of the instance variables
  void clear({keep_headers = false}) {
    board = []..length = 256;
    kings = ColorMap(EMPTY);
    turn = RED;
    half_moves = 0;
    move_number = 1;
    history = [];
    futures = [];
    if (!keep_headers) header = {};
    update_setup(generate_fen());
  }

  void reset() {
    load(DEFAULT_POSITION);
  }

  /// Load a position from a FEN String
  bool load(String fen, {keep_headers = false}) {
    List tokens = fen.split(RegExp(r'\s+'));
    String position = tokens[0];

    final validMap = validate_fen(fen);

    if (!validMap['valid']) {
      print(validMap['error']);
      return false;
    }

    var square = 0;

    clear();

    for (var i = 0; i < position.length; ++i) {
      final piece = position[i];
      try {
        if (piece == '/') {
          square += 0x07;
        } else if (is_digit(piece)) {
          square += int.parse(piece, radix: 10);
        } else {
          var color = (piece == piece.toUpperCase()) ? RED : BLACK;
          var type = PIECE_TYPES[piece.toLowerCase()]!;
          put(Piece(type, color), algebraic(square));
          square++;
        }
      } catch (e) {
        var a = '';
      }
    }

    if (tokens[1] == 'r') {
      turn = RED;
    } else {
      assert(tokens[1] == 'b');
      turn = BLACK;
    }

    half_moves = int.parse(tokens[4], radix: 10);
    move_number = int.parse(tokens[5], radix: 10);

    update_setup(generate_fen());

    return true;
  }

  static Map validate_fen(fen) {
    const errors = {
      0: 'No errors.',
      1: 'FEN string must contain six space-delimited fields.',
      2: '6th field (move number) must be a positive integer.',
      3: '5th field (half move counter) must be a non-negative integer.',
      4: '4th field (en-passant square) should be \'-\'.',
      5: '3rd field (castling availability) should be \'-\'.',
      6: '2nd field (side to move) is invalid.',
      7: '1st field (piece positions) does not contain 10 \'/\'-delimited rows.',
      8: '1st field (piece positions) is invalid [consecutive numbers].',
      9: '1st field (piece positions) is invalid [invalid piece].',
      10: '1st field (piece positions) is invalid [row too large].',
      11: '1st field (piece positions) is invalid [each side has one king].',
      12: '1st field (piece positions) is invalid [each side has no more than 2 advisers].',
      13: '1st field (piece positions) is invalid [each side has no more than 2 bishops].',
      14: '1st field (piece positions) is invalid [each side has no more than 2 knights].',
      15: '1st field (piece positions) is invalid [each side has no more than 2 rooks].',
      16: '1st field (piece positions) is invalid [each side has no more than 2 cannons].',
      17: '1st field (piece positions) is invalid [each side has no more than 5 pawns].',
      18: '1st field (piece positions) is invalid [king should at palace].',
      19: '1st field (piece positions) is invalid [red adviser should at right position].',
      20: '1st field (piece positions) is invalid [black adviser should at right position].',
      21: '1st field (piece positions) is invalid [red bishop should at right position].',
      22: '1st field (piece positions) is invalid [black bishop should at right position].',
      23: '1st field (piece positions) is invalid [red pawn should at right position].',
      24: '1st field (piece positions) is invalid [black pawn should at right position].'
    };

    /* 1st criterion: 6 space-seperated fields? */
    List tokens = fen.split(RegExp(r'\s+'));

    Map result(err_num) =>
        {
          'valid': err_num == 0,
          'error_number': err_num,
          'error': errors[err_num]
        };

    if (tokens.length != 6) {
      return result(1);
    }

    /* 2nd criterion: move number field is a integer value > 0? */
    var temp = int.tryParse(tokens[5]);
    if (temp != null) {
      if (temp <= 0) {
        return result(2);
      }
    } else {
      return result(2);
    }


    /* 3rd criterion: half move counter is an integer >= 0? */
    temp = int.tryParse(tokens[4]);
    if (temp != null) {
      if (temp < 0) {
        return result(3);
      }
    } else {
      return result(3);
    }

    /* 4th criterion: 4th field is a valid e.p.-string? */
    final check4 = RegExp(r'^(-|[abcdefgh][36])$');
    if (check4.firstMatch(tokens[3]) == null) {
      return result(4);
    }

    /* 6th criterion: 2nd field is "r" (red) or "b" (black)? */
    var check6 = RegExp(r'^([rb])$');
    if (check6.firstMatch(tokens[1]) == null) {
      return result(6);
    }

    /* 7th criterion: 1st field contains 10 rows? */
    List rows = tokens[0].split('/');
    if (rows.length != 10) {
      return result(7);
    }

    /* 8th criterion: every row is valid? */
    const Map pieces = {
      'p': {'number': 0, 'squares': []}, 'P': {'number': 0, 'squares': []},
      'c': {'number': 0, 'squares': []}, 'C': {'number': 0, 'squares': []},
      'r': {'number': 0, 'squares': []}, 'R': {'number': 0, 'squares': []},
      'n': {'number': 0, 'squares': []}, 'N': {'number': 0, 'squares': []},
      'b': {'number': 0, 'squares': []}, 'B': {'number': 0, 'squares': []},
      'a': {'number': 0, 'squares': []}, 'A': {'number': 0, 'squares': []},
      'k': {'number': 0, 'squares': []}, 'K': {'number': 0, 'squares': []}
    };

    for (var i = 0; i < rows.length; i++) {
      /* check for right sum of fields AND not two numbers in succession */
      var sum_fields = 0;
      var previous_was_number = false;

      for (var k = 0; k < rows[i].length; k++) {
        final temp2 = int.tryParse(rows[i][k], radix: 10);
        if (temp2 != null) {
          if (previous_was_number) {
            return result(8);
          }
          sum_fields += temp2;
          previous_was_number = true;
        } else {
          final checkOM = RegExp(r'^[prnbakPRNBAK]$');
          if (checkOM.firstMatch(rows[i][k]) == null) {
            /// @TODO Fix
            // return result(9);
          }
          sum_fields += 1;
          previous_was_number = false;
        }
      }

      if (sum_fields != 9) {
        return result(10);
      }
    }
    /*
    /* 9th criterion: amount of each piece type is valid? */
    if (pieces['k']['number'] != 1 || pieces['K']['number'] != 1) {
      //return result(11);
    }

    if (pieces['a']['number'] > 2 || pieces['A']['number'] > 2) {
      //return result(12);
    }
    if (pieces['b']['number'] > 2 || pieces['B']['number'] > 2) {
      //return result(13);
    }
    if (pieces['n']['number'] > 2 || pieces['N']['number'] > 2) {
      //return result(14);
    }
    if (pieces['r']['number'] > 2 || pieces['R']['number'] > 2) {
      //return result(15);
    }
    if (pieces['c']['number'] > 2 || pieces['C']['number'] > 2) {
      //return result(16);
    }
    if (pieces['p']['number'] > 5 || pieces['P']['number'] > 5) {
      //return result(17);
    }

    /* 10th criterion: piece's position is valid? */
    if (out_of_place(KING, pieces['k']['squares'][0], RED) ||
        out_of_place(KING, pieces['K']['squares'][0], BLACK)) {
      return result(18);
    }

    // @TODO Finish FEN Validate
    for (i = 0; i < pieces.a.squares.length; ++i) {
      if (out_of_place(ADVISER, pieces.a.squares[i], RED)) {
        return result(19);
      }
    }
    for (i = 0; i < pieces.A.squares.length; ++i) {
      if (out_of_place(ADVISER, pieces.A.squares[i], BLACK)) {
        return result(20);
      }
    }
    for (i = 0; i < pieces.b.squares.length; ++i) {
      if (out_of_place(BISHOP, pieces.b.squares[i], RED)) {
        return result(21);
      }
    }
    for (i = 0; i < pieces.B.squares.length; ++i) {
      if (out_of_place(BISHOP, pieces.B.squares[i], BLACK)) {
        return result(22);
      }
    }
    for (i = 0; i < pieces.p.squares.length; ++i) {
      if (out_of_place(PAWN, pieces.p.squares[i], RED)) {
        return result(23);
      }
    }
    for (i = 0; i < pieces.P.squares.length; ++i) {
      if (out_of_place(PAWN, pieces.P.squares[i], BLACK)) {
        return result(24);
      }
    }
     */

    /* everything's okay! */
    return result(0);
  }

  /// Returns a FEN String representing the current position
  String generate_fen() {
    var empty = 0,
        fen = '';

    for (var i = SQUARES_A9; i <= SQUARES_I0; ++i) {
      if (board[i] == null) {
        empty++;
      } else {
        if (empty > 0) {
          fen += empty.toString();
          empty = 0;
        }
        var color = board[i]!.color;
        PieceType? type = board[i]!.type;

        fen += color == RED ? type.toUpperCase() : type.toLowerCase();
      }

      if (file(i) >= 8) {
        if (empty > 0) {
          fen += empty.toString();
        }

        if (i != SQUARES_I0) {
          fen += '/';
        }

        empty = 0;
        i += 0x07;
      }
    }

    return [fen, turn, '-', '-', half_moves, move_number].join(' ');
  }

  /// Updates [header] with the List of args and returns it
  Map set_header(args) {
    for (var i = 0; i < args.length; i += 2) {
      if (args[i] is String && args[i + 1] is String) {
        header[args[i]] = args[i + 1];
      }
    }
    return header;
  }


  /* called when the initial board setup is changed with put() or remove().
   * modifies the FEN properties of the header object.  if the FEN is equal to
   * the default position, the FEN are deleted the setup is only updated if history.
   * length is zero, ie moves haven't been made.
   */
  void update_setup(String fen) {
    if (history.isNotEmpty) return;

    if (fen != DEFAULT_POSITION) {
      header['SetUp'] = '1';
      header['FEN'] = fen;
    } else {
      header.remove('SetUp');
      header.remove('FEN');
    }
  }

  /// Returns the piece at the square in question or null
  /// if there is none
  Piece? get(String square) {
    return board[SQUARES[square]];
  }

  bool put(Piece piece, String square) {
    /* check for piece */
    if (!SYMBOLS.contains(piece.type.toLowerCase())) {
      return false;
    }

    /* check for valid square */
    if (!(SQUARES.containsKey(square))) {
      return false;
    }

    int sq = SQUARES[square];

    /* don't let the user place more than one king */
    if (piece.type == KING &&
        !(kings[piece.color] == EMPTY || kings[piece.color] == sq)) {
      return false;
    }

    if (out_of_place(piece.type, sq, piece.color)) {
      return false;
    }

    board[sq] = piece;
    if (piece.type == KING) {
      kings[piece.color] = sq;
    }

    update_setup(generate_fen());

    return true;
  }

  /// Removes a piece from a square and returns it,
  /// or null if none is present
  Piece? remove(String square) {
    final piece = get(square);
    board[SQUARES[square]] = null;
    if (piece != null && piece.type == KING) {
      kings[piece.color] = EMPTY;
    }

    update_setup(generate_fen());

    return piece;
  }

  /// Build Move object
  /// @TODO Correct EasternChess rules
  Move build_move(List<Piece?> board, from, to, flags) {
    PieceType? captured;
    final toPiece = board[to];

    if (toPiece != null) {
      captured = toPiece.type;
    }
    // else if ((flags & BITS_EP_CAPTURE) != 0) {
    //   captured = PAWN;
    // }

    return Move(turn, from, to, flags, board[from]!.type, captured);
  }

  void add_move(board, moves, from, to, flags) {
    moves.add(build_move(board, from, to, flags));
  }

  /* convert a move from 0x9a coordinates to Internet Chinese Chess Server (ICCS)
   *
   * @param {boolean} sloppy Use the sloppy ICCS generator to work around over
   * disambiguation bugs in Fritz and Chessbase.  See below:
   *
   * r1bqkbnr/ppp2ppp/2n5/1B1pP3/4P3/8/PPPP2PP/RNBQK1NR b KQkq - 2 4
   * 4. ... Nge7 is overly disambiguated because the knight on c6 is pinned
   * 4. ... Ne7 is technically the valid SAN
   */
  String move_to_iccs(Move move) {
    var output = '';

    // let disambiguator = get_disambiguator(move, sloppy);

    // if (move.piece !== PAWN) {
    //   output += move.piece.toUpperCase() + disambiguator;
    // }

    // output += algebraic(move.to);
    output = algebraic(move.from) + algebraic(move.to);

    return output;
  }

  // parses all of the decorators out of a SAN string
  String stripped_iccs(String san) {
    return san.replaceAll(RegExp(r'='), '').replaceAll(RegExp(r'[+#]?[?!]*\$'), '');
  }

  bool king_attacked(us) {
    var square = kings[us];
    var them = swap_color(us);
    var i, len, sq;

    // knight
    for (var i = 0, len = PIECE_OFFSETS[KNIGHT]!.length; i < len; ++i) {
      sq = square + PIECE_OFFSETS[KNIGHT]![i];
      if (sq < 0) {
        continue;
      }
      if (board[sq] != null && !out_of_board(sq) && board[sq]!.color == them
          && board[sq]!.type == KNIGHT
          && !hobbling_horse_leg(sq, i < 4 ? 3 - i : 11 - i)) {
          return true;
      }
    }
    // king, rook, cannon
    for (var i = 0, len = PIECE_OFFSETS[ROOK]!.length; i < len; ++i) {
      var offset = PIECE_OFFSETS[ROOK]![i];
      var crossed = false;
      for (sq = square + offset; !out_of_board(sq); sq += offset) {
        if (sq < 0) {
          continue;
        }
        var piece = board[sq];
        if (piece != null) {
          if (piece.color == them) {
            if (crossed) {
              if (piece.type == CANNON) {
                return true;
              }
            } else {
              if (piece.type == ROOK || piece.type == KING) {
                return true;
              }
            }
          }
          if (crossed)
            break;
          else
            crossed = true;
        }
      }
    }
    // pawn
    for (var i = 0, len = PAWN_OFFSETS[them]!.length; i < len; ++i) {
      sq = square - PAWN_OFFSETS[them]![i];
      if (sq < 0) {
        continue;
      }
      if (board[sq] != null && !out_of_board(sq) &&
          board[sq]!.color == them && board[sq]!.type == PAWN) {
        return true;
      }
    }

    return false;
  }

  void push(List list, Move move) {
    list.add(
        GameState(move, ColorMap.clone(kings), turn, half_moves, move_number));
  }

  void make_move(Move move) {
    final us = turn;
    final them = swap_color(us);
    push(history, move);

    // if king was captured
    if (board[move.to] != null && board[move.to]!.type == KING) {
      kings[board[move.to]!.color] = EMPTY;
    }

    board[move.to] = board[move.from];
    board[move.from] = null;

    /* if we moved the king */
    if (board[move.to]!.type == KING) {
      kings[board[move.to]!.color] = move.to;
    }

    /* reset the 60 move counter if a piece is captured */
    if ((move.flags & BITS_CAPTURE) != 0) {
      half_moves = 0;
    } else {
      half_moves++;
    }

    if (turn == BLACK) {
      move_number++;
    }
    turn = swap_color(turn);
  }

  /// Undoes a move and returns it, or null if move history is empty
  Move? undo_move() {
    if (history.isEmpty) {
      return null;
    }
    final old = history.removeLast();

    final move = old.move;
    kings = old.kings;
    turn = old.turn;
    half_moves = old.half_moves;
    move_number = old.move_number;

    final us = turn;
    final them = swap_color(turn);

    board[move.from] = board[move.to];
    board[move.from]!.type = move.piece;
    board[move.to] = null;

    if ((move.flags & BITS_CAPTURE) != 0) {
      board[move.to] = Piece(move.captured!, them);
    }

    return move;
  }

  Move? redo_move() {
    return set_move(futures.removeLast(), undo: false);
  }

  Move? set_move(old, {undo = true}) {
    if (old == null) {
      return null;
    }

    final move = old.move;
    final them = swap_color(turn);
    kings = old.kings;
    turn = old.turn;
    half_moves = old.half_moves;
    move_number = old.move_number;

    board[move.from] = board[move.to];
    board[move.from]!.type = move.piece;
    board[move.to] = null;

    if ((move.flags & BITS_CAPTURE) != 0 && undo) {
      board[move.to] = Piece(move.captured!, turn);
    } else if ((move.flags & BITS_CAPTURE) != 0 && (undo == false)) {
      board[move.to] = Piece(move.captured!, them);
    }

    return move;
  }

  /// Generate move
  List<Move> generate_moves([Map? options]) {

    List<Move> moves = [];
    var us = turn;
    var them = swap_color(us);

    final second_rank = ColorMap<int>(0);
    second_rank[BLACK] = RANK_8;
    second_rank[RED] = RANK_2;

    var first_sq = SQUARES_A9;
    var last_sq = SQUARES_I0;

    /* do we want legal moves? */
    final legal = (options != null && options.containsKey('legal'))
        ? options['legal']
        : true;
    // do we need opponent moves?
    final opponent = (options != null && options.containsKey('opponent'))
        ? options['opponent']
        : false;

    /* are we generating moves for a single square? */
    if (options != null && options.containsKey('square')) {
      if (SQUARES.containsKey(options['square'])) {
        first_sq = last_sq = SQUARES[options['square']];
      } else {
        /* invalid square */
        return [];
      }
    }

    if (opponent) {
      turn = swap_color(turn);
      us = turn;
      them = swap_color(us);
    }

    var OFFSETS, offset, square, crossed;

    for (var i = first_sq; i <= last_sq; ++i) {
      final piece = board[i];

      if (piece == null || piece.color != us) {
        continue;
      }

      OFFSETS = piece.type == PAWN ? PAWN_OFFSETS[us] : PIECE_OFFSETS[piece.type];

      for (var j = 0, len = OFFSETS.length; j < len; ++j) {
        if (piece.type == PAWN && j > 0 && !crossed_river(i, us)) {
          break;
        }

        offset = OFFSETS[j];
        square = i;
        crossed = false;

        while (true) {
          square += offset;

          if (out_of_board(square)) {
            break;
          } else if (piece.type == KNIGHT && hobbling_horse_leg(i, j)) {
            break;
          } else if (piece.type == BISHOP &&
              (blocking_elephant_eye(i, j) || crossed_river(square, us))) {
            break;
          } else if ((piece.type == ADVISER || piece.type == KING) &&
              out_of_place(piece.type, square, us)) {
            break;
          }

          if (board[square] == null) {
            if (piece.type == CANNON && crossed) {
              continue;
            }
            add_move(board, moves, i, square, BITS_NORMAL);
          } else {
            if (piece.type == CANNON) {
              if (crossed) {
                if (board[square]!.color == them) {
                  add_move(board, moves, i, square, BITS_CAPTURE);
                }
                break;
              }
              crossed = true;
            } else {
              if (board[square]!.color == us) {
                break;
              }
              if (board[square]!.color == them) {
                add_move(board, moves, i, square, BITS_CAPTURE);
                break;
              }
            }
          }

          if (piece.type != CANNON && piece.type != ROOK) {
            break;
          }
        }
      }

      if (file(i) >= 8) {
        i = i + 0x07;
      }
    }

    /* return all pseudo-legal moves (this includes moves that allow the king
     * to be captured)
     */
    if (!legal) {
      return moves;
    }

    /* filter out illegal moves */
    var legal_moves = <Move>[];
    for (var index = 0; index < moves.length; index++) {
      try {
        make_move(moves[index]);
        if (!king_attacked(us)) {
          legal_moves.add(moves[index]);
        }
        undo_move();
      } catch (e) {
        debugPrintStack();
        var a = e;
      }
    }

    // DID we need opponent moves?
    if (opponent) {
      turn = swap_color(turn);
    }

    return legal_moves;
  }

  ///The move function can be called with in the following parameters:
  ///
  /// .move('Nxb7')      <- where 'move' is a case-sensitive SAN string
  ///
  /// .move({ from: 'h7', <- where the 'move' is a move object (additional
  ///         to :'h8',      fields are ignored)
  ///      })
  move(move, Map? options) {

    // allow the user to specify the sloppy move parser to work around over
    // disambiguation bugs in Fritz and Chessbase
    bool sloppy = (options != null && (options['sloppy'] != null))
        ? options['sloppy']
        : false;

    Move? move_obj;

    if (move is String) {
      /* convert the move string to a move object */
      move_obj = move_from_iccs(move, sloppy);
    } else if (move is Map) {

      final moves = generate_moves();

      /* convert the pretty move object to an ugly move object */
      for (var i = 0, len = moves.length; i < len; i++) {
        try {
          if (move['from'] == algebraic(moves[i].from)  && move['to'] == algebraic(moves[i].to)) {
            move_obj = moves[i];
            break;
          }
        } catch(e) {
          var a = e;
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }
    } else if (move is Move) {
      move_obj = move;
    }

    /* failed to find move */
    move_obj ??= move;

    /* need to make a copy of move because we can't generate SAN after the
       * move is made
       */

    try {
      final pretty_move = make_pretty(move_obj!);
      make_move(move_obj);

      futures = [];
      return pretty_move;

    } on Exception catch (e) {
      var a = e;
    }

  }

  Map<String, dynamic>? undo() {
    final move = undo_move();
    if (move != null) {
      return make_pretty(move);
    } else {
      futures.removeLast();
      return null;
    }
  }

  Map<String, dynamic>? redo() {
    // push(history, null);
    var move = redo_move();
    if (move != null) {
      return make_pretty(move);
    } else {
      history.removeLast();
      return null;
    }
  }

  List getHistory([Map? options]) {
    final reversed_history = <Move?>[];
    final move_history = [];
    final verbose = (options != null && options.containsKey('verbose') && options['verbose'] == true);


    while (history.isNotEmpty) {
      reversed_history.add(undo_move());
    }

    while (reversed_history.isNotEmpty) {
      final move = reversed_history.removeLast()!;
      if (verbose) {
        move_history.add(make_pretty(move));
      } else {
        move_history.add(move_to_iccs(move));
      }
      make_move(move);
    }

    return move_history;
  }

  /* this function is used to uniquely identify ambiguous moves */
  String get_disambiguator(Move move, sloppy) {
    var moves = generate_moves();

    var from = move.from;
    var to = move.to;
    var piece = move.piece;

    var ambiguities = 0;
    var same_rank = 0;
    var same_file = 0;

    for (var i = 0, len = moves.length; i < len; i++) {
      var ambig_from = moves[i].from;
      var ambig_to = moves[i].to;
      var ambig_piece = moves[i].piece;

      /* if a move of the same piece type ends on the same to square, we'll
       * need to add a disambiguator to the algebraic notation
       */
      if (piece == ambig_piece && from != ambig_from && to == ambig_to) {
        ambiguities++;

        if (rank(from) == rank(ambig_from)) {
          same_rank++;
        }

        if (file(from) == file(ambig_from)) {
          same_file++;
        }
      }
    }

    if (ambiguities > 0) {
      /* if there exists a similar moving piece on the same rank and file as
       * the move in question, use the square as the disambiguator
       */
      if (same_rank > 0 && same_file > 0) {
        return algebraic(from);
      } else if (same_file > 0) {
        /* if the moving piece rests on the same file, use the rank symbol as the
       * disambiguator
       */
        return algebraic(from)[1];
      } else {
        /* else use the file symbol */
        return algebraic(from)[0];
      }
    }

    return '';
  }

  String get ascii {
    var s = '   +---------------------------+\n';
    for (var i = SQUARES_A9; i <= SQUARES_I0; i++) {
      /* display the rank */
      if (file(i) == 0) {
        s += ' ' + '9876543210'[rank(i)] + ' |';
      }

      /* empty piece */
      if (board[i] == null) {
        s += ' . ';
      } else {
        var piece = board[i]!.type;
        var color = board[i]!.color;
        var symbol = color == RED ? piece.toUpperCase() : piece.toLowerCase();
        s += ' ' + symbol + ' ';
      }

      if ((i & 0x08) != 0) {
        s += '|\n';
        i += 7;
      }
    }
    s += '   +---------------------------+\n';
    s += '     a  b  c  d  e  f  g  h  i\n';

    return s;
  }
  bool get in_check {
    return king_attacked(turn);
  }

  bool get in_checkmate {
    return in_check && generate_moves().isEmpty;
  }

  bool get in_stalemate {
    return !in_check && generate_moves().isEmpty;
  }

  bool get insufficient_material {
    // TODO: more cases
    final pieces = {};
    var num_pieces = 0;

    for (var sq = SQUARES_A9; sq <= SQUARES_I0; sq++) {
      if (SQUARES.containsKey(sq)) {
        var piece = board[SQUARES[sq]];
        if (piece != null) {
          pieces[piece.type] =
          (pieces.containsKey(piece.type)) ? pieces[piece.type] + 1 : 1;
          num_pieces++;
        }
      }
    }

    /* k vs. k */
    if (num_pieces == 2) {
      return true;
    } else if (pieces[KNIGHT] == null &&
        pieces[ROOK] == null &&
        pieces[CANNON] == null &&
        pieces[PAWN] == null) {
      return true;
    }

    return false;
  }

  bool get in_threefold_repetition {
    /* TODO: while this function is fine for casual use, a better
     * implementation would use a Zobrist key (instead of FEN). the
     * Zobrist key would be maintained in the make_move/undo_move functions,
     * avoiding the costly that we do below.
     */
    var moves = [];
    final positions = {};
    var repetition = false;

    while (true) {
      var move = undo_move();
      if (move == null) {
        break;
      }
      moves.add(move);
    }

    while (true) {
      /* remove the last four fields in the FEN string, they're not needed
       * when checking for draw by rep */
      var fen = generate_fen()
          .split(' ')
          .sublist(0, 2)
          .join(' ');

      /* has the position occurred three or move times */
      positions[fen] = (positions.containsKey(fen)) ? positions[fen] + 1 : 1;
      if (positions[fen] >= 3) {
        repetition = true;
      }

      if (moves.isEmpty) {
        break;
      }
      make_move(moves.removeLast());
    }

    return repetition;
  }

  // convert a move from Internet Chinese Chess Server (ICCS) to 0x9a coordinates
  Move? move_from_iccs(String move, sloppy) {
    // strip off any move decorations: e.g Nf3+?!
    var clean_move = stripped_iccs(move);
    // if we're using the sloppy parser run a regex to grab piece, to, and from
    // this should parse invalid ICCS like: h2e2, H7-E7

    RegExp patter = RegExp(r'([a-iA-I][0-9])-?([a-iA-I][0-9])');

    Iterable<RegExpMatch> matches = patter.allMatches(clean_move);

    var piece, from, to;
    // TODO: support sloppy (must integrate with WXF)
    if (sloppy) {
      if (matches.isNotEmpty) {
        var count = 1;
        for (final m in matches) {
          if (count > 3) {
            break;
          }
          switch (count) {
            case 1:
              piece = m[0];
              break;
            case 2:
              from = m[0];
              break;
            case 3:
              to = m[0];
              break;
            default:
              break;
          }
          count++;
        }
      }
    }

    var moves = generate_moves();

    for (var i = 0, len = moves.length; i < len; i++) {
      // try the strict parser first, then the sloppy parser if requested by the user
      if (clean_move == stripped_iccs(move_to_iccs(moves[i]))
          || (sloppy &&  clean_move == stripped_iccs(move_to_iccs(moves[i])))) {
        return moves[i];
      } else {
          if (matches.isNotEmpty && (piece != null || piece.toLowerCase() == moves[i].piece)
              && SQUARES[from] == moves[i].from && SQUARES[to] == moves[i].to) {
              return moves[i];
          }
      }
    }

    return null;
  }

  /// ***************************************************************************
  /// UTILITY FUNCTIONS*/
  static int rank(int i) {
    return i >> 4;
  }

  static int file(int i) {
    return i & 0x0f;
  }

  static String algebraic(int i) {
    final f = file(i),
        r = rank(i);
    return 'abcdefghi'.substring(f, f + 1) + '9876543210'.substring(r, r + 1);
  }

  static Color swap_color(Color c) {
    return c == RED ? BLACK : RED;
  }

  static bool is_digit(String c) {
    return '0123456789'.contains(c);
  }

  static bool crossed_river(p, c) {
    return c == RED ? rank(p) < 5 : rank(p) > 4;
  }

  static bool out_of_board(square) {
    return square < 0 || rank(square) > 9 || file(square) > 8;
  }

  static bool out_of_place(piece, square, color) {
    // K, A, B, P
    Map<String, List> side = {};

    if (piece == PAWN) {
      List<int> side1 = [0, 2, 4, 6, 8];
      if (color == RED) {
        return rank(square) > 6 ||
            (rank(square) > 4 && !side1.contains(file(square)));
      } else {
        return rank(square) < 3 ||
            (rank(square) < 5 && !side1.contains(file(square)));
      }
    } else if (piece == BISHOP) {
      side[RED.toString()] =   [0x92, 0x96, 0x70, 0x74, 0x78, 0x52, 0x56];
      side[BLACK.toString()] = [0x02, 0x06, 0x20, 0x24, 0x28, 0x42, 0x46];
    } else if (piece == ADVISER) {
      side[RED.toString()]  = [0x93, 0x95, 0x84, 0x73, 0x75];
      side[BLACK.toString()] = [0x03, 0x05, 0x14, 0x23, 0x25];
    } else if (piece == KING) {
      side[RED.toString()]  = [0x93, 0x94, 0x95, 0x83, 0x84, 0x85, 0x73, 0x74, 0x75];
      side[BLACK.toString()] = [0x03, 0x04, 0x05, 0x13, 0x14, 0x15, 0x23, 0x24, 0x25];
    } else {
      // C, R, N
      return out_of_board(square);
    }

    return !side[color.toString()]!.contains(square);
  }

  bool hobbling_horse_leg(square, index) {
    final orientation = [-0x10, 0x10, -0x01, 0x01];
    return board[square + orientation[(index/2).floor()]] != null;
  }

  bool blocking_elephant_eye(square, index) {
    final orientation = [
      -0x10 - 0x01,
      0x10 + 0x01,
      0x10 - 0x01,
      -0x10 + 0x01
    ];
    return board[square + orientation[index]] != null;
  }

  /* pretty = external move object */
  Map<String, dynamic> make_pretty(Move ugly_move) {
    final map = <String, dynamic>{};
    map['iccs'] = move_to_iccs(ugly_move);
    map['to'] = algebraic(ugly_move.to);
    map['from'] = algebraic(ugly_move.from);

    var flags = '';
    for (var flag in BITS.keys) {
      if ((BITS[flag]! & ugly_move.flags) != 0) {
        flags += FLAGS[flag]!;
      }
    }
    map['flags'] = flags;

    return map;
  }

  // function clone(obj) {
  //   let dupe = obj instanceof Array
  //   ? [] : {};
  //
  //   for (let property in obj) {
  //   if (typeof property === 'object') {
  //   dupe[property] = clone(obj[property]);
  //   } else {
  //   dupe[property] = obj[property];
  //   }
  //   }
  //
  //   return
  //   dupe;
  // }

  // function trim(str) {
  //   return str.replace(/^\s+|\s+$/g, '');
  // }

  String trim(String str) {
    return str.replaceAll(RegExp(r'^\s+|\s+$'), '');
  }

  /// DEBUGGING UTILITIES
  int perft(int? depth) {
    var moves = generate_moves({ 'legal': false});
    var nodes = 0;
    var color = turn;

    for (var i = 0, len = moves.length; i < len; i++) {
      make_move(moves[i]);
      if (!king_attacked(color)) {
        if (depth! - 1 > 0) {
          var child_nodes = perft(depth - 1);
          nodes += child_nodes;
        } else {
          nodes++;
        }
      }
      undo_move();
    }

    return nodes;
  }

  List moves([Map? options]) {
    /* The internal representation of a EasternChess move is in 0x9a format, and
       * not meant to be human-readable.  The code below converts the 0x9a
       * square coordinates to algebraic coordinates.  It also prunes an
       * unnecessary move keys resulting from a verbose call.
       */

    final ugly_moves = generate_moves(options);
    if (options != null && options.containsKey('asObjects') && options['asObjects'] == true) {
      return ugly_moves;
    }

    final moves = [];

    for (var i = 0, len = ugly_moves.length; i < len; i++) {
      // does the user want a full move object (most likely not), or just ICCS
      if (options != null && options.containsKey('verbose') && options['verbose'] == true) {
        moves.add(make_pretty(ugly_moves[i]));
      } else {
        moves.add(move_to_iccs(ugly_moves[i]));
      }
    }

    return moves;
  }


  bool get in_draw {
    return half_moves >= 120 || in_stalemate || insufficient_material || in_threefold_repetition;
  }

  bool get game_over {
    return ( half_moves >= 120 ||
             in_checkmate ||
             in_stalemate ||
             insufficient_material ||
             in_threefold_repetition ||
             kings[swap_color(turn)] == EMPTY
    );
  }

  String get fen {
    return generate_fen();
  }

  /// Origin from JS return API is board: function()
  List? get get_board {
    var output = [], row = [];

    for (var i = SQUARES_A9; i <= SQUARES_I0; i++) {
      if (board[i] == null) {
        row.add(null);
      } else {
        row.add(Piece(board[i]!.type, board[i]!.color));
      }
      if ((i & 0x08) != false) {
        output.add(row);
        row = [];
        i += 7;
      }
    }

    return output;
  }

  /// return the san string representation of each move in history. Each string corresponds to one move.
  List<String?> san_moves() {
    /* pop all of history onto reversed_history */
    var reversed_history = <Move?>[];
    while (history.isNotEmpty) {
      reversed_history.add(undo_move());
    }

    final moves = <String?>[];
    var move_string = '';
    var move_number = 1;

    /* build the list of moves.  a move_string looks like: "3. b2b6 b9c7" */
    while (reversed_history.isNotEmpty) {
      final move = reversed_history.removeLast()!;

      /* if the position started with black to move, start PGN with 1. ... */
      if (move_number == 1 && history.isEmpty && move.color == BLACK) {
        move_string += '$move_number. ...';
        move_number++;
      } else if (move.color == RED) {
        /* store the previous generated move_string if we have one */
        if (move_string.isNotEmpty) {
          moves.add(move_string);
        }

        move_string = '$move_number .';
        move_number++;
      }

      move_string = '$move_string ${move_to_iccs(move)}';
      make_move(move);
    }

    /* are there any other leftover moves? */
    if (move_string.isNotEmpty) {
      moves.add(move_string);
    }

    /* is there a result? */
    if (header['Result'] != null) {
      moves.add(header['Result']);
    }

    return moves;
  }

  String pgn([Map? options]) {
    /* using the specification from http://www.xqbase.com/protocol/cchess_pgn.htm
       * example for html usage: .pgn({ max_width: 72, newline_char: "<br />" })
       */
    final newline = (options != null && options.containsKey('newline_char') && options['newline_char'] != null) ? options['newline_char'] : '\n';
    final max_width = (options != null && options.containsKey('max_width') && options['max_width'] != null) ? options['max_width'] : 0;
    final result = [];
    var header_exists = false;

    /* add the PGN header headerrmation */
    for (var i in header.keys) {
      /* TODO: order of enumerated properties in header object is not guaranteed,
               see ECMA-262 spec (section 12.6.4)
           */
      result.add('[${i.toString()} " ${header[i].toString()}"]$newline');
      header_exists = true;
    }

    if (header_exists && (history.isNotEmpty)) {
      result.add(newline);
    }

    final moves = san_moves();

    /* history should be back to what is was before we started generating PGN,
       * so join together moves
       */
    if (max_width == 0) {
      return result.join('') + moves.join(' ');
    }

    /* wrap the PGN output at max_width */
    var current_width = 0;
    for (var i = 0; i < moves.length; i++) {
      /* if the current move will push past max_width */
      if (current_width + moves[i]!.length > max_width && i != 0) {
        /* don't end the line with whitespace */
        if (result[result.length - 1] == ' ') {
          result.removeLast();
        }

        result.add(newline);
        current_width = 0;
      } else if (i != 0) {
        result.add(' ');
        current_width++;
      }

      result.add(moves[i]);
      current_width += moves[i]!.length;
    }

    return result.join('');
  }

  /// Load the moves of a game stored in Portable Game Notation.
  /// [options] is an optional parameter that contains a 'newline_char'
  /// which is a string representation of a RegExp (and should not be pre-escaped)
  /// and defaults to '\r?\n').
  /// Returns [true] if the PGN was parsed successfully, otherwise [false].
  bool load_pgn(String? pgn, [Map? options]) {
    // allow the user to specify the sloppy move parser to work around over
    // disambiguation bugs in Fritz and Chessbase
    bool sloppy = (options != null && (options['sloppy'] != null)) ? options['sloppy'] : false;

    String mask(str) {
      return str.replaceAll(RegExp(r'\\'), '\\');
    }


    Map<String, String> parse_pgn_header(header, [Map? options]) {
      final newline_char = (options != null && options.containsKey('newline_char')) ? options['newline_char'] : '\r?\n';
      final header_obj = <String, String>{};
      final headers = header.split(RegExp(newline_char));
      var key = '';
      var value = '';

      for (var i = 0; i < headers.length; i++) {
        var keyMatch = RegExp(r'^\[([A-Z][A-Za-z]*)\s.*\]$');
        var temp = keyMatch.firstMatch(headers[i]);
        if (temp != null) {
          key = temp[1]!;
        }
        //print(key);
        var valueMatch = RegExp(r'^\[[A-Za-z]+\s"(.*)"\]$');
        temp = valueMatch.firstMatch(headers[i]);
        if (temp != null) {
          value = temp[1]!;
        }
        //print(value);
        if (trim(key).isNotEmpty) {
          header_obj[key] = value;
        }
      }

      return header_obj;
    }

    final newline_char = (options != null && options.containsKey('newline_char')) ? options['newline_char'] : '\r?\n';

    // RegExp to split header. Takes advantage of the fact that header and movetext
    // will always have a blank line between them (ie, two newline_char's).
    // With default newline_char, will equal: /^(\[((?:\r?\n)|.)*\])(?:\r?\n){2}/
    final indexOfMoveStart = pgn!.indexOf(RegExp(newline_char + r'1\.'));

    /* get header part of the PGN file */
    String? header_string;
    if (indexOfMoveStart != -1) {
      header_string = pgn.substring(0, indexOfMoveStart).trim();
    }

    /* no info part given, begins with moves */
    if (header_string == null || header_string[0] != '[') {
      header_string = '';
    }

    reset();

    /* parse PGN header */
    final headers = parse_pgn_header(header_string, options);
    for (var key in headers.keys) {
      set_header([key, headers[key]]);
    }


    /* load the starting position indicated by [FEN position] */
    if (headers.containsKey('FEN')) {
      if (!load(headers['FEN']!, keep_headers: true)) {
        // second argument to load: don't clear the headers
        return false;
      }
    }

    /* delete header to get the moves */
    var ms = pgn.replaceAll(header_string, '').replaceAll(RegExp(mask(newline_char)), ' ');

    /* delete comments */
    ms = ms.replaceAll(RegExp(r'({[^}]+\})+?'), '');

    /* delete recursive annotation variations */
    // RegExp rav_regex = RegExp(r'(\([^()]+\))+?');

    // if (rav_regex.hasMatch(ms!)) {
    //     ms = ms.replaceAll(rav_regex, '');
    // }

    /* delete move numbers */
    ms = ms.replaceAll(RegExp(r'\d+\.'), '');

    /* delete ... indicating black to move */
    ms = ms.replaceAll(RegExp(r'\.\.\.'), '');

    /* delete numeric annotation glyphs */
    ms = ms.replaceAll(RegExp(r'\$\d+'), '');

    /* trim and get array of moves */
    var moves = trim(ms).split(RegExp(r'\s+'));

    /* delete empty entries */
    moves = moves.join(',').replaceAll(RegExp(r',,+'), ',').split(',');
    var move;

    for (var half_move = 0; half_move < moves.length - 1; half_move++) {
      move = move_from_iccs(moves[half_move], sloppy);

      /* move not possible! (don't clear the board to examine to show the
           * latest valid position)
           */
      if (move == null) {
        return false;
      } else {
        make_move(move);
      }
    }

    /* examine last move */
    move = moves[moves.length - 1];
    if (POSSIBLE_RESULTS.contains(move)) {
      if (!header.containsKey('Result')) {
        set_header(['Result', move]);
      }
    } else {
      move = move_from_iccs(move, sloppy);
      if (move == null) {
        return false;
      } else {
        make_move(move);
      }
    }
    return true;
  }

}

class Piece {
  PieceType type;
  final Color color;
  Piece(this.type, this.color);
}

class PieceType {
  final int shift;
  final String name;
  const PieceType._internal(this.shift, this.name);

  static const PieceType PAWN = PieceType._internal(0, 'p');
  static const PieceType KNIGHT = PieceType._internal(1, 'n');
  static const PieceType BISHOP = PieceType._internal(2, 'b');
  static const PieceType ROOK = PieceType._internal(3, 'r');
  static const PieceType KING = PieceType._internal(4, 'k');
  static const PieceType CANON = PieceType._internal(5, 'c');
  static const PieceType ADVISOR = PieceType._internal(6, 'a');

  @override
  int get hashCode => shift;
  @override
  String toString() => name;
  String toLowerCase() => name;
  String toUpperCase() => name.toUpperCase();
}

enum Color {
  RED,
  BLACK
}

class ColorMap<T> {
  T _red;
  T _black;
  ColorMap(T value)
      : _red = value,
        _black = value;
  ColorMap.clone(ColorMap other)
      : _red = other._red,
        _black = other._black;

  T operator [](Color color) {
    return (color == Color.RED) ? _red : _black;
  }

  void operator []=(Color color, T value) {
    if (color == Color.RED) {
      _red = value;
    } else {
      _black = value;
    }
  }
}

class Move {
  final Color color;
  final int from;
  final int to;
  final int flags;
  final PieceType piece;
  final PieceType? captured;
  const Move(
      this.color,
      this.from,
      this.to,
      this.flags,
      this.piece,
      this.captured);

  String get fromAlgebraic {
    return EasternChess.algebraic(from);
  }

  String get toAlgebraic {
    return EasternChess.algebraic(to);
  }
}

class GameState {
  final Move move;
  final ColorMap<int> kings;
  final Color turn;
  final int half_moves;
  final int move_number;
  const GameState(this.move, this.kings, this.turn, this.half_moves, this.move_number);
}
