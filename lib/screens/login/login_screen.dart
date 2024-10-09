import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/login_widgets/login_form.dart';
import 'package:product_iq/widgets/login_widgets/login_or_register.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScreen(
        heading: MyConsts.loginText,
        form: LoginForm(),
        buttonText: MyConsts.signUp);
  }
}
