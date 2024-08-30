import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/models/claim_model.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/widgets/claim_card.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/bloc/register_bloc.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';

class Claim extends StatefulWidget {
  final RegisterBloc _registerBloc;
   Claim({super.key}) : _registerBloc = getIt<RegisterBloc>();

  @override
  State<Claim> createState() => _ClaimState();
}

class _ClaimState extends State<Claim> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget._registerBloc,
      builder: (BuildContext context, RegisterState state) {
        if (state is loadedClaims) {
          List<ClaimModel> claimList = state.claimList;
          print('claimList11: $claimList');
          List<Widget> claimWidgetList = _buildClaimCardWidgetList(claimList);
          return claimList.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: claimWidgetList,
                )
              : const Center(
                  child: Text(CustomStrings.claimsListNoResult),
                );
        }
        return const SizedBox.shrink();
      },
      buildWhen: (_, RegisterState currentState) {
        bool rebuild = currentState is loadedClaims;
        return rebuild;
      },
    );
  }
   List<Widget> _buildClaimCardWidgetList(List<ClaimModel> claimList) {
    return claimList
        .map(
          (claimModelItem) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: InkWell(
              onTap: () {
                widget._registerBloc.add(onClickClaim(claimModelItem));
              },
              child: ClaimCard(claimModel: claimModelItem),
            ),
          ),
        )
        .toList();
  }
}