import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_iq/consts.dart';

class WorktoolsTag extends StatelessWidget {
  const WorktoolsTag({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: MyConsts.bgColor, width: 2)),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/elements/tag.svg',
              width: 14,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: MyConsts.bgColor, fontWeight: FontWeight.w700, fontSize: 12),
            )
          ],
        ));
  }
}
