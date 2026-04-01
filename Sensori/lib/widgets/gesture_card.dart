import 'package:flutter/material.dart';
import '../models/gesture_type.dart';

class GestureCard extends StatelessWidget {
  final GameGesture gesture;
  final bool isHighlighted;
  final double size;
  final bool dimmed;

  const GestureCard({
    super.key,
    required this.gesture,
    this.isHighlighted = false,
    this.size = 100,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = gesture.color;
    final opacity = dimmed ? 0.3 : 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        color: isHighlighted
            ? color.withOpacity(0.25)
            : color.withOpacity(0.08 * opacity),
        border: Border.all(
          color: isHighlighted
              ? color
              : color.withOpacity(0.35 * opacity),
          width: isHighlighted ? 3 : 1.5,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: color.withOpacity(0.45),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            gesture.icon,
            color: color.withOpacity(opacity),
            size: size * 0.42,
          ),
          const SizedBox(height: 6),
          Text(
            gesture.label,
            style: TextStyle(
              color: color.withOpacity(opacity),
              fontSize: size * 0.12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
