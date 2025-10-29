import 'package:flutter/material.dart';
import '../models/pet.dart';

class PetPage extends StatelessWidget {

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pet'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 26.0),
            Text("Todos os pets disponiveis para adoção!!!"),
          ],
        )
      )
    ); 
  }
}