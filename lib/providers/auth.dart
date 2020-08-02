import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String command) async {
    print("Called Authenticate");
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:${command}?key=AIzaSyBIJDyqQIeFeXS6vl3XW9Qj3X_KNDcPdb8";
    try {
      http.Response response = await http
          .post(
            url,
            body: json.encode(
              {
                "email": email,
                "password": password,
                "returnSecureToken": true,
              },
            ),
          )
          .timeout(Duration(seconds: 10));
      final authData = json.decode(response.body);
      print(authData);
      if (authData["error"] != null) {
        throw HttpException(authData["error"]["message"]);
      }
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> signUp(String email, String password) async {
    await _authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    await _authenticate(email, password, "signInWithPassword");
  }
}

// Future<void> signUp(String email, String password) async {
//   const url =
//       "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBIJDyqQIeFeXS6vl3XW9Qj3X_KNDcPdb8";
//   final response = await http.post(
//     url,
//     body: json.encode(
//       {"email": email, "password": password, "returnSecureToken": true},
//     ),
//   );
//   print(json.decode(response.body));
// }

// Future<void> signIn(String email, String password) async {
//   const url =
//       "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBIJDyqQIeFeXS6vl3XW9Qj3X_KNDcPdb8";
//   final response = await http.post(
//     url,
//     body: json.encode(
//       {"email": email, "password": password, "returnSecureToken": true},
//     ),
//   );
//   print(json.decode(response.body));
// }
