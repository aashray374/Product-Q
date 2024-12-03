import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/answer.dart';
import 'package:product_iq/routes/app_route_consts.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../../services/sample_answer_unlock.dart';
import '../../services/save_draft_answer.dart';


class InputAnswerBox extends ConsumerStatefulWidget {
  const InputAnswerBox(
      {super.key,
      required this.labelId,
      required this.hint,
      required this.question,
      required this.conceptId,
      required this.sampleAnswer,
      required this.totalPercent,
      required this.completedPercent,
      required this.moduleId,
        required this.conceptList,
      required this.appId});

  final String labelId;
  final String hint;
  final String question;
  final String sampleAnswer;
  final String moduleId;
  final List<dynamic> conceptList;
  final List<dynamic> conceptId;
  final String completedPercent;
  final String totalPercent;
  final int appId;

  @override
  _InputAnswerBoxState createState() => _InputAnswerBoxState();
}

class _InputAnswerBoxState extends ConsumerState<InputAnswerBox> {
  late TextEditingController _answerController;
  late Answer enteredAnswer;
  Answer? previousAnswer;
  var isSubmitting = false;
  var isSave = false;
  var isUnlock = false;
  final _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  var isLoading = false;
  var answerId = 0;
  var isMic= false;

  @override
  void initState() {
    _answerController = TextEditingController();
    loadDraftAnswer();
    _initSpeech();
    super.initState();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(debugLogging: true);
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult, listenFor: const Duration(seconds: 30));
    Fluttertoast.showToast(
      msg: "Microphone is Turn on",
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:MyConsts.productColors[3][0],
      textColor:Colors.white,
      fontSize: 14.0,
    );
    isMic = true;

    setState(() {});
  }
  void _stopListening() async {
    await _speechToText.stop();
    Fluttertoast.showToast(
      msg: "Microphone is Turn off",
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:MyConsts.productColors[3][0],
      textColor:Colors.white,
      fontSize: 14.0,
    );
    isMic= false;
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _answerController.text = _lastWords;
    });
  }

  void _fetchPreviousAnswer() async {
    // fetch previous answer
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        MyConsts.token = preferences.getString("token")!;
      });
    }
    final previousAnswerUrl = Uri.parse(
        '${MyConsts.baseUrl}/app/${widget.appId}/response/lebel/${widget.labelId}/all');
    http.Response response =
        await http.get(previousAnswerUrl, headers: MyConsts.requestHeader);
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      debugPrint(res.toString());
      List<Answer> previousAnswers = [];
      for (var obj in res) {
        previousAnswers.add(Answer.fromJson(obj));
      }
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
              'completedPercent': widget.completedPercent,
              'totalPercent': widget.totalPercent,
              'isPrevious': 'true',
              'appId': widget.appId.toString()
            });
      }
    } else {
      debugPrint(response.body);
    }
  }

  Future<void> loadDraftAnswer() async {
    final labelId = int.parse(widget.labelId); // Replace with actual value
    final appId = widget.appId;   // Replace with actual value
    final draftAnswer = await ref.read(saveDraftAnswerProvider.notifier).getDraftAnswer(labelId, appId,55);
    if (draftAnswer != null) {
      print(draftAnswer.id);
      print(draftAnswer.draftAnswer);
      _answerController.text = draftAnswer.draftAnswer;
      answerId = draftAnswer.id;
    }
  }

  Future<void> saveDraftAnswer() async {
    final labelId = int.parse(widget.labelId); // Replace with actual value
    final appId = widget.appId;   // Replace with actual value
    final draftAnswer = _answerController.text;

    setState(() {
      isSave = true;
    });

    final result = await ref.read(saveDraftAnswerProvider.notifier).addSaveDraftAnswer(labelId, appId,55, draftAnswer);

    setState(() {
      isSave = false;
    });

    if (result == 'exists') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft with the same content already exists.')),
      );
    } else if (result == 'updated') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft updated successfully.')),
      );
    } else if (result == 'saved') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved successfully.')),
      );
    }
  }

  void _postAnswer(String? answer) async {
    if (answer == null || answer.length <= 1) {
      _showSnackBarMessage('Please answer the question');
      setState(() {
        isSubmitting = false;
      });
      return;
    }
    if (MyConsts.token == '') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        MyConsts.token = preferences.getString("token")!;
      });
    }
    final postAnswerUrl = Uri.parse(
        '${MyConsts.baseUrl}/app/${widget.appId}/response/lebel/${widget.labelId}');
    debugPrint(widget.labelId);
    print("$postAnswerUrl");

    http.Response response = await http.post(postAnswerUrl,
        headers: MyConsts.requestHeader, body: json.encode({'answer': answer}));
    print("response of prateek '${response.body}'");
    final res = jsonDecode(response.body);
    if (response.statusCode == 200) {
      debugPrint(res.toString());
      setState(() {
        enteredAnswer = Answer.fromJson(res['now']);

        if (res['previous'] != null) {
          previousAnswer = Answer.fromJson(res['previous']);
          // print("hemant is answer ${res['previous']}");
          // previousAnswer!.evalutionResult = null;
          // previousAnswer!.evaluationResult = res['previous']['evalution_result'].toString();
        }
        isSubmitting = false;
      });

      // showRatingDialog(context, 0.0);
      GoRouter.of(context).pushNamed(MyAppRouteConst.coachReviewRoute,
          extra: previousAnswer != null
              ? [enteredAnswer, previousAnswer!]
              : [enteredAnswer],
          pathParameters: {
            'isPrevious': 'false',
            'appId': widget.appId.toString(),
            'completedPercent': widget.completedPercent,
            'totalPercent': widget.totalPercent
          });
      if (answerId !=  0 ) {
        // Remove the draft answer using its id
        await ref.read(saveDraftAnswerProvider.notifier).removeSaveDraftAnswer(
            answerId);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Draft removed successfully.')),
        // );
      }
      // removeSaveDraftAnswer();
    } else if (response.statusCode == 400) {
      print("message -----${res['message']}");
      _showSnackBarMessage(res['message']);
      setState(() {
        isSubmitting = false;
      });
    } else if (response.statusCode == 403) {
      _showSnackBarMessage(res['error']);
      setState(() {
        isSubmitting = false;
      });
    } else {
      if (res['error'] != null){
        _showSnackBarMessage(res['error']);
      } else if (res['message'] != null) {
        _showSnackBarMessage(res['message']);
      } else {
        _showSnackBarMessage('Something went wrong');
      }
      debugPrint(response.body);
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Submit Answer",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 17,
                    color: MyConsts.primaryDark,
                    fontWeight: FontWeight.w700),
              ),
              Row(
                children: [

                  InkWell(
                    onTap: () {
                      showBottomSheet(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/elements/book.png",
                          width: 17,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Learn Concepts",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 12,
                                  color: MyConsts.productColors[3][0],
                                  fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showBottomSheet2(context);
                      // showMyDialog(context,widget.hint);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/elements/bulb2.png",
                          width: 17,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Hint",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                              fontSize: 12,
                              color: MyConsts.productColors[3][0],
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          TextField(
            controller: _answerController,
            maxLines: widget.question.length==1? 11:9,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: MyConsts.primaryDark),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: MyConsts.productColors[3][0].withOpacity(0.15),
              hintText: "Type your answer or tap the microphone to speak",
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: MyConsts.primaryDark),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async{

                  if(_answerController.text.isNotEmpty){
                  setState(() {
                    isSave = true;
                  });
                  // Replace with your save draft logic
                  await saveDraftAnswer();
                  setState(() {
                    isSave = false;
                  });
                  }else{
                    _showSnackBarMessage("Please enter your answer");
                  }
                },
                child: Container(
                    width: isMic? MediaQuery.of(context).size.width * 33 / 100:MediaQuery.of(context).size.width * 33 / 100,

                    // width: MediaQuery.of(context).size.width * 35 / 100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          const BoxShadow(
                              color: Color.fromRGBO(100, 100, 111, 0.2),
                              offset: Offset(0, 4),
                              blurRadius: 16)
                        ],
                        border: Border.all(color: MyConsts.productColors[3][0]),
                        gradient: const LinearGradient(
                            colors: [Colors.white, Colors.white],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Center(
                      child: isSave
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: MyConsts.bgColor,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "SAVE DRAFT",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: MyConsts.productColors[3][0]),
                            ),
                    )),
              ),

              InkWell(
                onTap: () {
                  if (_speechEnabled) {
                    _speechToText.isListening ? _stopListening() : _startListening();
                  }
                },
                child: Container(
                  width: 75, // Adjust the width as needed
                  height: 75, // Adjust the height as needed
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    shape: BoxShape.circle,
                    border: Border.all(color:isMic?Colors.green:Colors.transparent),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mic,
                    size: isMic?28:26, // Adjust the size of the icon
                    color: Colors.black,
                  ),
                ),
              ),
              MyElevatedButton(
                  shadow: MyConsts.shadow1,
                  width:MediaQuery.of(context).size.width * 32 / 100,
                  colorFrom: MyConsts.productColors[3][0],
                  colorTo: MyConsts.productColors[3][0],
                  child: isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: MyConsts.bgColor,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "SUBMIT",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: MyConsts.bgColor),
                        ),
                  onTap: () {
                    setState(() {
                      isSubmitting = true;
                    });

                    _postAnswer(_answerController.text);
                  }),
            ],
          ),

        ],
      ),
    );
  }

  Future<void> showMyDialog(BuildContext context,String hint) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss the dialog
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hint",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(hint,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14 ,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 13,
                                    color: MyConsts.productColors[3][0],
                                    fontWeight: FontWeight.w700))),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showRatingDialog(BuildContext context, double rating) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss the dialog
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ), // To customize the shape
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // To make the dialog height adjust according to its content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Answer Rating",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: MyConsts.productColors[3][0]),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MyConsts.productColors[3][0],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        Navigator.of(context).pop();
                        GoRouter.of(context).pushNamed(
                            MyAppRouteConst.coachReviewRoute,
                            extra: previousAnswer != null
                                ? [enteredAnswer, previousAnswer!]
                                : [enteredAnswer],
                            pathParameters: {
                              'isPrevious': 'false',
                              'appId': widget.appId.toString()
                            });
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: MyConsts.bgColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return BottomSheetLearnContent(conceptId: widget.conceptId,sampleAnswer: widget.sampleAnswer,appId: widget.appId,labelId: widget.labelId,conceptList: widget.conceptList,);
      },
    );
  }
  void showBottomSheet2(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return BottomSheetHintContent(messageText: widget.hint,conceptId: widget.conceptId,sampleAnswer: widget.sampleAnswer,appId: widget.appId,labelId: widget.labelId,conceptList: widget.conceptList,);
      },
    );
  }
}
class BottomSheetHintContent extends ConsumerStatefulWidget {
  final String sampleAnswer;
  final String messageText;
  final int appId;
  final String labelId;
  final List<dynamic> conceptList;
  final List<dynamic> conceptId;

  BottomSheetHintContent({
    required this.sampleAnswer,
    required this.labelId,
    required this.messageText,
    required this.appId,
    required this.conceptList,
    required this.conceptId,
  });

  @override
  _BottomSheetHintContentState createState() => _BottomSheetHintContentState();
}

class _BottomSheetHintContentState extends ConsumerState<BottomSheetHintContent> {
  bool isUnlock = false;
  bool isSave = false;
  int remainingUses = 2;

  @override
  void initState() {
    super.initState();
    _updateUsageCount();
  }

  Future<void> _updateUsageCount() async {
    final sampleAnswerUnlockNotifier = ref.read(sampleAnswerUnlockProvider.notifier);
    final usageCount = await sampleAnswerUnlockNotifier.getUsageCount(int.parse(widget.labelId), widget.appId);
    setState(() {
      remainingUses = 2 - (usageCount as int); // Ensure usageCount is treated as int
    });
  }

  @override
  Widget build(BuildContext context) {
    final sampleAnswerUnlockNotifier = ref.read(sampleAnswerUnlockProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
        color: Color(0xFFF3F2FC),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:  Radius.circular(20))

        ),
        height: MediaQuery.of(context).size.height / 2, // Set height to half of screen height
        child: Column(
          children: [
            // Header with close button
            const SizedBox(height: 10),
            // Tab bar
            TabBar(
              tabs: [
                Tab(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Text("Hint", textAlign: TextAlign.center),
                  ),
                ),
                Tab(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Text("Sample Answer", textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      Text(widget.messageText,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 14 ,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)),
                    ],
                  ).paddingOnly(top: 15,bottom: 10,left: 20,right: 20),
                  Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              widget.sampleAnswer,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontSize: 12,
                                color:  Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                              ),
                            ).paddingOnly(top: 5, bottom: 5, left: 15, right: 15),
                            const SizedBox(height: 20),
                            isUnlock
                                ? const SizedBox.shrink()
                                : BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust blur strength
                              child: Container(
                                color: Colors.black.withOpacity(0), // Transparent background
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Centered button
                      isUnlock
                          ? const SizedBox.shrink()
                          : Center(
                        child: ElevatedButton(

                          onPressed: remainingUses > 0
                              ? () async {
                            await sampleAnswerUnlockNotifier.addSampleAnswerUnlock(int.parse(widget.labelId), widget.appId);
                            setState(() {
                              isUnlock = true;
                            });
                            _updateUsageCount(); // Update the usage count after button press
                          }
                              : null,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset("assets/elements/lock.png", width: 18),
                                  const SizedBox(width: 5),
                                  Text(
                                    'UNLOCK ANSWER',
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontSize: 13,
                                      color: remainingUses > 0 ? MyConsts.productColors[3][0] : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$remainingUses Remaining',
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust button padding
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyElevatedButton(
                shadow: MyConsts.shadow1,
                width: double.infinity,
                colorFrom: MyConsts.productColors[3][0],
                colorTo: MyConsts.productColors[3][0],
                child: isSave
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: MyConsts.bgColor,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: MyConsts.bgColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // _postAnswer(_answerController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class BottomSheetLearnContent extends ConsumerStatefulWidget {
  final String sampleAnswer;
  final int appId;
  final String labelId;
  final List<dynamic> conceptList;
  final List<dynamic> conceptId;

  BottomSheetLearnContent({
    required this.sampleAnswer,
    required this.labelId,
    required this.appId,
    required this.conceptList,
    required this.conceptId,
  });

  @override
  _BottomSheetLearnContentState createState() => _BottomSheetLearnContentState();
}

class _BottomSheetLearnContentState extends ConsumerState<BottomSheetLearnContent> {
  bool isUnlock = false;
  bool isSave = false;
  int remainingUses = 2;

  @override
  void initState() {
    super.initState();
    _updateUsageCount();
  }

  Future<void> _updateUsageCount() async {
    final sampleAnswerUnlockNotifier = ref.read(sampleAnswerUnlockProvider.notifier);
    final usageCount = await sampleAnswerUnlockNotifier.getUsageCount(int.parse(widget.labelId), widget.appId);
    setState(() {
      remainingUses = 2 - (usageCount as int); // Ensure usageCount is treated as int
    });
  }

  @override
  Widget build(BuildContext context) {
    final sampleAnswerUnlockNotifier = ref.read(sampleAnswerUnlockProvider.notifier);

    return DefaultTabController(
      length: 1,
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFF3F2FC),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:  Radius.circular(20))

        ),
        height: MediaQuery.of(context).size.height / 2, // Set height to half of screen height
        child: Column(
          children: [
            // Header with close button
            const SizedBox(height: 10),
            // Tab bar
            TabBar(
              tabs: [
                Tab(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: const Text("Product Concepts To Apply", textAlign: TextAlign.center),
                  ),
                ),

              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                    itemCount: widget.conceptList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap:  () {
                            /* GoRouter.of(context)
                                .pushNamed(MyAppRouteConst.iqRoute,
                                pathParameters: {
                                  'appId': '3'
                                });*/
                            GoRouter.of(context).pushNamed(MyAppRouteConst.iqLearningsRoute,
                                pathParameters: {'title':widget.conceptList[index].toString() , 'index': widget.conceptId[index].toString(), 'appId': "3"});

                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 20,right: 5),
                            width: MediaQuery.of(context).size.width - 20,
                            height: 48,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.35),
                                      blurRadius: 4,
                                      offset: Offset(0,1)

                                  )
                                ],
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF3629B7).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    width:25,
                                    height:24,
                                    child: Image.asset('assets/elements/concept.png',)).paddingOnly(right: 20),

                                Text(
                                  "${widget.conceptList[index]}",
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              widget.sampleAnswer,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                fontSize: 12,
                                color:  Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                              ),
                            ).paddingOnly(top: 5, bottom: 5, left: 15, right: 15),
                            const SizedBox(height: 20),
                            isUnlock
                                ? const SizedBox.shrink()
                                : BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust blur strength
                              child: Container(
                                color: Colors.black.withOpacity(0), // Transparent background
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Centered button
                      isUnlock
                          ? const SizedBox.shrink()
                          : Center(
                        child: ElevatedButton(

                          onPressed: remainingUses > 0
                              ? () async {
                            await sampleAnswerUnlockNotifier.addSampleAnswerUnlock(int.parse(widget.labelId), widget.appId);
                            setState(() {
                              isUnlock = true;
                            });
                            _updateUsageCount(); // Update the usage count after button press
                          }
                              : null,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset("assets/elements/lock.png", width: 18),
                                  const SizedBox(width: 5),
                                  Text(
                                    'UNLOCK ANSWER',
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontSize: 13,
                                      color: remainingUses > 0 ? MyConsts.productColors[3][0] : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$remainingUses Remaining',
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust button padding
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyElevatedButton(
                shadow: MyConsts.shadow1,
                width: double.infinity,
                colorFrom: MyConsts.productColors[3][0],
                colorTo: MyConsts.productColors[3][0],
                child: isSave
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: MyConsts.bgColor,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: MyConsts.bgColor,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // _postAnswer(_answerController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}