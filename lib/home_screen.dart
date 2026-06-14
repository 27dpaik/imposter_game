// UI for the setup screen, allows the user to pick players, number of imposters, and a category, then start
import 'package:flutter/material.dart';
import 'models.dart';
import 'word_data.dart';
import 'reveal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _players = 4;
  int _imposters = 1;
  late String _category = categories.keys.first;

  void _start() {
    final config = GameConfig(
      playerCount: _players,
      imposterCount: _imposters,
      category: _category,
    );
    final round = buildRound(config);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RevealScreen(round: round)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imposter')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              'One player is secretly the imposter.\n'
              'Pass the phone around, then talk it out and vote.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),

            // Players
            _Stepper(
              label: 'Players',
              value: _players,
              onMinus: _players > 3
                  ? () => setState(() {
                        _players--;
                        if (_imposters > _players - 1) _imposters = _players - 1;
                      })
                  : null,
              onPlus: _players < 10 ? () => setState(() => _players++) : null,
            ),
            const SizedBox(height: 16),

            // Imposters (always at least 1, and fewer than total players)
            _Stepper(
              label: 'Imposters',
              value: _imposters,
              onMinus:
                  _imposters > 1 ? () => setState(() => _imposters--) : null,
              onPlus: _imposters < _players - 1
                  ? () => setState(() => _imposters++)
                  : null,
            ),
            const SizedBox(height: 24),

            // Category
            const Text('Category'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: categories.keys
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),

            const Spacer(),
            FilledButton(
              onPressed: _start,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text('Start game'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
.
class _Stepper extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const _Stepper({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: onMinus,
              icon: const Icon(Icons.remove),
            ),
            SizedBox(
              width: 40,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton.filledTonal(
              onPressed: onPlus,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
