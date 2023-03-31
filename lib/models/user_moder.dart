import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  String? _loggedInUsername;

  String? get loggedInUsername => _loggedInUsername;

  set loggedInUsername(String? value) {
    _loggedInUsername = value;
    notifyListeners();
  }
}
