import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/the-meal-db-api.service.dart';
import '../widgets/recipe.data.dart';
import '../widgets/recipe.image.dart';
import '../widgets/recipe.title.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Recipe recipe;
  bool _isLoading = true;
  bool _hasLoaded = false; // Add this flag

  final TheMealDBService _theMealDBService = TheMealDBService();

  Future<void> _loadRecipe(recipeId) async {
    try {
      final res = await _theMealDBService.getRecipyById(recipeId);
      setState(() {
        recipe = res;
        _isLoading = false;
        _hasLoaded = true; // Mark as loaded
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasLoaded = true; // Mark as loaded even on error
      });
    }
  }

  Future<void> _loadRandomRecipe() async {
    try {
      final res = await _theMealDBService.getRandomRecipe();
      setState(() {
        recipe = res;
        _isLoading = false;
        _hasLoaded = true; // Mark as loaded
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasLoaded = true; // Mark as loaded even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) { // Only load if not already loaded
      final recipeId = ModalRoute.of(context)!.settings.arguments as String;
      if (recipeId == "") {
        _loadRandomRecipe();
      } else {
        _loadRecipe(recipeId);
      }
    }

    return _isLoading ? const Center(child: CircularProgressIndicator()) :
    Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                DetailImage(image: recipe.image),
                Positioned(
                  top: 15,
                  left: 15,
                  child: IconButton.filled(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    color: Colors.greenAccent,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: DetailTitle(id: recipe.id, name: recipe.name),
                  ),
                ),
              ],
            ),
            DetailData(recipe: recipe),
          ],
        ),
      ),
    );
  }
}