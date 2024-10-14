import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/profile/widget/profile.dart';

class ProfileNav extends StatefulWidget {
    final String? did;

  const ProfileNav({super.key,required this.did});

  @override
  State<ProfileNav> createState() => _ProfileNavState();
}

GlobalKey<NavigatorState> ProfileNavKey = GlobalKey<NavigatorState>();

class _ProfileNavState extends State<ProfileNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ProfileNavKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if (settings.name == "/myFiles") {
              // return const MyFiles();
            }
            return  MyProfile(did:widget.did,);
          },
        );
      },
    );
  }
}
