// Import delle librerie necessarie per Flutter e i servizi di sistema
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

// Funzione principale che avvia l'applicazione
void main() {
  // Inizializza il binding dei widget prima di qualsiasi altra operazione
  WidgetsFlutterBinding.ensureInitialized();
  // Imposta l'orientamento del dispositivo a verticale
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Avvia l'app principale
  runApp(const ReplicaSequenzaApp());
}

// Classe principale dell'applicazione Replica Sequenza
class ReplicaSequenzaApp extends StatelessWidget {
  const ReplicaSequenzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Costruisce l'interfaccia dell'app con Material Design
    return MaterialApp(
      title: 'Replica Sequenza',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
