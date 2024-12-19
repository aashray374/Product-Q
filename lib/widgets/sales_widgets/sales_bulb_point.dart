import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SalesBulbPoint extends StatelessWidget {
  const SalesBulbPoint(this.txt, {super.key});

  final String txt;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/elements/bulb.svg',
          semanticsLabel: "bulb",
          height: 24,
          width: 24,
        ),
        const SizedBox(
          width: 12,
        ),
        SizedBox(
            width: deviceWidth / 1.4,
            child: Text(
              txt,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Color(0xFFF3F2FC)),
              //maxLines: 2,
            ))
      ],
    );
  }
}
