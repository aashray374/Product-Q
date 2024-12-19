import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_iq/consts.dart';

class CrashErrorScreen extends StatefulWidget {
  final VoidCallback? retry;
  const CrashErrorScreen({super.key, this.retry});

  @override
  State<CrashErrorScreen> createState() => _CrashErrorScreenState();
}

class _CrashErrorScreenState extends State<CrashErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: MyConsts.bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/elements/reports.png'),
            const SizedBox(height: 10,),
            Text(
              "Server Issue,\n Try After Sometime",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ).paddingAll(15),
            GestureDetector(
              onTap: () async {
                if (widget.retry != null) {
                  widget.retry!();
                }
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MyConsts.primaryColorFrom),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "RETRY",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: MyConsts.primaryColorFrom,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset("assets/elements/ratebar.png", width: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
