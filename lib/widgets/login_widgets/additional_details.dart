import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:product_iq/widgets/login_widgets/company_input.dart';
import 'package:product_iq/widgets/login_widgets/name_input.dart';
import 'package:product_iq/widgets/login_widgets/phone_no_input.dart';
import 'package:product_iq/widgets/login_widgets/product_exp_input.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdditionalDetailsForm extends StatefulWidget {
  const AdditionalDetailsForm(
      {super.key,
      required this.userEmail,
      required this.userPassword});

  final String userEmail;
  final String userPassword;

  @override
  State<AdditionalDetailsForm> createState() => _AdditionalDetailsFormState();
}

class _AdditionalDetailsFormState extends State<AdditionalDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  var enteredPhoneNo = "", enteredJobTitle = "", enteredCompany = "", enteredName = "";
  String? selectedProductExp;

  var termsAndConditionsAccept = false;

  void signUpAndLogin() async {
    if (_formKey.currentState!.validate() && termsAndConditionsAccept) {
      _formKey.currentState!.save();
      final client = http.Client();
      final registerUrl = Uri.parse('${MyConsts.baseUrl}/auth/register');
      http.Response response = await client.post(registerUrl,
          headers: {
            'Content-type': 'application/json',
          },
          body: json.encode({
            "username": widget.userEmail,
            "email": widget.userEmail,
            "password": widget.userPassword,
            "product_exp": selectedProductExp,
            "name": enteredName.trim(),
            "phone_number": enteredPhoneNo.trim(),
            "job_title": enteredJobTitle.trim(),
            "company_or_institution": enteredCompany.trim(),
          }));
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final loginUrl = Uri.parse('${MyConsts.baseUrl}/auth/login');
        http.Response response2 = await http.post(loginUrl,
            headers: {
              'Content-type': 'application/json',
            },
            body: json.encode({
              "username": widget.userEmail,
              "password": widget.userPassword
            }));
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
    }
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
              height: 12,
            ),
            MyElevatedButton(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              colorFrom: MyConsts.primaryColorFrom,
              colorTo: MyConsts.primaryColorTo,
              onTap: signUpAndLogin,
              child: const Text("Continue"),
            ),
          ],
        ));
  }
}
