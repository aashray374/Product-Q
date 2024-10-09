import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';

class PaymentFailureScreen extends StatelessWidget {
  const PaymentFailureScreen({super.key});

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
                    Icons.error_outline_rounded,
                    size: 120,
                    color: MyConsts.primaryRed,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Payment Failed",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: MyConsts.primaryDark, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Please try again or contact support for assistance.",
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
                  "OK",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 16),
                ),
                onTap: () {
                  GoRouter.of(context).pushReplacementNamed(MyAppRouteConst.paymentFailureRoute);
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pop()
                }),
          )
        ],
      ),
    );
  }
}
