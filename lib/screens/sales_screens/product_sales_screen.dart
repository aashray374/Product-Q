import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_iq/widgets/sales_widgets/rps_custom_painter.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/sales_widgets/sales_bulb_point.dart';
import 'package:product_iq/widgets/sales_widgets/sales_tick_point.dart';

class ProductSalesScreen extends StatelessWidget {
  const ProductSalesScreen(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  size: Size(deviceWidth, deviceWidth * 0.95),
                  //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: RPSCustomPainter(
                      MyConsts.productName[index - 1]== "PRODUCT Interview Coach"? Color(0xFF082AA8):
                      MyConsts.productColors[index - 1][0],
                      MyConsts.productName[index - 1]== "PRODUCT Interview Coach"? Color(0xFF082AA8):
                      MyConsts.productColors[index - 1][1]),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Stack(
                        children: [
                          SizedBox(
                              width: deviceWidth,
                              child: Text(
                                MyConsts.appName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.white,fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )),
                          Image.asset("assets/elements/ratebar.png",width: 20,color: Colors.white,)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,),
                    Padding(
                      padding:  EdgeInsets.only(bottom:8,right:8,left:8 ),
                      child: Text(
                        index == 1
                            ? MyConsts.coachBulbPoints[0]
                            : index == 2
                                ? MyConsts.interviewBulbPoints[0] :MyConsts.iqBulbPoints[0]  ,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w900,color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 1; i <= 3; ++i)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: SalesBulbPoint(
                              index == 1
                                  ? MyConsts.coachBulbPoints[i]
                                  : index == 2
                                      ? MyConsts.interviewBulbPoints[i] : MyConsts.iqBulbPoints[i],
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 30, 12),
                child: Text(
                  MyConsts.productName[index - 1].toUpperCase()  ,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 29),
                  textAlign: TextAlign.left,
                ),
              ),
              Positioned(
                top: 10,
                right: -15,
                  child: SvgPicture.asset(MyConsts.productimage[index - 1],width: 85,))
            ],
          ),
          Opacity(
            opacity: 0.6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < 3; ++i)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: SalesTickPoint(
                        index == 1
                            ? MyConsts.coachTickPoints[i]
                            : index == 2

                            ? MyConsts.interviewTickPoints[i]
                            : MyConsts.iqTickPoints[i],
                      ),
                    ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
