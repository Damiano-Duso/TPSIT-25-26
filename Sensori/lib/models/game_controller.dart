import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/gesture_type.dart';
import '../services/accelerometer_service.dart';

enum GamePhase { idle, showingSequence, waitingInput, success, failure }

class GameController extends ChangeNotifier {
  final AccelerometerService _sensor = AccelerometerService();
  final _random = Random();

  GamePhase _phase = GamePhase.idle;
  List<GestureType> _sequence = [];
  int _inputIndex = 0;
  int _score = 0;
  int _highScore = 0;
  int _showingIndex = 0;       // index currently highlighted in preview
  GestureType? _detectedGesture;
  bool _correctFlash = false;
  bool _wrongFlash = false;

  StreamSubscription<GestureType>? _gestureSub;

  GamePhase get phase => _phase;
  List<GestureType> get sequence => _sequence;
  int get inputIndex => _inputIndex;
  int get score => _score;
  int get highScore => _highScore;
  int get showingIndex => _showingIndex;
  GestureType? get detectedGesture => _detectedGesture;
  bool get correctFlash => _correctFlash;
  bool get wrongFlash => _wrongFlash;

  /// How many gestures remain to be input this round
  int get remaining => _sequence.length - _inputIndex;

  void startGame() {
    _sequence = [];
    _inputIndex = 0;
    _score = 0;
    _sensor.start();
    _gestureSub = _sensor.onGesture.listen(_onGesture);
    _nextRound();
  }

  void _nextRound() {
    _inputIndex = 0;
    // Add one random gesture
    final pool = GestureType.values;
    _sequence.add(pool[_random.nextInt(pool.length)]);
    _phase = GamePhase.showingSequence;
    notifyListeners();
    _playSequence();
  }

  Future<void> _playSequence() async {
    await Future.delayed(const Duration(milliseconds: 600));
    for (var i = 0; i < _sequence.length; i++) {
      _showingIndex = i;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 900));
      _showingIndex = -1;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    _phase = GamePhase.waitingInput;
    notifyListeners();
  }

  void _onGesture(GestureType detected) {
    if (_phase != GamePhase.waitingInput) return;

    _detectedGesture = detected;
    notifyListeners();

    final expected = _sequence[_inputIndex];
    if (detected == expected) {
      _correctFlash = true;
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 350), () {
        _correctFlash = false;
        _inputIndex++;
        if (_inputIndex >= _sequence.length) {
          // Round complete
          _score = _sequence.length;
          if (_score > _highScore) _highScore = _score;
          _phase = GamePhase.success;
          notifyListeners();
          Future.delayed(const Duration(milliseconds: 1200), _nextRound);
        } else {
          notifyListeners();
        }
      });
    } else {
      _wrongFlash = true;
      _phase = GamePhase.failure;
      notifyListeners();
      if (_score > _highScore) _highScore = _score;
      Future.delayed(const Duration(milliseconds: 300), () {
        _wrongFlash = false;
        notifyListeners();
      });
    }
  }

  void resetToIdle() {
    _gestureSub?.cancel();
    _sensor.stop();
    _phase = GamePhase.idle;
    _sequence = [];
    _inputIndex = 0;
    _score = 0;
    _detectedGesture = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _gestureSub?.cancel();
    _sensor.dispose();
    super.dispose();
  }
}
