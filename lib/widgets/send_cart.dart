import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SendCart {
  void sendCart(BuildContext context, int quantity, double totalSum, List items,
      Function orderNow) {
    showPlatformDialog(
        context: context,
        builder: (ctx) => PlatformAlertDialog(
              title: Text('Order now?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(quantity == 1
                      ? 'You have $quantity item in your cart.'
                      : 'You have $quantity items in your cart.'),
                  Text(
                      items.toString().replaceAll('[', '').replaceAll(']', '')),
                  Text('Total summary: ${totalSum}'),
                ],
              ),
              actions: [
                PlatformDialogAction(
                    child: Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
                PlatformDialogAction(
                    child: Text('Order now'),
                    onPressed: () {
                      orderNow();
                      Navigator.pop(ctx);
                    }),
              ],
            ));
  }
}
