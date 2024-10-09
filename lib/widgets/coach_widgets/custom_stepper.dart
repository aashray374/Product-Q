import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'stepper_box.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/challenge.dart';

class CustomStepper extends StatelessWidget {
  const CustomStepper(
      {super.key,
      required this.heading,
      required this.challenges,
      required this.question,
      required this.problemId,
      this.moduleId = '1',
      required this.appId});

  final String heading;
  final List<Challenge> challenges;
  final String question;
  final String problemId;
  final String moduleId;
  final int appId;

  //sort challenges by order

  @override
  Widget build(BuildContext context) {
    int activeIndex = 0;
    for (var i = challenges.length - 1; i >= 0; --i) {
      if (challenges[i].isCompleted) {
        activeIndex = i + 1;
        break;
      }
    }
    if (activeIndex == challenges.length) {
      activeIndex = challenges.length - 1;
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: MyConsts.coachLight, borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: MyConsts.productColors[3][0],
                  fontSize: 18,
                  height: 1.3),
            ),
            const SizedBox(
              height: 18,
            ),
            Stack(
              children: [
                Column(
                  children: [
                    for (var challenge in challenges)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            if (challenge.isLocked) {
                              showDialog(
                                  context: (context),
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Challenge Locked',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: MyConsts.primaryDark)),
                                      content: const Text(
                                        'This challenge is locked. Please complete the previous challenges to unlock this one.',
                                        style: TextStyle(
                                            color: MyConsts.primaryDark),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'))
                                      ],
                                    );
                                  });
                              return;
                            }
                            GoRouter.of(context).pushNamed(
                                MyAppRouteConst.coachProblemRoute,
                                extra: {
                                  'question': question,
                                  'level_question': challenge.subtitle ?? '',
                                },
                                pathParameters: {
                                  'problemTitle': challenge.title,
                                  'problemId': challenge.id,
                                  'moduleId': moduleId,
                                  'appId': appId.toString()
                                });
                          },
                          child: StepperBox(
                            isCompleted: challenge.isCompleted,
                            title: challenge.title,
                            subtitle: challenge.subtitle,
                            rating: double.parse("${challenge.rating}"),
                            isLocked: challenge.isLocked,
                          ),
                        ),
                      ),
                  ],
                ),
                Positioned(
                  top: 4,
                  left: 0,
                  child: EasyStepper(
                      lineStyle: const LineStyle(
                          //progress: 0.5,
                          lineType: LineType.normal,
                          lineWidth: 100,
                          lineSpace: 0,
                          lineThickness: 2,
                          defaultLineColor: MyConsts.bgColor,
                          lineLength: 35),
                      showTitle: false,
                      unreachedStepBorderColor: Colors.transparent,
                      enableStepTapping: false,
                      stepRadius: 12,
                      borderThickness: 0,
                      internalPadding: 0,
                      finishedStepIconColor: MyConsts.bgColor,
                      activeStepBackgroundColor: MyConsts.bgColor,
                      showLoadingAnimation: false,
                      showStepBorder: false,
                      direction: Axis.vertical,
                      activeStep: activeIndex,
                      steps: [
                        for (var ch in challenges)
                          ch.isCompleted
                              ? const EasyStep(
                                  customStep: CircleAvatar(
                                    backgroundColor: MyConsts.primaryGreen,
                                    child: Icon(
                                      Icons.check,
                                      color: MyConsts.bgColor,
                                      size: 16,
                                    ),
                                  ),
                                )
                              : const EasyStep(
                                  activeIcon: Icon(
                                    Icons.circle,
                                    color: MyConsts.bgColor,
                                    size: 16,
                                  ),
                                  customStep: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: MyConsts.primaryColorFrom,
                                  ),
                                ),
                      ]),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
