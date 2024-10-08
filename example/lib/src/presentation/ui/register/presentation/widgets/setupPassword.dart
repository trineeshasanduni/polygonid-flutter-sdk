import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/bethelBottomBar.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/setupAccount.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/widget/glassEffect.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/login/bloc/login_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/register.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';

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
 

  @override
  void initState() {
    super.initState();
    _loginBloc = getIt<LoginBloc>();
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
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
                SizedBox(height: MediaQuery.of(context).size.height / 6),
                _buildSubtitle(),
              ],
            ),

            Column(
              children: [
                // IconButton(
                //   icon: const Icon(Icons.close, color: Colors.white),
                //   onPressed: () {
                //     Navigator.of(context).pushReplacementNamed(Routes.homePath);
                //     // Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(
                //     //     builder: (context) => const SetUpScreen(),
                //     //   ),
                //     // );
                //   },
                // ),
                _buildBlocContent(context),
                const SizedBox(height: 20),
                _buildRegisterButton(),
                // const SizedBox(height: 20),
                // _buildDashboardButton(),
              ],
            ),

            // _buildDashboardButton(),
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
          // return  CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor);
          return Loading(Loadingcolor:Theme.of(context).primaryColor,color:Theme.of(context).colorScheme.secondary);
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
    return Transform.rotate(
      angle: 45 * 3.1415927 / 180, // Converts 45 degrees to radians
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 5,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/space.png'),
            fit: BoxFit.contain,
          ),
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
      child: _buildtransperantButton('Log in'),
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
      child: _buildButton(context,'Register', Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary
          , Colors.black, Theme.of(context).primaryColor),
    );
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

 Widget _buildButton(BuildContext context,String text, dynamic colorScheme, dynamic colorScheme2, dynamic border, dynamic textColor) {
  return  Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [colorScheme,colorScheme2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.0), // Optional: Add some rounding to the button
      ),
      child: FrostedGlassBox(
        theWidth: MediaQuery.of(context).size.width,
        theHeight: 50.0,
        theX: 0.0,
        theY: 0.0,
        theColor: Colors.white.withOpacity(0.13), // This can remain for frosted glass effect
        theChild: Text(
          text,
          style: TextStyle(
            fontSize: 12.0,
            color: textColor, // Keep the text color simple since the gradient is on the button
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.robotoMono().fontFamily,
          ),
        ),
      ),
    
  );
}

Widget _buildtransperantButton(String text) {
  return   FrostedGlassBox(
        
        theWidth: MediaQuery.of(context).size.width,
        theHeight: 50.0,
        theX: 4.0,
        theY: 4.0,
        theColor: Colors.white.withOpacity(0.13),
        theChild: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary], // Customize your gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white, // This will be overridden by the gradient
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.robotoMono().fontFamily,
            ),
          ),
        ),
      
    
  );
}
 
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
  //       // border: const GradientBoxBorder(
  //       //   gradient: LinearGradient(
  //       //     colors: [Color(0xFFa3d902), Color(0xFF2CFFAE)],
  //       //   ),
  //       //   width: 1,
  //       // ),
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
}
