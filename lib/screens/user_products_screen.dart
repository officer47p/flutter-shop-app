import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = "/user-products";
  @override
  Widget build(BuildContext context) {
    final productsManger = Provider.of<Products>(context);
    final products = productsManger.items;
    return Scaffold(
      appBar: AppBar(
        title: Text("User Products"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => UserProductItem(products[i]),
        itemCount: products.length,
      ),
    );
  }
}
