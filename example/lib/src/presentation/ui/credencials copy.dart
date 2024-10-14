// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claims.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/claim.dart';
// import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
// import 'package:polygonid_flutter_sdk_example/utils/image_resource.dart';

// class Credencials extends StatefulWidget {
//   const Credencials({super.key});

//   @override
//   State<Credencials> createState() => _CredencialsState();
// }

// class _CredencialsState extends State<Credencials> {
//   final List<Map<String, dynamic>> categories = [
//     {
//       'name': 'User Authentication',
//       'icon': Icons.verified_user,
//       'onTap': ClaimsScreen()
//     },
//     {
//       'name': 'File Credentials',
//       'icon': Icons.file_present,
//       'onTap': ClaimsScreen()
//     },
//     {'name': 'File', 'icon': Icons.school, 'onTap': ClaimsScreen()},
//     {'name': 'File', 'icon': Icons.sports_soccer, 'onTap': ClaimsScreen()},
//     {'name': 'File', 'icon': Icons.movie, 'onTap': ClaimsScreen()},
//     {'name': 'File', 'icon': Icons.business, 'onTap': ClaimsScreen()},
//   ];

//   @override
// Widget build(BuildContext context) {
//   return SafeArea(
//     child: Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       // appBar: AppBar(
//       //   title: Text('Categories'),
//       // ),
//       body: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(8),
//               itemCount: categories.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2, // Number of columns
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 2 / 2, // Adjust the height and width ratio
//               ),
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => categories[index]['onTap'],
//                       ),
//                     );
//                   },
//                   child: Card(
//                     color: Theme.of(context).primaryColor,
//                     shadowColor: Theme.of(context).colorScheme.primary,
//                     elevation: 5,
//                     child: Stack(
//                       children: [
//                         _buildBackground(),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   categories[index]['icon'],
//                                   size: 40,
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   categories[index]['name'],
//                                   style:  TextStyle(fontSize: 14,fontFamily: GoogleFonts.robotoMono().fontFamily,),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget _buildHeader() {
//     return ListTile(
//       title: Row(
//         children: [
//           Image.asset('assets/images/launcher_icon.png', width: 30, height: 30),
//           RichText(
//             text: TextSpan(
//               text: 'zkp',
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.secondary,
//                 fontSize: 20,
//                 fontFamily: GoogleFonts.robotoMono().fontFamily,
//                 fontWeight: FontWeight.w300,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'STORAGE',
//                   style: TextStyle(
//                     color: Theme.of(context).secondaryHeaderColor,
//                     fontSize: 20,
//                     fontFamily: GoogleFonts.robotoMono().fontFamily,
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       trailing: Container(
//         width: 30,
//         height: 30,
//         decoration: BoxDecoration(
//           // color: Theme.of(context).colorScheme.primary,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               color: Theme.of(context).colorScheme.secondary, width: 1),
//         ),
//         child: GestureDetector(
//           onTap: () {
//             // _showWelcomeDialog();
//             // _refreshApp();
//           },
//           child: Icon(
//             Icons.wallet,
//             color: Theme.of(context).secondaryHeaderColor,
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }


//   Widget _buildBackground() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: CustomColors.claimCardBackground,
//         ),
//         width: double.infinity,
//         height: double.infinity,
//         child: SvgPicture.asset(
//           ImageResources.categoryBackground,
//           width: double.infinity,
//           fit: BoxFit.fill,
//         ),
//       ),
//     );
//   }
// }
