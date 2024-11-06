import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/circularProgress.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/loading.dart';
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

class _SetUpScreenState extends State<SetUpScreen>
    with SingleTickerProviderStateMixin {
  late final HomeBloc _bloc;
  bool isCreatingIdentity = false;

  get vsync => null;

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
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            baseColor: Theme.of(context).colorScheme.primary,
            spawnMinSpeed: 40,
            spawnMaxSpeed: 40,
            spawnMinRadius: 10,
            spawnMaxRadius: 30,
            particleCount: 5,
            spawnOpacity: 0.2,
            image: Image.asset('assets/images/logo_small.png'),
          ),
        ),
        child: _buildContent(context),
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
              : Column(
                  children: [
                    _buildreCreateIdentityButton(enabled),
                    SizedBox(height: 10),
                    _buildHaveIdentityButton(enabled),
                  ],
                );
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
            MaterialPageRoute(builder: (context) => const LoadingPage()),
          );
          // }
        },
        key: CustomWidgetsKeys.homeScreenButtonCreateIdentity, // Unique Key
        child: FrostedGlassBox(
          theWidth: MediaQuery.of(context).size.width,
          theHeight: 50.0,
          theX: 4.0,
          theY: 4.0,
          theColor: Colors.white.withOpacity(0.13),
          theChild: BlocBuilder<HomeBloc, HomeState>(
            bloc: _bloc,
            builder: (context, state) {
              return Text(
                'Create New DID',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.robotoMono().fontFamily,
                ),
              );
            },
            buildWhen: (_, currentState) => currentState
                is LoadedIdentifierHomeState, // Respond to this state
          ),
        ),
      ),
    );
  }

  Widget _buildreCreateIdentityButton(bool enabled) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: GestureDetector(
        onTap: () async {
          bool shouldProceed = await _showConfirmationDialog(context);

          if (shouldProceed) {
            _bloc.add(const HomeEvent.createIdentity());

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoadingPage()),
            );
          }
        },
        key: CustomWidgetsKeys.homeScreenButtonCreateIdentity, // Unique Key
        child: FrostedGlassBox(
          theWidth: MediaQuery.of(context).size.width,
          theHeight: 50.0,
          theX: 4.0,
          theY: 4.0,
          theColor: Colors.white.withOpacity(0.13),
          theChild: BlocBuilder<HomeBloc, HomeState>(
            bloc: _bloc,
            builder: (context, state) {
              return Text(
                'Re-Create New DID',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.robotoMono().fontFamily,
                ),
              );
            },
            buildWhen: (_, currentState) => currentState
                is LoadedIdentifierHomeState, // Respond to this state
          ),
        ),
      ),
    );
  }

  /// Function to show the confirmation dialog
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 54, 72, 1),
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
              title: Column(
                children: [
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/lottie/delete.gif',
                    height: 80,
                  ),
                  SizedBox(height: 10),
                  Text('Confirmation'),
                  SizedBox(height: 10),
                ],
              ),
              content: Text('Are you sure you want to create a new identity? \n'
                  'This will remove the existing identity and all associated data.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel',
                      style: TextStyle(color: Colors.redAccent[700])),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(dialogContext).pop(true);
                   
                     final storage = GetStorage();
                     storage.write('isConnected', false);
                  },
                  child: FrostedGlassBox(
                    theWidth: MediaQuery.of(context).size.width / 4,
                    theHeight: 50.0,
                    theX: 4.0,
                    theY: 4.0,
                    theColor: Colors.white.withOpacity(0.13),
                    theChild: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.robotoMono().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _buildRemoveIdentityButton(bool enabled) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: GestureDetector(
        onTap: () async {
          isCreatingIdentity = false;
          _bloc.add(const HomeEvent.removeIdentity());
        },
        key: CustomWidgetsKeys.homeScreenButtonRemoveIdentity, // Unique Key
        child: FrostedGlassBox(
          theWidth: MediaQuery.of(context).size.width,
          theHeight: 50.0,
          theX: 4.0,
          theY: 4.0,
          theColor: Colors.white.withOpacity(0.13),
          theChild: BlocConsumer<HomeBloc, HomeState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is LoadedIdentifierHomeState && !isCreatingIdentity) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Identity removed successfully'),
                    ),
                  );
                });
              }
            },
            builder: (context, state) {
              return Text(
                'Remove DID',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.robotoMono().fontFamily,
                ),
              );
            },
            buildWhen: (_, currentState) =>
                currentState is LoadedIdentifierHomeState,
          ),
        ),
      ),
    );
  }

  Widget _buildHaveIdentityButton(bool enabled) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: GestureDetector(
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
        ),
        child: FrostedGlassBox(
          theWidth: MediaQuery.of(context).size.width,
          theHeight: 50.0,
          theX: 4.0,
          theY: 4.0,
          theColor: Colors.white.withOpacity(0.13),
          theChild: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'Already have a DID',
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).secondaryHeaderColor,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  _buildTitle(),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              Column(
                children: [
                  _buildIdentityActionButton(),
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
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              "Welcome To",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.robotoMono().fontFamily,
              ),
            ),
          ),
          SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              "Bethel ZkpStorage",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width / 15,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.robotoMono().fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportWalletButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary
            ],
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
            'Import Wallet',
            style: TextStyle(
              fontSize: 12.0,
              color: Theme.of(context)
                  .primaryColor, // Keep the text color simple since the gradient is on the button
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.robotoMono().fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
