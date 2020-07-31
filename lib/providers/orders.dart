import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder({double amount, List<CartItem> products}) async {
    final url = "https://flutter-shop-app-22bfa.firebaseio.com/orders.json";
    final dateTime = DateTime.now();
    try {
      final response = await http
          .post(url,
              body: json.encode({
                "amount": amount,
                "dateTime": dateTime.toString(),
                "products": products
                    .map((e) => {
                          "id": e.id,
                          "productId": e.productId,
                          "title": e.title,
                          "quantity": e.quantity,
                          "price": e.price,
                        })
                    .toList(),
              }))
          .timeout(Duration(seconds: 10));
      // if (response.statusCode >= 400) {
      //   throw Exception();
      // }
      _orders.add(
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: amount,
          products: products,
          dateTime: dateTime,
        ),
      );
    } catch (err) {
      print(err);
      throw err;
    }
    notifyListeners();
  }
}
