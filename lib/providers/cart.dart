import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  // String lasItemId;

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    int count = 0;
    _items.forEach((key, value) => count += value.quantity);
    return count;
  }

  double get calculateTotalPrice {
    double totalPrice = 0;
    _items.forEach((key, value) => totalPrice += value.price * value.quantity);
    return totalPrice;
  }

  void additem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
    }
    // lasItemId = productId;
    notifyListeners();
  }

  // void undoAddition(String productId) {

  // }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingelItem(String productId) {
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      removeItem(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
