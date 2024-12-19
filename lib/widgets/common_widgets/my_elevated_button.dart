import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class MyElevatedButton extends StatelessWidget {
  const MyElevatedButton(
      {super.key,
      required this.width,
      required this.colorFrom,
      required this.colorTo,
      this.shadow = MyConsts.shadow1,
      required this.child,
      required this.onTap, this.margin});

  final double width;
  final BoxShadow shadow;
  final EdgeInsetsGeometry? margin;
  final Color colorFrom;
  final Color colorTo;
  final Widget child;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          margin: margin,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [shadow],
              gradient: LinearGradient(
                  colors: [colorFrom, colorTo],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Center(child: child)),
    );
  }
}
