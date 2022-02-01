import 'package:exo1/models/user.dart';
import 'package:exo1/services/auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserAuth? _userAuth;
  final AuthService _authService = AuthService();
  UserAuth get getUser => _userAuth!;

  void refreshUser() async {
    print('refreshUser');
    _userAuth = await _authService.getUserDetails();
    notifyListeners();
  }
}
