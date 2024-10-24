
import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/widget/files.dart';

class FileNav extends StatefulWidget {
  final String? did;
  final bool isBlureffect;
  const FileNav({super.key, required this.did, required this.isBlureffect});

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
           
            return  Files(did: widget.did,isBlureffect:widget.isBlureffect);
          },
        );
      },
    );
  }
}
