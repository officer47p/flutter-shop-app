import 'package:flutter/foundation.dart';
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

  void addOrder({double amount, List<CartItem> products}) {
    _orders.add(
      OrderItem(
        id: DateTime.now().toString(),
        amount: amount,
        products: products,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
