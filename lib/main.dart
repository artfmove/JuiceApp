import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import './screens/products_grid.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import './provider/products.dart';
import './provider/delivery_data.dart';

import './screens/settings.dart';
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';
import './provider/auth.dart';
import './provider/cart.dart';
import './widgets/badge.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

class Main extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => App();
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Brightness brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    final materialTheme = new ThemeData(
      //primarySwatch: Colors.teal,
      primaryColor: Colors.teal[700],
      accentColor: Color.fromRGBO(253, 217, 131, 1),
      buttonColor: Colors.red[400],
      //backgroundColor: Color.fromRGBO(237, 238, 240, 1),
      canvasColor: Color.fromRGBO(237, 238, 240, 1),
      // buttonColor: Colors.teal[100],
      appBarTheme: AppBarTheme(
          color: Colors.teal[400]), //Color.fromARGB(253, 217, 131, 1)),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.purple[300],
        padding: EdgeInsets.symmetric(vertical: 16),
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      // canvasColor: MaterialColor(
      //   0xFFFAECE6,
      //   <int, Color>{
      //     50: Color(0xFF162A49),
      //     100: Color(0xFF162A49),
      //     200: Color(0xFF162A49),
      //     300: Color(0xFF162A49),
      //     400: Color(0xFF162A49),
      //     500: Color(0xFF162A49),
      //     600: Color(0xFF162A49),
      //     700: Color(0xFF162A49),
      //     800: Color(0xFF162A49),
      //     900: Color(0xFF162A49),
      //   },
      //)
    );
    final materialDarkTheme = new ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
      accentColor: Colors.red,
    );

    final cupertinoTheme = new CupertinoThemeData(
      //brightness: brightness, // if null will use the system theme
      scaffoldBackgroundColor: Color.fromRGBO(237, 238, 240, 1),
      primaryContrastingColor: Colors.red,
      primaryColor: CupertinoDynamicColor.withBrightness(
        color: Colors.teal,
        darkColor: Colors.teal[700],
      ),
      barBackgroundColor: Colors.white,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeliveryData(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => PlatformApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],

          title: 'Flutter Platform Widgets',
          material: (_, __) {
            return new MaterialAppData(
              theme: materialTheme,
              darkTheme: materialDarkTheme,
              themeMode: brightness == Brightness.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
            );
          },
          cupertino: (_, __) => new CupertinoAppData(
            theme: cupertinoTheme,
          ),
          //home: LandingPage(),
          //initialRoute: '/',
          routes: {
            '/': (ctx) => auth.isAuth() ? LandingPage() : AuthScreen(),
            //'/': (ctx) => Provider.of<Auth>(context).isAuth() ? LandingPage() : AuthScreen(),
            '/auth-screen': (ctx) => AuthScreen(),
            '/cart': (ctx) => CartScreen(),
          },
        ),
      ),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  @override
  void dispose() {
    print('PRODUCTS GRIIIIIID LANDING');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('landing build');
    final List<Map<String, Object>> items = [
      {
        'page': ProductsGrid(),
        'title': 'Overview',
      },
      {
        'page': CartScreen(),
        'title': 'Cart',
      },
      {
        'page': Settings(context),
        'title': 'Settings',
      }
    ];

    return FutureBuilder(
        future: Provider.of<Cart>(context, listen: false).getCarts(),
        builder: (ctx, m) {
          print('0000000000000000000000');
          return PlatformTabScaffold(
            tabController: PlatformTabController(initialIndex: 0),
            iosContentPadding: true,
            appBarBuilder: (_, index) => PlatformAppBar(
              title: Text(items[index]['title']),
              // trailingActions: <Widget>[
              //   PlatformIconButton(
              //     padding: EdgeInsets.zero,
              //     icon: Icon(context.platformIcons.share),
              //     onPressed: () {
              //       showPlatformDialog(
              //         context: context,
              //         builder: (_) => PlatformAlertDialog(
              //           title: Text('Alert'),
              //           content: Text('Some content'),
              //           actions: <Widget>[
              //             PlatformDialogAction(
              //               child: PlatformText('Cancel'),
              //               onPressed: () {
              //                 Navigator.of(context).pop();
              //               },
              //             ),
              //             PlatformDialogAction(
              //                 child: PlatformText('Cancel'), onPressed: () {}),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ],
            ),
            bodyBuilder: (context, index) =>
                //tabIndex = index;
                items[index]['page'],
            items: [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.circle_grid_3x3), label: 'Offer'),
              BottomNavigationBarItem(
                icon: Consumer<Cart>(
                  builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: cart.getList.length.toString(),
                  ),
                  child: Icon(CupertinoIcons.shopping_cart),
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.settings), label: 'Settings'),
            ],
          );
        });
  }
}
