import 'package:flutter/material.dart';
import 'package:mislabs2/models/food.dart';
import '../models/category.dart';

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/recipe", arguments: food.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.green, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(child: Image.network(food.image)),
              Divider(),
              Text(food.name,
                    style: TextStyle(fontSize: 20),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}