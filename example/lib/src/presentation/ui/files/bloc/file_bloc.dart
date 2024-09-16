import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_constants.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/chain_config_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/error_exception.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/fileName_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/verify_upload_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/usecases/file_usecase.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/exceptions/iden3comm_exceptions.dart';
import 'package:polygonid_flutter_sdk/identity/domain/entities/identity_entity.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/common/widgets/profile_radio_button.dart';
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

  static const SelectedProfile _defaultProfile = SelectedProfile.public;
  SelectedProfile selectedProfile = _defaultProfile;

  FileBloc(this.fileUsecase, this.useSpaceUsecase, this.getFileNameUsecase,
      this._polygonIdSdk, this._qrcodeParserUtils, this.verifyUploadUsecase)
      : super(FileInitial()) {
    on<FileuploadEvent>(_handleFileUpload);
    on<UseSpaceEvent>(_handleUseSpace);
    on<GetFileNameEvent>(_handleGetFileName);
    on<VerifyUploadEvent>(_handleVerifyClick);
    on<onVerifyResponse>(_handleVerifyUpload);
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
    emit(Fileverifying());
    final failureOrVerify = await verifyUploadUsecase(
      VerifyUploadParam(
        BatchHash: event.BatchHash,
        ownerDid: event.ownerDid,
        did: event.did,
      ),
    );

    failureOrVerify.fold(
        (failure) => emit(FileVerifyFailed(failure.toString())),
        (response) => emit(VerifySuccess(response)));
  }

  Future<void> _handleVerifyUpload(
      onVerifyResponse event, Emitter<FileState> emit) async {
    String? VerifyResponse = event.verifyResponse;
    print('login response get: $VerifyResponse');
    if (VerifyResponse == null || VerifyResponse.isEmpty) {
      emit(FileVerifyFailed("Not valid response"));
      return;
    }

    try {
      final Iden3MessageEntity iden3message =
          await _qrcodeParserUtils.getIden3MessageFromQrCode(VerifyResponse);
      print('iden3message get: $iden3message');
      emit(VerifyResponseloaded(iden3message));

      String? privateKey =
          await SecureStorage.read(key: SecureStorageKeys.privateKey);

      print('privateKey get: $privateKey');

      if (privateKey == null) {
        emit(FileVerifyFailed("no private key found"));
        return;
      }

      await _authenticate(
        iden3message: iden3message,
        privateKey: privateKey,
        emit: emit,
      );
      print('Verify done');
    } catch (error) {
      emit(FileVerifyFailed("verify code is not valid"));
    }
  }

  Future<void> _authenticate({
    required Iden3MessageEntity iden3message,
    required String privateKey,
    required Emitter<FileState> emit,
  }) async {
    emit((Fileverifying()));

    final ChainConfigEntity currentChain =
        await _polygonIdSdk.getSelectedChain();
    print('curr: $currentChain');
    final EnvEntity envEntity = await _polygonIdSdk.getEnv();

    String? did = await _polygonIdSdk.identity.getDidIdentifier(
      privateKey: privateKey,
      blockchain: currentChain.blockchain,
      network: currentChain.network,
      method: currentChain.method,
    );
    print('did get: $did');

    IdentityEntity identityEntity = await _polygonIdSdk.identity.getIdentity(
      genesisDid: did,
      privateKey: privateKey,
    );
    print('identityEntity get: $identityEntity');

    try {
      print("try fetch");
      print('profile: ${selectedProfile.toString()}');
      final BigInt nonce = selectedProfile == SelectedProfile.public
          ? GENESIS_PROFILE_NONCE
          : await NonceUtils(getIt()).getPrivateProfileNonce(
              did: did, privateKey: privateKey, from: iden3message.from);
      print('nonce get: $nonce');
      print('did get1: $did');
      print('iden3message get1: $iden3message');
      print('privateKey get1: $privateKey');

      print('identityEntity fetch: $identityEntity');
      print('env fetch: $envEntity');

      await _polygonIdSdk.iden3comm.authenticateV2(
        message: iden3message,
        genesisDid: did,
        privateKey: privateKey,
        profileNonce: nonce,
        identityEntity: identityEntity,
        env: envEntity,
      );

      print('before emit');

      emit(const authenticated());
    } on OperatorException catch (error) {
      print('error1: $error');
      emit(FileVerifyFailed(error.errorMessage));
    } on PolygonIdSDKException catch (error) {
      print('error2: $error');

      emit(FileVerifyFailed(error.errorMessage));
    } catch (error) {
      print('error3: $error');

      emit(FileVerifyFailed(error.toString()));
    }
  }
}
