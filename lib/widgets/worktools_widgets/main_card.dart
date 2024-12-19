import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/widgets/worktools_widgets/worktools_tag.dart';

class MainWorktoolsCard extends StatelessWidget {
  const MainWorktoolsCard(
      {super.key,
      required this.heading,
      this.subheading,
      required this.tagText1,
      required this.tagText2, this.onTap});

  final String heading;
  final String? subheading;
  final String tagText1;
  final String tagText2;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              MyConsts.productColors[1][0],
              MyConsts.productColors[1][1]
            ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            if (subheading != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  subheading!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WorktoolsTag(text: tagText1),
                const SizedBox(
                  width: 8,
                ),
                WorktoolsTag(text: tagText2),
              ],
            )
          ],
        ),
      ),
    );
  }
}
