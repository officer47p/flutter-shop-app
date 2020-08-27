import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  String get userId {
    return _userId;
  }

  bool get isAuth {
    print(token);
    print("The condition: ${token != null}");
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      print("Is authenticated");
      return _token;
    }
    return null;
  }

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
      _token = authData["idToken"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(authData["expiresIn"])));
      _userId = authData["localId"];
      autoLogOut();
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  void logOut() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void autoLogOut() {
    print("Called auto logout");
    final timerSecs = _expiryDate.difference(DateTime.now()).inSeconds;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    _authTimer = Timer(Duration(seconds: timerSecs), logOut);
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
