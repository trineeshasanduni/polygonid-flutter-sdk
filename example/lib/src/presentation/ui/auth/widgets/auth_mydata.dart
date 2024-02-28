import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/auth/auth_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/auth/auth_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/auth/auth_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/button_next_action.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/profile_radio_button.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_button_style.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_widgets_keys.dart';

class AuthScreenData extends StatefulWidget {
  final AuthBloc _bloc;

  AuthScreenData({Key? key})
      : _bloc = getIt<AuthBloc>(),
        super(key: key);

  @override
  State<AuthScreenData> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreenData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  ///
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: CustomColors.background,
    );
  }

  ///
  Widget _buildBody() {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMydata(),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildTitle(),
                      // const SizedBox(height: 24),
                      _buildSubTitle(),
                      const SizedBox(height: 24),
                  
                      // _buildProgress(),
                      // const SizedBox(height: 24),
                      // _buildAuthenticationSuccessSection(),
                      // const SizedBox(height: 24),
                      // _buildErrorSection(),
                      // const SizedBox(height: 10),
                      Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Stack(
                    children: [
                      _buildBlocListener(),
                      _buildAuthConnectButton(),
                      // _buildNavigateToNextPageButton(),
                    ],
                  ),
                              ),
                    ],
                    
                  ),
                ),
              ),
            ),
            // Expanded(child: _buildRadioButtons()),
            
          ],
        ),
      ),
    );
  }

  ///
  Widget _buildAuthConnectButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: ElevatedButton(
          key: CustomWidgetsKeys.authScreenButtonConnect,
          onPressed: () {
            widget._bloc.add(const AuthEvent.clickScanQrCode());
          },
          style: CustomButtonStyle.primaryButtonStyleSmall,
          child: const Text(
            CustomStrings.authButtonCTA,
            style: CustomTextStyles.primaryButtonTextStyle,
          ),
        ),
      ),
    );
  }

  ///
  Widget _buildMydata() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        CustomStrings.homeMydata,
        textAlign: TextAlign.start,
        style: CustomTextStyles.TopicTextStyle,
      ),
    );
  }

  ///
  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        CustomStrings.homeMydataTitle,
        textAlign: TextAlign.start,
        style: CustomTextStyles.TitleTextStyle,
      ),
    );
  }

  ///
  Widget _buildSubTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        CustomStrings.homeMydataSubTitle,
        textAlign: TextAlign.start,
        style: CustomTextStyles.SubTitleTextStyle,
      ),
    );
  }

  ///
  Widget _buildNavigateToNextPageButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: ButtonNextAction(
          key: CustomWidgetsKeys.authScreenButtonNextAction,
          enabled: true,
          onPressed: () {
            Navigator.pushNamed(context, Routes.claimsPath);
          },
        ),
      ),
    );
  }

  ///
  Widget _buildBlocListener() {
    return BlocListener<AuthBloc, AuthState>(
      bloc: widget._bloc,
      listener: (context, state) {
        if (state is NavigateToQrCodeScannerAuthState) {
          _handleNavigateToQrCodeScannerAuthState();
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  ///
  Future<void> _handleNavigateToQrCodeScannerAuthState() async {
    String? qrCodeScanningResult =
        await Navigator.pushNamed(context, Routes.qrCodeScannerPath) as String?;
    widget._bloc.add(AuthEvent.onScanQrCodeResponse(qrCodeScanningResult));
  }

  ///
  Widget _buildProgress() {
    return BlocBuilder(
      bloc: widget._bloc,
      builder: (BuildContext context, AuthState state) {
        if (state is! LoadingAuthState) {
          return const SizedBox(
            height: 48,
            width: 48,
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<String>(
              stream: widget._bloc.proofGenerationStepsStream,
              initialData: "",
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Text(
                  snapshot.data ?? "",
                  style: CustomTextStyles.descriptionTextStyle,
                );
              },
            ),
            const SizedBox(
              height: 48,
              width: 48,
              child: CircularProgressIndicator(
                backgroundColor: CustomColors.primaryButton,
              ),
            ),
          ],
        );
      },
    );
  }

  ///
  Widget _buildAuthenticationSuccessSection() {
    return BlocBuilder(
      bloc: widget._bloc,
      builder: (BuildContext context, AuthState state) {
        if (state is! AuthenticatedAuthState) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            CustomStrings.authSuccess,
            style: CustomTextStyles.descriptionTextStyle
                .copyWith(color: CustomColors.greenSuccess),
          ),
        );
      },
    );
  }

  ///
  Widget _buildErrorSection() {
    return BlocBuilder(
      bloc: widget._bloc,
      builder: (BuildContext context, AuthState state) {
        if (state is! ErrorAuthState) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            state.message,
            style: CustomTextStyles.descriptionTextStyle
                .copyWith(color: CustomColors.redError),
          ),
        );
      },
    );
  }

  ///
  Widget _buildRadioButtons() {
    void _selectProfile(SelectedProfile profile) {
      widget._bloc.add(AuthEvent.profileSelected(profile));
    }

    return BlocBuilder(
        bloc: widget._bloc,
        builder: (BuildContext context, AuthState state) {
          return ProfileRadio(widget._bloc.selectedProfile, _selectProfile);
        });
  }
}
