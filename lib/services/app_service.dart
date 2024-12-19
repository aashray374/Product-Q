import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService with ChangeNotifier {
  late final SharedPreferences sharedPreferences;
  AppService(this.sharedPreferences);
  Future<void> onAppStart(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    final token = sharedPreferences.getString("token");
    // debugPrint(token);
    // final t = JwtDecoder.getExpirationDate(token!).toString();
    // debugPrint(t);
    if(token==null ||JwtDecoder.isExpired(token)){
      GoRouter.of(context).goNamed(MyAppRouteConst.salesRoute);
    }
    else if(!JwtDecoder.isExpired(token)){
      GoRouter.of(context).goNamed(MyAppRouteConst.appsRoute);
    }
    // _initialized = true;
    // notifyListeners();
  }
}
