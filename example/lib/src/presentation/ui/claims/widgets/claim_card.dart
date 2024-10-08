import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/models/claim_model.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_colors.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_dimensions.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_text_styles.dart';
import 'package:polygonid_flutter_sdk_example/utils/image_resource.dart';

class ClaimCard extends StatelessWidget {
  final ClaimModel claimModel;

  const ClaimCard({Key? key, required this.claimModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.width *
        CustomDimensions.claimCardHeightRatio;
    return SizedBox(
      height: cardHeight,
      child: Stack(
        children: [
          _buildBackground(),
          _buildContent(context),
        ],
      ),
    );
  }

  ///
  Widget _buildBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: const BoxDecoration(
          gradient: CustomColors.claimCardBackground,
        ),
        width: double.infinity,
        height: double.infinity,
        child: SvgPicture.asset(
          ImageResources.claimBackground,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  ///
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      claimModel.name,
                      style:  TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20,
                        fontFamily: GoogleFonts.robotoMono().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              //const Spacer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CustomStrings.claimCardIssuerLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).primaryColor,fontFamily: GoogleFonts.robotoMono().fontFamily,),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      claimModel.issuer,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontFamily: GoogleFonts.robotoMono().fontFamily,
                        fontSize: 12
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
