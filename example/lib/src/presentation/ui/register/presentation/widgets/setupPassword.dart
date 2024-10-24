import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/bethelBottomBar.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/transperant_button.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/setupAccount.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/widget/glassEffect.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/login/bloc/login_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/bloc/register_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/register.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class SetupPasswordScreen extends StatefulWidget {
  const SetupPasswordScreen({super.key});

  @override
  State<SetupPasswordScreen> createState() => _SetupPasswordScreenState();
}

class _SetupPasswordScreenState extends State<SetupPasswordScreen> {
  late final LoginBloc _loginBloc;
  late final HomeBloc _bloc;
  late final RegisterBloc _registerBloc;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  String? _errorMessage;
  bool _isFetching = true;
  var identity;

  @override
  void initState() {
    super.initState();
    _loginBloc = getIt<LoginBloc>();
    _bloc = getIt<HomeBloc>();
    _registerBloc = getIt<RegisterBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGetIdentifier();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

  void _initGetIdentifier() {
    _bloc.add(const GetIdentifierHomeEvent());
    // _getdid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: -150,
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
            top: 200,
            right: -60,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width / 1.5,
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
          // _header(state),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Column(
            //   children: [

            //     // _buildWelcome(),
            //   ],
            // ),

            Column(
              children: [
                _buildLogo(),
                const SizedBox(height: 20),
                _buildTitle(),
                const SizedBox(height: 4),
                _buildTopic(),
                // _buildSubtitle(),
              ],
            ),

            const SizedBox(height: 20),

            Column(
              children: [

                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    // Navigator.of(context).pushReplacementNamed(Routes.homePath);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Signup(),
                      ),
                    );
                  },
                ),
                _buildBlocContent(context),
                const SizedBox(height: 20),
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
                _buildRegisterButton(),
                // const SizedBox(height: 20),
                // _buildDashboardButton(),
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
                        fontFamily: GoogleFonts.robotoMono().fontFamily,
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

            // _buildDashboardButton(),
          ],
        ),
      ),
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

  Widget _buildBlocContent(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (context, state) {
        if (state is LoginLoading) {
          // return  CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
              LoadingAnimationWidget.progressiveDots(
                color: Theme.of(context).colorScheme.secondary,
                size: 30.0,
              )
            ],
          );
        }
        if (state is LoginFailure) {
          return Text(state.error, style: const TextStyle(color: Colors.red));
        }
        if (state is LoginSuccess) {
          _handleLoginSuccess(state);
        }
        if (state is StatusLoaded) {
          _handleStatusLoaded(state);
        }
        return _buildLoginButton();
      },
    );
  }

  void _handleLoginSuccess(LoginSuccess state) {
    final response = jsonEncode(state.response.toJson());
    final sessionId = state.response.headers.toString();

    print('Login response: $response');
    _loginBloc.add(onLoginResponse(response));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loginBloc.add(onGetStatusEvent(sessionId));
    });
  }

  void _handleStatusLoaded(StatusLoaded state) async {
    final did = jsonEncode(state.did.did);
    print('DID fetched: $did');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BethelBottomBar(
                  did: did,
                )),
      );
    });
  }

  Widget _buildLogo() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/launcher_icon.png'),
          fit: BoxFit.contain,
        ),
      ),

      // ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          'Let\'s Get',
          style: GoogleFonts.robotoMono(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        Text(
          'Started',
          // textAlign: TextAlign.center,
          style: GoogleFonts.robotoMono(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
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
      child: TransperantButton(
        text: 'Log In',
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

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
                  _registerBloc.add(clickRegisterScanQrCode());
                }
              },
              // style: CustomButtonStyle.primaryButtonStyle,
              child: loading
                  ? Loading(
                      Loadingcolor: Theme.of(context).primaryColor,
                      color: Theme.of(context).colorScheme.secondary)
                  : _buildButton(
                      context,
                      'Register Using Web ',
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                      Colors.black,
                      Theme.of(context).primaryColor),
            );
          }),
    );
  }

  Widget _buildRegisterButton() {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is LoadedIdentifierHomeState) {
          identity = state.identifier;
        }
        return BlocBuilder<RegisterBloc, RegisterState>(
          bloc: _registerBloc,
          builder: (BuildContext context, RegisterState state) {
            if (state is RegisterLoading) {
              return Loading(
                  Loadingcolor: Theme.of(context).primaryColor,
                  color: Theme.of(context).colorScheme.secondary);
            }
            if (state is RegisterSuccess) {
              final statusCode = state.response.statusCode;
              final response = jsonEncode(state.response.toJson());

              if (statusCode == 200 && _isFetching) {
                _errorMessage = 'You are already registered Using this DID';

                // Stop further fetching
                _isFetching = false;

                // Defer the state change until after the current frame
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {}); // Update the UI to show the error message
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
                      did: identity,
                      first: "",
                      last: "",
                      email: "",
                    ),
                  );
                } else {
                  // Handle case when fetching is disabled
                }
              },
              child: _buildButton(
                  context,
                  'Register',
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Colors.black,
                  Theme.of(context).primaryColor),
            );
          },
        );
      },
    );
  }

  Future<void> _handleRegistered(Iden3MessageEntity iden3message) async {
    debugPrint('User is registered');
    _registerBloc.add(fetchAndSaveClaims(iden3message: iden3message));
  }

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

// Widget _buildDashboardButton() {
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const BethelBottomBar( did: 'did'),
//         ),
//       );
//     },
//     child: _buildButton(context,'Dashboard', Colors.transparent,
//         Theme.of(context).colorScheme.secondary,Theme.of(context).colorScheme.primary, Colors.white),
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
