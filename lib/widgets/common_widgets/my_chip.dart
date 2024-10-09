import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class MyChip extends StatefulWidget {
  const MyChip(
      {super.key,
      required this.text,
      required this.colorFrom,
      required this.colorTo,
      this.filled = false});

  final String text;
  final Color colorFrom;
  final Color colorTo;
  final bool filled;

  @override
  State<MyChip> createState() => _MyChipState();
}

class _MyChipState extends State<MyChip> {
  var isSelected = false;

  void initBool() {
    isSelected = widget.filled;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.filled) {
          return;
        }
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(240),
              gradient: isSelected
                  ? LinearGradient(colors: [widget.colorFrom, widget.colorTo])
                  : null,
              color: Colors.white,
              border: GradientBoxBorder(
                  width: 2,
                  gradient: LinearGradient(
                      colors: [widget.colorFrom, widget.colorTo]))),
          child: Text(widget.text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : widget.colorFrom))),
    );
  }
}
