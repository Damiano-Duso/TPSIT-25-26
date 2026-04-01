import 'package:flutter/material.dart';
import '../models/game_controller.dart';
import '../models/gesture_type.dart';
import '../widgets/gesture_card.dart';
import '../widgets/sequence_preview.dart';
import '../widgets/status_header.dart';

class GameScreen extends StatefulWidget {
  final GameController controller;
  const GameScreen({super.key, required this.controller});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late Animation<Color?> _bgColor;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bgColor = ColorTween(
      begin: const Color(0xFF0D0D1A),
      end: const Color(0xFF0D0D1A),
    ).animate(_bgController);

    widget.controller.addListener(_onGameUpdate);
    widget.controller.startGame();
  }

  void _onGameUpdate() {
    if (!mounted) return;
    final phase = widget.controller.phase;
    if (phase == GamePhase.failure) {
      _flashBackground(const Color(0xFFD32F2F));
    } else if (widget.controller.correctFlash) {
      _flashBackground(const Color(0xFF1B5E20));
    }
    setState(() {});
  }

  void _flashBackground(Color color) {
    _bgColor = ColorTween(
      begin: color.withOpacity(0.3),
      end: const Color(0xFF0D0D1A),
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeOut));
    _bgController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _bgController.dispose();
    widget.controller.removeListener(_onGameUpdate);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;
    final phase = ctrl.phase;

    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _bgColor.value ?? const Color(0xFF0D0D1A),
          body: SafeArea(child: child!),
        );
      },
      child: _buildBody(context, ctrl, phase),
    );
  }

  Widget _buildBody(BuildContext context, GameController ctrl, GamePhase phase) {
    if (phase == GamePhase.failure) {
      return _GameOverPanel(ctrl: ctrl);
    }

    return Column(
      children: [
        // ── Top bar ────────────────────────────────────────────────────────
        StatusHeader(ctrl: ctrl),

        const Spacer(),

        // ── Phase content ──────────────────────────────────────────────────
        if (phase == GamePhase.showingSequence) ...[
          _PhaseLabel(
            icon: Icons.visibility_rounded,
            text: 'Guarda la sequenza…',
            color: const Color(0xFF6C63FF),
          ),
          const SizedBox(height: 24),
          SequencePreview(ctrl: ctrl),
        ],

        if (phase == GamePhase.waitingInput) ...[
          _PhaseLabel(
            icon: Icons.touch_app_rounded,
            text: 'Ora tocca a te!',
            color: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 8),
          Text(
            'Gesto ${ctrl.inputIndex + 1} di ${ctrl.sequence.length}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 28),
          // Show the next expected gesture as a hint card
          GestureCard(
            gesture: GameGesture.byType(ctrl.sequence[ctrl.inputIndex]),
            isHighlighted: true,
            size: 160,
          ),
          const SizedBox(height: 20),
          // Input progress dots
          _ProgressDots(ctrl: ctrl),
        ],

        if (phase == GamePhase.success) ...[
          _PhaseLabel(
            icon: Icons.check_circle_rounded,
            text: '✅ Perfetto!',
            color: const Color(0xFF4CAF50),
          ),
        ],

        if (phase == GamePhase.idle) ...[
          const CircularProgressIndicator(),
        ],

        const Spacer(),

        // ── Bottom info ────────────────────────────────────────────────────
        if (phase == GamePhase.waitingInput) _LiveAccelInfo(ctrl: ctrl),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _PhaseLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _PhaseLabel({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ProgressDots extends StatelessWidget {
  final GameController ctrl;
  const _ProgressDots({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(ctrl.sequence.length, (i) {
        final done = i < ctrl.inputIndex;
        final current = i == ctrl.inputIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: current ? 24 : 10,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: done
                ? const Color(0xFF4CAF50)
                : current
                    ? const Color(0xFF6C63FF)
                    : Colors.white.withOpacity(0.2),
          ),
        );
      }),
    );
  }
}

class _LiveAccelInfo extends StatelessWidget {
  final GameController ctrl;
  const _LiveAccelInfo({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final detected = ctrl.detectedGesture;
    if (detected == null) {
      return Text(
        'In attesa di un gesto…',
        style: TextStyle(
          color: Colors.white.withOpacity(0.3),
          fontSize: 13,
        ),
      );
    }
    final g = GameGesture.byType(detected);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(g.icon, color: g.color, size: 18),
        const SizedBox(width: 6),
        Text(
          'Rilevato: ${g.label}',
          style: TextStyle(color: g.color, fontSize: 13),
        ),
      ],
    );
  }
}

class _GameOverPanel extends StatelessWidget {
  final GameController ctrl;
  const _GameOverPanel({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💀', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 24),
            _ScoreBadge(
              label: 'PUNTEGGIO',
              value: ctrl.score,
              color: const Color(0xFFE91E63),
            ),
            const SizedBox(height: 12),
            _ScoreBadge(
              label: 'RECORD',
              value: ctrl.highScore,
              color: const Color(0xFFFFD700),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  ctrl.startGame();
                },
                icon: const Icon(Icons.replay_rounded),
                label: const Text(
                  'RIGIOCA',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Torna al menu',
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ScoreBadge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 13,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
