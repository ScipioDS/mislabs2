class Recipe {
  final String id;
  final String name;
  final String image;
  final String instructions;
  final List<String> ingredients;
  final String youtubeLink;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.instructions,
    required this.ingredients,
    required this.youtubeLink,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient.toString().trim());
      }
    }

    return Recipe(
      id: json['idMeal'],
      name: json['strMeal'],
      image: json['strMealThumb'],
      instructions: json['strInstructions'],
      ingredients: ingredients,
      youtubeLink: json['strYoutube'],
    );
  }


}