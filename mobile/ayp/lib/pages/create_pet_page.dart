import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CreatePetPage extends StatefulWidget {
  final String token;

  const CreatePetPage({super.key, required this.token});

  @override
  State<CreatePetPage> createState() => _CreatePetPageState();
}

class _CreatePetPageState extends State<CreatePetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _createPet() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma imagem.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse('http://127.0.0.1:8000/api/pets/');
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer ${widget.token}';

      request.fields['name'] = _nameController.text;
      request.fields['age'] = _ageController.text;
      request.fields['local'] = _localController.text;
      request.fields['description'] = _descriptionController.text;

      request.files.add(
        await http.MultipartFile.fromPath('image', _imageFile!.path),
      );

      final response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet criado com sucesso!')),
        );
        Navigator.pop(context, true);
      } else {
        final resBody = await response.stream.bytesToString();
        debugPrint("Erro: ${response.statusCode} => $resBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar pet (${response.statusCode})')),
        );
      }
    } catch (e) {
      debugPrint('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha de conexão com o servidor.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Anúncio"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _imageFile == null
                      ? const Center(
                          child: Icon(Icons.camera_alt,
                              size: 80, color: Colors.grey),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nome do pet"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o nome" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: "Idade"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe a idade" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(labelText: "Local"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o local" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Descrição"),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe a descrição" : null,
              ),
              const SizedBox(height: 25),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _createPet,
                        icon: const Icon(Icons.save),
                        label: const Text("Criar Anúncio"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 98, 0, 112),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
