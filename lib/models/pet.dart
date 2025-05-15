class Pet {
  final String id;
  final String name;
  final String type;
  final String image;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
  });

  Map<String, String> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
    };
  }

  factory Pet.fromMap(Map<String, String> map) {
    return Pet(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      image: map['image'] ?? '',
    );
  }
}
