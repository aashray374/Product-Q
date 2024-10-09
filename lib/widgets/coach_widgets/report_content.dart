import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/area.dart';

class ReportContent extends StatelessWidget {
  const ReportContent(
      {super.key,
      required this.area,
      required this.title,
      required this.subtitle});

  final Area area;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    var textColor = MyConsts.primaryGreen;
    var text = "Strong Areas";
    if (area == Area.weak) {
      textColor = MyConsts.primaryRed;
      text = "Weak Areas";
    }
    if (area == Area.average) {
      textColor = MyConsts.primaryOrange;
      text = "Average Areas";
    }
    return Column(
      children: [
        Chip(
            backgroundColor: Colors.white,
            side: BorderSide.none,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            label: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w900, color: textColor),
            )),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: MyConsts.primaryDark, fontWeight: FontWeight.w700),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
