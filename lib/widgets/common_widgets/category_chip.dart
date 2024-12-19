import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:product_iq/consts.dart';

class CategoryChip extends StatefulWidget {
  const CategoryChip({
    super.key,
    required this.onTap,
    required this.text,
    required this.isSelected,
    this.colorFrom,
    this.colorTo,
  });

  final void Function()? onTap;
  final bool isSelected;
  final String text;
  final Color? colorFrom;
  final Color? colorTo;

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(240),
              gradient: widget.isSelected
                  ? LinearGradient(
                      colors: widget.colorFrom == null
                          ? [
                              MyConsts.productColors[3][0],
                              MyConsts.productColors[1][1]
                            ]
                          : [widget.colorFrom!, widget.colorTo!])
                  : null,
              color: Colors.white,
              border: GradientBoxBorder(
                  width: 2,
                  gradient: LinearGradient(
                      colors: widget.colorFrom == null
                          ? [
                              MyConsts.productColors[3][0],
                              MyConsts.productColors[1][1]
                            ]
                          : [widget.colorFrom!, widget.colorTo!]))),
          child: Text(widget.text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                  color: widget.isSelected
                      ? Colors.white
                      : widget.colorFrom ?? MyConsts.productColors[3][0]))),
    );
  }
}
