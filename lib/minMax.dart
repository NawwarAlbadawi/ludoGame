// import 'dart:math';
//
// class Minimax {
//   final int depth;
//
//   Minimax({this.depth = 3});
//   double evaluateState(List<List<int>> pawnPositions, int playerIndex) {
//     double score = 0;
//     for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
//       int position = pawnPositions[playerIndex][pawnIndex];
//       if (position == 0) {
//         score -= 10; // Penalize pawns still in the home area
//       } else {
//         score += position; // Reward pawns closer to the destination
//       }
//     }
//     return score;
//   }
//
//   int getBestMove(
//       List<List<int>> pawnPositions, int playerIndex, int diceRoll) {
//     print('min$diceRoll');
//     int bestMove = -1;
//     double bestScore = double.negativeInfinity;
//     pawnPositions.forEach((v) {
//       print(v);
//     });
//     for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
//       if (_isValidMove(pawnPositions, playerIndex, pawnIndex, diceRoll)) {
//         List<List<int>> newState =
//             _simulateMove(pawnPositions, playerIndex, pawnIndex, diceRoll);
//         double score = _minimax(newState, depth - 1, false, playerIndex);
//         if (score > bestScore) {
//           bestScore = score;
//           bestMove = pawnIndex;
//         }
//       }
//     }
//
//     return bestMove;
//   }
//
//   double _minimax(
//       List<List<int>> state, int depth, bool isMaximizing, int playerIndex) {
//     if (depth == 0 || _isGameOver(state)) {
//       return evaluateState(state, playerIndex);
//     }
//
//     if (isMaximizing) {
//       double maxEval = double.negativeInfinity;
//       for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
//         if (_isValidMove(state, playerIndex, pawnIndex, 6)) {
//           // Assume dice roll of 6 for simplicity
//           List<List<int>> newState =
//               _simulateMove(state, playerIndex, pawnIndex, 6);
//           double eval = _minimax(newState, depth - 1, false, playerIndex);
//           maxEval = max(maxEval, eval);
//         }
//       }
//       return maxEval;
//     } else {
//       double minEval = double.infinity;
//       for (int opponentIndex = 0; opponentIndex < 4; opponentIndex++) {
//         if (opponentIndex != playerIndex) {
//           for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
//             if (_isValidMove(state, opponentIndex, pawnIndex, 6)) {
//               List<List<int>> newState =
//                   _simulateMove(state, opponentIndex, pawnIndex, 6);
//
//               double eval = _minimax(newState, depth - 1, true, playerIndex);
//               minEval = min(minEval, eval);
//             }
//           }
//         }
//       }
//       return minEval;
//     }
//   }
//
//   bool _isValidMove(List<List<int>> pawnPositions, int playerIndex,
//       int pawnIndex, int diceRoll) {
//     int currentPosition = pawnPositions[playerIndex][pawnIndex];
//
//     if (currentPosition == 0 && diceRoll != 6)
//       return false; // Pawn cannot move out of home
//     if (currentPosition + diceRoll > 57)
//       return false; // Pawn cannot move beyond the destination
//     return true;
//   }
//
//   List<List<int>> _simulateMove(List<List<int>> pawnPositions, int playerIndex,
//       int pawnIndex, int diceRoll) {
//     List<List<int>> newState = List<List<int>>.from(
//         pawnPositions.map((positions) => List<int>.from(positions)));
//     newState[playerIndex][pawnIndex] += diceRoll;
//     newState.forEach((v) {
//       print(v);
//     });
//     return newState;
//   }
//
//   bool _isGameOver(List<List<int>> pawnPositions) {
//     for (int playerIndex = 0; playerIndex < 4; playerIndex++) {
//       if (pawnPositions[playerIndex].every((position) => position == 57)) {
//         return true;
//       }
//     }
//     return false;
//   }
// }

import 'dart:math';

import 'game_state.dart';

class Minimax {
  final int depth;

  Minimax({this.depth = 3});

  // Evaluate the state for a given player
  double evaluateState(GameState state, int playerIndex) {
    double score = 0;
    for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
      int position = state.pawnPositions[playerIndex][pawnIndex];
      if (position == 0) {
        score -= 10; // Penalize pawns still in the home area
      } else {
        score += position; // Reward pawns closer to the destination
      }
    }
    return score;
  }

  int getBestMove(GameState state, int playerIndex, int diceRoll) {
    print('Dice Roll: $diceRoll');
    state.printState();

    int bestMove = -1;
    double bestScore = double.negativeInfinity;

    for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
      if (state.isValidMove(playerIndex, pawnIndex, diceRoll)) {
        GameState newState =
            state.simulateMove(playerIndex, pawnIndex, diceRoll);
        double score = _minimax(newState, depth - 1, false, playerIndex);
        if (score > bestScore) {
          bestScore = score;
          bestMove = pawnIndex;
        }
      }
    }

    return bestMove;
  }

  double _minimax(
      GameState state, int depth, bool isMaximizing, int playerIndex) {
    if (depth == 0 || state.isGameOver()) {
      return evaluateState(state, playerIndex);
    }

    if (isMaximizing) {
      double maxEval = double.negativeInfinity;
      for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
        if (state.isValidMove(playerIndex, pawnIndex, 6)) {
          GameState newState = state.simulateMove(playerIndex, pawnIndex, 6);
          double eval = _minimax(newState, depth - 1, false, playerIndex);
          maxEval = max(maxEval, eval);
        }
      }
      return maxEval;
    } else {
      double minEval = double.infinity;
      for (int opponentIndex = 0; opponentIndex < 4; opponentIndex++) {
        if (opponentIndex != playerIndex) {
          for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++) {
            if (state.isValidMove(opponentIndex, pawnIndex, 6)) {
              GameState newState =
                  state.simulateMove(opponentIndex, pawnIndex, 6);
              double eval = _minimax(newState, depth - 1, true, playerIndex);
              minEval = min(minEval, eval);
            }
          }
        }
      }
      return minEval;
    }
  }
}
