import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key, required this.title, required this.hintText, this.onSaved});

  final String title;
  final String hintText;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 14, color: MyConsts.primaryDark),
          ),
          const SizedBox(
            height: 4,
          ),
          TextFormField(
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: MyConsts.primaryDark),
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: MyConsts.primaryDark.withOpacity(0.6), fontSize: 14),
                isDense: true,
                contentPadding: const EdgeInsets.all(12)),
            validator: (value){
              if(value==null || value.isEmpty){
                return "Please enter to continue";
              }
              return null;
            },
            onSaved: onSaved,
          )
        ],
      ),
    );
  }
}
