import 'package:flutter/material.dart';
import 'package:flutter_app/screens/details.dart';
// import 'package:flutter_app/util/const.dart';
import 'package:flutter_app/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_app/data/foods.dart';
import 'package:flutter_app/widgets/cart_item.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_app/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DrinkItemDetail extends StatefulWidget {
  final String name;
  final double valueUn;
  final int indexItem;
  final VoidCallback onDelete;
  final VoidCallback addTotalValue;
  final VoidCallback subTotalValue;

  DrinkItemDetail({
    Key key,
    @required this.name,
    @required this.valueUn,
    @required this.indexItem,
    this.onDelete,
    this.addTotalValue,
    this.subTotalValue,
    })
      :super(key: key);

  @override
  _DrinkItemDetailState createState() => _DrinkItemDetailState();
}

class _DrinkItemDetailState extends State<DrinkItemDetail> {
  
  int units = 0;
  double totalValue = 20;
  var items = new List<Item>();

  void initState() {
    super.initState();
    totalValue = widget.valueUn;
  }

  void remove(int index) {
    setState(() {
      items.removeAt(index);
      save();
    });
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(items));
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

  _DrinkItemDetailState()  {
    items = [];
    load();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: 
        Card(

              elevation: 1.0,
              child:
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                child: 
         Row(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 2.0),
                Row(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width/1.5 - 100,
                      
                      color: Colors.white,
                      child: 
                      Text(
                      "${widget.name}",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    )
                ],
                ),
                SizedBox(height: 3.0),
                Text(
                    "R\$ ${totalValue.toString().replaceAll('.', ',')}0",
                    style: TextStyle(
                    fontSize: 16,
                      fontWeight: FontWeight.w400,
                      // color: Colors.green
                    ),
                  ),
              ],
            ),
            Spacer(),
            new Column(
              
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              
              children:
              <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
                    child: new ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: 22.0,
                          height: 22.0,
                          
                          child: new RawMaterialButton(
                          onPressed: (){
                            setState((){
                              if(units > 0){
                                units -= 1;
                                widget.subTotalValue();
                              }
                            });
                          },
                          fillColor: Colors.white,
                          shape: CircleBorder(),
                          elevation: 3.0,
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              Icons.remove,
                              color: Colors.lightBlueAccent[700],
                              size: 18,
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
                          width: 22.0,
                          height: 22.0,
                          
                          child: new RawMaterialButton(
                          onPressed: (){
                            setState((){
                              units += 1;
                              widget.addTotalValue();
                            });
                          },
                          fillColor: Colors.white,
                          shape: CircleBorder(),
                          elevation: 3.0,
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              Icons.add,
                              color: Colors.lightBlueAccent[700],
                              size: 18,
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
        ),
        ),
        )
    );
  }
}
