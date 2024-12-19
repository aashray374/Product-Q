import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/screens/coach_screens/coach_main_screen.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/coach_widgets/skill_gap_report.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';

class ModuleReport extends StatelessWidget {
  const ModuleReport({super.key});

  @override
  Widget build(BuildContext context) {
    return CoachMainScreen(
        appBarTitle: "Result",
        body: SingleChildScrollView(
          child: SafeArea(
              minimum:
                  const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 60),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: RadialGradient(colors: [
                            MyConsts.productColors[3][0].withOpacity(0.7),
                            MyConsts.productColors[3][0]
                          ])),
                      child: const Center(
                          child: Text(
                        "🎉",
                        style: TextStyle(fontSize: 48),
                      )),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      "Congratulations",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: MyConsts.primaryDark,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      "You passed as an APM ! Score 80% or more to achieve PM",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: MyConsts.primaryDark, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const SkillGapReport(),
                    const SizedBox(
                      height: 32,
                    ),
                    MyElevatedButton(
                        width: double.infinity,
                        colorFrom: MyConsts.productColors[3][0],
                        colorTo: MyConsts.productColors[3][0],
                        child: Text(
                          "Proceed to Next Challenge",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 16),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        }),
                    const SizedBox(
                      height: 16,
                    ),
                    MyElevatedButton(
                        width: double.infinity,
                        colorFrom: MyConsts.productColors[3][0],
                        colorTo: MyConsts.productColors[3][0],
                        child: Text(
                          "Learn on ProductIQ",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 16),
                        ),
                        onTap: () {
                          GoRouter.of(context)
                              .pushReplacementNamed(MyAppRouteConst.appsRoute);
                        })
                  ],
                ),
              )),
        ));
  }
}
