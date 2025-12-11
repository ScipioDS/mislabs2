import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/the-meal-db-api.service.dart';
import '../services/recipe-saving.service.dart'; // Add this import
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
  bool _hasLoaded = false;
  bool _isFavorite = false; // Add this

  final TheMealDBService _theMealDBService = TheMealDBService();
  final FavoritesService _favoritesService = FavoritesService(); // Add this

  Future<void> _loadRecipe(recipeId) async {
    try {
      final res = await _theMealDBService.getRecipyById(recipeId);
      final isFav = await _favoritesService.isFavorite(recipeId); // Check favorite status
      setState(() {
        recipe = res;
        _isFavorite = isFav;
        _isLoading = false;
        _hasLoaded = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasLoaded = true;
      });
    }
  }

  Future<void> _loadRandomRecipe() async {
    try {
      final res = await _theMealDBService.getRandomRecipe();
      final isFav = await _favoritesService.isFavorite(res.id); // Check favorite status
      setState(() {
        recipe = res;
        _isFavorite = isFav;
        _isLoading = false;
        _hasLoaded = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasLoaded = true;
      });
    }
  }

  // Toggle favorite status
  Future<void> _toggleFavorite() async {
    final newStatus = await _favoritesService.toggleFavorite(recipe.id);
    setState(() {
      _isFavorite = newStatus;
    });

    // Show a snackbar to give feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
          duration: const Duration(seconds: 2),
          backgroundColor: _isFavorite ? Colors.green : Colors.grey,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLoaded) {
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
                // Add favorite button
                Positioned(
                  top: 15,
                  right: 15,
                  child: IconButton.filled(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    color: _isFavorite ? Colors.red : Colors.grey.shade600,
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