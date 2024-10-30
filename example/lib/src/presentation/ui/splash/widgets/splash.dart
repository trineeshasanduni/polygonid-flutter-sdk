import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/create_wallet/setupAccount.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/widgets/setupPassword.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/splash/splash_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/splash/splash_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/splash/splash_state.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_button_style.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:polygonid_flutter_sdk_example/utils/image_resource.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription? _changeStateStreamSubscription;
  SplashBloc _bloc = getIt<SplashBloc>();

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  @override
  void dispose() {
    _changeStateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background,
      body: _buildBody(),
    );
  }

  ///
  Widget _buildBody() {
    return BlocListener(
      bloc: _bloc,
      listener: (BuildContext context, SplashState state) {
        if (state is WaitingTimeEndedSplashState) _handleWaitingTimeEnded();
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SvgPicture.asset(
            //   ImageResources.logo,
            //   width: 180,
            // ),
            Image.asset(
              'assets/images/ic_launcher.png',
              width: 80,
            ),
            _buildDownloadProgress(),
          ],
        ),
      ),
    );
  }

  ///
  Widget _buildDownloadProgress() {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, SplashState state) {
        if (state is DownloadProgressSplashState) {
          // return percentage
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text("Downloading circuits...",style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 16,
                fontFamily: GoogleFonts.robotoMono().fontFamily,
                fontWeight: FontWeight.w400,
              ),),
              const SizedBox(height: 2),
              Text(
                  "${(state.downloaded / state.contentLength * 100).toStringAsFixed(2)} %"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _bloc.add(const SplashEvent.cancelDownloadEvent());
                },
                style: CustomButtonStyle.primaryButtonStyle,
                child:  FittedBox(
                  child: Text(
                    "Cancel download",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: GoogleFonts.robotoMono().fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is ErrorSplashState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Error downloading circuits"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _bloc.add(const SplashEvent.startDownload());
                },
                style: CustomButtonStyle.outlinedPrimaryButtonStyle,
                child: FittedBox(
                  child: Text(
                    "Retry",
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.primaryButtonTextStyle
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  ///
  void _handleWaitingTimeEnded() {
    // Navigator.of(context).pushReplacementNamed(Routes.registerPath);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SetUpScreen()));
  }

  ///
  void _startDownload() {
    _bloc.add(const SplashEvent.startDownload());
  }
}
