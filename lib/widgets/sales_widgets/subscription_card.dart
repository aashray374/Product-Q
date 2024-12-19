import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/sales_widgets/unordered_list.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard(
      {super.key,
      required this.newPrice,
      required this.oldPrice,
      this.bgColor = const Color(0x1AFFFFFF), this.isRecommended=false, required this.cardTitle, required this.features});

  final double newPrice;
  final double oldPrice;
  final Color bgColor;
  final bool isRecommended;
  final String cardTitle;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    print("features $features");
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MyConsts.primaryColorFrom),
            color: bgColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: isRecommended ? 180 : null,
                  child: Text(
                    cardTitle,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: MyConsts.primaryDark, fontWeight: FontWeight.w700),
                  ),
                ),
                const Spacer(),
                Visibility(
                  visible: isRecommended,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(240),
                        gradient: const LinearGradient(
                            colors: [MyConsts.primaryColorFrom, MyConsts.primaryColorTo]),
                      ),
                      child: Text("Recommended",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: MyConsts.bgColor))),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            UnorderedList(features),
            const SizedBox(
              height: 8,
            ),
            Text(
              "INR ${newPrice.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: MyConsts.primaryColorFrom,
                  ),
            ),
            Text(
              "INR ${(newPrice+(newPrice*0.35)).toStringAsFixed(2)}",
              // "INR ${oldPrice.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: MyConsts.primaryDark.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.lineThrough),
            ),
          ],
        ),
      ),
    ]);
  }
}
