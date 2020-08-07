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
          builder: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (_, auth, previewsProducts) => Products(
              auth.token,
              auth.userId,
              previewsProducts == null ? [] : previewsProducts.items),
        ),
        ChangeNotifierProvider(
          builder: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (_, auth, previewsOrders) => Orders(
              auth.token, previewsOrders == null ? [] : previewsOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          print("Rebuilding the whole app");
          return MaterialApp(
            title: "My Shop",
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: <String, Widget Function(BuildContext)>{
              ProductsOverviewScreen.routeName: (context) {
                print("It's calling builder in init screen");
                return ProductsOverviewScreen();
              },
              AuthScreen.routeName: (ctx) {
                print("It's calling builder in init screen for auth screen");
                return AuthScreen();
              },
              ProductDetailScreen.routeName: (ctx) {
                print(
                    "It's calling builder in init screen for products details screen");
                return ProductDetailScreen();
              },
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
