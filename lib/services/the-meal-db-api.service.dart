import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../models/recipe.dart';
import 'package:http/http.dart' as http;

class TheMealDBService {
  Future<List<Category>> loadCategoryList() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categories = data["categories"];
      return categories.map((json) => Category.fromJson(json)).toList();
    }

    throw Exception("Failed to load categories");
  }

  Future<Category?> searchCategoryByName(String name) async {
    return null;
  }

  Future<List<Food>> loadFoodList(String categoryName) async{
    debugPrint('Food by category called!');
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List foods = data["meals"];
      debugPrint('Food by categories finished!');
      return foods.map((json) => Food.fromJson(json)).toList();
    }
    throw Exception("Failed to load foods by category");
  }

  Future<Recipe> getRecipyById(String id) async {
    debugPrint('Recipe service called!');
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data["meals"];
      if (meals == null || meals.isEmpty) {
        throw Exception("No recipe found!");
      }
      final recipe = Recipe.fromJson(meals[0]);
      debugPrint('Recipe service finished!');
      return recipe;
    }
    throw Exception("Failed to load Recipe!");
  }

  Future<Recipe> getRandomRecipe() async{
    debugPrint('Random recipe service called!');
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data["meals"];
      if (meals == null || meals.isEmpty) {
        throw Exception("No recipe found!");
      }
      final recipe = Recipe.fromJson(meals[0]);
      debugPrint('Random recipe service finished!');
      return recipe;
    }
    throw Exception("Failed to load Random recipe!");
  }
}