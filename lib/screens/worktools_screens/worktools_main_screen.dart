import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class WorktoolsMainScreen extends StatelessWidget {
  const WorktoolsMainScreen(
      {super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: MyConsts.bgColor),
          centerTitle: true,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              MyConsts.productColors[1][0],
              MyConsts.productColors[1][1]
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ),
        backgroundColor: MyConsts.bgColor,
        body: body);
  }
}
