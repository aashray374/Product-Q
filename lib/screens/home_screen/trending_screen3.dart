import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:story/story.dart';

class TrendingScreen3 extends StatelessWidget {
  const TrendingScreen3(
      {super.key,
      required this.headings,
      required this.body,
      required this.buttonText,
      required this.onTap,
      required this.appName});

  final List<String> headings;
  final List<String> body;
  final List<String> buttonText;
  final List<void Function()> onTap;
  final List<String> appName;

  @override
  Widget build(BuildContext context) {
    if (context.mounted) {
      return Scaffold(
        body: SafeArea(
          child: StoryPageView(
            itemBuilder: (context, pageIndex, storyIndex) {
              int i = storyIndex;
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/elements/story-bg.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            headings[i],
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            body[i],
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            gestureItemBuilder: (context, pageIndex, storyIndex) {
              int i = storyIndex;
              return Stack(children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 48),
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          size: 24, color: Colors.white),
                      onPressed: () {
                        GoRouter.of(context).goNamed(MyAppRouteConst.homeRoute);
                      },
                    ),
                  ),
                ),
                Positioned(
                    bottom: 24,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: MyElevatedButton(
                          colorFrom: MyConsts.productColors[3][0],
                          colorTo: MyConsts.productColors[0][1],
                          width: 300,
                          onTap: onTap[i],
                          child: Text(
                            buttonText[i],
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    )),
              ]);
            },
            storyLength: (pageIndex) {
              return headings.length;
            },
            pageLength: 1,
            onPageLimitReached: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
