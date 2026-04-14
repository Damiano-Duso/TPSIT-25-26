import 'package:flutter/material.dart';
import '../models/game_controller.dart';
import '../models/gesture_type.dart';
import 'gesture_card.dart';

class SequencePreview extends StatelessWidget {
  final GameController ctrl;
  const SequencePreview({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final sequence = ctrl.sequence;
    final highlighting = ctrl.showingIndex;
    final cardSize = sequence.length <= 4 ? 90.0 : 72.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: List.generate(sequence.length, (i) {
          final gesture = GameGesture.byType(sequence[i]);
          return Column(
            children: [
              GestureCard(
                gesture: gesture,
                isHighlighted: highlighting == i,
                dimmed: highlighting != -1 && highlighting != i,
                size: cardSize,
              ),
              const SizedBox(height: 4),
              Text(
                '${i + 1}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 11,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
