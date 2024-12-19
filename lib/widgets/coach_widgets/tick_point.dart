import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class TickPoint extends StatelessWidget {
  const TickPoint({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        const Icon(Icons.check, color: Colors.lightGreen,),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: deviceWidth*0.65,
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: MyConsts.primaryDark.withOpacity(0.6)),
          ),
        ),
      ],
    );
  }
}
