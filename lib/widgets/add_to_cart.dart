import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../provider/product.dart';
import '../provider/cart.dart';
import 'package:provider/provider.dart';

class AddToCart {
// void increase() {
//     setState(() {
//       widget.quantity++;
//     });
//   }

//   void decrease() {
//     setState(() {
//       if (widget.quantity == 0) return;
//       widget.quantity--;
//     });
//   }

  void addToCart(BuildContext ctx, Product product, int quantity, String idCart,
      bool isDetailScreen) {
    showPlatformDialog(
        context: ctx,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => PlatformAlertDialog(
              title: Text('Add to cart?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Product: ${product.title}'),
                  Text('Quantity: $quantity'),
                  Text(
                      'Total price: \$${double.parse(product.price) * quantity}'),
                  if (!isDetailScreen)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PlatformIconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              CupertinoIcons.minus,
                              size: 35,
                            ),
                            onPressed: () => setState(() {
                                  if (quantity == 0) return;
                                  quantity--;
                                })),
                        PlatformIconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              CupertinoIcons.plus,
                              size: 35,
                            ),
                            onPressed: () => setState(() {
                                  quantity++;
                                })),
                      ],
                    )
                ],
              ),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                PlatformDialogAction(
                  child: Text('Put to cart'),
                  onPressed: () {
                    Provider.of<Cart>(ctx, listen: false).addCart(
                      product.id,
                      idCart,
                      double.parse(product.price),
                      quantity,
                      product.title,
                      product.listImageUrl[0],
                    );
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  },
                ),
              ],
            ),
          );
        });
  }
}
