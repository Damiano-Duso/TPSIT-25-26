import 'package:flutter/material.dart';
import 'dart:convert';                   
import 'package:http/http.dart' as http; 
import 'dart:async';                     

//////////////////////////////////////////////////
//MAIN
void main() {
  runApp(const QuizApp());
}

//////////////////////////////////////////////////
//WIDGET PRINCIPALE DELL'APP
class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //Definizione delle rotte per la navigazione tra schermate
      initialRoute: '/',  //Schermata iniziale
      routes: {
        '/': (context) => const HomeScreen(),      //Home
        '/quiz': (context) => const QuizScreen(),  //Quiz
        '/results': (context) => const ResultsScreen(), //Risultati
      },
    );
  }
}