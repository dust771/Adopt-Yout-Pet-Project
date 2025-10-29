class Pet {
  final int id;
  final String name;
  final int age;
  final String description;
  final String local;
  final String image;

  Pet({    
    required this.id,
    required this.name,
    required this.age,
    required this.description,
    required this.local,
    required this.image,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      description: json['description'],
      local: json['local'],
      image: json['image'],
    );
  }
}