import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class SalesText extends StatelessWidget {
  const SalesText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Boost ",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w800, color: MyConsts.primaryLight),
          ),
          TextSpan(
            text: "your product skills ",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: "10x ",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 36,
                color: MyConsts.primaryLight),
          ),
          TextSpan(
            text: "and outperform competition",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
