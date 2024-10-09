import 'dart:async';

import 'package:flutter/material.dart';

class AuthService {
  final StreamController<bool> _onAuthStateChange =
      StreamController.broadcast();

  Stream<bool> get onAuthStateChange => _onAuthStateChange.stream;

  Future<bool> login() async {
    await Future.delayed(Duration(seconds: 1));
    debugPrint("login");

    _onAuthStateChange.add(true);
    return true;
  }

  void logout() {
    _onAuthStateChange.add(false);
  }
}
