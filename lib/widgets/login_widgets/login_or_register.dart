import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_outlined_button.dart';
import 'package:product_iq/widgets/home_widgets/main_app_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen(
      {super.key,
      required this.heading,
      required this.form,
      required this.buttonText,
      this.isAllButtonRequired = true});

  final String heading;
  final Widget form;
  final String buttonText;
  final bool? isAllButtonRequired;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    _auth.authStateChanges().listen((event) {
      setState(() {
        user = event;
      });
    });
    super.initState();
  }

  void _signInAndGoHome(String username, String password) async {
    final loginUrl = Uri.parse('${MyConsts.baseUrl}/auth/login');
    http.Response response2 = await http.post(loginUrl,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode({"username": username, "password": password}));
    final res = jsonDecode(response2.body);
    debugPrint(res.toString());
    //prefs.setString('token', res['token']);
    //prefs.setString('name', value)
    if (response2.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', res['token']);
      prefs.setString('name', res['name']);
      prefs.setString('email', res['email']);
      prefs.setString('product_exp', res['product_exp']);
      prefs.setString('phone_no', res['phone_number']);
      prefs.setString('job_title', res['job_title']);
      prefs.setString('company', res['company']);
      debugPrint(prefs.getString('token'));
    }
    GoRouter.of(context).goNamed(MyAppRouteConst.homeRoute);
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

  Future<void> _handleGoogleSignIn() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      // Start the Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the auth details from the signed-in Google account
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredentials = await _auth.signInWithCredential(credential);
      debugPrint(userCredentials.toString());

      if (userCredentials.additionalUserInfo?.isNewUser == true) {
        // Navigate to additional details screen for new users
        GoRouter.of(context).pushNamed(
          MyAppRouteConst.additionalDetailsRoute,
          extra: {
            'email': userCredentials.user?.email,
            'password': userCredentials.user?.uid,
          },
        );
      } else {
        print("hemant");
        // User already exists, sign in and go to home
        _signInAndGoHome(
          userCredentials.user!.email!,
          userCredentials.user!.uid,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  /*Future<User?> _handleGoogleSignIn() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the Google sign-in
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (error) {
      print("Google Sign-In Error: $error");
      return null;
    }
  }*/
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MainAppScreen(
        title: MyConsts.appName,
        body: SingleChildScrollView(
          //physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                widget.heading,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 20, color: MyConsts.primaryColorTo),
              ),
              Text(
                MyConsts.signupSubtext,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 24,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(24.0),
              //   child: SizedBox(
              //     width: double.infinity,
              //     child: SvgPicture.asset(
              //       'assets/elements/login_logo.svg',
              //       semanticsLabel: "login",
              //       width: MediaQuery.of(context).size.width / 2.6,
              //     ),
              //   ),
              // ),
              widget.form,
              if (widget.isAllButtonRequired!)
                MyOutlinedButton(
                  width: double.infinity,
                  outlineColor: MyConsts.primaryColorFrom,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  onTap: () {
                    setState(() {
                      if (widget.buttonText == MyConsts.signUp) {
                        GoRouter.of(context)
                            .pushReplacementNamed(MyAppRouteConst.signupRoute);
                      } else if (widget.buttonText == MyConsts.signIn) {
                        GoRouter.of(context)
                            .pushReplacementNamed(MyAppRouteConst.signinRoute);
                      }
                    });
                  },
                  child: Text(
                    widget.buttonText,
                    style: const TextStyle(color: MyConsts.primaryDark),
                  ),
                ),
              if (widget.isAllButtonRequired!)
                MyOutlinedButton(
                  width: double.infinity,
                  outlineColor: MyConsts.primaryColorFrom,
                  onTap: _handleGoogleSignIn,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: const Text(
                    "Login using Google",
                    style: TextStyle(color: MyConsts.primaryDark),
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }
}
