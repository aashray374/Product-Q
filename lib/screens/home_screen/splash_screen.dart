import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:product_iq/services/app_service.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppService _appService;

  @override
  void initState() {
    _appService = Provider.of<AppService>(context, listen: false);
    onStartUp();
    super.initState();
  }

  void onStartUp() async {
    await _appService.onAppStart(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          MyConsts.appName,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: MyConsts.primaryColorTo),
        ),
      ),
    );
  }
}
