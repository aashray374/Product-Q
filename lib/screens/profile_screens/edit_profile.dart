import 'package:flutter/material.dart';
import 'package:product_iq/widgets/home_widgets/main_app_screen.dart';
import 'package:product_iq/widgets/profile_widgets/edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key, required this.details});

  final Map<String,String> details;

  @override
  Widget build(BuildContext context) {
    return MainAppScreen(
        title: "Edit Profile",
        body: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(20),
            child: Column(
              children: [
                EditProfileForm(details: details,),
              ],
            ),
          ),
        ));
  }
}
