import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class PhoneNumInput extends StatelessWidget {
  const PhoneNumInput({super.key, this.onSaved, this.initialValue});

  final void Function(String?)? onSaved;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      style: Theme
          .of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: MyConsts.primaryDark),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          label: Text(
            "Phone No. (Optional)",
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium!
                .copyWith(
                color: MyConsts.primaryDark.withOpacity(0.6),
                fontSize: 14),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.all(12)),
      onSaved: onSaved,
    );
  }
}
