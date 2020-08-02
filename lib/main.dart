import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';

import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => Products(),
        ),
        ChangeNotifierProvider(
          builder: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          builder: (_) => Orders(),
        ),
        ChangeNotifierProvider(
          builder: (_) => Auth(),
        )
      ],
      child: MaterialApp(
        title: "My Shop",
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          // fontFamily: "Galada",
          // fontFamily: "Arial",
        ),
        initialRoute: AuthScreen.routeName,
        routes: <String, Widget Function(BuildContext)>{
          "/": (context) => ProductsOverviewScreen(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
