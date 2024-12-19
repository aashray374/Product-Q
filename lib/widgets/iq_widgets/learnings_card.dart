import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/learning.dart';
import 'package:product_iq/routes/app_route_consts.dart';

class LearningsCard extends StatelessWidget {
  const LearningsCard(
      {super.key,
      this.showFullText = false, required this.learnings, required this.index, required this.appId});

  final bool showFullText;
  final int index;
  final List<Learning> learnings;
  final int appId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      margin:const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyConsts.productColors[2][0].withOpacity(0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            learnings[index].name,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: MyConsts.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 20),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            learnings[index].description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 18, color: MyConsts.primaryDark, fontWeight: FontWeight.w600),
            maxLines: showFullText ? null : 2,
          ),
          if (!showFullText)
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(
                        MyAppRouteConst.iqLearningsDetailRoute,
                        extra: learnings,
                        pathParameters: {
                          'index': index.toString(),
                          'appId': appId.toString(),
                        });
                  },
                  child: Text(
                    "View Card",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: MyConsts.productColors[2][1],
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
