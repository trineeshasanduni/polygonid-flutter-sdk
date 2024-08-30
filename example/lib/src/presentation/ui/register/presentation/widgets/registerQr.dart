// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/setupPassword.dart';
// import 'package:video_player/video_player.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:video_player/video_player.dart';
// // import 'package:web3modal_flutter/web3modal_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class Registerqr extends StatefulWidget {
//   final dynamic response;
//   const Registerqr({Key? key, required this.response}) : super(key: key);
//   @override
//   State<Registerqr> createState() => _RegisterqrState();
// }

// class _RegisterqrState extends State<Registerqr> {
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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       // appBar: AppBar(
//       //   iconTheme: const IconThemeData(color: Colors.white),
//       //   // title: const Text('Scan Qr Code'),
//       // ),
//       body: Stack(
//         children: [
//           //  const BackgroundVideoWidget(),
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
//               // decoration: BoxDecoration(
//               //   color: Colors.black,
//               // ),
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
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 20),
//                       Container(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               // margin: const EdgeInsets.all(20)  ,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: Theme.of(context).secondaryHeaderColor,
//                               ),
//                               padding: const EdgeInsets.all(20),
//                               child: SizedBox(
//                                 height: 330,
//                                 width: 200,
//                                 child: Center(
//                                   child: Column(
//                                     children: [
//                                       Text('BETHEL zkpSTORAGE',
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold)),
//                                       const SizedBox(height: 10),
//                                       _animation(),
//                                       const SizedBox(height: 10),
//                                       PrettyQrView.data(
//                                         data: widget.response.toString(),
//                                       ),
//                                       const SizedBox(height: 10),
//                                       Text(
//                                           'Scan this QR code from your Polygon ID Wallet App to prove access rights',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .secondary
//                                       .withOpacity(0.8),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                             ),

//                             GestureDetector(
//                               onTap: () {
//                                 // Navigator.of(context)
//                                 //     .pushNamed('/storageLogin');
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) =>
//                                         SetupPasswordScreen()));
//                               },
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width / 6,
//                                 // height: ,
//                                 alignment: Alignment.bottomCenter,
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 15),
//                                 // margin: const EdgeInsets.only(top: 150),
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).primaryColor,
//                                   borderRadius: BorderRadius.circular(6),
//                                   border: Border.all(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     width: 2,
//                                     style: BorderStyle.solid,
//                                   ),
//                                 ),
//                                 child: Icon(
//                                   CupertinoIcons.home,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             // ValueListenableBuilder<bool>(
//                             //   valueListenable: isButtonEnabled,
//                             //   builder: (context, value, child) {
//                             //     return GestureDetector(
//                             //       onTap: value ? _submit : null,
//                             //       child: Container(
//                             //         width:
//                             //             MediaQuery.of(context).size.width / 3,
//                             //         alignment: Alignment.bottomCenter,
//                             //         padding: const EdgeInsets.symmetric(
//                             //             vertical: 15),
//                             //         // margin: const EdgeInsets.only(top: 150),
//                             //         decoration: BoxDecoration(
//                             //           color: value
//                             //               ? Theme.of(context).primaryColor
//                             //               : Colors.grey,
//                             //           borderRadius: BorderRadius.circular(6),
//                             //           border: Border.all(
//                             //             color: value
//                             //                 ? Theme.of(context)
//                             //                     .colorScheme
//                             //                     .primary
//                             //                 : Colors.white,
//                             //             width: 2,
//                             //             style: BorderStyle.solid,
//                             //           ),
//                             //         ),
//                             //         child: Center(
//                             //           child: Text(
//                             //             'Submit',
//                             //             style: TextStyle(
//                             //                 color: Colors.white,
//                             //                 fontSize: 15,
//                             //                 fontWeight: FontWeight.bold,
//                             //                 fontFamily:
//                             //                     GoogleFonts.robotoMono()
//                             //                         .fontFamily),
//                             //           ),
//                             //         ),
//                             //       ),
//                             //     );
//                             //   },
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _animation() {
//     return SpinKitThreeInOut(
//       size: 20.0,
//       duration: const Duration(milliseconds: 1000),
//       itemBuilder: (BuildContext context, int index) {
//         return DecoratedBox(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: index.isEven ? Colors.black : Color(0xFFa3d902),
//           ),
//         );
//       },
//     );
//   }
// }
