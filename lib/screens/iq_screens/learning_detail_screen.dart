import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/learning.dart';
import 'package:product_iq/screens/iq_screens/main_learning_screen.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:product_iq/widgets/iq_widgets/learnings_card.dart';

class LearningDetailScreen extends StatefulWidget {
  LearningDetailScreen({
    super.key,
    required this.learnings,
    required this.index,
    required this.appId,
  });

  final List<Learning> learnings;
  final int index;
  final int appId;

  @override
  State<LearningDetailScreen> createState() => _LearningDetailScreenState();
}

class _LearningDetailScreenState extends State<LearningDetailScreen> {
  var buttonText = "Next";
  var currentIndex = 0;

  @override
  void initState() {
    currentIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainLearningScreen(
        appId: widget.appId,
        title: widget.learnings[currentIndex].name,
        body: [
          LearningsCard(
            appId: widget.appId,
            learnings: widget.learnings,
            index: currentIndex,
            showFullText: true,
          ),
          MyElevatedButton(
              width: double.infinity,
              colorFrom: MyConsts.productColors[2][0],
              colorTo: MyConsts.productColors[2][1],
              child: Text(
                buttonText,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 14, color: MyConsts.bgColor),
              ),
              onTap: () {
                setState(() {
                  debugPrint("currentIndex: $currentIndex");
                  if (currentIndex == widget.learnings.length - 1) {
                    Navigator.of(context).pop();
                  } else {
                    currentIndex++;
                    if (currentIndex == widget.learnings.length - 1) {
                      buttonText = "Done";
                    }
                  }
                });
              })
        ]);
  }
}
