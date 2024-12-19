import 'dart:math';

import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/answer.dart';
import 'package:product_iq/widgets/coach_widgets/custom_percent_indicator.dart';

class NewReviewBox extends StatelessWidget {
  const NewReviewBox({super.key, required this.answerRating, required this.isCurrent});

  final Answer answerRating;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
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
    debugPrint("${answerRating.evaluationResult} & ${answerRating.evalutionResult}");
    if(answerRating.evaluationResult != null){
      rating = double.parse(answerRating.evaluationResult!);
    }
    else{
      rating = double.parse(answerRating.evalutionResult!);
    }

    final List<int> paramRating = [5, 5, 5];
    final params = ["Concept", "Practical", "Clarity"];
    for (int i = 0; i < min(answerRating.result.scores.length,3); ++i) {
      paramRating[i] = int.parse(answerRating.result.scores[i]);
      params[i] = answerRating.result.names[i];
    }

    final buffer = StringBuffer();
    for(var suggestion in answerRating.result.suggestionsReport){
      buffer.write('• $suggestion.\n');
    }
    final String suggestionText = buffer.toString();
    return Container(
      decoration: BoxDecoration(
          color: MyConsts.bgColor, borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,),
        child: Column(
          children: [
            Text(
              "Assessment Report",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 20,
                  color: MyConsts.primaryDark,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 16,
            ),
            Chip(
                backgroundColor: MyConsts.bgColor,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                label: Text(
                  "$rating/10",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                      color: getColorByRating(rating / 10)),
                )),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; ++i)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomPercentIndicator(
                          percent: paramRating[i] / 10,
                          progressColor: getColorByRating(paramRating[i] / 10),
                          centerText: params[i]),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              suggestionText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 14, color: MyConsts.primaryDark),
            ),
          ],
        ),
      ),
    );
  }
}
