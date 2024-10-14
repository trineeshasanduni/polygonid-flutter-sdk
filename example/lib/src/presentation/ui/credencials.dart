import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claims.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/dashboard/dashboard.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/widgets/claim.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/qrcode_scanner/widgets/qrcode_scanner.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_button_style.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/image_resource.dart';

class Credencials extends StatefulWidget {
    final ClaimsBloc _bloc;

   Credencials({Key? key, })
  : _bloc = getIt<ClaimsBloc>(),
        super(key: key);

  @override
  State<Credencials> createState() => _CredencialsState();
}

class _CredencialsState extends State<Credencials> {
  // final List<Map<String, dynamic>> categories = [
  //   {
  //     'name': 'User Authentication',
  //     'icon': Icons.verified_user,
  //     'onTap': ClaimsScreen()
  //   },
  //   {
  //     'name': 'File Credentials',
  //     'icon': Icons.file_present,
  //     'onTap': ClaimsScreen()
  //   },
  //   {'name': 'File', 'icon': Icons.school, 'onTap': ClaimsScreen()},
  //   {'name': 'File', 'icon': Icons.sports_soccer, 'onTap': ClaimsScreen()},
  //   {'name': 'File', 'icon': Icons.movie, 'onTap': ClaimsScreen()},
  //   {'name': 'File', 'icon': Icons.business, 'onTap': ClaimsScreen()},
  // ];
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'User Authentications',
      'subtitle': 'Issuer claims.',
      'image': 'assets/images/bg.png',
      'category': 'User Authentication' // Added category key
    },
    {
      'title': 'File Credentials',
      'subtitle': 'Issuer claims.',
      'image': 'assets/images/bg.png',
      'category': 'File Credentials' // Added category key
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          // Pass the selected category to ClaimsScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClaimsScreen(category: item['category']!),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            _buildBackgroundImage(item['image']!),
                            _buildTextOverlay(item['title']!, item['subtitle']!),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildBottomBar(),
              _buildBlocListener(),
            ],
          ),
        ),
      
    );
  }

  Widget _buildHeader() {
    return ListTile(
      title: Row(
        children: [
          Image.asset('assets/images/launcher_icon.png', width: 30, height: 30),
          RichText(
            text: TextSpan(
              text: 'zkp',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 20,
                fontFamily: GoogleFonts.robotoMono().fontFamily,
                fontWeight: FontWeight.w300,
              ),
              children: [
                TextSpan(
                  text: 'STORAGE',
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 20,
                    fontFamily: GoogleFonts.robotoMono().fontFamily,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 1),
        ),
        child: GestureDetector(
          onTap: () {
            // _showWelcomeDialog();
            // _refreshApp();
          },
          child: Icon(
            Icons.wallet,
            color: Theme.of(context).secondaryHeaderColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(String imagePath) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTextOverlay(String title, String subtitle) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // _buildRemoveAllClaimsButton(),
          _buildClaimsConnectButton(),
        ],
      ),
    );
  }

  Widget _buildClaimsConnectButton() {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder(
          bloc: widget._bloc,
          builder: (BuildContext context, ClaimsState state) {
            bool loading = state is LoadingDataClaimsState;
            return ElevatedButton(
              onPressed: () {
                if (!loading) {
                  widget._bloc.add(const ClaimsEvent.clickScanQrCode());
                }
              },
              style: CustomButtonStyle.primaryButtonStyle,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 120,
                  maxWidth: 120,
                  maxHeight: 20,
                ),
                child: Center(
                  child: loading
                      ? _buildCircularProgress()
                      :  Text(
                          CustomStrings.authButtonCTA,
                          // style: CustomTextStyles.primaryButtonTextStyle,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                ),
              ),
            );
          }),
    );
  }
  Widget _buildBlocListener() {
    return BlocListener<ClaimsBloc, ClaimsState>(
      bloc: widget._bloc,
      listener: (context, state) {
        print('state1: $state');
        
        if (state is NavigateToQrCodeScannerClaimsState) {
          print('navigate to qr code scanner : $state');
          _handleNavigateToQrCodeScannerClaimsState();
        }
        if (state is QrCodeScannedClaimsState) {
          print('state.iden3message: ${state.iden3message}');
          _handleQrCodeScanned(state.iden3message);
        }
        // if (state is NavigateToClaimDetailClaimState) {
        //   _handleNavigationToClaimDetail(state.claimModel);
        // }
      },
      child: const SizedBox.shrink(),
    );
  }

   Future<void> _handleNavigateToQrCodeScannerClaimsState() async {
    String? qrCodeScanningResult =
        // await Navigator.pushNamed(context, Routes.qrCodeScannerPath) as String?;
        await Navigator.push(context, MaterialPageRoute(builder: (context) => const QRCodeScannerPage())) ;
    widget._bloc.add(ClaimsEvent.onScanQrCodeResponse(qrCodeScanningResult));
    print('qrCodeScanningResult: $qrCodeScanningResult');
  }

   void _handleQrCodeScanned(Iden3MessageEntity iden3message) {
    print('iden3message23: $iden3message');
    widget._bloc
        .add(ClaimsEvent.fetchAndSaveClaims(iden3message: iden3message));
  }

  Widget _buildCircularProgress() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: CustomColors.primaryButton,
      ),
    );
  }
}
