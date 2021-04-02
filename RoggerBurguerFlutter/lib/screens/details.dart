import 'package:flutter/material.dart';
import 'package:flutter_app/data/comments.dart';
import 'package:flutter_app/data/foods.dart';
import 'package:flutter_app/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductDetails extends StatefulWidget {
  final String image;
  final String text;
  final double price;
  final String description;

  const ProductDetails({
    @required this.image,
    @required this.text,
    @required this.price,
    @required this.description,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int units = 1;
  double valueUn = 30;
  double additionalsValue = 0;
  String additionals = "";

  var items = new List<Item>();

  _ProductDetailsState() {
    items = [];
  }

  @override
  void initState() {
    super.initState();
    load2();
    load();

  }

  void add() {
    valueUn = widget.price + additionalsValue;
      items.add(
        Item(
          title: widget.text,
          units: units,
          valueUn: valueUn,
          additionals: additionals,
          image: widget.image,
          type: 'food'
        ),
      );
      save();

    for(var com in comments){
      com['state'] = false;
    }

    Navigator.pop(context);
  }

  Future load2() async {
  setState(() {
        valueUn = widget.price;
      });
  }

  // @override
  // void initState() {
  //   super.initState();

  //   load2();
  // }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if(data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        items = result;
        valueUn = widget.price;
      });
    }

  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(items));
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
          onPressed: (){
            for(var com in comments){
            com['state'] = false;
          }
          Navigator.pop(context);
          },
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
                  
                  Align(
                    
                    child: 
                    new ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                        width: 30,  
                        child: 
                        RawMaterialButton(
                          onPressed: (){
                            setState((){
                              if (units  > 1) {
                              units -= 1; 

                              additionalsValue = 0;
                              for(var com in comments){
                                  if(com['state'])  {
                                    additionalsValue += com['price'];
                                  }
                              }

                              valueUn = (widget.price  * units) + (additionalsValue  * units);
                              }
                            });
                          },
                          fillColor: Colors.white,
                          shape: CircleBorder(),
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.remove,
                              color: Colors.lightBlueAccent[700],
                              size: 21,
                            ),
                          ),
                        ),
                        ),
                        Text(
                          units.toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                        width: 30,  
                        child: 
                        RawMaterialButton(
                          onPressed: (){
                            setState((){
                              units += 1;
                              additionalsValue = 0;
                              for(var com in comments){
                                  if(com['state'])  {
                                    additionalsValue += com['price'];
                                  }
                              }
                              valueUn = (widget.price  * units) + (additionalsValue  * units);
                            });
                          },
                          fillColor: Colors.white,
                          shape: CircleBorder(),
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.add,
                              color: Colors.lightBlueAccent[700],
                              size: 21,
                            ),
                          ),
                        ),
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
              "Descrição",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            ),
            SizedBox(height: 10.0),

            Container(
            margin: EdgeInsets.only(left: 10),
            child:
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
            margin: EdgeInsets.only(left: 10),
            child: 
              Text(
                "Adicionais",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments == null?0:comments.length,
              itemBuilder: (BuildContext context, int index) {
              Map comment = comments[index];
                return 
                CheckboxListTile(
                  activeColor: Colors.greenAccent[700],
                  checkColor: Colors.teal[700],
                  title: 
                  Text(
                    "${comment['name']}",
                    style: TextStyle(
                      color: 
                      comment['state'] == true ? Colors.green : Colors.black,
                      // Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: 
                  Text(
                    "R\$ ${comment['price'].toString().replaceAll('.', ',')}0",
                    style: TextStyle(
                      color: 
                      comment['state'] == true ? Colors.green : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  key: Key("${comment['name']}"),
                  value: comment['state'],
                  onChanged: (bool value) {
                    setState(() {
                      comment['state'] = value;
                      additionalsValue = 0;
                      additionals = "";
                      for(var com in comments){
                          if(com['state'])  {
                            if(additionals == "") {
                              additionals += com['name'];
                            }
                            else {
                              additionals += " • " + com['name'];
                            }
                            additionalsValue += com['price'];
                          }
                          
                      }
                      valueUn = (widget.price  * units) + (additionalsValue  * units);
                    });
                  },
                );
              },
            ),
            SizedBox(height: 10.0),
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
          onPressed: add
        ),
      ),
    );
  }
  
}