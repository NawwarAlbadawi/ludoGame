class GameState {
  final List<List<int>> pawnPositions;

  GameState(this.pawnPositions);

  GameState.copy(GameState other)
      : pawnPositions = List<List<int>>.from(
          other.pawnPositions.map((positions) => List<int>.from(positions)),
        );
  bool isGameOver() {
    for (int playerIndex = 0; playerIndex < 4; playerIndex++) {
      if (pawnPositions[playerIndex].every((position) => position == 57)) {
        return true;
      }
    }
    return false;
  }

  GameState simulateMove(int playerIndex, int pawnIndex, int diceRoll) {
    GameState newState = GameState.copy(this);
    newState.pawnPositions[playerIndex][pawnIndex] += diceRoll;
    return newState;
  }

  bool isValidMove(int playerIndex, int pawnIndex, int diceRoll) {
    int currentPosition = pawnPositions[playerIndex][pawnIndex];

    if (currentPosition == 0 && diceRoll != 6) {
      return false; // Pawn cannot move out of home unless dice roll is 6
    }
    if (currentPosition + diceRoll > 57) {
      return false; // Pawn cannot move beyond the destination
    }
    return true;
  }

  void printState() {
    for (int playerIndex = 0; playerIndex < 4; playerIndex++) {
      print('Player $playerIndex: ${pawnPositions[playerIndex]}');
    }
  }
}
