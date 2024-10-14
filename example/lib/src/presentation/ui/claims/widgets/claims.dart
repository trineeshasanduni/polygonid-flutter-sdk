import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/navigations/routes.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claim_detail/widgets/claim_detail.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_event.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_state.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/models/claim_model.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claim_card.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/qrcode_scanner/widgets/qrcode_scanner.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/bloc/register_bloc.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_button_style.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';

class ClaimsScreen extends StatefulWidget {
  final ClaimsBloc _bloc;
  final String category;
  

  ClaimsScreen({Key? key,  required this.category})
      : _bloc = getIt<ClaimsBloc>(),
        super(key: key);

  @override
  State<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends State<ClaimsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget._bloc.add(const ClaimsEvent.getClaims());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  ///
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      
      iconTheme: const IconThemeData(color: Colors.white),

    );
  }

  ///
  Widget _buildBody() {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildTitle(),
                    const SizedBox(height: 6),
                    _buildDescription(),
                    const SizedBox(height: 6),
                    _buildError(),
                    const SizedBox(height: 24),
                    _buildClaimList(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildBottomBar(),
            _buildBlocListener(),
          ],
        ),
      ),
    );
  }

  ///
  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        CustomStrings.claimsTitle,
        style: TextStyle(color: Theme.of(context).secondaryHeaderColor,fontFamily: GoogleFonts.robotoMono().fontFamily,fontSize: 20,
    height: 1.8,
    fontWeight: FontWeight.w500 ),
        // style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 20),
      ),
    );
  }

  ///
  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        CustomStrings.claimsDescription,
        textAlign: TextAlign.start,
        style: CustomTextStyles.descriptionTextStyle,
      ),
    );
  }

  ///
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

  

  ///
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

  ///
  Widget _buildRemoveAllClaimsButton() {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder(
          bloc: widget._bloc,
          builder: (BuildContext context, ClaimsState state) {
            bool loading = state is LoadingDataClaimsState;
            return ElevatedButton(
              onPressed: () {
                if (!loading) {
                  widget._bloc.add(const ClaimsEvent.removeAllClaims());
                }
              },
              style: CustomButtonStyle.outlinedPrimaryButtonStyle,
              // style:  ,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 120,
                  maxWidth: 120,
                  maxHeight: 20,
                ),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      CustomStrings.deleteAllClaimsButtonCTA,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  ///
  // Widget _buildClaimList() {
  //   return BlocBuilder(
  //     bloc: widget._bloc,
  //     builder: (BuildContext context, ClaimsState state) {
  //       if (state is LoadedDataClaimsState) {
  //         List<ClaimModel> claimList = state.claimList;
  //         List<Widget> claimWidgetList = _buildClaimCardWidgetList(claimList);
  //         return claimList.isNotEmpty
  //             ? Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: claimWidgetList,
  //               )
  //             :  Center(
  //                 child: Text(CustomStrings.claimsListNoResult,style: TextStyle(color: Theme.of(context).secondaryHeaderColor),),
  //               );
  //       }
  //       return const SizedBox.shrink();
  //     },
  //     buildWhen: (_, ClaimsState currentState) {
  //       bool rebuild = currentState is LoadedDataClaimsState;
  //       return rebuild;
  //     },
  //   );
  // }

  Widget _buildClaimList() {
  return BlocBuilder(
    bloc: widget._bloc,
    builder: (BuildContext context, ClaimsState state) {
      if (state is LoadedDataClaimsState) {
         List<ClaimModel> filteredClaims = state.claimList.where((claim) {
              // Adjust the filtering logic based on your claim model
              return claim.name == widget.category; // Assuming 'category' exists in ClaimModel
            }).toList();

        // Group the claims by their name field
        Map<String, List<ClaimModel>> categorizedClaims = {};
        for (var claim in filteredClaims) {
          if (!categorizedClaims.containsKey(claim.name)) {
            categorizedClaims[claim.name] = [];
          }
          categorizedClaims[claim.name]?.add(claim);
        }

        return categorizedClaims.isNotEmpty
            ? Column(
                children: categorizedClaims.entries.map((entry) {
                  String categoryName = entry.key;
                  List<ClaimModel> claimsInCategory = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryHeader(categoryName),
                      Column(
                        children: _buildClaimCardWidgetList(claimsInCategory),
                      ),
                      const SizedBox(height: 24), // Add some spacing between categories
                    ],
                  );
                }).toList(),
              )
            : Center(
                child: Text(
                  CustomStrings.claimsListNoResult,
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                ),
              );
      }
      return const SizedBox.shrink();
    },
    buildWhen: (_, ClaimsState currentState) {
      return currentState is LoadedDataClaimsState;
    },
  );
}


  Widget _buildCategoryHeader(String categoryName) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    child: Text(
      categoryName,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).secondaryHeaderColor,
      ),
    ),
  );
}


  ///
  // List<Widget> _buildClaimCardWidgetList(List<ClaimModel> claimList) {
  //   return claimList
  //       .map(
  //         (claimModelItem) => Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //           child: InkWell(
  //             onTap: () {
  //               widget._bloc.add(ClaimsEvent.onClickClaim(claimModelItem));
  //             },
  //             child: ClaimCard(claimModel: claimModelItem),
  //           ),
  //         ),
  //       )
  //       .toList();
  // }

  List<Widget> _buildClaimCardWidgetList(List<ClaimModel> claimList) {
  return claimList.map((claimModelItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: InkWell(
        onTap: () {
          widget._bloc.add(ClaimsEvent.onClickClaim(claimModelItem));
        },
        child: ClaimCard(claimModel: claimModelItem),
      ),
    );
  }).toList();
}


  ///
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
        if (state is NavigateToClaimDetailClaimState) {
          _handleNavigationToClaimDetail(state.claimModel);
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  ///
  Future<void> _handleNavigateToQrCodeScannerClaimsState() async {
    String? qrCodeScanningResult =
        // await Navigator.pushNamed(context, Routes.qrCodeScannerPath) as String?;
        await Navigator.push(context, MaterialPageRoute(builder: (context) => const QRCodeScannerPage())) ;
    widget._bloc.add(ClaimsEvent.onScanQrCodeResponse(qrCodeScanningResult));
    print('qrCodeScanningResult: $qrCodeScanningResult');
  }

  // Future<void> _handleNavigateToQrCodeScannerClaimsState() async {
  //   String? qrCodeScanningResult =
  //       await Navigator.pushNamed(context, Routes.registerPath) as String?;
  //   widget._bloc.add(ClaimsEvent.onScanQrCodeResponse(qrCodeScanningResult));
  //   print('qrCodeScanningResult: $qrCodeScanningResult');
  // }

  ///
  void _handleQrCodeScanned(Iden3MessageEntity iden3message) {
    print('iden3message23: $iden3message');
    widget._bloc
        .add(ClaimsEvent.fetchAndSaveClaims(iden3message: iden3message));
  }

  ///
  Future<void> _handleNavigationToClaimDetail(ClaimModel claimModel) async {
    // bool? deleted = await Navigator.pushNamed(
    //   context,
    //   Routes.claimDetailPath,
    //   arguments: claimModel,
    // ) as bool?;
    bool? deleted = await Navigator.push(context, MaterialPageRoute(builder: (context) => ClaimDetailScreen(claimModel: claimModel,))) as bool?;

    widget._bloc.add(ClaimsEvent.onClaimDetailRemoveResponse(deleted));
  }

  ///
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

  ///
  Widget _buildError() {
    return BlocBuilder(
      bloc: widget._bloc,
      builder: (BuildContext context, ClaimsState state) {
        if (state is ErrorClaimsState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              state.message,
              textAlign: TextAlign.start,
              style: CustomTextStyles.descriptionTextStyle
                  .copyWith(color: CustomColors.redError),
            ),
          );
        }
        return const Text("");
      },
    );
  }
}
