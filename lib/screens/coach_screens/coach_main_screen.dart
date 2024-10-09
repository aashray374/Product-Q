import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class CoachMainScreen extends StatelessWidget {
  const CoachMainScreen(
      {super.key, required this.appBarTitle, required this.body, this.bgColor=MyConsts.bgColor});

  final Widget body;
  final String appBarTitle;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            appBarTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: appBarTitle=="Product Industry Trainer"? MyConsts.productColors[0][0]:MyConsts.productColors[3][0],
        ),
        backgroundColor: bgColor,
        body: body);
  }
}
