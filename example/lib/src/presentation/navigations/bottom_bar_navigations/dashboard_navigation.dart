
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';

class DashboardNav extends StatefulWidget {
  final String? did;
 final bool isBlureffect ;
  const DashboardNav({super.key, required this.did, required this.isBlureffect});

  @override
  State<DashboardNav> createState() => _DashboardNavState();
}

GlobalKey<NavigatorState> DashboardNavKey = GlobalKey<NavigatorState>();

class _DashboardNavState extends State<DashboardNav> {
  @override
  Widget build(BuildContext context) {
    print('isBlureffect: ${widget.isBlureffect}');
    return Navigator(
      key: DashboardNavKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
           
            return  Dashboard( did: widget.did,isBlureffect:widget.isBlureffect);
          },
        );
      },
    );
  }
}
