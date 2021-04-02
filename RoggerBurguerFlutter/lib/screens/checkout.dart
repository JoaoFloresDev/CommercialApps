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

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  
  var items = new List<Item>();
  var name = "";
  var txtPhone = TextEditingController();
  var txtName = TextEditingController();
  var txtEndress = TextEditingController();
  var txtPayform = TextEditingController();
  var txtPayback = TextEditingController();
  var txtObservations = TextEditingController();

  double totalPurchaseValue = 0;

  showAlertDialog(BuildContext context) {

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { 
        Navigator.pop(context);
      },
    );
    
    AlertDialog alert = AlertDialog(
      title: Text("Preencha seus dados"),
      content: Text("Para enviar seu pedido, por favor preencha todos seus dados"),
      actions: [
        okButton,
      ],
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List<String> _colors = <String>['Cartão', 'Dinheiro'];
  String _color = 'Cartão';

  List<String> _deliveryModes = <String>['Retirar no local', 'Delivery (taxa R\$ 4,00)'];
  String _deliveryMode = 'Retirar no local';

  @override
  void initState() {
    super.initState();
  }

  _CheckoutState() {
    items = [];
    load();
  }

  String createMessangeSend() {
    
    String messange = "";

    messange += "*Nome*:" + txtName.text + "\n";
    messange += "*Endereço*:" + txtEndress.text + "\n";
    messange += "*Telefone*:" + txtPhone.text + "\n\n";

    messange += "*Pedido*: \n";

    totalPurchaseValue = 0;

    if(_deliveryMode == 'Delivery (taxa R\$ 4,00)') {
      totalPurchaseValue += 4;
    }
    for (var it  in items) {
      totalPurchaseValue += it.valueUn * it.units;
    }
    for (var it  in items) {
      if(it.valueUn > 0) {
        messange += "*" + it.units.toString() + "x " + it.title + " R\$" + (it.units * it.valueUn).toStringAsFixed(2).replaceAll(".", ",") + "*" + "\n";
        if(it.additionals != "") {
          if(it.type == "food") {
            messange += "_Adicionais: ";
          }
          else {
            messange += "_";
          }

          messange += it.additionals + "_\n";
        }
        messange += "\n";
      }
    }
    
    if(txtObservations.text.isEmpty) {
      messange += "*Observações*: Sem observações";
    }
    else {
      messange += "*Observações*: " + txtObservations.text;
    }

    messange += "\n\n*Pagamento*: " + _color;
    if(_color == "Dinheiro") {
      if(txtPayback.text.isEmpty) {
        messange += "\nSem troco";
      }
      else {
        messange += "\n*Troco*: R\$" + txtPayback.text;
      }
    }

    messange += "\n\n*Forma de entrega*: " + _deliveryMode;

    messange += "\n\n*Total*: R\$" + totalPurchaseValue.toStringAsFixed(2).replaceAll(".", ",") ;

    print("---------- aaa ---------------");
    print(messange);
    print("---------- aaa ---------------");
    return messange;
  }

  void addTotalValue(int index) {
    setState(() {
      items[index].units += 1;
      updateTotalVue();
    });
  }

  void subTotalValue(int index) {
    setState(() {
      items[index].units -= 1;
      updateTotalVue();
    });
  }

  void remove(int index) {
    setState(() {
      items.removeAt(index);
      save();
      updateTotalVue();
    });
  }

  Future updateTextField() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString('name', txtName.text);
    prefs.setString('Endress', txtEndress.text);
    prefs.setString('Payform', txtPayform.text);
    prefs.setString('Phone', txtPhone.text);
    prefs.setString('Payback', txtPayback.text);
    prefs.setString('Observations', txtObservations.text);
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if(data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

      setState(() {
        items = result;
        txtName.text = prefs.getString('name');
        txtEndress.text = prefs.getString('Endress');
        txtPayform.text = prefs.getString('Payform');
        txtPhone.text = prefs.getString('Phone');
        txtPayback.text = prefs.getString('Payback');
        txtObservations.text = prefs.getString("Observations");

        for (var i = 0; i < items.length; i++) {
          if(items[i].type == "promotion") {
            filterData(items[i].title, i);
          }
        }

        updateTotalVue();
      });
    }
  }

    Future filterData(String name, int index) async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection('promotions').where('name', isEqualTo: name).getDocuments();
      
      if(querySnapshot.documents.length > 0) {
        var a = querySnapshot.documents[0];
        print(a['name']);
        print(a['price']);

        print("promotions/" + a['imageFile']);
        StorageReference ref = 
        FirebaseStorage.instance.ref().child("promotions/" + a['imageFile']);
        String url = (await ref.getDownloadURL()).toString();
        var price = a['price'];

        setState(() {
          items[index].image = url;
          items[index].valueUn = price.toInt();
        });
      }

      else {
        setState(() {
        items[index].title = "Produto indisponível";
        items[index].valueUn = 0;
        });
      }
      
      save();
      load();
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(items));
  }

  saveInRepeat() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('dataRepeat', jsonEncode(items));
    
    setState(() {
                            items.removeRange(0, items.length);
                            save();

                            totalPurchaseValue = 0;
                            if(_deliveryMode == 'Delivery (taxa R\$ 4,00)') {
                              totalPurchaseValue += 4;
                            }
                            for (var it  in items) {
                              totalPurchaseValue += it.valueUn * it.units;
                            }
                          });
  }

  updateTotalVue() {
    setState(() {
     totalPurchaseValue = 0;
    if(_deliveryMode == 'Delivery (taxa R\$ 4,00)') {
      totalPurchaseValue += 4;
    }
    for (var it  in items) {
      totalPurchaseValue += it.valueUn * it.units;
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: 
Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Carrinho",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        elevation: 5.0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: ()=>Navigator.pop(context),
        ),
        actions: <Widget>[
          SizedBox.fromSize(
            size: Size(80, 60), // button width and height
            child: ClipOval(
              child: Material(
                color: Colors.transparent, // button color
                child: InkWell(
                  splashColor: Colors.transparent, // splash color
                  onTap: () {
                    setState(() {
                      items.removeRange(0, items.length);
                      save();

                      totalPurchaseValue = 0;
                      if(_deliveryMode == 'Delivery (taxa R\$ 4,00)') {
                        totalPurchaseValue += 4;
                      }
                      for (var it  in items) {
                        totalPurchaseValue += it.valueUn * it.units;
                      }
                    });
                  }, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Limpar",
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(2.0,0,2.0,50),
        child: ListView(
          children: <Widget>[
            Padding(
            padding: EdgeInsets.fromLTRB(10,10,10,0),
            child:
              Text(
                r"Dados",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
              child: 
              SizedBox(
                height: 40,
                child: 
                TextFormField(
                textCapitalization: TextCapitalization.words,
                onChanged: (text) {
                  updateTextField();
                },
                controller: txtName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                decoration: InputDecoration(labelText: "Nome", border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  updateTextField();
                  FocusScope.of(context).nextFocus();
                }
              ),
              )
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
              child: 
              SizedBox(
                height: 40,
                child: 
              TextField(
                textCapitalization: TextCapitalization.words,
                  onChanged: (text) {
                    updateTextField();
                  },
                  controller: txtEndress,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(labelText: "Endereço", border: OutlineInputBorder(),),
                  textInputAction: TextInputAction.next, 
                  onSubmitted: (_) {
                    updateTextField();
                    FocusScope.of(context).nextFocus();
                  }
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
              child: 
              SizedBox(
                height: 40,
                child: 
              TextField(
                onChanged: (text) {
                  updateTextField();
                },
                keyboardType: TextInputType.number,
                  controller: txtPhone,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(labelText: "Telefone", border: OutlineInputBorder(),),
                  textInputAction: TextInputAction.next, 
                  onSubmitted: (_) {
                    updateTextField();
                    FocusScope.of(context).nextFocus();
                  }
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
                child: new ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                  Container(           
                    padding: EdgeInsets.only(left: 20, right: 20),   
                    width: MediaQuery.of(context).size.width - 150,
                    child: 
                    SizedBox(
                height: 40,
                child: 
                    DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _color = newValue;
                              });
                            },
                            items: _colors.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                    ),
                  ),
                  Container(              
                    width: 120.0,
                    child: 
                    SizedBox(
                height: 40,
                child: 
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: txtPayback,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Troco',
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      textInputAction: TextInputAction.next, 
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(), // move focus to next
                    ),
                    ),
                  )
                ],
              ),
            ),
            
            Container(           
              padding: EdgeInsets.only(left: 30, right: 30),   
              width: MediaQuery.of(context).size.width - 150,
              child: 
              SizedBox(
          height: 40,
          child: 
              DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      
                      value: _deliveryMode,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          _deliveryMode = newValue;
                          updateTotalVue();
                        });
                      },
                      items: _deliveryModes.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                    ),
                  ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10,0,10,0),
              child: 
              SizedBox(
                height: 40,
                child: 
              TextField(
                controller: txtObservations,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Observações',
              ),
            ),
              ),
            ),
            Padding(
            padding: EdgeInsets.fromLTRB(10,20,10,0),
            child:
              Text(
                r"Pedido",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            ListView.builder(
              
              primary: false,
              shrinkWrap: true,
              itemCount: items == null ? 0 :items.length,
              itemBuilder: 
              
              (BuildContext context, int index) {
                Item x = items[index];

                print(items[index].type);
  
                if(items[index].type == "promotion") {
                  return
                  PromotionCartItem(
                  img: x.image,
                  name: x.title,
                  units: x.units,
                  valueUn: x.valueUn,
                  additionals: x.additionals,
                  indexItem: index,
                  onDelete: () => remove(index),
                  addTotalValue: () => addTotalValue(index),
                  subTotalValue: () => subTotalValue(index),

                );
                }
                else {
                  return
                  CartItem(
                  img: x.image,
                  name: x.title,
                  units: x.units,
                  valueUn: x.valueUn,
                  additionals: x.additionals,
                  indexItem: index,
                  onDelete: () => remove(index),
                  addTotalValue: () => addTotalValue(index),
                  subTotalValue: () => subTotalValue(index),

                );
                }
              },
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),

      bottomSheet: Container(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.fromLTRB(20,5,5,5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        
                        Text(
                          "Total R\$",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        Text(
                          totalPurchaseValue.toStringAsFixed(2).replaceAll(".", ","),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(5,5,10,5),
                    width: MediaQuery.of(context).size.width/1.5,
                    height: 50.0,
                    child: FlatButton(
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Fazer Pedido".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      onPressed: (){
                        String messange = createMessangeSend();
                        if(
                            txtName.text.isEmpty ||
                            (txtEndress.text.isEmpty && _deliveryMode == 'Delivery (taxa R\$ 4,00)') ||
                            txtPhone.text.isEmpty
                        ) {
                          showAlertDialog(context);
                        }
                        else {
                          saveInRepeat();
                          FlutterOpenWhatsapp.sendSingleMessage("5514998985367", messange);
                        }
                      },
                    ),
                  ),

                ],
              ),
            ],
          ),
          height: 55,
        ),
    ),

    );
    
  }
}
