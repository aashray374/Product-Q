// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// FutureOr<String> appRouteRedirect(BuildContext context, SharedPreferences sharedPreferences, GoRouterState state) async{
//   bool isLoggedIn;
//   final token = sharedPreferences.getString("token");
//   if(token==null) {
//     isLoggedIn = false;
//   }
//   else if(!JwtDecoder.isExpired(token)){
//     isLoggedIn = true;
//   }
// }