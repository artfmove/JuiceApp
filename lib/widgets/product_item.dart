import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../provider/product.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../screens/product_detail_screen.dart';
import '../widgets/add_to_cart.dart';
import '../provider/cart.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  ProductItem(this.product);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isPreOrdered = false;

  @override
  Widget build(BuildContext context) {
    final existCart =
        Provider.of<Cart>(context).getExistCartQuantity(widget.product.id);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (_) => ProductDetailScreen(
                  widget.product, existCart.id, existCart.quantity, true)));
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Hero(
              tag: widget.product.id,
              child: Container(
                //color: Colors.red,
                //decoration:
                //BoxDecoration(borderRadius: BorderRadius.circular(16)),
                height: 250,
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/loading.png'),
                  image: NetworkImage(
                    widget.product.listImageUrl[0],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                // border: Border(
                //   top: BorderSide(width: 1.0, color: Colors.grey),
                // ),
                color: Colors.white70,
              ),
              height: 50,
              padding: EdgeInsets.only(left: 10, right: 10),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            widget.product.title,
                          ),
                          Text(
                            '\$${widget.product.price}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Consumer<Cart>(
                          builder: (_, cart, __) {
                            isPreOrdered =
                                cart.isPreOrdered(widget.product.title);
                            return Icon(
                              PlatformIcons(context).shoppingCart,
                              size: 26,
                              color: isPreOrdered
                                  ? Colors.teal[700]
                                  : Colors.grey[600],
                            );
                          },
                        ),
                        onTap: () {
                          if (!isPreOrdered) {
                            new AddToCart().addToCart(
                                context, widget.product, 1, null, false);
                            //Scaffold.of(context).showSnackBar(snackBar);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// GridTile(
//         child: GestureDetector(
//           child: Hero(
//             tag: widget.product.id,
//             child: Image.network(
//               widget.product.listImageUrl[0],
//               fit: BoxFit.cover,
//             ),
//           ),
//           onTap: () {
//             Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
//                 builder: (_) => ProductDetailScreen(widget.product)));
//           },
//         ),
//         footer: GridTileBar(
//           backgroundColor: Colors.black87,
//           title: Text(
//             '${widget.product.title}',
//             style: TextStyle(fontSize: 18),
//             textAlign: TextAlign.left,
//           ), //\n${widget.product.price}',

//           subtitle: Text(
//             '${widget.product.price.toString()}\$',
//             textAlign: TextAlign.center,
//           ),
// trailing: GestureDetector(
//   child: Consumer<Cart>(
//     builder: (_, cart, __) {
//       isPreOrdered = cart.isPreOrdered(widget.product.title);
//       return Icon(
//         PlatformIcons(context).shoppingCart,
//         color: isPreOrdered
//             ? Theme.of(context).accentColor
//             : Colors.white,
//       );
//     },
//   ),
//   onTap: () {
//     if (!isPreOrdered) {
//       new AddToCart().addToCart(context, widget.product, 1);
//       //Scaffold.of(context).showSnackBar(snackBar);
//     }
//   },
// ),
//         ),
//       ),
