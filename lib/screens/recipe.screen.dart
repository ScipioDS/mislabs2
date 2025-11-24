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

  final TheMealDBService _theMealDBService = TheMealDBService();

  Future<void> _loadRecipe(recipeId) async {
    try {
      final res = await _theMealDBService.getRecipyById(recipeId);
      setState(() {
        recipe = res;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final recipeId = ModalRoute.of(context)!.settings.arguments as String;
    _loadRecipe(recipeId);

    return _isLoading ? const Center(child: CircularProgressIndicator()) :
    Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DetailImage(image: recipe.image),
            const SizedBox(height: 20),
            DetailTitle(id: recipe.id, name: recipe.name),
            const SizedBox(height: 30),
            DetailData(recipe: recipe),
          ],
        ),
      ),
    );
  }
}