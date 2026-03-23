import 'package:flutter/material.dart';
import 'Screens/InicioSesion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CARE',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const InicioSesion(),
    );
  }
}
