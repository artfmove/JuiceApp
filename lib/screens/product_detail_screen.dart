import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../provider/product.dart';
import '../widgets/add_to_cart.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  final String idCart;

  int quantity;
  final bool isFromGrid;
  ProductDetailScreen(
    this.product,
    this.idCart,
    this.quantity,
    this.isFromGrid,
  );
  static const routeName = '/product-detail-screen';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  //var quantity = 1;

  void increase() {
    setState(() {
      widget.quantity++;
    });
  }

  void decrease() {
    setState(() {
      if (widget.quantity == 0) return;
      widget.quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return PlatformScaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                //iconTheme: IconThemeData(color: Colors.purple),
                expandedHeight: 300,
                pinned: true,
                title: Text(
                  widget.product.title,
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  // title: Text(
                  //   widget.product.title,
                  // ),
                  background: Hero(
                      tag: widget.isFromGrid
                          ? widget.product.id
                          : widget.product.id + '1',
                      child: CarouselSlider.builder(
                        itemCount: widget.product.listImageUrl.length,
                        options: CarouselOptions(
                          height: 400,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 4),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 1200),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                          onPageChanged: null,
                          scrollDirection: Axis.horizontal,
                        ),
                        itemBuilder: (BuildContext context, int itemIndex) =>
                            Image.network(
                          widget.product.listImageUrl[itemIndex],
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: 10),
                    Text(
                      '\$${widget.product.price}/0.5l',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: 300,
                        child: Text(
                          "\"${widget.product.description}\"",
                          textAlign: TextAlign.right,
                          softWrap: true,
                          style: TextStyle(
                              fontStyle: FontStyle.italic, height: 1.3),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(TextSpan(
                          style: TextStyle(height: 2),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Nutrition Facts per 100 grams:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '\nCalories: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: widget.product.nutritionList['calories']
                                  .toString(),
                            ),
                            TextSpan(
                                text: '\nFat: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: widget.product.nutritionList['fat']
                                  .toString(),
                            ),
                            TextSpan(
                                text: '\nProtein: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: widget.product.nutritionList['protein']
                                  .toString(),
                            ),
                          ])),
                    ),
                    SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color.fromRGBO(237, 238, 240, 1),
            ),
            //width: double.infinity * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Quantity',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    PlatformIconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.remove,
                        size: 40,
                        color: Theme.of(context).hintColor,
                      ),
                      onPressed: decrease,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: PlatformText(
                        '${widget.quantity}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    PlatformIconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.add,
                        size: 40,
                        color: Theme.of(context).hintColor,
                      ),
                      onPressed: increase,
                    ),
                  ],
                ),
                Padding(
                  //width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(8),
                  child: PlatformButton(
                    //color: Theme.of(context).primaryColor,
                    //material: MaterialRaisedButtonData(_,__ ) {},

                    //padding: EdgeInsets.symmetric(vertical: 20),
                    onPressed: widget.quantity == 0
                        ? null
                        : () => AddToCart().addToCart(context, widget.product,
                            widget.quantity, widget.idCart, true),
                    child: Text(
                      'Add to carts \$${widget.quantity * (double.tryParse(widget.product.price).abs())}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
