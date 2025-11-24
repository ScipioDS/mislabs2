import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/foods", arguments: [category.name, category.description]);
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
              Expanded(child: Image.network(category.image)),
              Divider(),
              Text(category.name, style: TextStyle(fontSize: 20)),
              Text(category.description,
                  style: TextStyle(fontSize: 16),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
      ),
    );
  }
}