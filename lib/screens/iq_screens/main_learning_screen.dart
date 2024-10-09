import 'package:flutter/material.dart';
import 'package:product_iq/widgets/common_widgets/search_widget.dart';
import 'main_iq_screen.dart';
import 'package:product_iq/consts.dart';

class MainLearningScreen extends StatelessWidget {
  const MainLearningScreen({super.key, required this.title, required this.body, required this.appId});

  final String title;
  final List<Widget> body;
  final int appId;

  @override
  Widget build(BuildContext context) {
    return MainIQScreen(
        appId: appId,
        body: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchWidget(focus: false, hintText: "Search Product Lessons",
                    onSubmitted: (value) {

                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 20,
                        color: MyConsts.primaryDark,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                ...body
              ],
            ),
          ),
        ));
  }
}
