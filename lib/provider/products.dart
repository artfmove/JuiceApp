import 'package:flutter/material.dart';
import './product.dart';
import 'package:firebase_database/firebase_database.dart';

class Products with ChangeNotifier {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Product> products = [];

  List<Product> get getProducts {
    return products;
  }

  Future<void> getProductsFromFirebase() async {
    products.clear();
    await databaseReference
        .child('products')
        .once()
        .then((DataSnapshot dataSnapshot) =>
            dataSnapshot.value.entries.forEach((doc) {
              products.add(Product(
                  id: doc.value['id'],
                  description: doc.value['description'],
                  price: doc.value['price'],
                  listImageUrl: doc.value['listImageUrl'],
                  title: doc.value['title'],
                  nutritionList: doc.value['nutrition'] == null
                      ? null
                      : doc.value['nutrition']));
            }))
        .then((value) => null)
        .catchError((onError) => print(onError));

    // await databaseReference.child('products').child('104').update({
    //   'nutrition': {'calories': '65', 'fat': '5555', 'protein': '33'}
    // });
  }

  Product findProduct(productId) {
    return products.firstWhere((data) => data.id == productId);
  }
}
