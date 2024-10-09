import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/screens/iq_screens/main_iq_screen.dart';
import 'package:product_iq/widgets/coach_widgets/tick_point.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';

class IqOnboardingScreen extends StatelessWidget {
  const IqOnboardingScreen({super.key, required this.appId});
  final int appId;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return MainIQScreen(
      appId: appId,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 24,
            ),
            SvgPicture.asset(
              "assets/elements/coach-welcome.svg",
              height: deviceHeight * 0.25,
            ),
            const SizedBox(
              height: 24,
            ),
            for (var text in MyConsts.iqTickPoints) TickPoint(text: text),
            const SizedBox(
              height: 24,
            ),
            MyElevatedButton(
                width: double.infinity,
                colorFrom: MyConsts.productColors[2][0],
                colorTo: MyConsts.productColors[2][1],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Start Product Training",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 14),
                  ),
                ),
                onTap: () {
                  GoRouter.of(context)
                      .pushNamed(MyAppRouteConst.iqRoute,
                          pathParameters: {"appId": appId.toString()});
                })
          ],
        ),
      ),
    );
  }
}
