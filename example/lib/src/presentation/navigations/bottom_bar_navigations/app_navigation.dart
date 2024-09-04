// import 'package:bethel_mobile/views/home/files.dart';
// import 'package:bethel_mobile/views/home/home_page.dart';
// import 'package:flutter/material.dart';

// class LoginNav extends StatefulWidget {
//   const LoginNav({super.key});

//   @override
//   State<LoginNav> createState() => _LoginNavState();
// }

// GlobalKey<NavigatorState> LoginNavKey = GlobalKey<NavigatorState>();

// class _LoginNavState extends State<LoginNav> {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: LoginNavKey,
//       onGenerateRoute: (RouteSettings settings) {
//         return MaterialPageRoute(
//           settings: settings,
//           builder: (BuildContext context) {
//             if (settings.name == "/myFiles") {
//               return const MyFiles();
//             }
//             return const HomePage();
//           },
//         );
//       },
//     );
//   }
// }
