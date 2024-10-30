import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/widget/glassEffect.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_button_style.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_widgets_keys.dart';

class SetUpScreen extends StatefulWidget {
  const SetUpScreen({super.key});

  @override
  State<SetUpScreen> createState() => _SetUpScreenState();
}

class _SetUpScreenState extends State<SetUpScreen> {
  late final HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<HomeBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGetIdentifier();
    });
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          // Positioned(
          //   top: -320,
          //   left: -120,
          //   child: SizedBox(
          //     height: MediaQuery.of(context).size.height,
          //     width: MediaQuery.of(context).size.width,

          //     child: SvgPicture.asset(
          //       'assets/images/blob-1.svg',
          //       fit: BoxFit.contain,
          //       color: const Color(0xFFa3d902).withOpacity(0.2),
          //     ),
          //     // child: Container(
          //     //   height: MediaQuery.of(context).size.height / 1,
          //     //   width: MediaQuery.of(context).size.width / 2,
          //     //   decoration: BoxDecoration(
          //     //       color: const Color(0xFF2CFFAE).withOpacity(0.2),
          //     //       shape:BoxShape.circle),
          //     // ),
          //   ),
          // ),
          // Positioned(
          //   top: 420,
          //   right: -120,
          //   child: SizedBox(
          //     height: MediaQuery.of(context).size.height,
          //     width: MediaQuery.of(context).size.width * 1.2,
          //     child: SvgPicture.asset(
          //       'assets/images/blob-2.svg',
          //       fit: BoxFit.contain,
          //       color: const Color(0xFFa3d902).withOpacity(0.2),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: -50,
          //   right: -120,
          //   child: SizedBox(
          //     height: MediaQuery.of(context).size.height,
          //     width: MediaQuery.of(context).size.width,
          //     child: SvgPicture.asset(
          //       'assets/images/blob-4.svg',
          //       fit: BoxFit.contain,
          //       color: const Color(0xFF2CFFAE).withOpacity(0.2),
                
          //     ),
          //   ),
          // ),
          
          // Positioned(
          //   top: 120,
          //   left: -120,
          //   child: SizedBox(
          //     height: MediaQuery.of(context).size.height,
          //     width: MediaQuery.of(context).size.width,
          //     child: SvgPicture.asset(
          //       'assets/images/blob-3.svg',
          //       fit: BoxFit.contain,
          //       color: const Color(0xFF2CFFAE).withOpacity(0.2),
          //     ),
          //   ),
          // ),
          Positioned(
            top: -220,
            left: -100,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.2,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                  // color: const Color(0xFFa3d902).withOpacity(0.2),
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                  shape: BoxShape.circle),
            ),
          ),

          
          Positioned(
            top: 480,
            right: -50,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                  color: const Color(0xFF2CFFAE).withOpacity(0.3),
                  // border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 2),
                  shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: 380,
            right: -50,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                 
                  border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
                  shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: 200,
            left: -100,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
                  // color: const Color(0xFFa3d902).withOpacity(0.3),
                  shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: -220,
            right: -100,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.2,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  color: const Color(0xFF2CFFAE).withOpacity(0.2),
                  shape: BoxShape.circle),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              //sigmaX is the Horizontal blur
              sigmaX: 5.0,
              //sigmaY is the Vertical blur
              sigmaY: 5.0,
            ),
            child: Container(),
          ),
          // _buildBackground(context),
          _buildContent(context),
        ],
      ),
    );
  }

  void _initGetIdentifier() {
    _bloc.add(const GetIdentifierHomeEvent());
  }

  Widget _buildIdentityActionButton() {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, HomeState state) {
          bool enabled = state is! LoadingDataHomeState;
          bool showCreateIdentityButton =
              state.identifier == null || state.identifier!.isEmpty;

          return showCreateIdentityButton
              ? _buildCreateIdentityButton(enabled)
              : _buildRemoveIdentityButton(enabled);
        },
      ),
    );
  }

  Widget _buildCreateIdentityButton(bool enabled) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: GestureDetector(
        onTap: () async {
          _bloc.add(const HomeEvent.createIdentity());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SetupPasswordScreen()));
        },
        key: CustomWidgetsKeys.homeScreenButtonCreateIdentity,
        child: FrostedGlassBox(
          theWidth: MediaQuery.of(context).size.width,
          theHeight: 50.0,
          theX: 4.0,
          theY: 4.0,
          theColor: Colors.white.withOpacity(0.13),
          theChild: Text(
            'Create Account',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.robotoMono().fontFamily,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveIdentityButton(bool enabled) {
  return AbsorbPointer(
    absorbing: !enabled,
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SetupPasswordScreen()));
        // _bloc.add(const HomeEvent.removeIdentity());
      },
      child: FrostedGlassBox(
        key: CustomWidgetsKeys.homeScreenButtonRemoveIdentity,
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
            'Already have an Account',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white, // This will be overridden by the gradient
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.robotoMono().fontFamily,
            ),
          ),
        ),
      ),
    ),
  );
}


  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            //
            child: Image.asset(
              'assets/images/dddepth-048.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.0,
            sigmaY: 2.0,
          ),
          child: Container(),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // _buildLottieAnimation(),
                  _buildHeader(),
                  _buildTitle(),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              Column(
                children: [
                  _buildIdentityActionButton(),
                  SizedBox(height: 10),
                   _buildImportWalletButton(context),
                ],
              ),
              
             
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: 150,
      child: Image.asset(
        'assets/images/launcher_icon.png',
      ),
    );
  }

  Widget _buildTitle() {
  return Container(
    child: Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "Welcome",
            style: TextStyle(
              color: Colors.white, // Set this to any color for the base, but it will be overridden by the gradient
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.robotoMono().fontFamily,
            ),
          ),
        ),
        SizedBox(height: 10),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "Bethel Zkp",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.robotoMono().fontFamily,
            ),
          ),
        ),
      ],
    ),
  );
}


  // Widget _buildLottieAnimation() {
  Widget _buildImportWalletButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      // context.go(
      //   '/inputPhrase',
      // );
    },
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.0), // Optional: Add some rounding to the button
      ),
      child: FrostedGlassBox(
        theWidth: MediaQuery.of(context).size.width,
        theHeight: 50.0,
        theX: 4.0,
        theY: 4.0,
        theColor: Colors.white.withOpacity(0.13), // This can remain for frosted glass effect
        theChild: Text(
          'Import Wallet',
          style: TextStyle(
            fontSize: 12.0,
            color: Theme.of(context).primaryColor, // Keep the text color simple since the gradient is on the button
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.robotoMono().fontFamily,
          ),
        ),
      ),
    ),
  );
}


  // Widget _buildCreateWalletButton(BuildContext context, bool enabled) {
  //   return GestureDetector(
  //     // onTap: () {
  //     //   Navigator.pushNamed(
  //     //     context,
  //     //     '/generatePhrase',
  //     //   );
  //     // },
  //     // onTap: () => context.go('/generatePhrase'),
  //     child: FrostedGlassBox(
  //       theWidth: 10.0,
  //       theHeight: 50.0,
  //       theX: 4.0,
  //       theY: 4.0,
  //       theColor: Colors.white.withOpacity(0.13),
  //       theChild: Text(
  //         'Create Wallet',
  //         style: TextStyle(
  //           fontSize: 14.0,
  //           color: Colors.white,
  //           fontWeight: FontWeight.w500,
  //           fontFamily: GoogleFonts.robotoMono().fontFamily,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
