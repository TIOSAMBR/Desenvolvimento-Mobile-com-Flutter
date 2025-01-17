import 'package:flutter/material.dart';
import 'package:teste/anuncio_lista_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mercado Negro',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AnuncioListaScreen(),
    );
  }
}
