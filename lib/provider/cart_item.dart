import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String idProduct;
  final String title;
  final int quantity;
  final double price;
  final String image;

  CartItem({
    @required this.id,
    @required this.idProduct,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.image,
  });
}
