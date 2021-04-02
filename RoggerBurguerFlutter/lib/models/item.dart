// Future<void> filterData() async {
//     QuerySnapshot querySnapshot = await Firestore.instance.collection('promotions').where('desc', isEqualTo: 'Rogger Egg').getDocuments();
//     for (int i = 0; i < querySnapshot.documents.length; i++) {
//       var a = querySnapshot.documents[i];
//       print("- Filtrando ---------"); 
//       print(a['desc']);
//       print(a['name']);
//       print(a['price']);
//       print(a['imageFile']);

//       printUrl(a['name'], a['price'], a['desc'], a['imageFile'],);
//     }
//   }

class Item {
  String title;
  int units;
  double valueUn;
  String additionals;
  String image;
  String type;

  Item({
    this.title, 
    this.units, 
    this.valueUn, 
    this.additionals,
    this.image,
    this.type,
        });
  
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    units = json['units'];
    valueUn = json['valueUn'];
    type = json['type'];
    additionals = json['additionals'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['units'] = this.units;

    data['valueUn'] = this.valueUn;
    data['type'] = this.type;
    data['additionals'] = this.additionals;
    data['image'] = this.image;

    return data;
  }
}