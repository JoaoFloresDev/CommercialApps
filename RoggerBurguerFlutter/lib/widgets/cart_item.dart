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

class CartItem extends StatefulWidget {
  final String name;
  final String img;
  final int units;
  final double valueUn;
  final String additionals;
  final int indexItem;
  final VoidCallback onDelete;
  final VoidCallback addTotalValue;
  final VoidCallback subTotalValue;

  CartItem({
    Key key,
    @required this.name,
    @required this.img,
    @required this.units,
    @required this.valueUn,
    @required this.additionals,
    @required this.indexItem,
    this.onDelete,
    this.addTotalValue,
    this.subTotalValue,
    })
      :super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  
  int units = 1;
  double totalValue = 20;
  var items = new List<Item>();

  void initState() {
    super.initState();
    units = widget.units;
    totalValue = widget.valueUn * widget.units;
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

  _CartItemState()  {
    items = [];
    load();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: 
        Card(
              elevation: 3.0,
              child:
         Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0.0, right: 3.0),
              child: Container(
                height: MediaQuery.of(context).size.width/3,
                width: MediaQuery.of(context).size.width/3,
                child: 
                SizedBox(
                  child:Padding(
                    padding: EdgeInsets.only(left: 1, top: 5, bottom: 5, right: 0),
                    child: 
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.0),
                      child: Image.asset(
                        "${widget.img}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
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
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    )
                ],
                ),
                SizedBox(height: 3.0),
                Text(
                    "R\$ ${totalValue.toStringAsFixed(2).replaceAll('.', ',')}",
                    style: TextStyle(
                    fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green
                    ),
                  ),
                SizedBox(height: 3.0),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width/1.5 - 110,
                      
                      color: Colors.white,
                      child: 
                      Text(
                      widget.additionals,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    )
                  ],
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
                        SizedBox(height: 3.0),
                        
                        SizedBox(
                          width: 25.0,
                          height: 25.0,
                          child: new RawMaterialButton(
                          onPressed: (){
                            setState((){
                              widget.onDelete();
                            });
                          },
                          fillColor: Colors.white,
                          shape: CircleBorder(),
                          elevation: 0.0,
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              Icons.clear,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: MediaQuery.of(context).size.width/3 - 80,
                ),
            Align(
              alignment: Alignment.bottomCenter,
                    child: new ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: 18.0,
                          height: 18.0,
                          
                          child: new RawMaterialButton(
                          onPressed: (){
                            setState((){
                              if(units > 1){
                                units -= 1;
                                totalValue = (widget.valueUn  * units);
                                widget.subTotalValue();
                              }
                            });
                          },
                          fillColor: Colors.lightBlueAccent[700],
                          shape: CircleBorder(),
                          elevation: 1.0,
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        ),

                        
                      Container(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 10.0,
                            maxWidth: 13.0,
                            minHeight: 20.0,
                            maxHeight: 20.0,
                          ),
                          child: 
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: 
                            Text(
                              units.toString(),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                        SizedBox(
                          width: 18.0,
                          height: 18.0,
                          
                          child: new RawMaterialButton(
                          onPressed: (){
                            setState((){
                              units += 1;
                              totalValue = (widget.valueUn * units);
                              widget.addTotalValue();
                            });
                          },
                          fillColor: Colors.lightBlueAccent[700],
                          shape: CircleBorder(),
                          elevation: 1.0,
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
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
            SizedBox(
              // height: 20,
            )
        ],
        ),
        )
    );
  }
}
