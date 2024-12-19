import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class ProfileOptions extends StatelessWidget {
  const ProfileOptions(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.text,
      this.textColor = MyConsts.primaryDark,
      this.showArrow = true});

  final void Function() onTap;
  final IconData icon;
  final String text;
  final Color textColor;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [MyConsts.shadow2],
                color: Colors.white),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: MyConsts.primaryColorTo,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 14, color: textColor),
                ),
                const Spacer(),
                Icon(
                  Icons.navigate_next,
                  color:
                      showArrow ? MyConsts.primaryColorTo : Colors.transparent,
                )
              ],
            )));
  }
}
