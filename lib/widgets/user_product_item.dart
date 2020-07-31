import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  UserProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      subtitle: Text(
        product.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: () => Navigator.of(context)
                .pushNamed(EditProductScreen.routeName, arguments: product),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () async {
              try {
                await Provider.of<Products>(context).deleteProduct(product.id);
              } catch (err) {
                print("fkdsjnfjk sdkjf sdk fsd fk shd");
                scaffold.showSnackBar(SnackBar(
                  content: Text("Couldn't delete the product."),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
