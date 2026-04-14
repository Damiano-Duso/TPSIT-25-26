import 'package:flutter/material.dart';
import 'ListaScreen.dart';

void main() {
  runApp(MyApp());
}


   //APP PRINCIPALE
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