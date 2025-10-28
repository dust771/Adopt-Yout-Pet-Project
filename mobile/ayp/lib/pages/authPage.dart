import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AuthPage extends StatelessWidget
{

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Faça seu login!"),
      ),
      body: Center(
        child: Text("Pagina de autenticação"),
      ),
    );
  }


}