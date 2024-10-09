import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConsts.bgColor,
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [MyConsts.coachShadow],
                      color: MyConsts.productColors[3][0],
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: MyConsts.productColors[3][0], width: 12)),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 120,
                    color: MyConsts.bgColor,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Payment Successful",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: MyConsts.primaryDark, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Congratulations on starting your journey with Product Cohort!",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: MyConsts.primaryDark, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 80),
            child: MyElevatedButton(
                width: double.infinity,
                colorFrom: MyConsts.productColors[3][0],
                colorTo: MyConsts.productColors[3][0],
                child: Text(
                  "Done",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 16),
                ),
                onTap: () {
                  GoRouter.of(context).goNamed(MyAppRouteConst.appsRoute);
                }),
          )
        ],
      ),
    );
  }
}
