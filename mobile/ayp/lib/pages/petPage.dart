import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'create_pet_page.dart';

class PetsScreen extends StatefulWidget {
  final String token;
  final String baseUrl;

  const PetsScreen({super.key, required this.token, required this.baseUrl});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<dynamic> pets = [];
  bool loading = true;

  Future<void> _fetchPets() async {
    setState(() => loading = true);
    try {
      final response = await http.get(
        Uri.parse('${widget.baseUrl}/api/pets/'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          // caso DRF retorne { results: [...] }, use: pets = data['results'];
          pets = data is List ? data : data['results'];
          loading = false;
        });
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar pets (${response.statusCode})')),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao conectar ao servidor')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pets disponíveis"),
        backgroundColor: Colors.purple,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchPets,
              child: pets.isEmpty
                  ? const Center(child: Text("Nenhum pet cadastrado."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        final imagePath = pet['image'];
                        final imageUrl = imagePath != null && !imagePath.startsWith('http')
                            ? '${widget.baseUrl}$imagePath'
                            : imagePath;

                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            leading: imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, progress) {
                                        if (progress == null) return child;
                                        return const SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.pets, size: 50);
                                      },
                                    ),
                                  )
                                : const Icon(Icons.pets, size: 50),
                            title: Text(pet['name'] ?? 'Sem nome'),
                            subtitle: Text(
                              '${pet['local'] ?? 'Local não informado'}\n${pet['description'] ?? ''}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.add),
        label: const Text("Criar novo"),
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreatePetPage(token: widget.token),
            ),
          );
          if (created == true) _fetchPets();
        },
      ),
    );
  }
}
