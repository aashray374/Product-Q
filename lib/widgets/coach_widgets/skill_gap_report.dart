import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/coach_widgets/report_content.dart';
import 'package:product_iq/models/area.dart';

class SkillGapReport extends StatelessWidget {
  const SkillGapReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Skill Gap Report",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: MyConsts.primaryDark),
            ),
            ReportContent(
              area: Area.weak,
              title: " Execution and Strategy",
              subtitle:
                  "Learning - Lorem Ipsum is simply dummy text of the printing and",
            ),
            const SizedBox(height: 8,),
            ReportContent(
              area: Area.average,
              title: " Execution and Strategy",
              subtitle:
              "Learning - Lorem Ipsum is simply dummy text of the printing and",
            ),
            const SizedBox(height: 8,),
            ReportContent(
              area: Area.strong,
              title: " Execution and Strategy",
              subtitle:
              "Learning - Lorem Ipsum is simply dummy text of the printing and",
            ),
          ],
        ),
      ),
    );
  }
}
