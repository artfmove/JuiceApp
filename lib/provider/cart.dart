import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'cart_item.dart';

class Order {
  final String title;
  final int quantity;
  final double price;

  Order(this.title, this.quantity, this.price);
}

class Cart extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;

  DatabaseReference database = FirebaseDatabase.instance.reference();

  List<CartItem> cartData = [];
  double totalPrice;

  List<CartItem> get getList {
    return cartData;
  }

  double get getTotalPrice {
    totalPrice = 0;
    getList.forEach((e) {
      totalPrice = totalPrice + (e.price * e.quantity);
    });

    return totalPrice;
  }

  void orderNow() async {
    List<String> orderNowList = [];
    getList.forEach((element) {
      orderNowList.add(
          'title:${element.title}, quantity:${element.quantity}, price:${element.price} ');
    });

    await database
        .child('orders')
        .child(user.uid)
        .push()
        .set({
          'idOrder': DateTime.now().toIso8601String(),
          'idUser': user.uid,
          'list': orderNowList,
          'totalPrice': getTotalPrice,
        })
        .then((value) => print('Ordered'))
        .catchError((onError) => print(onError));

    await database
        .child('carts')
        .child(user.uid)
        .remove()
        .then((value) => null)
        .catchError((error) => print(error));
    await getCarts();
  }

  CartItem getExistCartQuantity(String idProduct) {
    var cart = CartItem(
        id: null,
        idProduct: null,
        title: null,
        quantity: 1,
        price: null,
        image: null);
    getList.forEach((element) {
      if (element.idProduct == idProduct) {
        cart = element;
      }
    });
    return cart;
  }

  Future<void> addCart(String idProduct, String idCart, double price,
      int quantity, String title, String image) async {
    String newKey = database.child('carts').child(user.uid).push().key;
    print(idCart);

    await database
        .child('carts')
        .child(user.uid)
        .child(idCart != null ? idCart : newKey)
        .update({
          'id': idCart != null ? idCart : newKey,
          'idProduct': idProduct,
          'title': title,
          'quantity': quantity.toString(),
          'price': price.toString(),
          'image': image,
        })
        .then((value) => print('Card added'))
        .catchError((error) => print("Failed to add cart: $error"));

    await getCarts();
  }

  Future<void> getCarts() async {
    print('getCartsss');
    print('${auth.currentUser.uid}111111111111');
    final List<CartItem> listData = [];

    await database
        .child('carts')
        .child(auth.currentUser.uid)
        .once()
        .then((DataSnapshot dataSnapshot) => dataSnapshot.value.entries.forEach(
            (doc) => listData.add(CartItem(
                id: doc.value['id'],
                idProduct: doc.value['idProduct'],
                price: double.tryParse(doc.value['price']),
                quantity: int.parse(doc.value['quantity']),
                title: doc.value['title'],
                image: doc.value['image']))))
        .catchError((onError) => print('error getCarts $onError'));

    // totalPrice = 0;
    // listData.forEach((e) {
    //   totalPrice = totalPrice + (e.price * e.quantity);
    // });
    cartData = listData;
    print('00000000000${cartData.length}');
    notifyListeners();
  }

  Future<void> deleteCart(String id) async {
    print(id);
    await database
        .child('carts')
        .child(user.uid)
        .child(id)
        .remove()
        .then((value) => print('deleted'))
        .catchError((onError) => print(onError));
    await getCarts();
  }

  bool isPreOrdered(String title) {
    if (cartData.any((element) => element.title == title ? true : false))
      return true;
    else
      return false;
  }

  List reversCartToList() {
    List list = [];
    getList.forEach((element) {
      list.add(element.title.toString());
    });
    return list;
  }
}
