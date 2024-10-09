import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/services/recently_visited_provider.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';

class MainIQCard extends ConsumerWidget {
  const MainIQCard(
      {super.key,
      required this.icon,
      required this.text,
      required this.index,
      required this.isAllowed,
      required this.appId});

  final IconData icon;
  final String text;
  final int index;
  final bool isAllowed;
  final int appId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return MyElevatedButton(
        width: double.infinity,
        colorFrom: MyConsts.productColors[2][0].withOpacity(0.8),
        colorTo: MyConsts.productColors[2][1].withOpacity(0.8),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: MyConsts.bgColor,
            ),
            const SizedBox(
              width: 24,
            ),
            SizedBox(
              width: deviceWidth * 0.6,
              child: Text(
                text,
                softWrap: true,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        onTap: () {
          if(!isAllowed) {
            print( " ankit --------------- ${'title'+ text  +'index'+ index.toString()+ 'appId' +  appId.toString()}");

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Topic Locked',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                          color: MyConsts
                              .primaryDark)),
                  content: const Text(
                      'To view this topic you need to purchase the full app', style: TextStyle(color: MyConsts.primaryDark)),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).goNamed(
                            MyAppRouteConst
                                .subscriptionRoute);
                      },
                      child: const Text('Buy Now'),
                    ),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              },
            );
            return;
          }
          ref.read(recentlyVisitedProvider.notifier).addRecentlyVisited(

              appId,
              text,
              MyConsts.appTypes[2],
              MyAppRouteConst.iqLearningsRoute,
              index.toString());
          print( " hemant --------------- ${'title'+ text  +'index'+ index.toString()+ 'appId' +  appId.toString()}");
          GoRouter.of(context).pushNamed(MyAppRouteConst.iqLearningsRoute,
              pathParameters: {'title': text, 'index': index.toString(), 'appId': appId.toString()});
        });
  }
}
