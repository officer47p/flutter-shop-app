import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = "/user-products";

  Future<void> _refreshContent(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsManger = Provider.of<Products>(context);
    // final products = productsManger.items;
    print("BUILD IS BEING CALLED");
    return Scaffold(
        appBar: AppBar(
          title: Text("User Products"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
            ),
            IconButton(
              icon: Icon(Icons.ac_unit),
              onPressed: () => Provider.of<Products>(context, listen: false)
                  .callChangeNotifier(),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshContent(context),
          builder: (context, snapshot) {
            print("FutureBuilder build call");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final products = Provider.of<Products>(context).items;
              return RefreshIndicator(
                onRefresh: () => _refreshContent(context),
                child: ListView.builder(
                  itemBuilder: (ctx, i) => UserProductItem(products[i]),
                  itemCount: products.length,
                ),
              );
            }
          },
        ));
  }
}
