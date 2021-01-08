import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../widgets/cart_item.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../widgets/send_cart.dart';
import '../provider/auth.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isController = true;
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Cart>(context);
    final auth = Provider.of<Auth>(context).checkConnection(context);

    var totalPrice = 0.0;
    totalPrice = data.getTotalPrice;
    if (totalPrice == 0.0) {
      _controller.forward();

      return SlideTransition(
          position: _slideAnimation,
          child: Center(
            child: Text(
              'Add something to your cart',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w100),
            ),
          ));
    } else
      return Scaffold(
          body: Stack(alignment: Alignment.bottomCenter, children: [
        ListView.builder(
            itemCount: data.getList.length,
            itemBuilder: (ctx, i) => CartItem(data.getList[i])),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PlatformButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Order now for \$', style: TextStyle(fontSize: 20)),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.bounceOut,
                  reverseDuration: const Duration(milliseconds: 0),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final offsetAnimation = Tween<Offset>(
                            begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                        .animate(animation);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  child: Text(totalPrice.toString(),
                      key: ValueKey<double>(totalPrice),
                      style: const TextStyle(fontSize: 20)),
                ),
              ],
            ),
            onPressed: () {
              SendCart().sendCart(context, data.getList.length,
                  data.getTotalPrice, data.reversCartToList(), data.orderNow);
            },
          ),
        ),
      ]));

    //   body: FutureBuilder(
    //       future: Provider.of<Cart>(context).getData(),
    //       builder: (ctx, dataSnapshot) {
    //         return Consumer<Cart>(builder: (ctx, data, child) {
    //           price = data.getTotalPrice;

    //           return Stack(alignment: Alignment.bottomCenter, children: [
    //             ListView.builder(
    //                 itemCount: data.cartData.length,
    //                 itemBuilder: (ctx, i) => CartItem(data.cartData[i])),
    //             PlatformButton(
    //               child: PlatformText('Order now for $price'),
    //             )
    //           ]);
    //         });
    //       }),
    // );
  }
}
