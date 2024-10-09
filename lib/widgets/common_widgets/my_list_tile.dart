import 'package:flutter/material.dart';
import 'package:product_iq/consts.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({super.key, required this.title, required this.subtitle, required this.iconColor});

  final String title;
  final String subtitle;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        child: Icon(Icons.bookmarks, color: iconColor, size: 20,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: iconColor.withOpacity(0.1),
        )
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: MyConsts.primaryDark, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 14, color: MyConsts.primaryDark.withOpacity(0.7)),
      ),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
