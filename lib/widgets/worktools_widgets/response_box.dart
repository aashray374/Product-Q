import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:clipboard/clipboard.dart';
import 'package:product_iq/models/worktools_result.dart';
import 'package:product_iq/widgets/worktools_widgets/skill_gap_text.dart';

class ResponseBox extends StatelessWidget {
  const ResponseBox({super.key, required this.responseText});

  final FeaturesList responseText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 40, 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyConsts.productColors[3][0].withOpacity(0.3)),
            child: SkillGapText(
              heading: responseText.featureName,
              body: responseText.featureDetailPoints[0],
            )),
        Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () async {
                FlutterClipboard.copy(
                        '*${responseText.featureName}* - ${responseText.featureDetailPoints[0]}')
                    .then(
                  (value) {
                    return ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Text Copied'),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.copy,
                size: 20,
              ),
            ))
      ]),
    );
  }
}
