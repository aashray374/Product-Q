import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:product_iq/widgets/login_widgets/email_input.dart';
import 'package:product_iq/widgets/login_widgets/password_input.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var enteredEmail = "", enteredPassword = "";
  final _formKey = GlobalKey<FormState>();
  Widget buttonChild = const Text(MyConsts.signIn);

  void signInWithEmail() async {
    print("object");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final loginUrl = Uri.parse('${MyConsts.baseUrl}/auth/login');
      http.Response response = await http.post(loginUrl,
          headers: {
            'Content-type': 'application/json',
          },
          body: json.encode({
            "username": enteredEmail.trim(),
            "password": enteredPassword.trim()
          }));
      final res = jsonDecode(response.body);
      debugPrint(res.toString());
      //prefs.setString('token', res['token']);
      //prefs.setString('name', value)
      if (response.statusCode == 200) {
        final t = JwtDecoder.getExpirationDate(res['token']!).toString();
        debugPrint(t);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res['token']);
        prefs.setString('name', res['name']);
        prefs.setString('email', res['email']);
        prefs.setString('product_exp', res['product_exp']);
        prefs.setString('phone_no', res['phone_number']);
        prefs.setString('job_title', res['job_title']);
        prefs.setString('company', res['company']);
        debugPrint(prefs.getString('token'));
        loginSuccess();
      } else if (response.statusCode == 400) {
        setState(() {
          buttonChild = const Text(MyConsts.signIn);
        });
        incorrectCredentials(res['error']);
      } else {
        setState(() {
          buttonChild = const Text(MyConsts.signIn);
        });
        loginFailure();
      }
    }
  }

  void incorrectCredentials(String err) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: MyConsts.primaryColorFrom,
        content: Text(
          err,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: MyConsts.bgColor),
        )));
  }

  void loginFailure() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: MyConsts.primaryColorFrom,
        content: Text(
          "Something went wrong. Please try again later.",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: MyConsts.bgColor),
        )));
  }

  void loginSuccess() {
    GoRouter.of(context).goNamed(MyAppRouteConst.appsRoute);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: MyConsts.primaryColorFrom,
        content: Text(
          "Successfully Logged in",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: MyConsts.bgColor),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            EmailInput(
              onSaved: (value) {
                enteredEmail = value!;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            PasswordInput(
              onSaved: (value) {
                enteredPassword = value!;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // web view to a link
                    GoRouter.of(context)
                        .pushNamed(MyAppRouteConst.forgotPasswordRoute);
                  },
                  child: Text(
                    "Forgot Password?",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: MyConsts.primaryColorFrom, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            MyElevatedButton(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              width: double.infinity,
              colorFrom: MyConsts.primaryColorFrom,
              colorTo: MyConsts.primaryColorTo,
              onTap: () {
                setState(() {
                  buttonChild = const CircularProgressIndicator(
                    color: MyConsts.bgColor,
                  );
                });
                signInWithEmail();
              },
              child: buttonChild,
            ),
          ],
        ));
  }
}
