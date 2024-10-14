import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/registerQr_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claims.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/widget/glassEffect.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/claim.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/bloc/register_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_button_style.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:polygonid_flutter_sdk_example/utils/qr_code_parser_utils.dart';
// import 'package:rive/rive.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late final HomeBloc _bloc;
  late final RegisterBloc _registerBloc;
  String? _errorMessage;
  final formKey = GlobalKey<FormState>();
  var identity = TextEditingController();
  final storage = const FlutterSecureStorage();
  // VideoPlayerController? _controller;
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
  bool _isFetching = true; // Added flag to control fetching

  @override
  void initState() {
    super.initState();

    // Initialize the video player controller
    // _controller = VideoPlayerController.asset('assets/images/green-bg.mp4')
    //   ..initialize().then((_) {
    //     debugPrint('video initialized: ${_controller!.value.isInitialized}');
    //     _controller!.play();
    //     _controller!.setLooping(true);
    //     setState(() {});
    //   });

    _bloc = getIt<HomeBloc>();
    _registerBloc = getIt<RegisterBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGetIdentifier();
    });
  }

  void _initGetIdentifier() {
    _bloc.add(const GetIdentifierHomeEvent());
    // _getdid();
  }

  // void _getdid(){
  //    BlocBuilder<HomeBloc, HomeState>(
  //     bloc: _bloc,
  //     builder: (BuildContext context, HomeState state) {
  //      String did = state.identifier ?? '';

  //     },
  //     buildWhen: (_, currentState) =>
  //         currentState is LoadedIdentifierHomeState,
  //   );
  // }

  @override
  void dispose() {
    // _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _registerBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,

          // iconTheme: const IconThemeData(color: Colors.white),
          // foregroundColor: Colors.white,
          backgroundColor:
              Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 50,
              left: -50,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width / 2.4,
                decoration: BoxDecoration(
                    color: const Color(0xFFa3d902).withOpacity(0.3),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: 400,
              right: -60,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                    color: const Color(0xFF2CFFAE).withOpacity(0.15),
                    shape: BoxShape.circle),
              ),
            ),
            // RiveAnimation.asset(
            //   'assets/images/shape2.riv',
            //   fit: BoxFit.cover,
            //   alignment: Alignment.center,
            // ),
            BackdropFilter(
              filter: ImageFilter.blur(
                //sigmaX is the Horizontal blur
                sigmaX: 40.0,
                //sigmaY is the Vertical blur
                sigmaY: 50.0,
              ),
              child: Container(),
            ),
            Column(
              children: [
                _walletDetails(),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 8),
                            _buildTitle(),
                            const SizedBox(height: 4),
                            _buildTopic(),
                            const SizedBox(height: 50),
                            _buildForm(),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,  
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2.5,
                                  height: 1,
                                  color: Theme.of(context)
                                      .secondaryHeaderColor
                                      .withOpacity(0.5),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'or',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2.5,
                                  height: 1,
                                  color: Theme.of(context)
                                      .secondaryHeaderColor
                                      .withOpacity(0.5),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildQRButton(),
                            _buildBlocListener(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _walletDetails() {
    return ClipPath(
      clipper: TcustomCurve(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
        child: Center(
          child: Column(
            children: [
              Text('Sign Up',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontFamily: GoogleFonts.robotoMono().fontFamily,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              bloc: _bloc,
              builder: (BuildContext context, HomeState state) {
                identity = state.identifier != null
                    ? TextEditingController(text: state.identifier)
                    : TextEditingController();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: identity,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'This is Your DID',
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontFamily: GoogleFonts.robotoMono().fontFamily,
                          fontSize: 13,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                );
              },
              buildWhen: (_, currentState) =>
                  currentState is LoadedIdentifierHomeState,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder(
              pageBuilder: (context, animation, secondAnimation) =>
                  const SetupPasswordScreen(),
              transitionsBuilder: (context, animation, secondAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }),
                    // MaterialPageRoute(
                    //   builder: (context) => const SetupPasswordScreen(),
                    // ),
                  ),
                  child: Container(
                    // color: Theme.of(context).colorScheme.secondary.w,
                    width: MediaQuery.of(context).size.width / 8,
                    // height: 50,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                      // borderRadius: BorderRadius.circular(6),
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ],
                        ),
                        
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      CupertinoIcons.home,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                BlocBuilder<RegisterBloc, RegisterState>(
                  bloc: _registerBloc,
                  builder: (BuildContext context, RegisterState state) {
                    if (state is RegisterSuccess) {
                      final statusCode = state.response.statusCode;
                      final response = jsonEncode(state.response.toJson());

                      if (statusCode == 200 && _isFetching) {
                        _errorMessage =
                            'You are already registered Using this DID';

                        // Stop further fetching
                        _isFetching = false;

                        // Defer the state change until after the current frame
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(
                              () {}); // Update the UI to show the error message
                        });
                      } else if (statusCode == 201) {
                        _errorMessage = null;
                        // Handle other status codes or responses
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _registerBloc.add(onGetRegisterResponse(response));
                        });
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _errorMessage = 'Error in registration';
                        });
                      }
                    } else if (state is Registered) {
                      _errorMessage = null;

                      // Defer navigation until after the current frame
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _handleRegistered(state.iden3message);

                        // Navigate to the desired page (e.g., HomeScreen)
                      });
                    } else if (state is loadedClaims) {
                      _errorMessage = null;
                      // Defer navigation until after the current frame
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SetupPasswordScreen(),
                          ),
                        );
                      });
                    }

                    return GestureDetector(
                      onTap: () {
                        if (_isFetching) {
                          _registerBloc.add(
                            SubmitSignup(
                              did: identity.text,
                              first: "thathsarani",
                              last: "trineesha",
                              email: "trineesha@gmail.com",
                            ),
                          );
                        } else {
                          // Handle case when fetching is disabled
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        alignment: Alignment.bottomCenter,
                        // padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: state is RegisterLoading
                              ? Loading(
                                  Loadingcolor: Theme.of(context).primaryColor,
                                  color:
                                      Theme.of(context).colorScheme.secondary)
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        GoogleFonts.robotoMono().fontFamily,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///
  // Widget _buildButton(
  //     String text, dynamic colorScheme, dynamic border, dynamic textColor) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     alignment: Alignment.center,
  //     padding: const EdgeInsets.symmetric(vertical: 15),
  //     decoration: BoxDecoration(
  //       color: colorScheme,
  //       borderRadius: BorderRadius.circular(50),
  //       border: Border.all(
  //         color: border,
  //         width: 2,
  //       ),
  //     ),
  //     child: Text(
  //       text,
  //       style: GoogleFonts.robotoMono(
  //         color: textColor,
  //         fontSize: 12,
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildButton(BuildContext context, String text, dynamic colorScheme,
      dynamic colorScheme2, dynamic border, dynamic textColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme, colorScheme2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
            30.0), // Optional: Add some rounding to the button
      ),
      child: FrostedGlassBox(
        theWidth: MediaQuery.of(context).size.width,
        theHeight: 50.0,
        theX: 0.0,
        theY: 0.0,
        theColor: Colors.white
            .withOpacity(0.13), // This can remain for frosted glass effect
        theChild: Text(
          text,
          style: TextStyle(
            fontSize: 12.0,
            color:
                textColor, // Keep the text color simple since the gradient is on the button
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.robotoMono().fontFamily,
          ),
        ),
      ),
    );
  }

  ///

  // ///
  // Widget _buildCircularProgress() {
  //   return const SizedBox(
  //     height: 20,
  //     width: 20,
  //     child: CircularProgressIndicator(
  //       strokeWidth: 2,
  //       backgroundColor: Colors.white,
  //     ),
  //   );
  // }

  ///
  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bethel ',
          style: TextStyle(
            fontFamily: GoogleFonts.robotoMono().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Text(
          'zkpStorage',
          style: TextStyle(
            fontFamily: GoogleFonts.robotoMono().fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  ///
  Widget _buildTopic() {
    return Text(
      'Hack Proof Blockchain Based Secure Decentralised file storage with (ZKP) Zero-Knowledge Proof',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: GoogleFonts.robotoMono().fontFamily,
        fontSize: 10,
        color: Colors.white,
      ),
    );
  }

  Future<void> _handleRegistered(Iden3MessageEntity iden3message) async {
    debugPrint('User is registered');
    _registerBloc.add(fetchAndSaveClaims(iden3message: iden3message));
  }

  /////////////////////////Qr scanner for registration////////////////////////
  // Widget _buildQRButton() {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => const SetupPasswordScreen(),
  //         ),
  //       );
  //     },
  //     child: _buildButton('Register Using QR',
  //         Theme.of(context).colorScheme.secondary, Colors.black, Colors.black),
  //   );
  // }

  Widget _buildQRButton() {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder(
          bloc: _registerBloc,
          builder: (BuildContext context, RegisterState state) {
            bool loading = state is RegisterQrLoading;
            return GestureDetector(
              onTap: () {
                if (!loading) {
                  _registerBloc.add(clickScanQrCode());
                }
              },
              // style: CustomButtonStyle.primaryButtonStyle,
              child: loading
                  ? Loading(
                      Loadingcolor: Theme.of(context).primaryColor,
                      color: Theme.of(context).colorScheme.secondary)
                  : _buildButton(
                      context,
                      'Register Using Qr',
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Colors.black,
                      Theme.of(context).primaryColor),
            );
          }),
    );
  }

  // Widget _buildBlocListener() {
  //   return BlocListener<RegisterBloc, RegisterState>(
  //     bloc: _registerBloc,
  //     listener: (context, state)async {
  //       print('state1: $state');

  //       if (state is NavigateToQrCodeScanner) {
  //         print('navigate to qr code scanner : $state');
  //         _handleNavigateToQrCodeScanner();
  //       }
  //       if (state is QrCodeScanned) {
  //         print('qr code scanned : $state');
  //         final AddQr = state.registerQREntity.aDDQR;
  //         print('add qr code1: $AddQr');
  //         final storage = GetStorage();
  //         final addQr = storage.write('AddQr', AddQr);

  //         final AddQr1 = await storage.read('AddQr');
  //           print('qr code read1: $AddQr1');
  //         print('add qr code: $addQr.');

  //         _handleCallbackUrl(state.registerQREntity.qR);
  //       }
  //       if (state is CallbackLoaded) {
  //         final response = jsonEncode(state.callbackResponse.toJson());
  //         print('qr clback response: $response');
  //         _registerBloc.add(onGetQrResponse(response));
  //       }
  //       if (state is QrRegistered) {
  //         WidgetsBinding.instance.addPostFrameCallback((_) async{
  //           print('fetching qr registered');
  //          await _handleQrRegistered(state.iden3message);

  //           // Navigate to the desired page (e.g., HomeScreen)
  //         });
  //       }
  //       if (state is loadedQrClaims) {
  //         // WidgetsBinding.instance.addPostFrameCallback((_) async {
  //           print('qr code fetching');
  //           final storage = GetStorage();
  //           final AddQr =await storage.read('AddQr');
  //           print('qr code read: $AddQr');
  //           await _handleCallbackUrl(AddQr.toString());
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const SetupPasswordScreen(),
  //             ),
  //           );
  //         // });
  //       }
  //     },
  //     child: const SizedBox.shrink(),
  //   );

  Widget _buildBlocListener() {
    return BlocListener<RegisterBloc, RegisterState>(
      bloc: _registerBloc,
      listener: (context, state) async {
        print('state1: $state');

        if (state is NavigateToQrCodeScanner) {
          print('navigate to qr code scanner : $state');
          _handleNavigateToQrCodeScanner();
        }

        if (state is QrCodeScanned) {
          print('qr code scanned : $state');
          final AddQr = state.registerQREntity.aDDQR;
          print('add qr code1: $AddQr');

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('AddQr', AddQr!); // Write
          final String? storedQr = prefs.getString('AddQr'); // Read
          print('Shared Preferences stored qr: $storedQr');

          _handleCallbackUrl(state.registerQREntity.qR);
        }

        if (state is CallbackLoaded) {
          final response = jsonEncode(state.callbackResponse.toJson());
          print('qr callback response: $response');
          _registerBloc.add(onGetQrResponse(response));
        }

        if (state is QrRegistered) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            print('fetching qr registered');
            await _handleQrRegistered(state.iden3message);

            // Navigate to the desired page (e.g., HomeScreen)
          });
        }

        if (state is loadedQrClaims) {
          // Ensure async read and await before using the value
          print('qr code fetching');

          final storage = GetStorage();

          try {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            final String? storedQr = prefs.getString('AddQr');

            if (storedQr != null) {
              print('qr code read: $storedQr');
              await _handleCallbackUrl(storedQr.toString());

              // Navigate after handling callback URL
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetupPasswordScreen(),
                ),
              );
            } else {
              print('Error: AddQr is null, no QR code found in storage.');
            }
          } catch (e) {
            print('Error reading AddQr from storage: $e');
          }
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  Future<void> _handleQrRegistered(Iden3MessageEntity iden3message) async {
    debugPrint('User is registered');
    _registerBloc.add(fetchAndSaveQrClaims(iden3message: iden3message));
  }

  Future<void> _handleNavigateToQrCodeScanner() async {
    String? qrCodeScanningResult =
        await Navigator.pushNamed(context, Routes.qrCodeScannerPath) as String?;
    _registerBloc.add(OnScanQrCodeResponse(qrCodeScanningResult));
    print('qrCodeScanningResult: $qrCodeScanningResult');
  }

  Future<void> _handleCallbackUrl(String? callbackUrl) async {
    if (callbackUrl == null || callbackUrl.isEmpty) {
      _registerBloc
          .add(RegisterFailure("no callback url found") as RegisterEvent);
    } else {
      String did = identity.text;
      print('did qr code: $did');
      print('callbackUrl qr code: $callbackUrl');

      _registerBloc.add(getCallbackUrl(callbackUrl, did));
    }
  }
}

//////////////////////////////// curves for the signup page////////////////////////////////////
class TcustomCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 45);
    final lastCurve = Offset(80, size.height - 45);
    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    final secondFirstCurve = Offset(0, size.height - 45);
    final secondLastCurve = Offset(size.width - 80, size.height - 45);
    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy,
        secondLastCurve.dx, secondLastCurve.dy);

    final thirdFirstCurve = Offset(size.width, size.height - 45);
    final thirdLastCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy,
        thirdLastCurve.dx, thirdLastCurve.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class TcustomCurve1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);

    // First curve with increased control point offset
    final firstCurve = Offset(size.width * 0.2, size.height - 50);
    final lastCurve = Offset(size.width * 0.4, size.height - 30);
    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    // Second curve with larger control point offset for deeper curve
    final secondFirstCurve = Offset(size.width * 0.6, size.height);
    final secondLastCurve = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy,
        secondLastCurve.dx, secondLastCurve.dy);

    // Third curve to connect to the top-right corner
    final thirdFirstCurve = Offset(size.width, size.height - 50);
    final thirdLastCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy,
        thirdLastCurve.dx, thirdLastCurve.dy);

    // Close the path and connect to the top
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
