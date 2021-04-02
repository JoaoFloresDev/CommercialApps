import 'package:flutter/material.dart';
import 'package:flutter_app/containers/main.dart';
import 'package:flutter_app/widgets/card_image.dart';

class BannerSlide extends StatelessWidget {
  final List<CardImageItem> items;

  const BannerSlide({@required this.items});

  List<Widget> _buildBanners() => items
      .map((banner) => CardImage(
            image: banner.image,
            text: banner.text,

            format: CardImageType.category,
            textAlign: CrossAxisAlignment.start,

            typeItem: "food",
            
            price: banner.price,
            description: banner.description,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 220,
      margin: EdgeInsets.only(top: 0),
      padding: EdgeInsets.only(top: 12, left: 0),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5, left: 10),
            child: Text(
              'Lanches',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _buildBanners(),
            ),
          ),
        ],
      ),
    );
  }
}
