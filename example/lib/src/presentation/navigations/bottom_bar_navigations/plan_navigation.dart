import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/add_plans.dart';

class PlanNav extends StatefulWidget {
  const PlanNav({super.key});

  @override
  State<PlanNav> createState() => _PlanNavState();
}
GlobalKey<NavigatorState> PlanNavKey = GlobalKey<NavigatorState>();

class _PlanNavState extends State<PlanNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: PlanNavKey,
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
            return const AddPlans();
          },
        );
      },
    );
  }
}