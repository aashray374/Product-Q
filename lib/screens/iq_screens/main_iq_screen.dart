import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class MainIQScreen extends StatelessWidget {
  const MainIQScreen({super.key, required this.body, required this.appId});

  final Widget body;
  final int appId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: MyConsts.bgColor),
          centerTitle: true,
          title: Text(
            MyConsts.productNameMap[appId]!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  MyConsts.productColors[2][0],
                  MyConsts.productColors[2][1]
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ),
        backgroundColor: MyConsts.bgColor,
        body: body);
  }
}
