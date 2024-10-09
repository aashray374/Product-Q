import 'package:flutter/material.dart';
import 'package:product_iq/widgets/login_widgets/additional_details.dart';
import 'package:product_iq/widgets/login_widgets/login_or_register.dart';

class AdditionalDetailsScreen extends StatelessWidget {
  const AdditionalDetailsScreen({
    super.key,
    required this.userDetails,
  });

  final Map<String, String?> userDetails;

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
        heading: 'Fill in these details to continue',
        form: AdditionalDetailsForm(
          userEmail: userDetails['email']!,
          userPassword: userDetails['password']!,
        ),
        isAllButtonRequired: false,
        buttonText: "Continue");
  }
}
