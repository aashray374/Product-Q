import 'dart:math';

import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

import '../../models/answer.dart';

class YourAnswerBox extends StatefulWidget {
  const YourAnswerBox(
      {super.key,
      this.userAnswer = MyConsts.dummyText,
      required this.isPrevious,
      required this.answerRating});

  final String userAnswer;
  final bool isPrevious;
  final Answer answerRating;

  @override
  State<YourAnswerBox> createState() => _YourAnswerBoxState();
}

class _YourAnswerBoxState extends State<YourAnswerBox> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isPrevious) {
      print("previours answer -----${widget.answerRating.toJson()}");
      print("rating -----${widget.answerRating.evaluationResult}");
    } else {
      print("real answer -----${widget.answerRating.toJson()}");
    }
    Color getColorByRating(double rating) {
      if (rating <= 0.5) {
        return MyConsts.primaryRed;
      }
      if (rating <= 0.75) {
        return MyConsts.primaryOrange;
      }
      return MyConsts.primaryGreen;
    }

    //random nom in 1 to 5
    double rating = Random().nextInt(5) + 1;
    debugPrint(
        "${widget.answerRating.evaluationResult} & ${widget.answerRating.evalutionResult}");
    if (widget.answerRating.evaluationResult!.isNotEmpty) {
      // print("rating sdfasf--${widget.answerRating.evalutionResult! }");
      rating = /*4.0*/ double.parse(widget.answerRating.evaluationResult!);
    } else {
      rating = double.parse(widget.answerRating.evalutionResult!);
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      decoration: BoxDecoration(
          color: MyConsts.productColors[3][0].withOpacity(0.15),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.isPrevious
                    ? Container(
                  padding: EdgeInsets.only(top: 3,bottom: 3,right: 8,left: 8),
                  decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$rating/10",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 13,
                                  color: getColorByRating(rating / 10),
                                  fontWeight: FontWeight.w700),
                        ),
                      )
                    : Text(
                        " Your Answer",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 15,
                                color: MyConsts.primaryDark,
                                fontWeight: FontWeight.w700),
                      ),
                Text(
                  "",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 12,
                      color: MyConsts.primaryDark,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.userAnswer,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 14, color: MyConsts.primaryDark),
              maxLines: isExpanded ? 100 : 2,
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: isExpanded
                    ? const Icon(
                        Icons.arrow_circle_up_rounded,
                        color: MyConsts.primaryDark,
                      )
                    : const Icon(
                        Icons.arrow_circle_down_rounded,
                        color: MyConsts.primaryDark,
                      ))
          ],
        ),
      ),
    );
  }
}
