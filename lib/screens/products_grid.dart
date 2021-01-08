import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../widgets/product_item.dart';
import '../provider/product.dart';
import '../provider/auth.dart';

class ProductsGrid extends StatefulWidget {
  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  bool isLoaded = false;
  List<Product> productData;

  @override
  void dispose() {
    print('PRODUCTS GRIIIIIID DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Products>(context, listen: false)
            .getProductsFromFirebase(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    //CustomProgressIndicator());
                    CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Products>(
                builder: (ctx, data, child) => GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: data.getProducts.length,
                  itemBuilder: (ctx, i) {
                    return ProductItem(data.getProducts[i]);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              );
            }
          }
        });
  }
}
