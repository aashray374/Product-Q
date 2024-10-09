import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ToggleChip extends StatelessWidget {
  const ToggleChip({Key? key, required this.onToggle, required this.selectedIndex}) : super(key: key);

  final void Function(int?) onToggle;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
        minWidth: 100.0,
        cornerRadius: 20.0,
        activeBgColors: const [
          [MyConsts.primaryColorFrom, MyConsts.primaryColorTo],
          [MyConsts.primaryColorFrom, MyConsts.primaryColorTo]
        ],
        activeFgColor: MyConsts.bgColor,
        inactiveBgColor: MyConsts.primaryColorFrom.withOpacity(0.5),
        inactiveFgColor: MyConsts.primaryDark.withOpacity(0.5),
        initialLabelIndex: selectedIndex,
        totalSwitches: 2,
        labels: const [ 'Quaterly','Yearly'],
        customTextStyles: const [
          TextStyle(fontWeight: FontWeight.w700),
          TextStyle(fontWeight: FontWeight.w700),],
        radiusStyle: true,
        animate: true,
        animationDuration: 100,
        onToggle: onToggle);
  }
}
