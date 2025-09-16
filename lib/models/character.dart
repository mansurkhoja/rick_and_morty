class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String locationName;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.locationName,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
    id: json['id'],
    name: json['name'],
    status: json['status'],
    species: json['species'],
    gender: json['gender'],
    locationName: json['location']['name'],
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'species': species,
    'gender': gender,
    'location': {'name': locationName},
    'image': image,
  };
}
