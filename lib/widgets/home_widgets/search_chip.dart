import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class SearchChip extends StatefulWidget {
  const SearchChip(
      {super.key, required this.isSelected, this.onTap, required this.text});

  final bool isSelected;
  final void Function()? onTap;
  final String text;

  @override
  State<SearchChip> createState() => _SearchChipState();
}

class _SearchChipState extends State<SearchChip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(240),
              color: widget.isSelected
                  ? MyConsts.productColors[3][0]
                  : Colors.white,
              border:
                  Border.all(width: 2, color: MyConsts.productColors[3][0])),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isSelected ? Icons.check : Icons.add,
                size: 20,
                color: !widget.isSelected
                    ? MyConsts.productColors[3][0]
                    : Colors.white,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(widget.text,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: widget.isSelected
                          ? Colors.white
                          : MyConsts.productColors[3][0])),
              const SizedBox(
                width: 2,
              ),
            ],
          )),
    );
  }
}
