import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/widget/add_plans.dart';

class PlanNav extends StatefulWidget {
  final String? did;
  // final bool isBlureffect;
  const PlanNav({
    super.key,
    required this.did,
  });

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
            if (settings.name == "/addPlans") {
              return  AddPlans( did: widget.did);
            }
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
            return  AddPlans( did: widget.did);
          },
        );
      },
    );
  }
}
