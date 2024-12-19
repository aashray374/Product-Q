import 'package:flutter/material.dart';
import 'package:product_iq/widgets/sales_widgets/rps_custom_painter.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/sales_widgets/sales_text.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Column(
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                    size: Size(deviceWidth, deviceWidth * 1.05),
                    //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                    painter: RPSCustomPainter(MyConsts.primaryColorFrom, MyConsts.primaryColorTo)),
              ),
              SafeArea(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: deviceWidth,
                        child: Text(
                          MyConsts.appName,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 280,
                      child: SalesText(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      MyConsts.salesScreenText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  // InkWell(
                  //   onTap: () {},
                  //   child: Container(
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(8),
                  //           color: MyConsts.primaryLight),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 24, vertical: 16),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             SvgPicture.asset(
                  //               'assets/elements/star.svg',
                  //               semanticsLabel: "star",
                  //               height: 20,
                  //               width: 20,
                  //             ),
                  //             Padding(
                  //               padding:
                  //                   const EdgeInsets.symmetric(horizontal: 8),
                  //               child: Text(
                  //                 MyConsts.freeText,
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .titleSmall!
                  //                     .copyWith(color: MyConsts.primaryDark),
                  //               ),
                  //             ),
                  //             SvgPicture.asset(
                  //               'assets/elements/star.svg',
                  //               semanticsLabel: "star",
                  //               height: 20,
                  //               width: 20,
                  //             ),
                  //           ],
                  //         ),
                  //       )),
                  // ),
                ],
              )),
            ],
          ),
          const Spacer(),
          Image.asset(
            'assets/elements/sales_flowchart.png',
            semanticLabel: "flowchart",
            width: deviceWidth*0.6,
          ),
          const Spacer(),
        ],
    );
  }
}
