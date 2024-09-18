import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_constants.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/chain_config_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/error_exception.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/cid_entity.dart';
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


  static const SelectedProfile _defaultProfile = SelectedProfile.public;
  SelectedProfile selectedProfile = _defaultProfile;

  DownloadBloc(this.downloadVerify, this._qrcodeParserUtils, this._polygonIdSdk,
      this.statusUsecase,this.cidsUsecase)
      : super(DownloadInitial()) {
    on<onClickDownload>(_handleDownloadVerify);
    on<onDownloadResponse>(_handleDownloadResponse);
    on<onGetDownloadStatusEvent>(_handleDownloadStatus);
    on<GetCidsEvent>(_handleGetCids);
  }

  Future<void> _handleDownloadVerify(
      onClickDownload event, Emitter<DownloadState> emit) async {
    emit(Downloading());
    final failureOrdownload = await downloadVerify(DownloadParams(
        batch_hash: event.batch_hash,
        file_hash: event.file_hash,
        didU: event.didU));
    failureOrdownload.fold(
        (failure) => emit(DownloadFailed(failure.toString())),
        (download) => emit(DownloadSuccess(download,event.batch_hash )));
  }

  Future<void> _handleDownloadResponse(
      onDownloadResponse event, Emitter<DownloadState> emit) async {
    String? DownloadResponse = event.response;
    print('download response get: $DownloadResponse');
    if (DownloadResponse == null || DownloadResponse.isEmpty) {
      emit(const DownloadFailed("Download Response failed"));
      return;
    }

    try {
      final Iden3MessageEntity iden3message =
          await _qrcodeParserUtils.getIden3MessageFromQrCode(DownloadResponse);
      print('iden3message download get: $iden3message');
      emit(loaded(iden3message));

      String? privateKey =
          await SecureStorage.read(key: SecureStorageKeys.privateKey);

      print('privateKey get: $privateKey');

      if (privateKey == null) {
        emit(DownloadFailed("no private key found"));
        return;
      }

      await _authenticate(
        iden3message: iden3message,
        privateKey: privateKey,
        emit: emit,
      );
      print('authdownload done');
    } catch (error) {
      emit(DownloadFailed("Download response is not valid"));
    }
  }

  Future<void> _authenticate({
    required Iden3MessageEntity iden3message,
    required String privateKey,
    required Emitter<DownloadState> emit,
  }) async {
    emit(Downloading());

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
      print('env fetch download: $envEntity');

      await _polygonIdSdk.iden3comm.authenticateV2(
        message: iden3message,
        genesisDid: did,
        privateKey: privateKey,
        profileNonce: nonce,
        identityEntity: identityEntity,
        env: envEntity,
      );

      print('before download emit');

      emit(const downlodVerified());
    } on OperatorException catch (error) {
      print('error1: $error');
      emit(DownloadFailed(error.errorMessage));
    } on PolygonIdSDKException catch (error) {
      print('error2: $error');

      emit(DownloadFailed(error.errorMessage));
    } catch (error) {
      print('error3: $error');

      emit(DownloadFailed(error.toString()));
    }
  }

  Future<void> _handleDownloadStatus(
      onGetDownloadStatusEvent event, Emitter<DownloadState> emit) async {
    emit(Downloading());

    final status =
        await statusUsecase(DownloadStatusParams(sessionId: event.sessionId));
    print('status downloaddd get: $status');

    status.fold(
      (failure) {
        print('failure get: $failure');
        emit(DownloadFailed(failure.toString()));
      },
      (did) {
        print('Emitting StatusLoaded downloaddd with DID: $did');
        emit(StatusLoaded(did,event.batch_hash ));
      },
    );
  }

  void _handleGetCids(
      GetCidsEvent event, Emitter<DownloadState> emit) async {
    emit(GettingCids());
    final fileNameResponse =
        await cidsUsecase(CidsParams(index: event.index,did: event.did,owner: event.owner));
    fileNameResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(DownloadFailed(failure.toString()));
      },
      (fileName) {
        print('Emitting StatusLoaded with DID15: $fileName');
        emit(CidsGot(fileName));
      },
    );
  }

}
