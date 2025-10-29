// mainScreen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import '../models/pet.dart';
import './profilePage.dart';
import './petPage.dart';

class MainScreen extends StatefulWidget {
  final String token;
  final String baseUrl;

  const MainScreen({super.key, required this.token, required this.baseUrl});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> pets = [];
  bool loadingPets = true;
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchPets();
    _fetchUser();
  }

  Future<void> _fetchPets() async {
    setState(() => loadingPets = true);
    try {
      final response = await http.get(
        Uri.parse('${widget.baseUrl}/api/pets/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          pets = data is List ? data : data['results'];
          loadingPets = false;
        });
      } else {
        setState(() => loadingPets = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar pets (${response.statusCode})')),
        );
      }
    } catch (e) {
      setState(() => loadingPets = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao conectar ao servidor')),
      );
    }
  }

  Future<void> _fetchUser() async {
    try {
      final response = await http.get(
        Uri.parse('${widget.baseUrl}/api/users/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);
        if (dataList.isNotEmpty) {
          setState(() {
            username = dataList[0]['username'];
          });
        }
      }
    } catch (e) {
      debugPrint("Erro ao buscar usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height * 0.3;

    final List<String> imgList = [
      'assets/images/img1.jpg',
      'assets/images/img2.jpg',
      'assets/images/img3.png',
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Adote seu pet",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.purple),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    username != null ? 'Bem-vindo, $username' : 'Bem-vindo',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blueAccent),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blueAccent),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      token: widget.token,
                      baseUrl: widget.baseUrl,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Dogs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PetsScreen(token: widget.token, baseUrl: widget.baseUrl),
                  ),
                );
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("V 1.0"),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrossel de imagens locais
            CarouselSlider(
              options: CarouselOptions(
                height: height,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: imgList.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
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
            const SizedBox(height: 20),
            Text(
              username != null
                  ? 'Bem-vindo, $username ao Projeto Adote Seu Pet!'
                  : 'Bem-vindo ao Projeto Adote Seu Pet!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Encontre seu novo melhor amigo aqui. Navegue por perfis de animais adoráveis que estão esperando por um lar amoroso. Adote, não compre!",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Lista de pets
            loadingPets
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  )
                : pets.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Nenhum pet encontrado.'),
                      )
                    : Column(
                        children: pets.map((pet) {
                          final imagePath = pet['image'];
                          final imageUrl = imagePath != null && !imagePath.startsWith('http')
                              ? '${widget.baseUrl}$imagePath'
                              : imagePath;

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Image.network(
                                          imageUrl,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.pets, size: 80);
                                          },
                                        ),
                                      )
                                    : Container(
                                        height: 200,
                                        color: Colors.grey[300],
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.pets, size: 80),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(pet['name'] ?? 'Sem nome',
                                          style: const TextStyle(
                                              fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 5),
                                      Text('Idade: ${pet['age'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
                                      const SizedBox(height: 5),
                                      Text('Local: ${pet['local'] ?? 'Não informado'}', style: const TextStyle(fontSize: 16)),
                                      const SizedBox(height: 10),
                                      Text(pet['description'] ?? '', style: const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
          ],
        ),
      ),
    );
  }
}
