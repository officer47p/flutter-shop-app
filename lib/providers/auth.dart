import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signUp(String email, String password) async {}

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
}
