import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:video_player/video_player.dart';

import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/bethelBottomBar.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/login/bloc/login_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/register.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';

class SetupPasswordScreen extends StatefulWidget {
  const SetupPasswordScreen({super.key});

  @override
  State<SetupPasswordScreen> createState() => _SetupPasswordScreenState();
}

class _SetupPasswordScreenState extends State<SetupPasswordScreen> {
  late final LoginBloc _loginBloc;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/green-bg.mp4')
      ..initialize().then((_) {
        _controller!.play();
        _controller!.setLooping(true);
        setState(() {});
      });

    _loginBloc = getIt<LoginBloc>();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(Routes.homePath);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildVideoBackground(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildVideoBackground() {
    return Center(
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
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTitle(),
            _buildSubtitle(),
            _buildBlocContent(context),
            const SizedBox(height: 20),
            _buildRegisterButton(),
            _buildDashboardButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBlocContent(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (context, state) {
        if (state is LoginLoading) {
          return const CircularProgressIndicator(
            color: Colors.yellow,
          );
        }
        if (state is LoginFailure) {
          return Text(state.error, style: const TextStyle(color: Colors.red));
        }
        if (state is LoginSuccess) {
          final response = jsonEncode(state.response.toJson());
          final sessionId = state.response.headers.toString();

          print('headers123: $sessionId');
          // final storage = GetStorage();
          // storage.write('sessionID', sessionId);

          print('Login response123: $response');
          _loginBloc.add(onLoginResponse(response));

          // if (state is authenticated) {
          // String? getSessionId = storage.read(key: 'sessionID') as String?;
          print('getSessionId: $sessionId');

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loginBloc.add(onGetStatusEvent(sessionId));
          });
        // }
        }
        
        if (state is StatusLoaded) {
          final did = jsonEncode(state.did.toJson());
          print('did get fetch: ${did}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, Routes.homePath);
            print('Status loaded for DID: ${did}');
          });
        }

        return _buildLoginButton();
      },
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bethel ',
          style: GoogleFonts.robotoMono(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Text(
          'zkpStorage',
          style: GoogleFonts.robotoMono(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Column(
      children: [
        const SizedBox(height: 4),
        Text(
          'Hack Proof Blockchain Based Secure Decentralized File Storage with Zero-Knowledge Proof (ZKP)',
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoMono(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {
        _loginBloc.add(LoginWithCredentials());
      },
      child: _buildButton('Log in'),
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Signup(),
          ),
        );
      },
      child: _buildButton('Register'),
    );
  }

  Widget _buildDashboardButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BethelBottomBar(),
          ),
        );
      },
      child: _buildButton('Dashboard'),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(6),
        border: const GradientBoxBorder(
          gradient: LinearGradient(
            colors: [Color(0xFFa3d902), Color(0xFF2CFFAE)],
          ),
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

//   Widget _buildAuthenticationSuccessSection(String sessionId) {
//   if (sessionId.isNotEmpty) {
//     // Ensure this event is only added once by using a post-frame callback
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loginBloc.add(onGetStatusEvent(sessionId));
//     });
//   }

//   return BlocBuilder<LoginBloc, LoginState>(
//     bloc: _loginBloc,
//     builder: (context, state) {
//       if (state is StatusLoaded) {
//         print('did get fetch: ${state.did}');
//         // Perform navigation or any other logic based on the status being loaded
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Navigator.pushNamed(context, Routes.homePath);
//           print('Status loaded for DID: ${state.did}');
//         });
//       }

//       return const SizedBox.shrink();
//     },
//   );
// }

// Widget _buildAuthenticationSuccessSection(String sessionId) {
//   if (sessionId.isNotEmpty) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loginBloc.add(onGetStatusEvent(sessionId));
//     });
//   }

//   return BlocBuilder<LoginBloc, LoginState>(
//     bloc: _loginBloc,
//     builder: (context, state) {
//       if (state is StatusLoaded) {
//         print('fetch did:');
//         final did =jsonEncode(state.did.toJson());
//         print('did get fetch: ${did}');
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Navigator.pushNamed(context, Routes.homePath);
//           print('Status loaded for DID: ${did}');
//         });
//       } else if (state is LoginLoading) {
//         return const CircularProgressIndicator(); // Show a loading indicator
//       } else if (state is LoginFailure) {
//         return Text(state.error, style: const TextStyle(color: Colors.red)); // Show error message
//       }

//       return const SizedBox.shrink(); // Default state
//     },
//   );
// }

  Widget _buildAuthenticationSuccessSection(String sessionId) {
    print('authenticating');
    if (sessionId.isNotEmpty) {
      // Add the event to fetch the status
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loginBloc.add(onGetStatusEvent(sessionId));
      });
      print('authenticated');
    }

    BlocBuilder<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (context, state) {
        if (state is StatusLoaded) {
          print('fetch did:');
          final did = jsonEncode(state.did.toJson());
          print('did get fetch: ${did}');

          // Direct navigation inside the StatusLoaded state
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, Routes.homePath);
            print('Status loaded for DID: ${did}');
          });

          // Return an empty widget while navigation is processed
          return const SizedBox.shrink();
        } else if (state is LoginLoading) {
          return const CircularProgressIndicator(
            color: Colors.pink,
          ); // Show a loading indicator
        } else if (state is LoginFailure) {
          return Text(state.error,
              style: const TextStyle(color: Colors.red)); // Show error message
        }

        return const SizedBox.shrink(); // Default state
      },
    );
    return const SizedBox.shrink();
  }

  // Widget _getStatusResponse() {
  //   return BlocBuilder<LoginBloc, LoginState>(
  //     bloc: _loginBloc,
  //     builder: (context, state) {
  //       if (state is StatusLoaded) {
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           Navigator.pushNamed(context, Routes.homePath);
  //           print('Status loaded for DID: ${state.did}');
  //         });
  //       }

  //       return const SizedBox.shrink();
  //     },
  //   );
  // }
}
