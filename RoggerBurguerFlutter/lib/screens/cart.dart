import 'package:flutter/material.dart';
import 'package:flutter_app/screens/checkout.dart';
import 'package:flutter_app/data/foods.dart';
import 'package:flutter_app/widgets/cart_item.dart';


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with AutomaticKeepAliveClientMixin<CartScreen >{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho"),
      ),
      body: Padding(
        
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView.builder(

          itemCount: foods == null ? 0 :foods.length,
          itemBuilder: (BuildContext context, int index) {
            Map food = foods[index];
            return CartItem(
              img: food['img'],
              name: food['name'],
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: "Checkout",
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context){
                return Checkout();
              },
            ),
          );
        },
        child: Icon(
          Icons.arrow_forward,
        ),
        heroTag: Object(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
