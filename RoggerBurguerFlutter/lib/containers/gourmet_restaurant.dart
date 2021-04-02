import 'package:flutter/material.dart';
import 'package:flutter_app/containers/main.dart';
import 'package:flutter_app/widgets/card_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/details.dart';
import 'package:flutter_app/screens/detailsDrink.dart';
import 'package:flutter_app/screens/detailsPromotions.dart';

class GourmetRestaurants extends StatelessWidget {
  @override

  final Image imageDownloaded;
  final String text;
  final double price;
  final String description;

  const GourmetRestaurants({
    @required this.text,
    @required this.price,
    @required this.description,
    @required this.imageDownloaded,
  });

  Widget build(BuildContext context) {

    return 
     Container(
      margin: EdgeInsets.only(right: 10,left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10, top: 10),
            child:
            FlatButton(
            onPressed: (){

                print(price);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PromotionsProductDetails(text: text, price: price, description: description, imageDownloaded: imageDownloaded),
                  )
                );
            },

            padding: EdgeInsets.all(0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: imageDownloaded,
            ),
          ),
            
            decoration: BoxDecoration(
        color: Colors.white,
        
            borderRadius: BorderRadius.circular(30),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5),
                  //     spreadRadius: 3,
                  //     blurRadius: 3,
                  //     offset: Offset(0, 0),
                  //   ),
                  //     ],
            ),
          ),
        ],
      ),
    );

  }

}
