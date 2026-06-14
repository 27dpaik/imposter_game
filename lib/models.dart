// Shared data classes used across the app.

class GameConfig {
  final int playerCount;
  final int imposterCount;
  final String category;

  const GameConfig({
    required this.playerCount,
    required this.imposterCount,
    required this.category,
  });
}

/// A single playable round: the secret word plus who the imposters are.
/// `isImposter[i]` is true if player i is an imposter.
class GameRound {
  final String secretWord;
  final String category;
  final List<bool> isImposter;

  const GameRound({
    required this.secretWord,
    required this.category,
    required this.isImposter,
  });

  int get playerCount => isImposter.length;

  List<int> get imposterNumbers {
    final result = <int>[];
    for (var i = 0; i < isImposter.length; i++) {
      if (isImposter[i]) result.add(i + 1);
    }
    return result;
  }
}
