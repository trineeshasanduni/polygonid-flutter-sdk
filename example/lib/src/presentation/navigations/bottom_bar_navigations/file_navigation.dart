
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';

class PlansNav extends StatefulWidget {
  const PlansNav({super.key});

  @override
  State<PlansNav> createState() => _PlansNavState();
}

GlobalKey<NavigatorState> PlansNavKey = GlobalKey<NavigatorState>();

class _PlansNavState extends State<PlansNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: PlansNavKey,
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
