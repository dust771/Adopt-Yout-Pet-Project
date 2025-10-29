class Pet {
  final int id;
  final String name;
  final String age;
  final String local;
  final String description;
  final String? image;

  Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.local,
    required this.description,
    this.image,
  });

 factory Pet.fromJson(Map<String, dynamic> json, String baseUrl) {
  return Pet(
    id: json['id'],
    name: json['name'] ?? '',
    age: json['age'].toString(),  // <-- força string
    local: json['local'] ?? '',
    description: json['description'] ?? '',
    image: json['image'] != null ? '$baseUrl${json['image']}' : null,
  );
}
}
