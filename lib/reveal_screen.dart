//each player taps to see their word, then discussion + result.

import 'package:flutter/material.dart';
import 'models.dart';

enum _Phase { hidden, revealed, discussion, result }

class RevealScreen extends StatefulWidget {
  final GameRound round;
  const RevealScreen({super.key, required this.round});

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  int _currentPlayer = 0; 
  _Phase _phase = _Phase.hidden;

  bool get _isLastPlayer => _currentPlayer >= widget.round.playerCount - 1;

  void _reveal() => setState(() => _phase = _Phase.revealed);

  void _next() {
    setState(() {
      if (_isLastPlayer) {
        _phase = _Phase.discussion;
      } else {
        _currentPlayer++;
        _phase = _Phase.hidden;
      }
    });
  }

  void _showResult() => setState(() => _phase = _Phase.result);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imposter')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_phase) {
      case _Phase.hidden:
        return _HiddenView(
          playerNumber: _currentPlayer + 1,
          onReveal: _reveal,
        );
      case _Phase.revealed:
        return _RevealedView(
          isImposter: widget.round.isImposter[_currentPlayer],
          secretWord: widget.round.secretWord,
          category: widget.round.category,
          isLastPlayer: _isLastPlayer,
          onNext: _next,
        );
      case _Phase.discussion:
        return _DiscussionView(onReveal: _showResult);
      case _Phase.result:
        return _ResultView(
          round: widget.round,
          onPlayAgain: () => Navigator.pop(context),
        );
    }
  }
}

class _HiddenView extends StatelessWidget {
  final int playerNumber;
  final VoidCallback onReveal;
  const _HiddenView({required this.playerNumber, required this.onReveal});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.phone_iphone,
            size: 64, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 24),
        Text('Player $playerNumber',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Pass the phone to this player.'),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: onReveal,
          child: const Text('Tap to reveal'),
        ),
      ],
    );
  }
}

class _RevealedView extends StatelessWidget {
  final bool isImposter;
  final String secretWord;
  final String category;
  final bool isLastPlayer;
  final VoidCallback onNext;

  const _RevealedView({
    required this.isImposter,
    required this.secretWord,
    required this.category,
    required this.isLastPlayer,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isImposter) ...[
          Text('You are the',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('IMPOSTER',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: scheme.error,
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 16),
          Text('Category: $category\nBlend in and don\'t get caught.',
              textAlign: TextAlign.center),
        ] else ...[
          Text('Your word',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(secretWord,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  )),
        ],
        const SizedBox(height: 40),
        FilledButton.tonal(
          onPressed: onNext,
          child: Text(isLastPlayer ? 'Hide & start discussion' : 'Hide & pass'),
        ),
      ],
    );
  }
}

class _DiscussionView extends StatelessWidget {
  final VoidCallback onReveal;
  const _DiscussionView({required this.onReveal});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.forum, size: 64),
        const SizedBox(height: 24),
        Text('Discuss!', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        const Text(
          'Take turns giving one clue about your word.\n'
          'The imposter is faking it. Then vote on who you think it is.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: onReveal,
          child: const Text('Reveal the answer'),
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  final GameRound round;
  final VoidCallback onPlayAgain;
  const _ResultView({required this.round, required this.onPlayAgain});

  @override
  Widget build(BuildContext context) {
    final numbers = round.imposterNumbers;
    final label = numbers.length == 1
        ? 'The imposter was Player ${numbers.first}'
        : 'The imposters were Players ${numbers.join(', ')}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.flag, size: 64),
        const SizedBox(height: 24),
        Text(label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Text('The word was "${round.secretWord}"',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 40),
        FilledButton(
          onPressed: onPlayAgain,
          child: const Text('Play again'),
        ),
      ],
    );
  }
}
