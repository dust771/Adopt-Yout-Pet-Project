import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './models/pet.dart';
import './models/user.dart';
import './pages/mainScreen.dart';
import './pages/authPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

// Widget raiz do app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
  // 🔐 Coloque aqui o seu token JWT
      home: AuthPage(), // Tela principal
    );
  }
}
