import 'package:flutter/material.dart';
import 'package:flutter_app/containers/main.dart';
import 'package:flutter_app/widgets/card_image.dart';

class Categories extends StatelessWidget {
  final List<CardImageItem> items;

  const Categories({@required this.items});

  List<Widget> _buildCategories() => items
      .map((category) => CardImage(
            image: category.image,
            text: category.text,
            typeItem: "drink",
            price: category.price,
            description: category.description,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 220,
      padding: EdgeInsets.only(top: 5, left: 0),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5,left: 10),
            child: Text(
              'Bebidas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _buildCategories(),
            ),
          ),
        ],
      ),
    );
  }
}
