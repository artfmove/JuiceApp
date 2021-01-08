import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String price;
  final List<dynamic> listImageUrl;
  final Map<dynamic, dynamic> nutritionList;
  bool isFav = false;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.listImageUrl,
      this.isFav,
      this.nutritionList});
}
