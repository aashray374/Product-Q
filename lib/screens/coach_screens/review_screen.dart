import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/answer.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/coach_widgets/reivew_box.dart';
import 'package:product_iq/widgets/coach_widgets/your_answer_box.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen(
      {super.key,
      required this.answers,
      required this.completedPercent,
      required this.totalPercent,
      required this.isOnlyPrevious,
      required this.appId});

  final List<Answer> answers;
  final bool isOnlyPrevious;
  final int appId;
  final String completedPercent;
  final String totalPercent;

  @override
  Widget build(BuildContext context) {
    final bool isPrevious = answers.length > 2;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            MyConsts.productNameMap[appId]!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: MyConsts.productColors[3][0],
        ),
        backgroundColor: MyConsts.bgColor,
        body: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.only(left: 12, right: 12, top: 32),
            child: Column(
              children: [
                if (!isPrevious) ...[
                  ReviewBox(answerRating: answers[0], isCurrent: true),
                  const SizedBox(
                    height: 16,
                  ),
                  YourAnswerBox(
                    userAnswer: answers[0].answer,
                    isPrevious: false,
                    answerRating: answers[0],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
                Text(
                  "Your Past Answers",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: MyConsts.primaryDark),
                ),
                const SizedBox(
                  height: 12,
                ),
                for (var i = isPrevious ? 0 : 1; i < answers.length; i++) ...[
                  // ReviewBox(
                  //   answerRating: answers[i],
                  //   isCurrent: false,
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  YourAnswerBox(
                    userAnswer: answers[i].answer,
                    isPrevious: true,
                    answerRating: answers[i],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: isOnlyPrevious
            ? null
            : [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: deviceWidth / 2.5,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: MyConsts.productColors[3][0])),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "RETRY",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: MyConsts.productColors[3][0]),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.refresh,
                          size: 18,
                          color: MyConsts.productColors[3][0],
                        ),
                      ],
                    ),
                  ),
                ),
                MyElevatedButton(
                  width: deviceWidth / 2.5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  colorFrom: MyConsts.productColors[3][0],
                  colorTo: MyConsts.productColors[3][0],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "NEXT",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(Icons.navigate_next,
                          size: 18, color: Colors.white),
                    ],
                  ),
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    print("token is ------${preferences.getString("token")!}");
                    GoRouter.of(context).goNamed(
                        MyAppRouteConst.coachModulesInfoRoute,
                        extra: completedPercent == totalPercent
                            ? ((int.parse(completedPercent)) /
                                    int.parse(totalPercent))
                                .toPrecision(2)
                            : ((int.parse(completedPercent) + 1) /
                                    int.parse(totalPercent))
                                .toPrecision(2),
                        pathParameters: {
                          'completedPercent':
                              (int.parse(completedPercent) + 1).toString(),
                          'totalPercent': totalPercent,
                          'appId': '$appId',
                          'id': MyConsts.moduleId,
                          'moduleTitle': MyConsts.moduleName
                        });
                  },
                )
              ]);
  }
}
