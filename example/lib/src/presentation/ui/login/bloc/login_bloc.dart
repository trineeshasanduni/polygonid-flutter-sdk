import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_constants.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/chain_config_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/error_exception.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/exceptions/iden3comm_exceptions.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/login/data/model/login_status_model.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/entities/login_status_entity.dart';
import 'package:polygonid_flutter_sdk/login/domain/usecases/login_usecase.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/profile_radio_button.dart';
import 'package:polygonid_flutter_sdk_example/utils/nonce_utils.dart';
import 'package:polygonid_flutter_sdk_example/utils/qr_code_parser_utils.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginDoneUsecase loginDone;
  final QrcodeParserUtils _qrcodeParserUtils;
  final PolygonIdSdk _polygonIdSdk;
  final LoginStatusUsecase statusUsecase;

  static const SelectedProfile _defaultProfile = SelectedProfile.public;
  SelectedProfile selectedProfile = _defaultProfile;

  LoginBloc(this.loginDone, this._qrcodeParserUtils, this._polygonIdSdk,
      this.statusUsecase)
      : super(LoginInitial()) {
    on<LoginWithCredentials>((event, emit) async {
      emit(LoginLoading('Starting login'));
      final failureOrLogins = await loginDone();
      failureOrLogins.fold((failure) => emit(LoginFailure(failure.toString())),
          (login) => emit(LoginSuccess(login)));
    });

    on<clickScanQrCode>(_handleClickScanQrCode);
    on<onLoginResponse>(_handleScanQrCodeResponse);
    on<onGetStatusEvent>(_handleLoginStatus);
  }

  ///
  void _handleClickScanQrCode(clickScanQrCode event, Emitter<LoginState> emit) {
    emit(const navigateToQrCodeScanner());
  }

  ///
  Future<void> _handleLoginStatus(onGetStatusEvent event, Emitter<LoginState> emit) async {
  emit(LoginLoading('Authenticating'));

  final status = await statusUsecase(UseCaseParams(sessionId: event.sessionId));

  status.fold(
    (failure) {
      emit(LoginFailure(failure.toString()));
    },
    
    (did) {
      emit(StatusLoaded(did));
    },
  );
}


  

  Future<void> _handleScanQrCodeResponse(
      onLoginResponse event, Emitter<LoginState> emit) async {
    String? LoginResponse = event.response;
    if (LoginResponse == null || LoginResponse.isEmpty) {
      emit(LoginFailure("no qr code scanned"));
      return;
    }

    try {
      final Iden3MessageEntity iden3message =
          await _qrcodeParserUtils.getIden3MessageFromQrCode(LoginResponse);
      emit(loaded(iden3message));

      String? privateKey =
          await SecureStorage.read(key: SecureStorageKeys.privateKey);


      if (privateKey == null) {
        emit(LoginFailure("no private key found"));
        return;
      }

      await _authenticate(
        iden3message: iden3message,
        privateKey: privateKey,
        emit: emit,
      );
    } catch (error) {
      emit(LoginFailure("Scanned code is not valid"));
    }
  }

  Future<void> _authenticate({
    required Iden3MessageEntity iden3message,
    required String privateKey,
    required Emitter<LoginState> emit,
  }) async {
    emit(LoginLoading('Authenticating user '));

    final ChainConfigEntity currentChain =
        await _polygonIdSdk.getSelectedChain();
    final EnvEntity envEntity = await _polygonIdSdk.getEnv();

    String? did = await _polygonIdSdk.identity.getDidIdentifier(
      privateKey: privateKey,
      blockchain: currentChain.blockchain,
      network: currentChain.network,
      method: currentChain.method,
    );

    IdentityEntity identityEntity = await _polygonIdSdk.identity.getIdentity(
      genesisDid: did,
      privateKey: privateKey,
    );

    try {
    
      final BigInt nonce = selectedProfile == SelectedProfile.public
          ? GENESIS_PROFILE_NONCE
          : await NonceUtils(getIt()).getPrivateProfileNonce(
              did: did, privateKey: privateKey, from: iden3message.from);
     

      await _polygonIdSdk.iden3comm.authenticateV2(
        message: iden3message,
        genesisDid: did,
        privateKey: privateKey,
        profileNonce: nonce,
        identityEntity: identityEntity,
        env: envEntity,
      );


      emit(const authenticated());
    } on OperatorException catch (error) {
      emit(LoginFailure(error.errorMessage));
    } on PolygonIdSDKException catch (error) {

      emit(LoginFailure(error.errorMessage));
    } catch (error) {

      emit(LoginFailure(error.toString()));
    }
  }
}
