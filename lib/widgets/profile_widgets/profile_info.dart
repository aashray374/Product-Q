import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: MyConsts.primaryColorTo,
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.51,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: MyConsts.primaryDark),
          ),
        ),
      ],
    );
  }
}
