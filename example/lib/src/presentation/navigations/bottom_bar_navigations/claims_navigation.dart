
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claims.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claimsPage/widgets/claims_page.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/credencials.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';

class ClaimsNav extends StatefulWidget {
  const ClaimsNav({super.key});

  @override
  State<ClaimsNav> createState() => _ClaimsNavState();
}

GlobalKey<NavigatorState> ClaimsNavKey = GlobalKey<NavigatorState>();

class _ClaimsNavState extends State<ClaimsNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ClaimsNavKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            
            return  Credencials();
          },
        );
      },
    );
  }
}
