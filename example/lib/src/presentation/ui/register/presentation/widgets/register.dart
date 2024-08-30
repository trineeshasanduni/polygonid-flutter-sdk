import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/setupPassword.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/bloc/register_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/registerQr.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
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

  final formKey = GlobalKey<FormState>();
  // final TextEditingController
  var identity = TextEditingController();
  final storage = const FlutterSecureStorage();
  VideoPlayerController? _controller;
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.asset('assets/images/green-bg.mp4')
    //   ..initialize().then((_) {
    //     debugPrint('video initialized: ${_controller!.value.isInitialized}');
    //     _controller!.play();
    //     _controller!.setLooping(true);
    //     setState(() {});
    //   });
    // DIDController.addListener(_checkInput);
  }

  // void _checkInput() {
  //   isButtonEnabled.value = DIDController.text.isNotEmpty;
  // }

  @override
  void dispose() {
    // DIDController.removeListener(_checkInput);
    // DIDController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
      // create: (context) => _reg,
      Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              final response = jsonEncode(state.response.toJson());
              print('response123: ${response}');
              Navigator.pop(context, response);
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ));
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Center(
                  child: Container(
                    child: _controller!.value.isInitialized
                        ? Transform.scale(
                            scale: 1.8,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 3.5,
                                child: VideoPlayer(_controller!)),
                          )
                        : const SizedBox(),
                  ),
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
                                  fontFamily:
                                      GoogleFonts.robotoMono().fontFamily,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            Text(
                              'zkpStorage',
                              style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.robotoMono().fontFamily,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
                                color: Colors.white)),
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
                                BlocBuilder(
                                  bloc: _bloc,
                                  builder:
                                      (BuildContext context, HomeState state) {
                                    print(
                                        'state.identifier: ${state.identifier}');

                                    identity = state.identifier != null
                                        ? TextEditingController(
                                            text: state.identifier)
                                        : TextEditingController();
                                    return TextFormField(
                                      controller: identity,
                                      enabled: false,
                                      decoration: InputDecoration(
                                        labelText:
                                            'Paste your Polygon DID here',
                                        labelStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            fontFamily: GoogleFonts.robotoMono()
                                                .fontFamily,
                                            fontSize: 13),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red.withOpacity(0.4),
                                          ),
                                        ),
                                      ),
                                      // validator: (value) {
                                      //   if (value!.isEmpty) {
                                      //     return 'DID is required';
                                      //   }
                                      //   return null;
                                      // },
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
                                      // onTap: () => 
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //              SetupPasswordScreen())
                                                  //  ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        alignment: Alignment.bottomCenter,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: const GradientBoxBorder(
                                            gradient: LinearGradient(colors: [
                                              Color(0xFFa3d902),
                                              Color(0xFF2CFFAE)
                                            ]),
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
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<RegisterBloc>()
                                            .add(SubmitSignup(
                                              did: identity.text,
                                              first: "thathsarani",
                                              last: "trineesha",
                                              email: "trineesha@gmail.com",
                                            ));
                                        // if (formKey.currentState!.validate()) {
                                        //   context
                                        //       .read<RegisterBloc>()
                                        //       .add(SubmitSignup(
                                        //         did: identity.text,
                                        //         first: "thathsarani",
                                        //         last: "trineesha",
                                        //         email: "trineesha@gmail.com",
                                        //       ));
                                        // }
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
                                            gradient: LinearGradient(colors: [
                                              Color(0xFFa3d902),
                                              Color(0xFF2CFFAE),
                                            ]),
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
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
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      // ),
    );
  }
}
