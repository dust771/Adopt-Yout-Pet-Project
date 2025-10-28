import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
      home: MainScreen(), // Tela principal
    );
  }
}

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final List<String> imgList = [
      'assets/images/img1.jpg',
      'assets/images/img2.jpg',
      'assets/images/img3.png',
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Adote seu pet", style: TextStyle(color: Colors.purple)
        ),

      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.purple,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                  ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Bem-vindo',
                    style: TextStyle(color: Colors.white, fontSize: 18)
                  ), 
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blueAccent),
              title: const Text('Home'),
              onTap: (){
                Navigator.pop(context);
              }
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blueAccent),
              title: const Text('Perfil'),
              onTap: (){
                Navigator.pop(context);
              }
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Dogs'),
              onTap: (){
                Navigator.pop(context);
              }
          ),
          const Spacer(),
           Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text("V 1.0", style: TextStyle(color: Colors.black) ),
            ),
          ]
        )

      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          CarouselSlider(
  options: CarouselOptions(
    height: height,
    autoPlay: true,
    enlargeCenterPage: true,
    viewportFraction: 1.0,
    autoPlayInterval: const Duration(seconds: 3),
  ),
  items: [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.png',
  ].map((imagePath) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }).toList(),
),

          SizedBox(height: 20),
          Text(
            'Bem-vindo ao Projeto Adote Seu Pet!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Encontre seu novo melhor amigo aqui.',
            style: TextStyle(fontSize: 16),
          ),
        ]
        
        ,
      )
    )
    );

  }
}