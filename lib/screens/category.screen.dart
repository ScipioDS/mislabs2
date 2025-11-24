import 'package:flutter/material.dart';
import 'package:mislabs2/services/the-meal-db-api.service.dart';

import '../models/category.dart';
import '../widgets/category.grid.dart';

class CategoryScreen extends StatefulWidget {
  final String title;
  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> _categories = [];
  List<Category> _filteredCategory = [];

  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';

  final TheMealDBService _theMealDBService = TheMealDBService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategoryList();
  }

  Future<void> _loadCategoryList() async {
    try {
      final list = await _theMealDBService.loadCategoryList();
      setState(() {
        _categories = list;
        _filteredCategory = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Failed to load categories: $e");
    }
  }

  void _filterCategory(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCategory = _categories;
      } else {
        _filteredCategory = _categories
            .where((cat) =>
            cat.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _searchCategoryByName(String name) async {
    if (name.isEmpty) return;

    setState(() => _isSearching = true);

    final result = await _theMealDBService.searchCategoryByName(name);

    setState(() {
      _isSearching = false;
      if (result != null) {
        _filteredCategory = [result];
      } else {
        _filteredCategory = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              onChanged: _filterCategory,
            ),
          ),

          Expanded(
            child: _filteredCategory.isEmpty &&
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
                          color: Colors.grey, fontSize: 18)),
                  TextButton(
                    onPressed: _isSearching
                        ? null
                        : () =>
                        _searchCategoryByName(_searchQuery),
                    child: _isSearching
                        ? const CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                        : const Text("Search in API"),
                  )
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(12),
              child: CategoryGrid(
                category: _filteredCategory,
              ),
            ),
          ),

          // 🔽 NEW BUTTON AT BOTTOM 🔽
          // SizedBox(
          //   width: double.infinity,
          //   child: Padding(
          //     padding: const EdgeInsets.all(12),
          //     child: ElevatedButton(
          //       onPressed: () async {
          //         Recipe recipe = await _theMealDBService.getRandomRecipe();
          //         Navigator.pushNamed(context, '/recipe', arguments: recipe);
          //       },
          //       child: const Text(
          //         "Get a random recipe",
          //         style: TextStyle(fontSize: 18),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}