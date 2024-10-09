import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class CompanyInput extends StatelessWidget {
  const CompanyInput({super.key, this.onSaved, this.initialValue});

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
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            label: Text(
              "Company (Optional)",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: MyConsts.primaryDark.withOpacity(0.6),
                  fontSize: 14),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.all(12)),
        onSaved: onSaved);
  }
}
