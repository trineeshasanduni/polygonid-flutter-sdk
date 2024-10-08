import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/claims_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/file_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/dashBoard_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/plan_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/bottom_bar_navigations/profile_navigation.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/widget/add_plans.dart';

class BethelBottomBar extends StatefulWidget {
  final String? did;
  const BethelBottomBar({
    super.key,
    required this.did,
  });

  

  @override
  BethelBottomBarState createState() => BethelBottomBarState();
}

class BethelBottomBarState extends State<BethelBottomBar> {
  int currentIndex = 0;

  void navigateToPlans() {
    setState(() {
      currentIndex = 2; // Assuming PlanNav is at index 2
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the frame has updated before pushing a new route
      PlanNavKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => AddPlans(did: widget.did),
        ),
      );
    });
  }

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
        Icons.map,
        size: 30,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      Icon(
        Icons.security,
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
            children: <Widget>[
              DashboardNav(
                did: widget.did,
              ),
              FileNav(
                did: widget.did,
              ),
              PlanNav(did: widget.did),
              ClaimsNav(),
              ProfileNav(),
              
            ],
          ),
        ),
      ),
    );
  }
}
