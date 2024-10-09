import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class JobTitleInput extends StatelessWidget {
  const JobTitleInput({super.key, this.onSaved, this.initialValue});

  final void Function(String?)? onSaved;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: MyConsts.primaryDark),
      decoration: InputDecoration(
          label: Text(
            "Job Title",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: MyConsts.primaryDark.withOpacity(0.6),
                fontSize: 14),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.all(12)),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.trim().length <= 1) {
          return "Please enter your job title";
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
