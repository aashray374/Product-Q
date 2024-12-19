import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget(
      {super.key, required this.color, required this.text, this.shadow});

  final Color color;
  final String text;
  final BoxShadow? shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: shadow == null ? null : [shadow!]),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: MyConsts.primaryGrey,
            ),
            const SizedBox(
              width: 8,
            ),
            Opacity(
              opacity: 0.4,
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: MyConsts.primaryGrey),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.mic,
              color: MyConsts.primaryGrey,
            ),
          ],
        ),
      ),
    );
  }
}
