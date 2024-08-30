
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BethelBottomBar extends StatefulWidget {
  const BethelBottomBar({super.key});

  @override
  BethelBottomBarState createState() => BethelBottomBarState();
}

class BethelBottomBarState extends State<BethelBottomBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.dashboard,
        size: 30,
        color: Theme.of(context).secondaryHeaderColor,
// replace with your desired color
      ),
      Icon(
        Icons.document_scanner,
        size: 30,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      Icon(
        Icons.account_circle,
        size: 30,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      Icon(
        Icons.account_circle,
        size: 30,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      Icon(
        Icons.account_circle,
        size: 30,
        color: Theme.of(context).secondaryHeaderColor,
      ),
    ];
    return PopScope(
      // onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          items: items,
          index: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            //  _goBranch(currentIndex);
          },

          height: 60,
          backgroundColor: Colors.black,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          // color: Colors.black,

          buttonBackgroundColor: Theme.of(context).colorScheme.secondary,

          // animationDuration: const Duration(milliseconds: 200),
        ),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: currentIndex,
            children: const <Widget>[
              /// First Route
              // HomeNav(),
              // TransferNav(),
              // ProfileNav(),
              // DashboardNav(),
              // FileNav(),
              // ProfileNav(),
              // PlansNav(),
              // ActivitiesNav(),

              /// Second Route
              // UpdatesNavigator(),
            ],
          ),
        ),
      ),
    );
  }
}
