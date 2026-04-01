import 'package:flutter/material.dart';

enum GestureType {
  tiltRight,
  tiltLeft,
  tiltForward,
  shake,
}

class GameGesture {
  final GestureType type;
  final String label;
  final String emoji;
  final String instruction;
  final Color color;
  final IconData icon;

  const GameGesture({
    required this.type,
    required this.label,
    required this.emoji,
    required this.instruction,
    required this.color,
    required this.icon,
  });

  static const all = [
    GameGesture(
      type: GestureType.tiltRight,
      label: 'Destra',
      emoji: '➡️',
      instruction: 'Inclina a DESTRA',
      color: Color(0xFF4CAF50),
      icon: Icons.arrow_forward_rounded,
    ),
    GameGesture(
      type: GestureType.tiltLeft,
      label: 'Sinistra',
      emoji: '⬅️',
      instruction: 'Inclina a SINISTRA',
      color: Color(0xFF2196F3),
      icon: Icons.arrow_back_rounded,
    ),
    GameGesture(
      type: GestureType.tiltForward,
      label: 'Avanti',
      emoji: '⬆️',
      instruction: 'Inclina in AVANTI',
      color: Color(0xFFFF9800),
      icon: Icons.arrow_upward_rounded,
    ),
    GameGesture(
      type: GestureType.shake,
      label: 'Scuoti',
      emoji: '📳',
      instruction: 'SCUOTI il telefono',
      color: Color(0xFFE91E63),
      icon: Icons.vibration_rounded,
    ),
  ];

  static GameGesture byType(GestureType t) => all.firstWhere((g) => g.type == t);
}
