import 'dart:convert';
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
// import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/setupPassword.dart';
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

  final formKey = GlobalKey<FormState>();
  var identity = TextEditingController();
  final storage = const FlutterSecureStorage();
  VideoPlayerController? _controller;
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    // Initialize the video player controller
    _controller = VideoPlayerController.asset('assets/images/green-bg.mp4')
      ..initialize().then((_) {
        debugPrint('video initialized: ${_controller!.value.isInitialized}');
        _controller!.play();
        _controller!.setLooping(true);
        setState(() {});
      });

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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _registerBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            Center(
              child: _controller != null && _controller!.value.isInitialized
                  ? Transform.scale(
                      scale: 1.8,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: VideoPlayer(_controller!),
                      ),
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
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
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hack Proof Blockchain Based Secure Decentralised file storage with (ZKP) Zero-Knowledge Proof',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: GoogleFonts.robotoMono().fontFamily,
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
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
                                    ? TextEditingController(
                                        text: state.identifier)
                                    : TextEditingController();
                                return TextFormField(
                                  controller: identity,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    labelText: 'Paste your Polygon DID here',
                                    labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontFamily:
                                          GoogleFonts.robotoMono().fontFamily,
                                      fontSize: 13,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red.withOpacity(0.4),
                                      ),
                                    ),
                                  ),
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
                                      builder: (context) =>
                                          const SetupPasswordScreen(),
                                    ),
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    alignment: Alignment.bottomCenter,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
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
                                  builder: (BuildContext context,
                                      RegisterState state) {
                                    if (state is RegisterSuccess) {
                                      final response =
                                          jsonEncode(state.response.toJson());
                                      debugPrint('response123: $response');

                                      // Defer the state change until after the current frame
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _registerBloc.add(
                                            onGetRegisterResponse(response));
                                      });
                                    } else if (state is Registered) {
                                      // Defer navigation until after the current frame
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _handleRegistered(state.iden3message);

                                        // Navigate to the desired page (e.g., HomeScreen)
                                      });
                                    } else if (state is loadedClaims) {
                                      // Defer navigation until after the current frame
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SetupPasswordScreen(),
                                          ),
                                        );
                                      });
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        _registerBloc.add(
                                          SubmitSignup(
                                            did: identity.text,
                                            first: "thathsarani",
                                            last: "trineesha",
                                            email: "trineesha@gmail.com",
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        alignment: Alignment.bottomCenter,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: const GradientBoxBorder(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFa3d902),
                                                Color(0xFF2CFFAE)
                                              ],
                                            ),
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
                                                        GoogleFonts.robotoMono()
                                                            .fontFamily,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRegistered(Iden3MessageEntity iden3message) async {
    print('iden3message233: $iden3message');
    _registerBloc.add(fetchAndSaveClaims(iden3message: iden3message));
  }
}
