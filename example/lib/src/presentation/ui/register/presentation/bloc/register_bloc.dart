import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_constants.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/chain_config_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/filter_entity.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/credential/domain/exceptions/credential_exceptions.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/credential/request/offer_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/callback_response_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/register_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/registerQr_entity.dart';
import 'package:polygonid_flutter_sdk/registers/domain/usecases/register_usecase.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/mappers/claim_model_mapper.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/models/claim_model.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/nonce_utils.dart';
import 'package:polygonid_flutter_sdk_example/utils/qr_code_parser_utils.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;
  final CallbackUsecase callbackUsecase;
  final QrcodeParserUtils qrcodeParserUtils;
  final PolygonIdSdk _polygonIdSdk;
  final ClaimModelMapper _mapper;

  RegisterBloc(this.registerUsecase, this.callbackUsecase,
      this.qrcodeParserUtils, this._polygonIdSdk, this._mapper)
      : super(RegisterInitial()) {
    on<SubmitSignup>((event, emit) async {
      emit(RegisterLoading());
      print('registering');
      final res = await registerUsecase(UseCaseParams(
          did: event.did,
          first: event.first,
          last: event.last,
          email: event.email));
      print('res: ${res.fold}');
      return res.fold((failure) => emit(RegisterFailure(failure.message)),
          (register) => emit(RegisterSuccess(register)));
    });
///scan//////
    on<onGetRegisterResponse>(_handleRegisterResponse);
    on<fetchAndSaveClaims>(_fetchAndSaveClaims);
    on<getClaims>(_getClaims);
  ///callback/////
    on<onGetQrResponse>(_handleQrResponse);
    on<fetchAndSaveQrClaims>(_fetchAndSaveQrClaims);
    on<getQrClaims>(_getQrClaims);
    
    on<clickScanQrCode>(_handleClickScanQrCode);
    on<OnScanQrCodeResponse>(_handleScanQrCodeResponse);
    on<getCallbackUrl>(_handleCallbackUrl);
  }

  void _handleClickScanQrCode(
      clickScanQrCode event, Emitter<RegisterState> emit) {
        print('fetching qr code');
    emit(NavigateToQrCodeScanner());
  }

  

  Future<void> _handleScanQrCodeResponse(
  OnScanQrCodeResponse event, 
  Emitter<RegisterState> emit
) async {
  String? qrCodeResponse = event.response;
  print('qrCodeResponse: $qrCodeResponse');
  
  if (qrCodeResponse == null || qrCodeResponse.isEmpty) {
    emit(RegisterFailure("No QR code scanned"));
    return;
  }

  try {
    print('Attempting to parse QR code response');
    
    // Parse the QR code response from JSON string
    final Map<String, dynamic> parsedJson = jsonDecode(qrCodeResponse);
    
    // Create RegisterQREntity from the parsed JSON
    final RegisterQrEntity registerQREntity = RegisterQrEntity.fromJson(parsedJson);
    
    print('registerQREntity result: $registerQREntity');
    emit(QrCodeScanned(registerQREntity));
  } catch (error) {
    emit(RegisterFailure("Scanned code is not valid"));
  }
}


  Future<void> _handleCallbackUrl(
      getCallbackUrl event, Emitter<RegisterState> emit) async {
    emit(RegisterQrLoading());

    print('callbackUrl get: ${event.url}');
    print('did get: ${event.did}');

    final callbackUrl =
        await callbackUsecase(CallbackParams(callbackUrl: event.url, did:event.did ));
    print('callbackUrl get1: ${callbackUrl}');

    callbackUrl.fold(
      (failure) {
        print('callbackUrl get2: $failure');
        emit(RegisterFailure(failure.toString()));
      },
      (callbackUrlRes) {
        print('Emitting StatusLoaded with DID: $callbackUrlRes');
        emit(CallbackLoaded(callbackUrlRes));
      },
    );
  }

  Future<void> _handleQrResponse(
      onGetQrResponse event, Emitter<RegisterState> emit) async {
    String? qrCodeResponse = event.response;
    print('qrCodeResponse1: $qrCodeResponse');
    if (qrCodeResponse == null || qrCodeResponse.isEmpty) {
      emit(RegisterFailure("Scanned code is not valid"));
    }

    try {
      final Iden3MessageEntity iden3message =
          await qrcodeParserUtils.getIden3MessageFromQrCode(qrCodeResponse!);
      print('iden3message res1: $iden3message');
      emit(Registered(iden3message));
      print('state23: ${state}');
      print('get fetch1 ');
    } catch (error) {
      emit(RegisterFailure("Scanned code is not valid"));
    }
  }

  Future<void> _fetchAndSaveQrClaims(
      fetchAndSaveQrClaims event, Emitter<RegisterState> emit) async {
    String? privateKey =
        await SecureStorage.read(key: SecureStorageKeys.privateKey);
    print('privateKey1: $privateKey');
    if (privateKey == null) {
      emit(RegisterFailure("Private key not found"));
      return;
    }

    ChainConfigEntity chainConfig = await _polygonIdSdk.getSelectedChain();

    String didIdentifier = await _polygonIdSdk.identity.getDidIdentifier(
        privateKey: privateKey,
        blockchain: chainConfig.blockchain,
        network: chainConfig.network);

    print('didIdentifier: $didIdentifier');

    emit(RegisterQrLoading());

    Iden3MessageEntity iden3message = event.iden3message;
    print('iden3message fetch: $iden3message');
    if (event.iden3message.messageType != Iden3MessageType.credentialOffer) {
      emit(RegisterFailure("Read message is not of type offer"));
      return;
    }

    BigInt nonce = await NonceUtils(_polygonIdSdk).lookupNonce(
            did: didIdentifier,
            privateKey: privateKey,
            from: iden3message.from) ??
        GENESIS_PROFILE_NONCE;

    try {
      List<ClaimEntity> claimList =
          await _polygonIdSdk.iden3comm.fetchAndSaveClaims(
        message: event.iden3message as OfferIden3MessageEntity,
        genesisDid: didIdentifier,
        profileNonce: nonce,
        privateKey: privateKey,
      );

      print('claimList: ${claimList}.');

      if (claimList.isNotEmpty) {
        add(getQrClaims());
        // add(event)
      }
    } catch (exception) {
      emit(RegisterFailure(CustomStrings.iden3messageGenericError));
    }
  }

  Future<void> _getQrClaims(getQrClaims event, Emitter<RegisterState> emit) async {
    emit(RegisterQrLoading());

    List<FilterEntity>? filters = event.filters;

    String? privateKey =
        await SecureStorage.read(key: SecureStorageKeys.privateKey);

    if (privateKey == null) {
      emit(RegisterFailure("Private key not found"));
      return;
    }

    ChainConfigEntity chainConfig = await _polygonIdSdk.getSelectedChain();

    String did = await _polygonIdSdk.identity.getDidIdentifier(
      privateKey: privateKey,
      blockchain: chainConfig.blockchain,
      network: chainConfig.network,
      method: chainConfig.method,
    );

    if (did.isEmpty) {
      emit(RegisterFailure(
          "without an identity is impossible to remove credential"));
      return;
    }

    try {
      List<ClaimEntity> claimList = await _polygonIdSdk.credential.getClaims(
        filters: filters,
        genesisDid: did,
        privateKey: privateKey,
      );

      List<ClaimModel> claimModelList =
          claimList.map((claimEntity) => _mapper.mapFrom(claimEntity)).toList();
      emit(loadedQrClaims(claimModelList));
      print('loadedClaims: ${claimModelList}');
    } on GetClaimsException catch (_) {
      emit(RegisterFailure("error while retrieving claims"));
    } catch (_) {
      emit(RegisterFailure("generic error"));
    }
  }

   Future<void> _handleRegisterResponse(
      onGetRegisterResponse event, Emitter<RegisterState> emit) async {
    String? qrCodeResponse = event.response;
    print('qrCodeResponse1: $qrCodeResponse');
    if (qrCodeResponse == null || qrCodeResponse.isEmpty) {
      emit(RegisterFailure("Scanned code is not valid"));
    }

    try {
      final Iden3MessageEntity iden3message =
          await qrcodeParserUtils.getIden3MessageFromQrCode(qrCodeResponse!);
      print('iden3message res1: $iden3message');
      emit(Registered(iden3message));
      print('state23: ${state}');
      print('get fetch1 ');
    } catch (error) {
      emit(RegisterFailure("Scanned code is not valid"));
    }
  }

  Future<void> _fetchAndSaveClaims(
      fetchAndSaveClaims event, Emitter<RegisterState> emit) async {
    String? privateKey =
        await SecureStorage.read(key: SecureStorageKeys.privateKey);
    print('privateKey1: $privateKey');
    if (privateKey == null) {
      emit(RegisterFailure("Private key not found"));
      return;
    }

    ChainConfigEntity chainConfig = await _polygonIdSdk.getSelectedChain();

    String didIdentifier = await _polygonIdSdk.identity.getDidIdentifier(
        privateKey: privateKey,
        blockchain: chainConfig.blockchain,
        network: chainConfig.network);

    print('didIdentifier: $didIdentifier');

    emit(RegisterLoading());

    Iden3MessageEntity iden3message = event.iden3message;
    print('iden3message fetch: $iden3message');
    if (event.iden3message.messageType != Iden3MessageType.credentialOffer) {
      emit(RegisterFailure("Read message is not of type offer"));
      return;
    }

    BigInt nonce = await NonceUtils(_polygonIdSdk).lookupNonce(
            did: didIdentifier,
            privateKey: privateKey,
            from: iden3message.from) ??
        GENESIS_PROFILE_NONCE;

    try {
      List<ClaimEntity> claimList =
          await _polygonIdSdk.iden3comm.fetchAndSaveClaims(
        message: event.iden3message as OfferIden3MessageEntity,
        genesisDid: didIdentifier,
        profileNonce: nonce,
        privateKey: privateKey,
      );

      print('claimList: ${claimList}.');

      if (claimList.isNotEmpty) {
        add(getClaims());
        // add(event)
      }
    } catch (exception) {
      emit(RegisterFailure(CustomStrings.iden3messageGenericError));
    }
  }

  Future<void> _getClaims(getClaims event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());

    List<FilterEntity>? filters = event.filters;

    String? privateKey =
        await SecureStorage.read(key: SecureStorageKeys.privateKey);

    if (privateKey == null) {
      emit(RegisterFailure("Private key not found"));
      return;
    }

    ChainConfigEntity chainConfig = await _polygonIdSdk.getSelectedChain();

    String did = await _polygonIdSdk.identity.getDidIdentifier(
      privateKey: privateKey,
      blockchain: chainConfig.blockchain,
      network: chainConfig.network,
      method: chainConfig.method,
    );

    if (did.isEmpty) {
      emit(RegisterFailure(
          "without an identity is impossible to remove credential"));
      return;
    }

    try {
      List<ClaimEntity> claimList = await _polygonIdSdk.credential.getClaims(
        filters: filters,
        genesisDid: did,
        privateKey: privateKey,
      );

      List<ClaimModel> claimModelList =
          claimList.map((claimEntity) => _mapper.mapFrom(claimEntity)).toList();
      emit(loadedClaims(claimModelList));
      print('loadedClaims: ${claimModelList}');
    } on GetClaimsException catch (_) {
      emit(RegisterFailure("error while retrieving claims"));
    } catch (_) {
      emit(RegisterFailure("generic error"));
    }
  }
}
