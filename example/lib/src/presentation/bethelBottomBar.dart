
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/dashboard_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/plans_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/profile_navigation.dart';

class BethelBottomBar extends StatefulWidget {
  const BethelBottomBar( {super.key});

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
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          items: items,
          index: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          height: 60,
          backgroundColor: Colors.black,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),

          buttonBackgroundColor: Theme.of(context).colorScheme.secondary,

        ),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: currentIndex,
            children: const <Widget>[
              
              DashboardNav(),
              FileNav(),
              ProfileNav(),
              
            ],
          ),
        ),
      ),
    );
  }
}