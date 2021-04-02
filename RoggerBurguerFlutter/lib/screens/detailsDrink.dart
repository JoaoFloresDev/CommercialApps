import 'package:flutter/material.dart';
import 'package:flutter_app/data/drinksData.dart';
import 'package:flutter_app/data/foods.dart';
import 'package:flutter_app/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/data/foods.dart';
import 'package:flutter_app/widgets/cart_item.dart';
import 'package:flutter_app/widgets/promotions_cart_item.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_app/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/details.dart';
import 'package:flutter_app/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/data/foods.dart';
import 'package:flutter_app/widgets/cart_item.dart';
import 'package:flutter_app/widgets/drinkItemDetail.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_app/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/containers/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/screens/cart.dart';
import 'package:flutter_app/screens/checkout.dart';
import 'package:flutter_app/screens/checkoutRepeat.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailsDrink extends StatefulWidget {
  final String image;
  final String text;
  final String description;
  final double price;

  const ProductDetailsDrink({
    @required this.image,
    @required this.text,
    @required this.description,
    @required this.price,
  });

  @override
  _ProductDetailsStateDrink createState() => _ProductDetailsStateDrink();
}

class _ProductDetailsStateDrink extends State<ProductDetailsDrink> {
  int isFav = 1;
  int units = 1;
  double valueUn = 0;
  double price = 0;
  String additionals = "";
  List dataList = drinksSoda;

  var items = new List<Item>();

  void add(int units, double price, String additionals) {
    setState(() {
      items.add(
      Item(
        title: widget.text,
        units: units,
        valueUn: price,
        additionals: additionals,
        image: widget.image,
        type: 'drink'
      ),
      );
      save();
    });
  }

  makeCartItens() {
    print("fazenodo carrinho");

    for (var it  in dataList) {
      if(it["units"] != 0) {
        print(it['name']);
        print(it['price']);
        print(it['units']);

        add(it['units'].toInt(), it['price'].toDouble(), it['name']);
      }
    }
    Navigator.pop(context);
  }

  Future load() async {
    
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if(data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(items));
  }

  _ProductDetailsStateDrink() {
    items = [];
    load();
  }

  void addTotalValue(int index) {
    dataList[index]["units"] += 1;
    valueUn = 0;
    setState(() {
      for (var it  in dataList) {
      valueUn += it["price"] * it["units"];
      }
    });
  }

  void subTotalValue(int index) {
    dataList[index]["units"] -= 1;
    valueUn = 0;
    setState(() {
      for (var it  in dataList) {
      valueUn += it["price"] * it["units"];
      }
    });
  }

  @override
  void initState() {
    
    super.initState();
    if(widget.text == "Refrigerante") {
      dataList = drinksSoda;
    }
    else if(widget.text == "Cerveja") {
      dataList = drinksBeer;
    }
    else if(widget.text == "Água") {
      dataList = drinksWater;
    }
    for (var it  in dataList) {
      it["units"]= 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: ()=>Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
              widget.text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
            ),
        elevation: 5.0,

        actions: <Widget>[
          SizedBox.fromSize(
            size: Size(60, 60), // button width and height
            child: ClipRRect(
              child: Material(
                color: Colors.transparent, // button color
                child: InkWell(
                  splashColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "R\$ ${valueUn.toString().replaceAll('.', ',')}0",
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 12),
                      ), // text
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  margin:EdgeInsets.only(top: 8,left: 35, right: 35),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            Stack(
              children: <Widget>[
                  Align(
                    child: new ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: 
                        <Widget>[
                        Text(
                          "R\$ ${valueUn.toString().replaceAll('.', ',')}0",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black
                          ),
                        ),
                        
                        RawMaterialButton(
                          enableFeedback: false,
                          onPressed: (){},
                        ),
                      ],
                    ),
                  ),
                ],
            ),
            SizedBox(height: 5.0),

            Container(
            margin: EdgeInsets.only(left: 10),
            child:
            Text(
              "Opções",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            ),
            ListView.builder(
              
              primary: false,
              shrinkWrap: true,
              itemCount: dataList == null ? 0 :dataList.length,
              itemBuilder: 
              
              (BuildContext context, int index) {
  
                  return
                  DrinkItemDetail(
                  name: dataList[index]['name'],
                  valueUn: dataList[index]['price'],
                  indexItem: index,
                  addTotalValue: () => addTotalValue(index),
                  subTotalValue: () => subTotalValue(index),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
          child: 
          Align(
            alignment: Alignment.topCenter,
                    child: new ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          r"Adicionar ao carrinho",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
          color: Theme.of(context).accentColor,
          onPressed: (){
            makeCartItens();
          },
        ),
      ),
    );
  }
}