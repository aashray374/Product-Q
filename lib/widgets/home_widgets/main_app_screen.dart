import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({super.key, required this.title, required this.body, this.footer});
  final String title;
  final Widget body;
  final List<Widget>? footer;


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
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              MyConsts.primaryColorFrom,
              MyConsts.primaryColorTo
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ),
        backgroundColor: MyConsts.bgColor,
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: footer,
        body: body);
  }
}
