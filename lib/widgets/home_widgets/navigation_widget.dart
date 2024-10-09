import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_iq/consts.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int currentPageIndex = 1;

  Color isSelectedColor(int index) {
    if (currentPageIndex == index) {
      return MyConsts.bgColor;
    } else {
      return MyConsts.primaryDark;
    }
  }

  void _goToBranch(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConsts.bgColor,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          _goToBranch(currentPageIndex);
        },
        indicatorColor: MyConsts.primaryColorFrom,
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.home_outlined, color: isSelectedColor(0)),
              label: MyConsts.homeButton),
          NavigationDestination(
              icon: Icon(Icons.widgets_outlined, color: isSelectedColor(1)),
              label: MyConsts.appButton),
          NavigationDestination(
              icon: Icon(Icons.person_2_outlined, color: isSelectedColor(2)),
              label: MyConsts.profileButton),
        ],
      ),
      body: widget.navigationShell,
    );
  }
}
