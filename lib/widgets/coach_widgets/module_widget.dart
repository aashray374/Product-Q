import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget(
      {super.key, this.appTitle, required this.title, required this.percentCompleted});

  final String title;
   final String ? appTitle;
  final double percentCompleted;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: const [MyConsts.shadow2]),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(
              flex: 2,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color:appTitle=="Product Industry Trainer"? MyConsts.productColors[0][0]:MyConsts.productColors[3][0],
              ),
              height: deviceWidth * 0.13,
              width: deviceWidth * 0.13,
              child: const Icon(
                Icons.content_paste,
                color: Colors.white,
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700, color: MyConsts.primaryDark),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            const Spacer(
              flex: 1,
            ),
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: MyConsts.productColors[3][0].withOpacity(0.2),
                  ),
                ),
                Container(
                  width: percentCompleted * 100,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:appTitle=="Product Industry Trainer"? MyConsts.productColors[0][0]:MyConsts.productColors[3][0],
                  ),
                ),
              ],
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              "${(100 * percentCompleted).round()}%",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: MyConsts.primaryDark, fontWeight: FontWeight.w700),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
