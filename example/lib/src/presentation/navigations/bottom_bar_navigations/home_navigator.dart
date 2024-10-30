
// import 'package:flutter/material.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/widget/files.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/register.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';

// class HomeNav extends StatefulWidget {
//   const HomeNav({super.key});

//   @override
//   State<HomeNav> createState() => _HomeNavState();
// }

// GlobalKey<NavigatorState> HomeNavKey = GlobalKey<NavigatorState>();

// class _HomeNavState extends State<HomeNav> {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: HomeNavKey,
//       onGenerateRoute: (RouteSettings settings) {
//         return MaterialPageRoute(
//           settings: settings,
//           builder: (BuildContext context) {
//             if (settings.name == "/myFiles") {
//               return const Files();
//             }
//             if( settings.name == "/storageLogin"){
//               return const SetupPasswordScreen();
//             }
//             if( settings.name == "/register"){
//               return const Signup();
//             }
//               return const Dashboard();
          
//             // return const SetupPasswordScreen();
//           },
//         );
//       },
//     );
//   }
// }
