import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/bethelBottomBar.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
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
          return const CircularProgressIndicator(color: Colors.yellow);
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
    
    // final storage = GetStorage();
    // await storage.write('DID', did);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BethelBottomBar(did)),
      );
    });
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
}
