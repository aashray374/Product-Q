import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/challenge.dart';
import 'package:product_iq/models/coach_challenge.dart';
import 'package:product_iq/screens/coach_screens/coach_main_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:product_iq/widgets/coach_widgets/custom_stepper_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ModuleDetailsScreen extends StatefulWidget {

  const ModuleDetailsScreen(
      {super.key,
      required this.percent,
      required this.moduleTitle,
      required this.moduleId, required this.appId,required this.totalPercent,required this.completedPercent});

  final double percent;
  final String moduleTitle;
  final String moduleId;
  final int appId;
  final int completedPercent;
  final int totalPercent;

  @override
  State<ModuleDetailsScreen> createState() => _ModuleDetailsScreenState();
}

class _ModuleDetailsScreenState extends State<ModuleDetailsScreen> {
  final List<CoachChallenge> challenges = [];
  bool isFetching = true;

  @override
  void initState() {
    MyConsts.moduleName = widget.moduleTitle;
    MyConsts.moduleId = widget.moduleId;
    loadChallenges();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadChallenges() async {
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        MyConsts.token = preferences.getString("token")!;
      });
    }

    debugPrint(MyConsts.token);
    final appsUrl =
        Uri.parse('${MyConsts.baseUrl}/app/${widget.appId}/module/${widget.moduleId}');
    http.Response response =
        await http.get(appsUrl, headers: MyConsts.requestHeader);
    var res = jsonDecode(response.body);
    print(res[1]);
    // print(res['labels']);
    if(response.statusCode == 200) {
      res = jsonDecode(response.body);
        for (var challenge in res) {
          var coachChallenge = CoachChallenge.fromJson(challenge);
          challenges.add(coachChallenge);
          //sort labels by order
          coachChallenge.labels.sort((a, b) => a.order.compareTo(b.order));
        }

    } else {
      debugPrint(response.body);
    }
    setState(() {
      isFetching = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    // print("hemant-- ${challenges[1].labels[3].companyLogo!}");
    return CoachMainScreen(
      appBarTitle: MyConsts.productNameMap[widget.appId]!,
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color:MyConsts.productNameMap[widget.appId]=="Product Industry Trainer"? MyConsts.productColors[0][0]:MyConsts.productColors[3][0],

                    // color: MyConsts.productColors[3][0],
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        progressColor: Colors.green,
                        radius: 24,
                        percent: widget.percent,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          "${(100 * widget.percent).truncate()}%",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Text(
                        widget.moduleTitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              isFetching
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        for (var challenge in challenges)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CustomStepper2(
                              apptitle: MyConsts.productNameMap[widget.appId],
                              completedPercent: widget.completedPercent.toString(),
                              totalPercent: widget.totalPercent.toString(),
                              appId: widget.appId,
                              moduleId: widget.moduleId,
                              problemId: challenge.id.toString(),
                              question: challenge.description,
                              heading: challenge.challengeName,
                              challenges : [

                                for (var label in challenge.labels)
                                  Challenge(
                                    topicId: label.topicId!,
                                      id: label.id.toString(),
                                      title: label.levelName,
                                      subtitle : label.levelQuestion ?? '',
                                      isCompleted: label.completed ?? false,
                                      isLocked: label.isLocked,
                                    rating: label.rating,
                                    topics: label.topics!,
                                    companyLogo: label.companyLogo!,
                                    sampleAnswer: label.sampleAnswer! ,
                                    levelHint: label.levelHint!
                                  )
                              ],
                            ),
                          )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
