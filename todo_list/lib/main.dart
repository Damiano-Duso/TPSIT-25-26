// Import delle librerie necessarie
import 'package:flutter/material.dart';
import 'ListaScreen.dart';

// Funzione principale che avvia l'applicazione To Do List
void main() {
  runApp(MyApp());
}


   //APP PRINCIPALE - Classe principale dell'app To Do List
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      home: ListaScreen(),
    );
  }
}