import 'package:flutter/material.dart';
import '../provider/cart_item.dart' as item;
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import '../provider/cart.dart';
import '../screens/product_detail_screen.dart';

class CartItem extends StatelessWidget {
  final item.CartItem data;
  CartItem(this.data);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
                Provider.of<Products>(context).findProduct(data.idProduct),
                data.id,
                data.quantity,
                false)));
      },
      child: Dismissible(
        key: Key(data.id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            PlatformIcons(context).delete,
            color: Colors.white,
            size: 30,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
        ),
        direction: DismissDirection.endToStart,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Hero(
              tag: data.idProduct + '1',
              child: Image.network(
                data.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(data.title),
          subtitle: Text(data.quantity.toString()),
          trailing: Text('${(data.quantity * data.price).toString()}\$'),
        ),
        confirmDismiss: (direction) {
          return showPlatformDialog(
            context: context,
            builder: (ctx) => PlatformAlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to remove item from cart?'),
              actions: [
                PlatformDialogAction(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.pop(ctx, true);
                    }),
                PlatformDialogAction(
                    child: Text('No'),
                    onPressed: () => Navigator.pop(ctx, false)),
              ],
            ),
          );
        },
        onDismissed: (_) async {
          Provider.of<Cart>(context, listen: false).deleteCart(data.id);
          //return true;
        },
      ),
    );
  }
}
