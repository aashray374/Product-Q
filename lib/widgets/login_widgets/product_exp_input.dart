import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class ProductExperienceInput extends StatelessWidget {
  const ProductExperienceInput({super.key, this.onChanged});

  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                label: Text(
                  "Product Experience",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: MyConsts.primaryDark.withOpacity(0.6), fontSize: 14),
                ),
                isDense: false,
                contentPadding: const EdgeInsets.all(12)),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: MyConsts.primaryDark),
            items: MyConsts.productExperience
                .map((exp) => DropdownMenuItem(
                    value: exp,
                    child: Text(
                      exp,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: MyConsts.primaryDark),
                    )))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
