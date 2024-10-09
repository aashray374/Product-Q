import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/screens/sales_screens/product_sales_screen.dart';
import 'package:product_iq/screens/sales_screens/sales_screen_home.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/services/app_service.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainSalesScreen extends StatefulWidget {
  const MainSalesScreen({super.key, required this.appService});

  final AppService appService;

  @override
  State<MainSalesScreen> createState() => _MainSalesScreenState();
}

class _MainSalesScreenState extends State<MainSalesScreen> {
  late PageController _pageController;
  var currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    // startAutoScroll();

    _pageController = PageController(initialPage: 0);
    onLaunch();
    super.initState();
  }

  void onLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isOnboard", true);
  }

  void startAutoScroll() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      int nextPage = (currentIndex + 1) % 4;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentIndex = nextPage;
      });
    });
  }
  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConsts.bgColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: 5,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              controller: _pageController,
              itemBuilder: (context, index) =>
                  index == 0 ? const SalesScreen() : ProductSalesScreen(index),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; ++i)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(4),
                  height: i == currentIndex ? 8 : 4,
                  width: i == currentIndex ? 8 : 4,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: MyConsts.primaryColorFrom),
                )
            ],
          ),
          const SizedBox(height: 12,),
        ],
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        GestureDetector(
          onTap: () {
            GoRouter.of(context).pushNamed(MyAppRouteConst.signupRoute);
          },
          child: Container(
            width: deviceWidth / 2.5,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: MyConsts.primaryColorFrom)),
            child: Text(
              "SKIP",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: MyConsts.primaryColorFrom),
            ),
          ),
        ),
        MyElevatedButton(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          width: deviceWidth / 2.5,
          colorFrom: MyConsts.primaryColorFrom,
          colorTo: MyConsts.primaryColorTo,
          child: Text(
            "NEXT",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          onTap: () {
            setState(() {
              currentIndex++;
              if (currentIndex > 3) {
                GoRouter.of(context).pushNamed(MyAppRouteConst.signupRoute);
              } else {
                _pageController.jumpToPage(currentIndex);
              }
            });
          },
        )
      ],
    );
  }
}
