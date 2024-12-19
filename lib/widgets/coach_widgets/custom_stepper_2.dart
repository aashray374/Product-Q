import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/challenge.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/coach_widgets/stepper_box.dart';

class CustomStepper2 extends StatelessWidget {
  const CustomStepper2(
      {super.key,
      required this.heading,
      this.apptitle,
      required this.challenges,
      required this.question,
      required this.totalPercent,
      required this.completedPercent,
      required this.problemId,
      this.moduleId = '1',
      required this.appId});

  final String heading;
  final String ? apptitle;
  final List<Challenge> challenges;
  final String question;
  final String problemId;
  final String moduleId;
  final String completedPercent;
  final String totalPercent;

  final int appId;

  @override
  Widget build(BuildContext context) {
    // print("hemant ${challenges.subtitle}");
    int activeIndex = -1;
    for (var i = challenges.length - 1; i >= 0; --i) {
      print("challenges1 ----- ${challenges[i].companyLogo}");

      if (challenges[i].isCompleted) {
        activeIndex = i;
        debugPrint('activeIndex: $activeIndex');
        break;
      }
    }
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: MyConsts.coachLight,
            borderRadius: BorderRadius.circular(6)),
        child: Padding(
            padding: const EdgeInsets.all(18.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              Stack(children: [
                Column(
                  children: [
                    const SizedBox(height: 6,),
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
                                  'completedPercent':completedPercent,
                                  'sampleAnswer':challenge.sampleAnswer,
                                  'levelHint':challenge.levelHint,
                                  'companyLogo' : challenge.companyLogo,
                                  'totalPercent':totalPercent,
                                  'question': question,
                                  'labelId': challenge.id,
                                  'level_question': challenge.subtitle,
                                  'topics': challenge.topics,
                                  'topic_id': challenge.topicId,
                                },
                                pathParameters: {

                                  'problemTitle': challenge.title,
                                  'problemId': challenge.id,
                                  'moduleId': moduleId,
                                  'appId': appId.toString()
                                });
                          },
                          child: StepperBox(
                            apptitle: apptitle,
                            isCompleted: challenge.isCompleted,
                            title: "",
                            subtitle: challenge.subtitle,
                            rating: double.parse("${challenge.rating ?? 0}") ,
                            isLocked: challenge.isLocked,
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 32),
                  child: IgnorePointer(
                    child: AnotherStepper(
                        stepperDirection: Axis.vertical,
                        verticalGap: 24,
                        activeIndex: activeIndex,
                        activeBarColor: MyConsts.primaryGreen,
                        stepperList: [
                      for (var challenge in challenges)
                        StepperData(
                          iconWidget: challenge.isCompleted
                              ? const CircleAvatar(
                                  backgroundColor: MyConsts.primaryGreen,
                                  child: Icon(
                                    Icons.check,
                                    color: MyConsts.bgColor,
                                    size: 16,
                                  ),
                                )
                              : const Icon(
                                  Icons.circle,
                                  color: MyConsts.bgColor,
                                  size: 16,
                                ),
                          title: StepperText(
                            challenge.title,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 14),
                          ),
                          /*subtitle: StepperText(
                            challenge.title,
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 12,color: Colors.grey.shade400),
                          )*/
                        )
                    ]),
                  ),
                )
              ])
            ])));
  }
}
