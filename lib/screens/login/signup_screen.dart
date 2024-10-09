import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/login_widgets/login_or_register.dart';
import 'package:product_iq/widgets/login_widgets/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthScreen(
        heading: MyConsts.signupText,
        form: SignUpForm(),
        buttonText: MyConsts.signIn);
  }
}
