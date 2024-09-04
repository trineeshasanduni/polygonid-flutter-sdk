
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';

class DashboardNav extends StatefulWidget {
  const DashboardNav({super.key});

  @override
  State<DashboardNav> createState() => _DashboardNavState();
}

GlobalKey<NavigatorState> DashboardNavKey = GlobalKey<NavigatorState>();

class _DashboardNavState extends State<DashboardNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: DashboardNavKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            // if (settings.name == "/myFiles") {
            //   return const MyFiles();
            // }
            // if( settings.name == "/storageLogin"){
            //   return const SetupPasswordScreen();
            // }
            // if( settings.name == "/register"){
            //   return const Signup();
            // }
            // if( settings.name == "/dashboard"){
            //   return const Dashboard();
            // }
            // return const HomePage();
            return const Dashboard();
          },
        );
      },
    );
  }
}
