import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:product_iq/widgets/login_widgets/company_input.dart';
import 'package:http/http.dart' as http;
import 'package:product_iq/widgets/login_widgets/job_title_input.dart';
import 'package:product_iq/widgets/login_widgets/name_input.dart';
import 'package:product_iq/widgets/login_widgets/phone_no_input.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key, required this.details});

  final Map<String, String> details;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();

  void saveChanges() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _formKey.currentState!.save();
      if (MyConsts.token == '') {
        setState(() {
          MyConsts.token = preferences.getString("token")!;
          debugPrint("New token");
        });
      }
      final registerUrl = Uri.parse('${MyConsts.baseUrl}/user/update');
      http.Response response = await http.post(registerUrl,
          headers: MyConsts.requestHeader,
          body: json.encode({
            //"product_exp": selectedProductExp,
            "name": enteredName.trim(),
            "phone_number": enteredPhoneNum.trim(),
            "job_title": enteredJobTitle.trim(),
            "company_or_institution": enteredCompany.trim(),
          }));
      debugPrint(response.body);
      if (response.statusCode <= 300) {
        preferences.setString('name', enteredName.trim());
        preferences.setString('phone_no', enteredPhoneNum.trim());
        preferences.setString('job_title', enteredJobTitle.trim());
        preferences.setString('company', enteredCompany.trim());
        GoRouter.of(context).goNamed(MyAppRouteConst.profileRoute, extra: true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyConsts.primaryColorFrom,
            content: Text(
              "Changes Saved",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: MyConsts.bgColor),
            )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyConsts.primaryColorFrom,
            content: Text(
              "Error Connecting...",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: MyConsts.bgColor),
            )));
      }
    }
  }

  var enteredName = '',
      enteredCompany = '',
      enteredJobTitle = '',
      enteredPhoneNum = '';

  @override
  void initState() {
    enteredName = widget.details['name']!;
    enteredCompany = widget.details['company']!;
    enteredJobTitle = widget.details['job_title']!;
    enteredPhoneNum = widget.details['phone_no']!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          NameInput(
            initialValue: enteredName,
            onSaved: (value) {
              enteredName = value!;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          PhoneNumInput(
            initialValue: enteredPhoneNum,
            onSaved: (value) {
              enteredPhoneNum = value!;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          CompanyInput(
            initialValue: enteredCompany,
            onSaved: (value){
              enteredCompany = value!;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          JobTitleInput(
            initialValue: enteredJobTitle,
            onSaved: (value){
              enteredJobTitle = value!;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          //ProductExperienceInput(),
          const SizedBox(
            height: 12,
          ),
          MyElevatedButton(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            width: double.infinity,
            colorFrom: MyConsts.primaryColorFrom,
            colorTo: MyConsts.primaryColorTo,
            onTap: saveChanges,
            child: Text(
              "Save Changes",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
