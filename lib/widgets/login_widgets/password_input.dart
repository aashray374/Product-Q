import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key, this.onSaved});

  final Function(String?)? onSaved;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  var isVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: MyConsts.primaryDark),
      keyboardType: TextInputType.visiblePassword,
      obscureText: !isVisible,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
            });
          },
          icon: !isVisible
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
        label: Text(
          MyConsts.password,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: MyConsts.primaryDark.withOpacity(0.6),
              fontSize: 14),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().length < 8) {
          return MyConsts.passwordError;
        }
        return null;
      },
      onSaved: widget.onSaved
    );
  }
}
