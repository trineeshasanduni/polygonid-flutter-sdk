import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claims.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/claim.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/bloc/register_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
import 'package:polygonid_flutter_sdk_example/utils/qr_code_parser_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

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
  }

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
                      top:50,
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
                      height: MediaQuery.of(context).size.height /1.5,
                      width: MediaQuery.of(context).size.width/1.5 ,
                      decoration: BoxDecoration(
                          color: const Color(0xFF2CFFAE).withOpacity(0.15),
                          shape: BoxShape.circle),
                    ),
                  ),
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
                             SizedBox(height: MediaQuery.of(context).size.height /8),
                            _buildTitle(),
                            const SizedBox(height: 4),
                            _buildTopic(),
                            const SizedBox(height: 50),
                            _buildForm(),
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
                        labelText: 'Paste your Polygon DID here',
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
                    MaterialPageRoute(
                      builder: (context) => const SetupPasswordScreen(),
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 6,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(6),
                      border: const GradientBoxBorder(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFa3d902),
                            Color(0xFF2CFFAE),
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
                        width: MediaQuery.of(context).size.width / 1.8,
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
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
}

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
    path.quadraticBezierTo(
        thirdFirstCurve.dx, thirdFirstCurve.dy, thirdLastCurve.dx, thirdLastCurve.dy);

    // Close the path and connect to the top
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

