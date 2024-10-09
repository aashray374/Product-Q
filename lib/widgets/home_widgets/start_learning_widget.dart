import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/home_widgets/search_bar.dart';

class StartLearningWidget extends StatelessWidget {
  const StartLearningWidget({super.key});

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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Elevate your\nProduct IQ",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 28),
                ),
                const Spacer(),
                Image.asset(
                  'assets/elements/target.png',
                  semanticLabel: "target",
                  width: deviceWidth * 0.2,
                )
              ],
            ),
            // const SizedBox(
            //   height: 4,
            // ),
            // Text(
            //   "Elevate your Product IQ",
            //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            //       color: MyConsts.bgColor.withOpacity(0.8),
            //       fontSize: 16,
            //       fontStyle: FontStyle.italic),
            // ),
            const SizedBox(
              height: 18,
            ),
            Opacity(
                opacity: 0.6,
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context).pushNamed(MyAppRouteConst.searchRoute);
                  },
                  child: const SearchBarWidget(
                    color: MyConsts.bgColor,
                    text: MyConsts.searchText,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
