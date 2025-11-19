import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronometro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CronometroPage(),
    );
  }
}

class CronometroPage extends StatefulWidget {
  @override
  _CronometroPageState createState() => _CronometroPageState();
}

class _CronometroPageState extends State<CronometroPage> {
  // Stream controller per i tick (ogni 100ms)
  StreamController<int> _tickController = StreamController<int>.broadcast();
  
  // Stream controller per i secondi
  StreamController<int> _secondsController = StreamController<int>.broadcast();
  
  Timer? _tickTimer;
  int _totalTicks = 0;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  
  @override
  void initState() {
    super.initState();
    _setupStreams();
  }
  
  void _setupStreams() {
    // Lo stream dei tick ascolta e ogni 10 tick (1 secondo) genera un evento secondi
    int tickCount = 0;
    _tickController.stream.listen((tick) {
      tickCount++;
      if (tickCount >= 10) {
        _seconds++;
        _secondsController.add(_seconds);
        tickCount = 0;
      }
    });
  }
  
  void _startTicking() {
    _tickTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _totalTicks++;
      _tickController.add(_totalTicks);
    });
  }
  
  void _handleStartStopReset() {
    setState(() {
      if (!_isRunning) {
        // START
        _isRunning = true;
        _isPaused = false;
        _startTicking();
      } else if (_isRunning && !_isPaused) {
        // STOP
        _tickTimer?.cancel();
        _isRunning = false;
      } else {
        // RESET (se era in pausa)
        _tickTimer?.cancel();
        _totalTicks = 0;
        _seconds = 0;
        _secondsController.add(0);
        _isRunning = false;
        _isPaused = false;
      }
    });
  }
  
  void _handlePauseResume() {
    setState(() {
      if (_isRunning && !_isPaused) {
        // PAUSE
        _tickTimer?.cancel();
        _isPaused = true;
      } else if (_isPaused) {
        // RESUME
        _isPaused = false;
        _startTicking();
      }
    });
  }
  
  String _getFirstButtonText() {
    if (!_isRunning && !_isPaused) return 'START';
    if (_isRunning && !_isPaused) return 'STOP';
    return 'RESET';
  }
  
  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  @override
  void dispose() {
    _tickTimer?.cancel();
    _tickController.close();
    _secondsController.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronometro'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: StreamBuilder<int>(
                stream: _secondsController.stream,
                initialData: 0,
                builder: (context, snapshot) {
                  return Text(
                    _formatTime(snapshot.data ?? 0),
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _handleStartStopReset,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    _getFirstButtonText(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  onPressed: _isRunning || _isPaused ? _handlePauseResume : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    _isPaused ? 'RESUME' : 'PAUSE',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}