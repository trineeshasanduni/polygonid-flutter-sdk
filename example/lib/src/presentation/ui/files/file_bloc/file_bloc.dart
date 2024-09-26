import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_constants.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/chain_config_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/filter_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/error_exception.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';
import 'package:polygonid_flutter_sdk/credential/domain/exceptions/credential_exceptions.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/downloadVerify_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/fileName_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/verify_upload_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/usecases/file_usecase.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/credential/request/offer_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/exceptions/iden3comm_exceptions.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/mappers/claim_model_mapper.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/models/claim_model.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/profile_radio_button.dart';
import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
import 'package:polygonid_flutter_sdk_example/utils/nonce_utils.dart';
import 'package:polygonid_flutter_sdk_example/utils/qr_code_parser_utils.dart';
import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final FileUsecase fileUsecase;
  final UseSpaceUsecase useSpaceUsecase;
  final FileNameUsecase getFileNameUsecase;
  final VerifyUploadUsecase verifyUploadUsecase;
  final QrcodeParserUtils _qrcodeParserUtils;
  final PolygonIdSdk _polygonIdSdk;
   final ClaimModelMapper _mapper;


  static const SelectedProfile _defaultProfile = SelectedProfile.public;
  SelectedProfile selectedProfile = _defaultProfile;

  FileBloc(this.fileUsecase, this.useSpaceUsecase, this.getFileNameUsecase,
      this._polygonIdSdk, this._qrcodeParserUtils, this.verifyUploadUsecase,this._mapper)
      : super(FileInitial()) {
    on<FileuploadEvent>(_handleFileUpload);
    on<UseSpaceEvent>(_handleUseSpace);
    on<GetFileNameEvent>(_handleGetFileName);
    on<VerifyUploadEvent>(_handleVerifyClick);
    on<onVerifyResponse>(_handleVerifyUpload);
    on<fetchAndSaveUploadVerifyClaims>(_fetchAndSaveClaims);
    on<getUploadVerifyClaims>(_getUploadVerifyClaims);
    on<ResetFileStateEvent>((event, emit) {
  emit(FileInitial());  // Reset state to initial
});


    /////////download//////
    
  }

  void _handleFileUpload(FileuploadEvent event, Emitter<FileState> emit) async {
    emit(FileUploading());
    final uploadResponse = await fileUsecase(UseCaseParams(
        did: event.did, ownerDid: event.ownerDid, fileData: event.fileData));
    uploadResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(FileUploadFailed(failure.toString()));
      },
      (upload) {
        print('Emitting StatusLoaded with DID: $upload');
        emit(FileUploaded(upload));
      },
    );
  }

  void _handleUseSpace(UseSpaceEvent event, Emitter<FileState> emit) async {
    print('fetching use space12');
    emit(FileUploading());
    final useSpaceResponse = await useSpaceUsecase(UseSpaceParam(
        did: event.did, ownerDid: event.ownerDid, batchSize: event.batchSize));
    useSpaceResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(FileUploadFailed(failure.toString()));
      },
      (useSpace) {
        print('Emitting StatusLoaded with DID1: $useSpace');
        emit(FileUsingSpaced(useSpace));
      },
    );
  }

  void _handleGetFileName(
      GetFileNameEvent event, Emitter<FileState> emit) async {
    emit(FileUploading());
    final fileNameResponse =
        await getFileNameUsecase(FileNameParam(BatchHash: event.BatchHash));
    fileNameResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(FileNameFetchedFailed(failure.toString()));
      },
      (fileName) {
        print('Emitting StatusLoaded with DID12: $fileName');
        emit(FileNameLoaded(fileName));
      },
    );
  }

  Future<void> _handleVerifyClick(
      VerifyUploadEvent event, Emitter<FileState> emit) async {
    emit(Fileverifying(event.BatchHash));
    final failureOrVerify = await verifyUploadUsecase(
      VerifyUploadParam(
        BatchHash: event.BatchHash,
        ownerDid: event.ownerDid,
        did: event.did,
      ),
    );

    failureOrVerify.fold(
        (failure) => emit(FileVerifyFailed(failure.toString())),
        (response) => emit(VerifySuccess(response,event.BatchHash)));
  }

  Future<void> _handleVerifyUpload(
      onVerifyResponse event, Emitter<FileState> emit) async {
    String? qrCodeResponse = event.verifyResponse;
    String? batchHash = event.batchHash;
    print('qrCodeResponse1: $qrCodeResponse');
    if (qrCodeResponse == null || qrCodeResponse.isEmpty) {
      emit(FileVerifyFailed("Scanned code is not valid"));
    }

    try {
      final Iden3MessageEntity iden3message =
          await _qrcodeParserUtils.getIden3MessageFromQrCode(qrCodeResponse!);
      print('iden3message res1: $iden3message');
      emit(VerifyResponseloaded(iden3message,event.batchHash! ));
      print('state23: ${state}');
      print('get fetch1 ');
    } catch (error) {
      emit(FileVerifyFailed("Scanned code is not valid"));
    }
  }

  Future<void> _fetchAndSaveClaims(
      fetchAndSaveUploadVerifyClaims event, Emitter<FileState> emit) async {
    String? privateKey =
        await SecureStorage.read(key: SecureStorageKeys.privateKey);

        String batchHash = event.batchHash!;
    print('privateKey1: $privateKey');
    if (privateKey == null) {
      emit(FileVerifyFailed("Private key not found"));
      return;
    }
    print('print failure');

    ChainConfigEntity chainConfig = await _polygonIdSdk.getSelectedChain();

    String didIdentifier = await _polygonIdSdk.identity.getDidIdentifier(
        privateKey: privateKey,
        blockchain: chainConfig.blockchain,
        network: chainConfig.network);

    print('didIdentifier: $didIdentifier');

    emit(Fileverifying(batchHash));

    Iden3MessageEntity iden3message = event.iden3message;
    print('iden3message fetch: $iden3message');
    if (event.iden3message.messageType != Iden3MessageType.credentialOffer) {
      emit(FileVerifyFailed("Read message is not of type offer"));
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
        add(getUploadVerifyClaims(batchHash));
        // add(event)
      }
    } catch (exception) {
      emit(FileVerifyFailed(CustomStrings.iden3messageGenericError));
    }
  }

  Future<void> _getUploadVerifyClaims(getUploadVerifyClaims event, Emitter<FileState> emit) async {
String batchHash = event.batchHash!;
    emit(Fileverifying(batchHash));

    List<FilterEntity>? filters = event.filters;

    String? privateKey =
        await SecureStorage.read(key: SecureStorageKeys.privateKey);

    if (privateKey == null) {
      emit(FileVerifyFailed("Private key not found"));
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
      emit(FileVerifyFailed(
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
      emit(VerifiedClaims(claimModelList,batchHash));
      print('loadedClaims: ${claimModelList}');
    } on GetClaimsException catch (_) {
      emit(FileVerifyFailed("error while retrieving claims"));
    } catch (_) {
      emit(FileVerifyFailed("generic error"));
    }
  }




  
}
