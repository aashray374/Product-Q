import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:shimmer/shimmer.dart';

class StoryShimmer extends StatelessWidget {
  const StoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MyConsts.primaryGrey.withOpacity(0.5),
      highlightColor: MyConsts.primaryColorFrom.withOpacity(0.5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < 7; ++i)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 12),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: MyConsts.primaryGrey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
