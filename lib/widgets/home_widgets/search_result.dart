import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_iq/consts.dart';

class SearchResults extends StatelessWidget {
  const SearchResults(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.onTap,
      required this.type,
      required this.filters, required this.isSearch})
      : super(key: key);

  final List<String> title;
  final List<String> subtitle;
  final List<Function> onTap;
  final List<String> type;
  final List<bool> filters;
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    final filteredTitle = [];
    final filteredSubtitle = [];
    final filteredOnTap = [];
    for (int i = 0; i < filters.length; i++) {
      if (filters[i]) {
        for (int j = 0; j < title.length; j++) {
          if (type[j] == MyConsts.chipsText[i]) {
            filteredTitle.add(title[j]);
            filteredSubtitle.add(subtitle[j]);
            filteredOnTap.add(onTap[j]);
          }
        }
      }
    }
    if(!isSearch){
      return const SizedBox(height: 0, width: 0);
    }
    if (filteredTitle.isEmpty) {
      return Opacity(
        opacity: 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: SvgPicture.asset(
              'assets/elements/no-results.svg',
              height: 240,
            )),
            const SizedBox(height: 12),
            Text(
              "No results found",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: MyConsts.primaryDark),
            )
          ],
        ),
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredTitle.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            tileColor: Colors.white,
            title: Text(
              filteredTitle[index],
              maxLines: 1,
            ),
            subtitle: Text(
              filteredSubtitle[index],
              maxLines: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () async {
              //await Future.delayed(const Duration(milliseconds: 1000));
              filteredOnTap[index]();
            },
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
