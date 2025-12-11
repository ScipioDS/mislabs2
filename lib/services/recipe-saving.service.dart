import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_recipes';

  // Save a favorite recipe ID
  Future<void> addFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    if (!favorites.contains(recipeId)) {
      favorites.add(recipeId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  // Remove a favorite recipe ID
  Future<void> removeFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    favorites.remove(recipeId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  // Check if a recipe is favorited
  Future<bool> isFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.contains(recipeId);
  }

  // Get all favorite recipe IDs
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(String recipeId) async {
    final isFav = await isFavorite(recipeId);
    if (isFav) {
      await removeFavorite(recipeId);
    } else {
      await addFavorite(recipeId);
    }
    return !isFav;
  }
}