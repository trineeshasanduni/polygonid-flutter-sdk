
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/bethelBottomBar.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/register.dart';
// import 'package:video_player/video_player.dart';

// class SetupPasswordScreen extends StatefulWidget {
//   // final String? mnemonic;
//   const SetupPasswordScreen({super.key});

//   @override
//   State<SetupPasswordScreen> createState() => _SetupPasswordScreenState();
// }

// class _SetupPasswordScreenState extends State<SetupPasswordScreen> {
//   final formKey = GlobalKey<FormState>();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final storage = const FlutterSecureStorage();
//   VideoPlayerController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset('assets/images/green-bg.mp4')
//       ..initialize().then((_) {
//         debugPrint('video initialized: ${_controller!.value.isInitialized}');
//         _controller!.play();
//         _controller!.setLooping(true);
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               icon: Icon(Icons.close, color: Colors.white),
//               onPressed: () {
//                 Navigator.of(context).pushReplacementNamed(Routes.homePath);
//               }),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: Container(
//               child: _controller!.value.isInitialized
//                   ? Transform.scale(
//                       scale: 1.8,
//                       child: SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height / 3.5,
//                           child: VideoPlayer(_controller!)),
//                     )
//                   : const SizedBox(),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Bethel ',
//                         style: TextStyle(
//                             fontFamily: GoogleFonts.robotoMono().fontFamily,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).colorScheme.secondary),
//                       ),
//                       Text(
//                         'zkpStorage',
//                         style: TextStyle(
//                             fontFamily: GoogleFonts.robotoMono().fontFamily,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                       'Hack Proof Blockchain Based Secure Decentralised file storage with (ZKP) Zero-Knowledge Proof',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontFamily: GoogleFonts.robotoMono().fontFamily,
//                           fontSize: 10,
//                           color: Colors.white)),
//                   SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () async {
//                       // try {
//                       //   final loginValue =
//                       //       await WalletController.to.fetchLoginQr();
//                       //   Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //       builder: (context) => LoginQr(
//                       //         response: loginValue.loginDetails,
//                       //         header: loginValue.headers,
//                       //       ),
//                       //     ),
//                       //   );
//                       // } catch (e) {
//                       //   print('Error: $e');
//                       //   ScaffoldMessenger.of(context).showSnackBar(
//                       //     SnackBar(
//                       //         content: Text('Failed to fetch login details')),
//                       //   );
//                       // }
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 3,
//                       alignment: Alignment.bottomCenter,
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       // margin: const EdgeInsets.only(top: 150),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(6),
//                         border: const GradientBoxBorder(
//                           gradient: LinearGradient(
//                               colors: [Color(0xFFa3d902), Color(0xFF2CFFAE)]),
//                           width: 2,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Log in',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: GoogleFonts.robotoMono().fontFamily),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: () {
//                       // Navigator.pushNamed(context, '/register');
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => Signup(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 3,
//                       alignment: Alignment.bottomCenter,
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(6),
//                         border: const GradientBoxBorder(
//                           gradient: LinearGradient(
//                               colors: [Color(0xFFa3d902), Color(0xFF2CFFAE)]),
//                           width: 2,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Register',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: GoogleFonts.robotoMono().fontFamily),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // Navigator.pushNamed(context, '/dashboard');
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BethelBottomBar(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 3,
//                       alignment: Alignment.bottomCenter,
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(6),
//                         border: const GradientBoxBorder(
//                           gradient: LinearGradient(
//                               colors: [Color(0xFFa3d902), Color(0xFF2CFFAE)]),
//                           width: 2,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Dashboard',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: GoogleFonts.robotoMono().fontFamily),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // void _submit() async {
//   //   Navigator.push(
//   //       context, MaterialPageRoute(builder: (context) => const BottomBar()));
//   // }
// }
