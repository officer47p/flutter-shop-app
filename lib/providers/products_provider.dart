import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product getProductById(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> fetchAndSetProducts() async {
    print("Called the refresh");
    const url = "https://flutter-shop-app-22bfa.firebaseio.com/products.json";
    try {
      final response = await http.get(url);
      if (json.decode(response.body) == null) {
        notifyListeners();
        return;
      } else if (json.decode(response.body)["error"] != null) {
        throw HttpException(json.decode(response.body)["error"]);
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> tempProductsList = [];
      print("Before foreach, response: ${data} and ${response.body}");
      data.forEach((prodId, prodData) {
        tempProductsList.add(Product(
          id: prodId,
          title: prodData["title"],
          price: prodData["price"],
          description: prodData["description"],
          imageUrl: prodData["imageUrl"],
          isFavorite: prodData["isFavorite"],
        ));
      });
      _items = [...tempProductsList];
      notifyListeners();
    } catch (err) {
      print("Error in fetchAndSetProducts ${err}");
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = "https://flutter-shop-app-22bfa.firebaseio.com/products.json";
    final response = await http.post(url,
        body: json.encode(
          {
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "isFavorite": product.isFavorite
          },
        ));

    _items.add(
      Product(
        id: json.decode(response.body)["name"],
        description: product.description,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final productIndex =
        _items.indexWhere((element) => element.id == product.id);
    if (productIndex >= 0) {
      final url =
          "https://flutter-shop-app-22bfa.firebaseio.com/products/${product.id}.json";

      await http.patch(url,
          body: json.encode({
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "imageUrl": product.imageUrl,
          }));
      _items[productIndex] = product;
      notifyListeners();
    } else {
      print("Update failed");
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        "https://flutter-shop-app-22bfa.firebaseio.com/products/${productId}.json";
    final existingProductIndex =
        _items.indexWhere((element) => element.id == productId);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((prod) => prod.id == productId);
    notifyListeners();
    var response;
    try {
      response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw Exception("Couldn't delete the product.");
      }
      existingProduct = null;
    } catch (err) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw err;
    }
  }

  // void toggleFavorite(String id) {
  //   _items.firstWhere((element) => element.id == id).isFavorite =
  //       !_items.firstWhere((element) => element.id == id).isFavorite;
  //   notifyListeners();
  // }
}
