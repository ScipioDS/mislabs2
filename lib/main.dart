import 'package:flutter/material.dart';
import 'package:mislabs2/screens/category.screen.dart';
import 'package:mislabs2/screens/food.screen.dart';
import 'package:mislabs2/screens/recipe.screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals - TheMealDB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const CategoryScreen(title: 'TheMealDB'),
        "/foods": (context) => const FoodScreen(title: 'Foods by Category'),
        "/recipe": (context) => const DetailsPage(),
      },
    );
  }
}