import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key, this.onSaved, this.initialValue});

  final Function(String?)? onSaved;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: MyConsts.primaryDark),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          label: Text(
            MyConsts.mail,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: MyConsts.primaryDark.withOpacity(0.6),
                fontSize: 14),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.all(12)),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.trim().length <= 1 ||
            value.contains('@') == false) {
          return MyConsts.mailError;
        }
        return null;
      },
      onSaved: onSaved
    );
  }
}
