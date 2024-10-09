import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class UnorderedList extends StatelessWidget {
  const UnorderedList(this.texts, {super.key});

  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];
    for (var text in texts) {
      // Add list item
      widgetList.add(UnorderedListItem(text));
      // Add space between items
      widgetList.add(const SizedBox(height: 4.0));
    }

    return Column(children: widgetList);
  }
}

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "• ",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: MyConsts.primaryDark.withOpacity(0.6)),
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: MyConsts.primaryDark.withOpacity(0.6)),
          ),
        ),
      ],
    );
  }
}
