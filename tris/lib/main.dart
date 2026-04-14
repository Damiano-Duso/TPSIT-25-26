// Punto di ingresso dell'app Flutter per il gioco Tris Online.
import 'package:flutter/material.dart';
import 'screens/connection_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Widget principale dell'applicazione.
/// Configura il tema e mostra la schermata di connessione.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tris Online',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ConnectionScreen(),
    );
  }
}
