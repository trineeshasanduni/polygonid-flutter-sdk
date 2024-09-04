
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';

class ActivitiesNav extends StatefulWidget {
  const ActivitiesNav({super.key});

  @override
  State<ActivitiesNav> createState() => _ActivitiesNavState();
}

GlobalKey<NavigatorState> ActivitiesNavKey = GlobalKey<NavigatorState>();

class _ActivitiesNavState extends State<ActivitiesNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ActivitiesNavKey,
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
