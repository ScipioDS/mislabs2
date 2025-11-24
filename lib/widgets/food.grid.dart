import 'package:flutter/material.dart';
import 'package:mislabs2/models/food.dart';
import 'package:mislabs2/widgets/food.card.dart';

class FoodGrid extends StatefulWidget {
  final List<Food> foods;
  final String categoryDescription;

  const FoodGrid({
    super.key,
    required this.foods,
    required this.categoryDescription,
  });

  @override
  State<StatefulWidget> createState() => _FoodGridState();
}

class _FoodGridState extends State<FoodGrid> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.categoryDescription,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 150/244,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return FoodCard(food: widget.foods[index]);
            },
            childCount: widget.foods.length,
          ),
        ),
      ],
    );
  }
}