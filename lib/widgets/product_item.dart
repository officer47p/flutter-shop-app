import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(ProductDetailScreen.routeName, arguments: product.id),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(-1, -1),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: Image.network(
              product.imageUrl,
              // color: Colors.red,
              fit: BoxFit.cover,
              // alignment: Alignment.topCenter,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: CircleBorder(),
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: Theme.of(context).accentColor,
                  ),
                  onTap: () {
                    cart.additem(product.id, product.price, product.title);
                    final scaffold = Scaffold.of(context);
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text("${product.title} Added To The Cart"),
                        duration: Duration(seconds: 2),
                        backgroundColor: Theme.of(context).primaryColor,
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () => cart.removeSingelItem(product.id),
                          textColor: Colors.amber,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              trailing: Consumer<Product>(
                builder: (context, value, _) => Material(
                  child: InkWell(
                    customBorder: CircleBorder(),
                    child: Icon(
                      value.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onTap: () {
                      product.toggleFavoriteStatus();
                    },
                  ),
                  color: Colors.transparent,
                ),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Galada"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// IconButton(
//   icon: Icon(Icons.add_shopping_cart),
//   color: Theme.of(context).accentColor,
//   onPressed: () {
//     cart.additem(product.id, product.price, product.title);
//     final scaffold = Scaffold.of(context);
//     scaffold.hideCurrentSnackBar();
//     scaffold.showSnackBar(
//       SnackBar(
//         content: Text("${product.title} Added To The Cart"),
//         duration: Duration(seconds: 2),
//         backgroundColor: Theme.of(context).primaryColor,
//         action: SnackBarAction(
//           label: "Undo",
//           onPressed: () => cart.removeSingelItem(product.id),
//           textColor: Colors.amber,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10),
//           ),
//         ),
//       ),
//     );
//   },
// ),
