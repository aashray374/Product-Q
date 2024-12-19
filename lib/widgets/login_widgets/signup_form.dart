import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:flutter/gestures.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:product_iq/widgets/login_widgets/company_input.dart';
import 'package:product_iq/widgets/login_widgets/email_input.dart';
import 'package:product_iq/widgets/login_widgets/name_input.dart';
import 'package:product_iq/widgets/login_widgets/password_input.dart';
import 'package:http/http.dart' as http;
import 'package:product_iq/widgets/login_widgets/phone_no_input.dart';
import 'dart:convert';

import 'package:product_iq/widgets/login_widgets/product_exp_input.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  var enteredName = "",
      enteredEmail = "",
      enteredPassword = "",
      enteredPhoneNo = "",
      enteredJobTitle = "",
      enteredCompany = "";
  String? selectedProductExp;

  var termsAndConditionsAccept = false;
  var isVisible = false;

  final _formKey = GlobalKey<FormState>();

  void signUpWithEmail() async {
    if (_formKey.currentState!.validate() && termsAndConditionsAccept) {
      _formKey.currentState!.save();
      final client = http.Client();
      final registerUrl = Uri.parse('${MyConsts.baseUrl}/auth/register');
      http.Response response = await client.post(registerUrl,
          headers: {
            'Content-type': 'application/json',
          },
          body: json.encode({
            "username": enteredEmail.trim(),
            "email": enteredEmail.trim(),
            "password": enteredPassword.trim(),
            "product_exp": selectedProductExp,
            "name": enteredName.trim(),
            "phone_number": enteredPhoneNo.trim(),
            "job_title": enteredJobTitle.trim(),
            "company_or_institution": enteredCompany.trim(),
          }));
      debugPrint(response.body);
      if (response.statusCode <= 300) {
        registerSuccess();
      } else {
        registerFailure();
      }
    }
  }

  void registerSuccess() {
    GoRouter.of(context).pushReplacementNamed(MyAppRouteConst.signinRoute);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: MyConsts.primaryColorFrom,
        content: Text(
          "User Registered Successfully, Please Login",
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: MyConsts.bgColor),
        )));
  }

  void registerFailure() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: MyConsts.primaryColorFrom,
        content: Text(
          "User Registration Failed, Please try again later",
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
            NameInput(
              onSaved: (value) {
                enteredName = value!;
              },
            ),
            const SizedBox(
              height: 12,
            ),
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
              height: 12,
            ),
            ProductExperienceInput(onChanged: (value) {
              if (value == null) return;
              setState(() {
                selectedProductExp = value;
              });
            }),
            const SizedBox(
              height: 12,
            ),
            CompanyInput(
              onSaved: (value) {
                enteredCompany = value!;
              },
            ),

            const SizedBox(
              height: 12,
            ),
            // JobTitleInput(
            //   onSaved: (value) {
            //     enteredJobTitle = value!;
            //   },
            // ),
            // const SizedBox(
            //   height: 12,
            // ),
            PhoneNumInput(
              onSaved: (value) {
                enteredPhoneNo = value!;
              },
            ),
            Row(
              children: [
                Checkbox(
                    value: termsAndConditionsAccept,
                    onChanged: (val) {
                      setState(() {
                        termsAndConditionsAccept = val!;
                      });
                    }),
                const SizedBox(
                  width: 12,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: MyConsts.tncText,
                        style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(
                        text: MyConsts.tnc,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: MyConsts.primaryColorFrom),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => print(MyConsts.tnc)),
                  ]),
                )
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
              onTap: signUpWithEmail,
              child: const Text(MyConsts.signUp),
            ),
          ],
        ));
  }
}
