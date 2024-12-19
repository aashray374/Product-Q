import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({
    super.key,
    required this.width,
    required this.outlineColor,
    required this.child,
    required this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
  });

  final double width;
  final Color outlineColor;
  final Widget child;
  final void Function() onTap;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: width,
            margin: margin,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
                border: Border.all(color: outlineColor)),
            child: Center(child: child)));
  }
}
