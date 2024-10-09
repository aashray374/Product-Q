import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:flutter_svg/svg.dart';

class OffersWidget extends StatelessWidget {
  const OffersWidget(
      {super.key,
      required this.productName,
      required this.discountPrice,
      required this.originalPrice});

  final String productName;
  final double discountPrice;
  final double originalPrice;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [MyConsts.primaryColorFrom, MyConsts.primaryColorTo],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              productName,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 24),
            ),
            // const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("INR ${discountPrice.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 28)),
                    Text(
                      "${(originalPrice+(originalPrice*0.35)).toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Color(0xFFB3B3B3),
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/elements/offers.svg',
                  semanticsLabel: "offer",
                  width: deviceWidth * 0.2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
