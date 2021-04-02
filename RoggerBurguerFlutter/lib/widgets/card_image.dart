import 'package:flutter/material.dart';
import 'package:flutter_app/screens/details.dart';
import 'package:flutter_app/screens/detailsDrink.dart';

class CardImage extends StatelessWidget {
  final String image;
  final String text;
  final CardImageType format;
  final CrossAxisAlignment textAlign;
  final String typeItem;
  final double price;
  final String description;

// "R\$ " + banner.price.toStringAsFixed(2).replaceAll(".", ",")

  const CardImage({
    @required this.image,
    @required this.text,
    this.format = CardImageType.banner,
    this.textAlign = CrossAxisAlignment.center,
    this.typeItem,
    this.price,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = handleImageHeight(format);

    return Container(
      margin: EdgeInsets.only(right: 10,left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 10),
            child:
            FlatButton(
            onPressed: (){
              if(typeItem == "food")  {
                print(typeItem);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(image: image, text: text, price: price, description: description,),
                  )
                );
              }
              else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsDrink(image: image, text: text, price: price, description: description,),
                  )
                );
              }
            }
            ,
            padding: EdgeInsets.all(0.0),
            child: 
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(image, height: imageHeight),
            ),
            ),
            
            decoration: BoxDecoration(
        color: Colors.white,
        
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 0),
                    ),
                      ],
      ),
          ),
          SizedBox(
            width: 120,
            child: 
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,fontSize: 14,
              ),
              textAlign: TextAlign.center
            ),
          )
        ],
      ),
    );
  }
}

enum CardImageType {
  banner,
  category,
}

double handleImageHeight(CardImageType type) {
  final banners = {
    CardImageType.banner: 120.0,
    CardImageType.category: 120.0,
  };
  return banners[type];
}
