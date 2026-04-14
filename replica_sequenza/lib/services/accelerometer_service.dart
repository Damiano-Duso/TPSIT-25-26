import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/gesture_type.dart';

/// Thresholds for gesture detection
const double _kTiltThreshold = 5.5;    // m/s² lateral tilt
const double _kForwardThreshold = 6.0;  // m/s² forward tilt
const double _kShakeThreshold = 22.0;   // m/s² shake magnitude (relative to gravity)
const int _kCooldownMs = 800;           // ms between gesture detections

class AccelerometerService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  final _gestureController = StreamController<GestureType>.broadcast();

  /// Emits a [GestureType] every time a valid gesture is detected.
  Stream<GestureType> get onGesture => _gestureController.stream;

  DateTime _lastDetection = DateTime(2000);

  // Rolling window for shake detection
  final List<double> _magnitudeWindow = [];
  static const int _windowSize = 5;

  void start() {
    _subscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.gameInterval,
    ).listen(_onEvent);
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _magnitudeWindow.clear();
  }

  void _onEvent(AccelerometerEvent e) {
    final now = DateTime.now();
    if (now.difference(_lastDetection).inMilliseconds < _kCooldownMs) return;

    final x = e.x; // positive = right, negative = left
    final y = e.y; // positive = forward (top tilt), negative = backward
    final z = e.z;

    // ── Shake detection via magnitude deviation ──────────────────────────────
    final magnitude = sqrt(x * x + y * y + z * z);
    _magnitudeWindow.add(magnitude);
    if (_magnitudeWindow.length > _windowSize) _magnitudeWindow.removeAt(0);

    if (_magnitudeWindow.length == _windowSize) {
      final avg = _magnitudeWindow.reduce((a, b) => a + b) / _windowSize;
      final deviation = (magnitude - avg).abs();
      if (deviation > _kShakeThreshold) {
        _emit(GestureType.shake, now);
        return;
      }
    }

    // ── Tilt detection ───────────────────────────────────────────────────────
    // Priority: dominant axis wins
    if (x.abs() > y.abs()) {
      if (x > _kTiltThreshold) {
        _emit(GestureType.tiltRight, now);
      } else if (x < -_kTiltThreshold) {
        _emit(GestureType.tiltLeft, now);
      }
    } else {
      if (y < -_kForwardThreshold) {
        _emit(GestureType.tiltForward, now);
      }
    }
  }

  void _emit(GestureType type, DateTime now) {
    _lastDetection = now;
    _gestureController.add(type);
  }

  void dispose() {
    stop();
    _gestureController.close();
  }
}
