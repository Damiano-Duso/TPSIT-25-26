// Import delle librerie necessarie
import 'package:flutter/material.dart';
import '../models/game_controller.dart';
import 'game_screen.dart';

// Schermata iniziale dell'app Replica Sequenza
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / title
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFFE91E63)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.vibration_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Replica Sequenza',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Osserva la sequenza e\nreplica con il tuo telefono!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),

                // Gesture legend
                _GestureLegend(),

                const SizedBox(height: 48),

                // Start button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => _startGame(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'INIZIA IL GIOCO',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Metodo per avviare il gioco e navigare alla schermata di gioco
  void _startGame(BuildContext context) {
    final controller = GameController();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(controller: controller),
      ),
    );
  }
}

class _GestureLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lista dei gesti con icona, colore e descrizione
    final gestures = [
      (Icons.arrow_back_rounded, const Color(0xFF4CAF50), 'Inclina sinistra'),
      (Icons.arrow_forward_rounded, const Color(0xFF2196F3), 'Inclina destra'),
      (Icons.arrow_upward_rounded, const Color(0xFFFF9800), 'Inclina avanti'),
      (Icons.vibration_rounded, const Color(0xFFE91E63), 'Scuoti'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            'I GESTI',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: gestures
                .map((g) => _LegendItem(icon: g.$1, color: g.$2, label: g.$3))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// Widget per rappresentare un singolo elemento della legenda dei gesti
class _LegendItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _LegendItem({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
