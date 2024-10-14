import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_constants.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/chain_config_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/filter_entity.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/credential/domain/exceptions/credential_exceptions.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/share_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/verify_share_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/usecases/file_usecase.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/credential/request/offer_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/mappers/claim_model_mapper.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/models/claim_model.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/nonce_utils.dart';
import 'package:polygonid_flutter_sdk_example/utils/qr_code_parser_utils.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  final ShareUsecase shareUsecase;
  final ShareVerifyUsecase shareVerifyUsecase;
  final QrcodeParserUtils _qrcodeParserUtils;
  final PolygonIdSdk _polygonIdSdk;
   final ClaimModelMapper _mapper;

  ShareBloc(this.shareUsecase, this.shareVerifyUsecase, this._qrcodeParserUtils,this._polygonIdSdk,this._mapper)
      : super(ShareInitial()) {
    on<onClickShare>(_handleShare);
    on<ShareVerifyEvent>(_handleShareVerifyClick);
    on<onShareVerifyResponse>(_handleShareVerifyUpload);
    on<fetchAndSaveShareVerifyClaims>(_fetchAndSaveClaims);
    on<getShareVerifyClaims>(_getUploadVerifyClaims);

    on<ResetShareStateEvent>((event, emit) {
      emit(ShareInitial()); // Reset state to initial
    });
  }

  Future<void> _handleShare(
      onClickShare event, Emitter<ShareState> emit) async {
    emit(Sharing());
    final failureOrShare = await shareUsecase(ShareUrlParams(
        BatchHash: event.batch_hash,
        FileHash: event.file_hash,
        OwnerDid: event.OwnerDid,
        FileName: event.FileName,
        ShareDid: event.ShareDid,
        Owner: event.Owner));
    failureOrShare.fold((failure) => emit(ShareFailed(failure.toString())),
        (Share) => emit(Shared(Share)));
  }

  Future<void> _handleShareVerifyClick(
      ShareVerifyEvent event, Emitter<ShareState> emit) async {
    emit(ShareVerifying(event.BatchHash));
    final failureOrVerify = await shareVerifyUsecase(ShareVerifyParam(
        BatchHash: event.BatchHash,
        FileHash: event.FileHash,
        Did: event.Did,
        OwnerAddress: event.OwnerAddress));

    failureOrVerify.fold(
        (failure) => emit(ShareVerifyFailed(failure.toString())),
        (response) => emit(ShareVerifySuccess(response, event.BatchHash)));
  }

  Future<void> _handleShareVerifyUpload(
      onShareVerifyResponse event, Emitter<ShareState> emit) async {
    String? qrCodeResponse = event.verifyResponse;
    String? batchHash = event.batchHash;
    print('qrCodeResponse3: $qrCodeResponse');
    if (qrCodeResponse == null || qrCodeResponse.isEmpty) {
      emit(ShareVerifyFailed("Scanned code is not valid"));
    }

    try {
      final Iden3MessageEntity iden3message =
          await _qrcodeParserUtils.getIden3MessageFromQrCode(qrCodeResponse!);
      print('iden3message res3: $iden3message');
      emit(ShareVerifyResponseloaded(iden3message, event.batchHash!));
      print('state234: ${state}');
      print('get fetch3 ');
    } catch (error) {
      emit(ShareVerifyFailed("Scanned code is not valid"));
    }
  }

  Future<void> _fetchAndSaveClaims(
      fetchAndSaveShareVerifyClaims event, Emitter<ShareState> emit) async {
    String? privateKey =
        await SecureStorage.read(key: SecureStorageKeys.privateKey);

        String batchHash = event.batchHash!;
    print('privateKey1: $privateKey');
    if (privateKey == null) {
      emit(ShareVerifyFailed("Private key not found"));
      return;
    }
    print('print failure');

    ChainConfigEntity chainConfig = await _polygonIdSdk.getSelectedChain();

    String didIdentifier = await _polygonIdSdk.identity.getDidIdentifier(
        privateKey: privateKey,
        blockchain: chainConfig.blockchain,
        network: chainConfig.network);

    print('didIdentifier: $didIdentifier');

    emit(ShareVerifying(batchHash));

    Iden3MessageEntity iden3message = event.iden3message;
    print('iden3message fetch: $iden3message');
    if (event.iden3message.messageType != Iden3MessageType.credentialOffer) {
      emit(ShareVerifyFailed("Read message is not of type offer"));
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
        add(getShareVerifyClaims(batchHash));
        // add(event)
      }
    } catch (exception) {
      emit(ShareVerifyFailed(CustomStrings.iden3messageGenericError));
    }
  }

  Future<void> _getUploadVerifyClaims(getShareVerifyClaims event, Emitter<ShareState> emit) async {
String batchHash = event.batchHash!;
    emit(ShareVerifying(batchHash));

    List<FilterEntity>? filters = event.filters;

    String? privateKey =
        await SecureStorage.read(key: SecureStorageKeys.privateKey);

    if (privateKey == null) {
      emit(ShareVerifyFailed("Private key not found"));
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
      emit(ShareVerifyFailed(
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
      emit(ShareVerifiedClaims(claimModelList,batchHash));
      print('loadedClaims: ${claimModelList}');
    } on GetClaimsException catch (_) {
      emit(ShareVerifyFailed("error while retrieving claims"));
    } catch (_) {
      emit(ShareVerifyFailed("generic error"));
    }
  }
}
