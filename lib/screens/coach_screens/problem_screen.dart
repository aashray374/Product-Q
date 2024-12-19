import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/coach_widgets/input_answer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/answer.dart';
import '../../routes/app_route_consts.dart';
class ProblemScreen extends StatefulWidget {
  ProblemScreen(
      {super.key,
        required this.problemTitle,
        required this.problem,
        required this.problemId,
        required this.moduleId,
        required this.appId});

  final String moduleId;
  final int appId;
  String problemTitle;
  Map<String, dynamic> problem;
  String problemId;
  @override
  _ProblemScreenState createState() => _ProblemScreenState();
}

// class ProblemScreen extends StatelessWidget {
class _ProblemScreenState extends State<ProblemScreen> {
  // const ProblemScreen({super.key, required this.problemTitle, required this.problem, required this.problemId, required this.moduleId, required this.appId});

  // late String problemTitle;
  // late Map<String,dynamic> problem;
  // late String problemId;
  // // final List<dynamic> topics;
  // late String moduleId;
  // late int appId;
  var isLoading = false;

  void _fetchPreviousAnswer() async {
    // fetch previous answer
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        MyConsts.token = preferences.getString("token")!;
      });
    }
    final previousAnswerUrl = Uri.parse(
        '${MyConsts.baseUrl}/app/${widget.appId}/response/lebel/${widget.problem['labelId']}/all');
    http.Response response =
    await http.get(previousAnswerUrl, headers: MyConsts.requestHeader);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      List<Answer> previousAnswers = [];
      for (var obj in res) {
        previousAnswers.add(Answer.fromJson(obj));
      }

      previousAnswers = previousAnswers.reversed.toList();
      if (previousAnswers.isEmpty) {
        setState(() {
          isLoading = false;
        });

        _showSnackBarMessage('No previous answer found');
      } else {
        setState(() {
          isLoading = false;
        });
        GoRouter.of(context).pushNamed(MyAppRouteConst.coachReviewRoute,
            extra: previousAnswers,
            pathParameters: {
              'completedPercent': widget.problem['completedPercent']!,
              'totalPercent': widget.problem['totalPercent'],
              'isPrevious': 'true',
              'appId': widget.appId.toString()
            });
      }
    } else {
      debugPrint(response.body);
    }
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    print("problem is ${widget.problem}");
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyConsts.productColors[3][0],
        //appBar: AppBar(backgroundColor: Colors.transparent,),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: deviceHeight*0.2,
                        maxHeight: widget.problem['level_question'].toString().length==1 ?deviceHeight * 0.3 :deviceHeight * 0.4,
                      ),
                      width: double.infinity,

                      height: widget.problem['level_question'].toString().length==1 ?deviceHeight * 0.3 :deviceHeight * 0.4,
                        child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image.asset(
                            "assets/elements/question-bg.png",
                            color: MyConsts.productColors[3][0],
                            colorBlendMode: BlendMode.multiply,
                            width: double.infinity,
                            height: deviceHeight * 0.4,
                            fit: BoxFit.fill,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center ,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget.problem['companyLogo'] == '1' ||
                                      widget.problem['companyLogo'] == null
                                      ? const SizedBox.shrink()
                                      : Image.network(
                                    "${MyConsts.imageUrl}${widget.problem['companyLogo']}",
                                    height: 35,
                                    width: 35,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.problemTitle,
                                    style:
                                    Theme.of(context).textTheme.titleLarge,

                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(40, 20, 40, 0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.problem['question']!,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                            fontSize: 16, height: 1.2),
                                      ),
                                      Divider(
                                        color:
                                        MyConsts.bgColor.withOpacity(0.5),
                                        thickness: 2,
                                      ).paddingOnly(top:10, bottom: 10),
                                      widget.problem['level_question'].toString().length != 1
                                          ? Text(
                                        widget.problem['level_question']!,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                            fontSize: 16, height: 1.2),
                                      ):

                                            const SizedBox.shrink() ,
                                            SizedBox.shrink() ,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    //const Spacer(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height:  widget.problem['level_question'].toString().length==1 ? deviceHeight * 0.6: deviceHeight * 0.5,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: MyConsts.bgColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: InputAnswerBox(
                            question: widget.problem['level_question'],
                            conceptId: widget.problem['topic_id'],
                            conceptList: widget.problem['topics'],
                            completedPercent:
                            widget.problem['completedPercent']!,
                            hint: widget.problem['levelHint']!,
                            sampleAnswer: widget.problem['sampleAnswer']!,
                            totalPercent: widget.problem['totalPercent']!,
                            labelId: widget.problemId,
                            moduleId: widget.moduleId,
                            appId: widget.appId,
                          )),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 40,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              Positioned(
                  top: 40,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.access_time_sharp,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      _fetchPreviousAnswer();
                    },
                  )),

            ],
          ),
        ));
  }
}