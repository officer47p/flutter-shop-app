import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final url =
        "https://flutter-shop-app-22bfa.firebaseio.com/products/${id}.json";
    final lastFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    http.Response response;
    try {
      response = await http.patch(
        url,
        body: json.encode(
          {
            "isFavorite": isFavorite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw Exception();
      }
    } catch (err) {
      isFavorite = lastFavoriteStatus;
      notifyListeners();
      throw err;
    }
  }
}
