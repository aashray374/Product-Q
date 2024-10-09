import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/models/worktools_result.dart';
import 'package:product_iq/screens/worktools_screens/worktools_main_screen.dart';
import 'package:product_iq/widgets/common_widgets/my_elevated_button.dart';
import 'package:product_iq/widgets/worktools_widgets/response_box.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share_plus/share_plus.dart';

class SkillGapAnalysis extends StatelessWidget {
  const SkillGapAnalysis(
      {super.key, required this.title, required this.result});

  final String title;
  final WorktoolsResult result;

  @override
  Widget build(BuildContext context) {
    String formatText(PrdContent features) {
      List<FeaturesList> cardsText =[];
      if(result.prdContent.problemStatement.runtimeType == String){
        cardsText.add(FeaturesList(
            featureName: "Problem Statement",
            featureDetailPoints: [
              result.prdContent.problemStatement
            ]));
      }
      if(result.prdContent.objective.runtimeType == String){
        cardsText.add(FeaturesList(
            featureName: "Objective",
            featureDetailPoints: [
              result.prdContent.objective
            ]));
      }
      if(result.prdContent.persona.runtimeType == String){
        cardsText.add(FeaturesList(
            featureName: "Persona",
            featureDetailPoints: [
              result.prdContent.persona
            ]));
      }
      if(result.prdContent.highLevelSolution.runtimeType == String){
        cardsText.add(FeaturesList(
            featureName: "High Level Solution",
            featureDetailPoints: [
              result.prdContent.highLevelSolution
            ]));
      }
      cardsText.addAll(result.prdContent.featuresList);
      var features = cardsText;
      final points = [];
      for (var feature in features) {
        points.add(
            '*${feature.featureName}* - ${feature.featureDetailPoints[0]}');
      }
      StringBuffer formattedStrings = StringBuffer();
      for (var text in points) {
        formattedStrings.writeln("• $text");
      }
      return formattedStrings.toString();
    }

    return WorktoolsMainScreen(
        title: title,
        body: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(result.prdTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: MyConsts.primaryDark)),
                const SizedBox(
                  height: 24,
                ),
                if (result.prdContent.problemStatement.runtimeType == String)
                  ResponseBox(
                    responseText: FeaturesList(
                        featureName: "Problem Statement",
                        featureDetailPoints: [
                          result.prdContent.problemStatement
                        ]),
                  ),
                if (result.prdContent.objective.runtimeType == String)
                  ResponseBox(
                    responseText: FeaturesList(
                        featureName: "Objective",
                        featureDetailPoints: [
                          result.prdContent.objective
                        ]),
                  ),
                if (result.prdContent.persona.runtimeType == String)
                  ResponseBox(
                    responseText: FeaturesList(
                        featureName: "Persona",
                        featureDetailPoints: [
                          result.prdContent.persona
                        ]),
                  ),
                if (result.prdContent.highLevelSolution.runtimeType == String)
                  ResponseBox(
                    responseText: FeaturesList(
                        featureName: "High Level Solution",
                        featureDetailPoints: [
                          result.prdContent.highLevelSolution
                        ]),
                  ),
                for (var responseText in result.prdContent.featuresList)
                  ResponseBox(responseText: responseText),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        String fullText =
                            formatText(result.prdContent);
                        FlutterClipboard.copy(fullText).then(
                          (value) {
                            return ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Text Copied'),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Copy All",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: MyConsts.productColors[1][0],
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                MyElevatedButton(
                    width: double.infinity,
                    colorFrom: MyConsts.productColors[1][0],
                    colorTo: MyConsts.productColors[1][1],
                    child: Text(
                      "Share",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 14),
                    ),
                    onTap: () {
                      String formattedText =
                          formatText(result.prdContent);
                      Share.share(formattedText);
                    })
              ],
            ),
          ),
        ));
  }
}
