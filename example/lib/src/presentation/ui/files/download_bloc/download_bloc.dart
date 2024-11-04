import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_constants.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/chain_config_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/error_exception.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/cid_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/downloadUrl_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/downloadVerify_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/download_status_entity.dart';
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

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadVerifyUsecase downloadVerify;
  final QrcodeParserUtils _qrcodeParserUtils;
  final PolygonIdSdk _polygonIdSdk;
  final DownloadStatusUsecase statusUsecase;
  final CidsUsecase cidsUsecase;
  final DownloadUsecase downloadUsecase;

  static const SelectedProfile _defaultProfile = SelectedProfile.public;
  SelectedProfile selectedProfile = _defaultProfile;

  DownloadBloc(this.downloadVerify, this._qrcodeParserUtils, this._polygonIdSdk,
      this.statusUsecase, this.cidsUsecase, this.downloadUsecase)
      : super(DownloadInitial()) {
    on<onClickDownload>(_handleDownloadVerify);
    on<onDownloadResponse>(_handleDownloadResponse);
    on<onGetDownloadStatusEvent>(_handleDownloadStatus);
    on<GetCidsEvent>(_handleGetCids);
    on<onClickDownloadUrl>(_handleDownloadUrl);
    on<ResetDownloadStateEvent>((event, emit) {
      emit(DownloadInitial()); // Reset state to initial
    });
  }

  Future<void> _handleDownloadVerify(
      onClickDownload event, Emitter<DownloadState> emit) async {
    emit(Downloading(event.batch_hash, 0.1, event.file_hash));
    print('downloading45:${event.batch_hash}....${event.fileHash}');
    final failureOrdownload = await downloadVerify(DownloadParams(
        batch_hash: event.batch_hash,
        file_hash: event.file_hash,
        didU: event.didU));
    failureOrdownload.fold(
        (failure) => emit(DownloadFailed(failure.toString())),
        (download) =>
            emit(DownloadSuccess(download, event.batch_hash, event.fileHash)));

    print('download45:${event.batch_hash}');
  }

  Future<void> _handleDownloadResponse(
      onDownloadResponse event, Emitter<DownloadState> emit) async {
    String? DownloadResponse = event.response;

    if (DownloadResponse == null || DownloadResponse.isEmpty) {
      emit(const DownloadFailed("Download Response failed"));
      return;
    }

    try {
      final Iden3MessageEntity iden3message =
          await _qrcodeParserUtils.getIden3MessageFromQrCode(DownloadResponse);
      emit(loaded(iden3message));

      String? privateKey =
          await SecureStorage.read(key: SecureStorageKeys.privateKey);

      if (privateKey == null) {
        emit(DownloadFailed("no private key found"));
        return;
      }

      await _authenticate(
          iden3message: iden3message,
          privateKey: privateKey,
          emit: emit,
          batchHash: event.batchHash!,
          fileHash: event.fileHash!);
    } catch (error) {
      emit(DownloadFailed("Download response is not valid"));
    }
  }

  Future<void> _authenticate({
    required Iden3MessageEntity iden3message,
    required String privateKey,
    required String batchHash,
    required String fileHash,
    required Emitter<DownloadState> emit,
  }) async {
    emit(Downloading(batchHash, 0.5, fileHash));

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

      emit(const downlodVerified());
    } on OperatorException catch (error) {
      emit(DownloadFailed(error.errorMessage));
    } on PolygonIdSDKException catch (error) {
      emit(DownloadFailed(error.errorMessage));
    } catch (error) {
      emit(DownloadFailed(error.toString()));
    }
  }

  Future<void> _handleDownloadStatus(
      onGetDownloadStatusEvent event, Emitter<DownloadState> emit) async {
    emit(Downloading(event.batch_hash, 0.8, event.fileHash));

    print('_handleDownloadStatus url :${event.fileHash}');

    final status =
        await statusUsecase(DownloadStatusParams(sessionId: event.sessionId));

    status.fold(
      (failure) {
        emit(DownloadFailed(failure.toString()));
      },
      (did) {
        emit(StatusLoaded(did, event.batch_hash, event.fileHash));
      },
    );
  }

  void _handleGetCids(GetCidsEvent event, Emitter<DownloadState> emit) async {
    emit(GettingCids());
    final fileNameResponse = await cidsUsecase(CidsParams(
        index: event.index,
        did: event.did,
        owner: event.owner,
        BatchHash: event.batch_hash));
    fileNameResponse.fold(
      (failure) {
        emit(DownloadFailed(failure.toString()));
      },
      (cids) {
        emit(CidsGot(cids, event.batch_hash, event.fileHash));
      },
    );
  }

  Future<void> _handleDownloadUrl(
      onClickDownloadUrl event, Emitter<DownloadState> emit) async {
    emit(LoadingUrl(event.BatchHash, event.fileHash));
    print('loafing url :${event.FileHash}');
    final failureOrdownloadurl = await downloadUsecase(DownloadUrlParams(
        BatchHash: event.BatchHash,
        FileHash: event.FileHash,
        Odid: event.Odid,
        FileName: event.FileName,
        Cids: event.Cids));

        print('failureOrdownloadurl:${failureOrdownloadurl}');
    failureOrdownloadurl.fold(
        (failure) => emit(DownloadFailed(failure.toString())),
        
        (downloadurl) => emit(
            DownloadUrlSuccess(downloadurl, event.BatchHash, event.fileHash)));
    
  }
}
