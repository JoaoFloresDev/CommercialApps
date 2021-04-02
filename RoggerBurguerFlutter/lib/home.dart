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
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  final List<CardImageItem> categories;
  final List<CardImageItem> banners;
  final List<GourmetRestaurants> listPromotions;

  const Home({
    @required this.categories,
    @required this.banners,
    @required this.listPromotions,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: 
      ThemeData.light().copyWith(
        primaryColor: Colors.red[600],
        accentColor: Colors.lightBlueAccent[700],
      ), 
      title: 'Rogger Burguers',
      home: 
      FirstRoute(categories: this.categories, banners: this.banners, listPromotions: listPromotions),
    );
  }
}

class FirstRoute extends StatefulWidget {
  
  final List<CardImageItem> categories;
  final List<CardImageItem> banners;
  final List<GourmetRestaurants> listPromotions;

  const FirstRoute({
    @required this.categories,
    @required this.banners,
    @required this.listPromotions,
  });

  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {

  var items = new List<GourmetRestaurants>();
  var needUpdate = false;

  _FirstRouteState() {
    items = [];
    getDocs();
    getDocs2();
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getDocs() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("promotions").getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      print("- iiii ---------"); 

      print(a['desc']);
      print(a['name']);
      print(a['price']);
      print(a['imageFile']);

      printUrl(a['name'], a['price'], a['desc'], a['imageFile'],);
    }
  }

  Future<void> getDocs2() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("version").getDocuments();
        var a = querySnapshot.documents[0];
        print(a['versao']);
        if(a['versao'] != '1.0.0') {
          needUpdate = true;
        }
  }

  printUrl(String name, double price, String desc, String imageFile) async {
    
    StorageReference ref = 
    FirebaseStorage.instance.ref().child("promotions/$imageFile");
    String url = (await ref.getDownloadURL()).toString();
    print(" imprimindo  URL!!!!!!!!!!!!!!!!!!!!");
    print(url);
    load(name, price, desc, imageFile, url);
  }
  
  Future load(String name, double price, String desc, String imageFile,  String url) async {

    var teste = Image.network(
      url,
    );
    setState(() {
      items.add(
        GourmetRestaurants(  
                            text: name, 
                            price: price.toDouble(), 
                            description: name,
                            imageDownloaded: teste,
                          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
          appBar: AppBar(
          title: const Text("Rogger Burguer's", 
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),
                            ),
          actions: <Widget>[
          SizedBox.fromSize(
            size: Size(60, 60),
            child: ClipOval(
              child: Material(
                color: Colors.transparent, // button color
                child: InkWell(
                  splashColor: Colors.transparent, // splash color
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutRepeat(),
                      )
                    );
                  }, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.repeat), // icon
                      Text(
                        "Repetir",
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 8),
                      ), // text
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          SizedBox.fromSize(
            size: Size(60, 60), // button width and height
            child: ClipOval(
              child: Material(
                color: Colors.transparent, // button color
                child: InkWell(
                  splashColor: Colors.transparent, // splash color
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Checkout(),
                      )
                    );
                  }, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.shopping_cart), // icon
                      Text(
                        "Carrinho",
                        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 8),
                      ), // text
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
        ),
      body:  ListView(
          children: <Widget>[
            Container(
            height: needUpdate == true? 50.0 : 0,
            child: 
            FlatButton(
              child: 
              Align(
                alignment: Alignment.center,
                        child: new ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              r"Atualização disponível, clique aqui",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
              color: Colors.blue,
              onPressed: (){
                launchURL("https://play.google.com/store/apps/details?id=com.joao.roggerburguers");
              },
              ),
            ),
            BannerSlide(items: widget.banners),
            Categories(items: widget.categories),
            Container(
              margin: EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Destaques',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            ListView.builder(

              primary: false,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: 
              (BuildContext context, int index) {
                return  
                items[index];
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            FlutterOpenWhatsapp.sendSingleMessage("5514998985367", "Olá! Quero realizar um novo pedido.");
           },

          child: Icon(
            Icons.call,
            size: 30,
          ),
          backgroundColor: Colors.green,
          elevation: 30,
        ),
    );
  }
}