import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class SalesTickPoint extends StatelessWidget {
  const SalesTickPoint(this.txt, {super.key});

  final String txt;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Image.asset(
          'assets/elements/tick2.png',
          height: 20,
          width: 20,
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
            width: deviceWidth / 1.4,
            child: Text(
              txt,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w400, color: MyConsts.primaryDark),
              maxLines: 2,
            ))
      ],
    );
  }
}
