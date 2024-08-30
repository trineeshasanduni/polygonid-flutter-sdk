import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:polygonid_flutter_sdk/sdk/identity.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/setupPassword.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/bloc/register_bloc.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:video_player/video_player.dart';
// import 'package:web3modal_flutter/web3modal_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late final HomeBloc _bloc;
  // late W3MService _w3mService;
  final formKey = GlobalKey<FormState>();
  final DIDController = TextEditingController();
  final storage = const FlutterSecureStorage();
  VideoPlayerController? _controller;
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
  bool isConnectedToMetaMask =
      false; // State variable to track MetaMask connection

  @override
  void initState() {
    super.initState();
    // _initW3MService();
    _controller = VideoPlayerController.asset('assets/images/green-bg.mp4')
      ..initialize().then((_) {
        debugPrint('video initialized: ${_controller!.value.isInitialized}');
        _controller!.play();
        _controller!.setLooping(true);
        setState(() {});
      });
    DIDController.addListener(_checkInput);

    // _bloc = getIt<HomeBloc>();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initGetIdentifier();
    // });
  }

  // void _initGetIdentifier() {
  //   _bloc.add(const GetIdentifierHomeEvent());
  // }

  // void _initW3MService() async {
  //   _w3mService = W3MService(
  //     projectId: 'e96af4893d7308f455d1055dcf0a8fb3',
  //     metadata: const PairingMetadata(
  //       name: 'Web3Modal Flutter Example',
  //       description: 'Web3Modal Flutter Example',
  //       url: 'https://www.walletconnect.com/',
  //       icons: ['https://walletconnect.com/walletconnect-logo.png'],
  //       redirect: Redirect(
  //         native: 'w3m://',
  //         universal: 'https://www.walletconnect.com',
  //       ),
  //     ),
  //   );

  //   await _w3mService.init();
  //   // Manually check the connection status if necessary
  //   bool isConnected = await _checkMetaMaskConnection();
  //   setState(() {
  //     isConnectedToMetaMask = isConnected;
  //   });
  // }

  // Future<bool> _checkMetaMaskConnection() async {
  //   // Replace with the actual method to check connection
  //   // This might be a call to a method provided by W3MService or a specific API
  //   try {
  //     bool connected = await _w3mService.isConnected;
  //     return connected;
  //   } catch (e) {
  //     print('Error checking MetaMask connection: $e');
  //     return false;
  //   }
  // }

  void _checkInput() {
    isButtonEnabled.value = DIDController.text.isNotEmpty;
  }

  @override
  void dispose() {
    DIDController.removeListener(_checkInput);
    DIDController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: Container(
              child: _controller!.value.isInitialized
                  ? Transform.scale(
                      scale: 1.8,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: VideoPlayer(_controller!)),
                    )
                  : const SizedBox(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
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
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        'zkpStorage',
                        style: TextStyle(
                            fontFamily: GoogleFonts.robotoMono().fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                      'Hack Proof Blockchain Based Secure Decentralised file storage with (ZKP) Zero-Knowledge Proof',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: GoogleFonts.robotoMono().fontFamily,
                          fontSize: 10,
                          color: Colors.white)),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // BlocBuilder(
                          //   bloc: _bloc,
                          //   builder: (BuildContext context, HomeState state) {
                          //     print('state print: $state');
                          //     // TextEditingController DIDController = state.identifier as TextEditingController;
                          //     return TextFormField(
                          //       controller: DIDController,
                          //       decoration: InputDecoration(
                          //         labelText: 'Paste your Polygon DID here',
                          //         labelStyle: TextStyle(
                          //             color: Colors.white.withOpacity(0.4),
                          //             fontFamily:
                          //                 GoogleFonts.robotoMono().fontFamily,
                          //             fontSize: 13),
                          //         border: OutlineInputBorder(
                          //           borderSide: BorderSide(
                          //             color: Colors.red.withOpacity(0.4),
                          //           ),
                          //         ),
                          //       ),
                          //       validator: (value) {
                          //         if (value!.isEmpty) {
                          //           return 'DID is required';
                          //         }
                          //         return null;
                          //       },
                          //     );
                          //   },
                          //   buildWhen: (_, currentState) =>
                          //       currentState is LoadedIdentifierHomeState,
                          // ),

                          // BlocBuilder(
                          //   bloc: _bloc,
                          //   builder: (BuildContext context, HomeState state) {
                          //     print('state.identifier: ${state.identifier}');

                          //     final TextEditingController identity = state.identifier != null
                          //         ? TextEditingController(text: state.identifier)
                          //         : TextEditingController();
                          //     // return Text(
                          //     //   state.identifier ??
                          //     //       CustomStrings
                          //     //           .homeIdentifierSectionPlaceHolder,
                          //     //   key: const Key('identifier'),
                          //     //   style: CustomTextStyles.descriptionTextStyle
                          //     //       .copyWith(
                          //     //           fontSize: 20,
                          //     //           fontWeight: FontWeight.w700),
                          //     // );
                          //     return TextFormField(
                          //       controller: identity,
                          //       enabled: false,
                          //       decoration: InputDecoration(
                          //         labelText: 'Paste your Polygon DID here',
                          //         labelStyle: TextStyle(
                          //             color: Colors.white.withOpacity(0.4),
                          //             fontFamily:
                          //                 GoogleFonts.robotoMono().fontFamily,
                          //             fontSize: 13),
                          //         border: OutlineInputBorder(
                          //           borderSide: BorderSide(
                          //             color: Colors.red.withOpacity(0.4),
                          //           ),
                          //         ),
                          //       ),
                          //       validator: (value) {
                          //         if (value!.isEmpty) {
                          //           return 'DID is required';
                          //         }
                          //         return null;
                          //       },
                          //     );
                          //   },
                          //   buildWhen: (_, currentState) =>
                          //       currentState is LoadedIdentifierHomeState,
                          // ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    // Navigator.of(context)
                                    //     .pushNamed('/storageLogin'),
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SetupPasswordScreen())),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  alignment: Alignment.bottomCenter,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: const GradientBoxBorder(
                                      gradient: LinearGradient(colors: [
                                        Color(0xFFa3d902),
                                        Color(0xFF2CFFAE)
                                      ]),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.home,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                             
                                   GestureDetector(
                                    onTap:() {
                                        context
                                            .read<RegisterBloc>()
                                            .add(SubmitSignup(
                                              did: '',
                                              first: "thathsarani",
                                              last: "trineesha",
                                              email: "trineesha@gmail.com",
                                            ));
                                        
                                      },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      alignment: Alignment.bottomCenter,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      decoration: BoxDecoration(
                                          color: 
                                              Theme.of(context).primaryColor
                                             ,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border:  const GradientBoxBorder(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFFa3d902),
                                                        Color(0xFF2CFFAE)
                                                      ]),
                                                  width: 2,
                                                )
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
                                                      .fontFamily),
                                        ),
                                      ),
                                    ),
                                  // )
                                // },
                              ),
                            ],
                          ),
                          // W3MConnectWalletButton(service: _w3mService),
                          // W3MAccountButton(service: _w3mService,)
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
    );
  }

  void _submit() async {
    print('submitting');
    //  await WalletController.to.addUser(
    //   "79179855485517959415279473341851584883681887175169008946781267938371369",
    //   DIDController.text,
    //   "88871286709793914884405575185504262374183498556034135874130629985717964",
    //   "0xD1F56B3efC77b00E1c0b31F77Ae42212D8babc9A"

    // );

    final did = DIDController.text;

    // await storage.write(key: 'userDID', value: did);
    // final response = await WalletController.to.signUp(
    //   did,
    //   "trineesha@gmail.com",
    //   "trineesha",
    //   "thathsarani",
    // );

    // print('response: $response');

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Registerqr(response: response),
    //   ),
    // );
  }
}
