import 'package:flutter/material.dart';
import 'package:mislabs2/models/food.dart';
import 'package:mislabs2/services/the-meal-db-api.service.dart';
import 'package:mislabs2/widgets/food.grid.dart';


class FoodScreen extends StatefulWidget {
  final String title;
  const FoodScreen({super.key, required this.title});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  List<Food> _foods = [];
  List<Food> _filteredFoods = [];

  bool _isLoading = true;
  bool _loadFoods = true;
  String _searchQuery = '';
  String categoryDescription = '';

  final TheMealDBService _theMealDBService = TheMealDBService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadFoodList(categoryName) async {
    try {
      final list = await _theMealDBService.loadFoodList(categoryName);
      setState(() {
        _foods = list;
        _filteredFoods = list;
        _isLoading = false;
        _loadFoods = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Failed to load categories: $e");
    }
  }

  void _filterFoods(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredFoods = _foods;
      } else {
        _filteredFoods = _foods
            .where((cat) =>
            cat.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadFoods){
      final args = ModalRoute.of(context)!.settings.arguments as List<String>;
      final categoryName = args[0];
      categoryDescription = args[1];
      _loadFoodList(categoryName);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search categories...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterFoods,
            ),
          ),

          Expanded(
            child: _filteredFoods.isEmpty &&
                _searchQuery.isNotEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text("No category found",
                      style: TextStyle(
                          color: Colors.grey, fontSize: 18)
                  ),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(12),
              child: FoodGrid(
                foods: _filteredFoods,
                categoryDescription: categoryDescription,
              ),
            ),
          ),
        ],
      ),
    );
  }
}