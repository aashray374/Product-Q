import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class SkillGapText extends StatelessWidget {
  const SkillGapText({super.key, required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: "$heading - ",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: MyConsts.primaryDark, fontWeight: FontWeight.w800),
      ),
      TextSpan(
        text: body,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: MyConsts.primaryDark),
      ),
    ]));
  }
}
