import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final ctx = context;
    // final scaffold = Scaffold.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total",
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        Chip(
                          label: Text(
                            "\$${cart.calculateTotalPrice.toString()}",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        FlatButton(
                          child: Text(
                            "ORDER NOW",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          textColor: Theme.of(context).primaryColor,
                          onPressed: cart.itemCount > 0
                              ? () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    await Provider.of<Orders>(context,
                                            listen: false)
                                        .addOrder(
                                      products: cart.items.values.toList(),
                                      amount: cart.calculateTotalPrice,
                                    );
                                    cart.clearCart();
                                  } catch (err) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("An error accourd"),
                                        content: Text("Something went wrong"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Ok"),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          )
                                        ],
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.of(context).pop();
                                  }
                                }
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (ctx, i) {
                    final item = cart.items.entries.toList()[i];
                    print("Rebuilding CartItem ${item.key}");
                    return CartItem(
                      id: item.key,
                      price: item.value.price,
                      quantity: item.value.quantity,
                      titel: item.value.title,
                      deleteItem: cart.removeItem,
                    );
                  },
                  itemCount: cart.items.length,
                )),
              ],
            ),
    );
  }
}
