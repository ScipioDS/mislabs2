class Food {
  final String id;
  final String name;
  final String image;

  Food({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['idMeal'],
      name: json['strMeal'],
      image: json['strMealThumb'],
    );
  }
}