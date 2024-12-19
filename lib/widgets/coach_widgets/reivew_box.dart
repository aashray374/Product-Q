import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/answer.dart';

class ReviewBox extends StatelessWidget {
  ReviewBox(
      {super.key, required this.answerRating, required this.isCurrent});

  final Answer answerRating;
  final bool isCurrent;
var  isScore  = false.obs;
var  isReport  = false.obs;
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
    debugPrint(
        "${answerRating.evaluationResult} && ${answerRating.evalutionResult}");
    if (answerRating.evaluationResult != null) {
      print("rating result  ${answerRating.evaluationResult!}");

      rating = double.parse(answerRating.evaluationResult!);
    } else {
      rating =  double.parse(answerRating.evalutionResult!);
    }

    final List<int> paramRating = [5, 5, 5,5,5];
    final params = ["Concept", "Practical", "Clarity","Management","Product"];
    for (int i = 0; i < min(answerRating.result.scores.length, 5); ++i) {
      // print("rating adsfasfsf ${answerRating.result.scores[i]}");
      paramRating[i] =  answerRating.result.scores[i].isEmpty ?  0: int.parse(answerRating.result.scores[i]);
      params[i] = answerRating.result.names[i];
    }

    final buffer = StringBuffer();
    for (var suggestion in answerRating.result.suggestionsReport) {
      buffer.write('• $suggestion.\n');
    }
    final String suggestionText = buffer.toString();
    return Container(
      decoration: BoxDecoration(
          color: MyConsts.bgColor, borderRadius: BorderRadius.circular(8)),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
        ),
        child: Column(
          children: [
            Text(
              "Product Industry Trainer Report",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 20,
                  color: MyConsts.primaryDark,
                  fontWeight: FontWeight.w700),

            ),
            SizedBox(height: 16,),
            CircularPercentIndicator(
              radius: 50,
              animation: true,
              percent: rating / 10,
              lineWidth: 5,
              progressColor: getColorByRating(
                  rating/
                      10),
              backgroundWidth: 1,
              animateFromLastPercent: true,
              center: Container(
                width: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey,width: 0.2)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("TOTAL SCORE",style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 8,
                        color: MyConsts.primaryDark,
                        fontWeight: FontWeight.w500)),
                    Text(rating.toString(),style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 20,
                        color: MyConsts.primaryDark,
                        fontWeight: FontWeight.w700))
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),
            Obx(
               () {
                return InkWell(
                  onTap: () {
                    if(isScore.value){
                      isScore.value= false;
                      print(isScore);
                    }else{
                      isScore.value= true;
                      print(isScore);

                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: isScore.value? 320 : 45,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        if(isScore.value)
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height:320.0, // Adjust the height as needed
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              params[index],
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${paramRating[index]}/10',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 3),
                                        Container(
                                          width: double.infinity,
                                          height: 15,
                                          decoration: BoxDecoration(
                                              color: Colors
                                                  .grey[300], // Background color
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor:
                                                paramRating[index] / 10, // 90% width
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: getColorByRating(
                                                      paramRating[index] /
                                                          10), // Progress color
                                                  borderRadius:
                                                      BorderRadius.circular(20)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        // Add more titles and progress containers as needed
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ).paddingOnly(left: 20, top: 40, right: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/elements/reports.png",
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Product Concepts Score",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                )
                              ],
                            ),
                            Image.asset(
                              "assets/elements/arrows.png",
                              width: 22,
                            ),
                          ],
                        ).paddingOnly(left: 15, top: 10, right: 15),
                        if(isScore.value)
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 8,
                              height: 320,
                              decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
               () {
                return InkWell(
                   onTap: () {
                    if(isReport.value){
                      isReport.value= false;
                    print(isReport);
                    }else{
                      isReport.value= true;
                    print(isReport);
                    }
                    },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15, top: 10, right: 15,bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/elements/boxs.png", width: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    "Points To Consider",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                              Image.asset("assets/elements/arrows.png", width: 22),
                            ],
                          ),
                        ),
                        if(isReport.value)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 40, right: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap:
                                                true, // Makes the ListView adjust its height to fit its content
                                            physics:
                                                NeverScrollableScrollPhysics(), // Disables scrolling
                                            itemCount: answerRating.result
                                                .suggestionsReport.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.only(bottom: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("• "+
                                                      answerRating.result
                                                          .suggestionsReport[index],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                            fontSize: 15.5,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 10, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/elements/boxs.png",
                                            width: 20),
                                        SizedBox(width: 5),
                                        Text(
                                          "Points To Consider",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Image.asset("assets/elements/arrows.png",
                                        width: 22),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            ),

            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
