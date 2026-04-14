// Import della libreria Flutter per Material Design
import 'package:flutter/material.dart';
import 'screens/connection_screen.dart';

// Funzione principale che avvia l'applicazione Tris
void main() {
  runApp(const MyApp());
}

// Classe principale dell'applicazione Tris
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Costruisce l'app con Material Design e tema personalizzato
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
