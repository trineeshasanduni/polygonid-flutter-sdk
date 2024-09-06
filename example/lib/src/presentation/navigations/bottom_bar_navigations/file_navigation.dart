
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/widget/files.dart';

class FileNav extends StatefulWidget {
  final String? did;
  const FileNav({super.key, required this.did});

  @override
  State<FileNav> createState() => _FileNavState();
}

GlobalKey<NavigatorState> FileNavKey = GlobalKey<NavigatorState>();

class _FileNavState extends State<FileNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: FileNavKey,
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
            return  Files(did: widget.did,);
          },
        );
      },
    );
  }
}
