import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:polygonid_flutter_sdk/add_plans/data/dataSources/remote/addPlans_remote_datasource_impl.dart';
import 'package:polygonid_flutter_sdk/add_space/data/dataSources/remote/addSpace_remote_datasource_impl.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/repositories/addPlans_repository.dart';
import 'package:polygonid_flutter_sdk/add_plans/domain/usecases/addPlans_usecase.dart';
import 'package:polygonid_flutter_sdk/add_space/domain/repositories/addSpace_repository.dart';
import 'package:polygonid_flutter_sdk/add_space/domain/usecases/addSpace_usecase.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/file/data/dataSources/file_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/file/domain/repositories/file_repo.dart';
import 'package:polygonid_flutter_sdk/file/domain/usecases/file_usecase.dart';
import 'package:polygonid_flutter_sdk/iden3comm/data/mappers/iden3_message_type_mapper.dart';
import 'package:polygonid_flutter_sdk/login/data/dataSources/remote/login_remote_dataSource_impl.dart'
    as login_remote_dataSource_impl;
import 'package:polygonid_flutter_sdk/login/data/dataSources/remote/login_remote_datasource_impl.dart';
import 'package:polygonid_flutter_sdk/login/domain/repositories/login_repository.dart';
import 'package:polygonid_flutter_sdk/login/domain/usecases/login_usecase.dart';
import 'package:polygonid_flutter_sdk/registers/data/dataSources/register_remote_dataSource.dart';
import 'package:polygonid_flutter_sdk/registers/data/dataSources/remote/register_remote_dataSource_impl.dart';
import 'package:polygonid_flutter_sdk/file/data/dataSources/remote/file_remote_dataSource_impl.dart';
import 'package:polygonid_flutter_sdk/registers/data/repositories/register_repo_impl.dart';
import 'package:polygonid_flutter_sdk/login/data/repositories/login_repository_impl.dart';
import 'package:polygonid_flutter_sdk/file/data/repositories/file_repo_impl.dart';
import 'package:polygonid_flutter_sdk/add_plans/data/repositories/addPlans_repository_impl.dart';
import 'package:polygonid_flutter_sdk/add_space/data/repositories/addSpace_repository_impl.dart';
import 'package:polygonid_flutter_sdk/registers/domain/repositories/register_repo.dart';
import 'package:polygonid_flutter_sdk/registers/domain/usecases/register_usecase.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/common/env.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/auth/auth_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/backup_identity/bloc/backup_identity_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/check_identity_validity/bloc/check_identity_validity_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claim_detail/bloc/claim_detail_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/claims_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/mappers/claim_model_mapper.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/mappers/claim_model_state_mapper.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/claims/mappers/proof_model_type_mapper.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/download_bloc/download_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/file_bloc/file_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/files/share_bloc/share_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/home/home_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/login/bloc/login_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/plans/bloc/add_plans_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/register/presentation/bloc/register_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/restore_identity/bloc/restore_identity_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/sign/sign_bloc.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/ui/splash/splash_bloc.dart';
import 'package:polygonid_flutter_sdk_example/utils/qr_code_parser_utils.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

/// Dependency Injection initializer
Future<void> init() async {
  registerEnv();
  await registerProviders();
  registerSplashDependencies();
  registerHomeDependencies();
  registerClaimDetailDependencies();
  registerClaimsDependencies();
  registerAuthDependencies();
  registerMappers();
  registerSignDependencies();
  registerIdentityDependencies();
  registerBackupIdentityDependencies();
  registerRestoreIdentityDependencies();
  registerUtilities();
  registerRegisterDependencies();
  registerLoginDependencies();
  fileUploadDependencies();
  addPlansDependencies();
  DownloadDependencies();
  ShareDependencies();
  _initGetit();
}

void registerEnv() {
  Map<String, dynamic> defaultEnv = jsonDecode(Env.defaultEnvironment);
  print('defaultEnv: $defaultEnv');
  String stacktraceEncryptionKey = Env.stacktraceEncryptionKey;
  String pinataGateway = Env.pinataGateway;
  String pinataGatewayToken = Env.pinataGatewayToken;

  EnvEntity envV1 = EnvEntity.fromJson(defaultEnv);
  if (stacktraceEncryptionKey.isNotEmpty) {
    envV1 = envV1.copyWith(stacktraceEncryptionKey: stacktraceEncryptionKey);
  }

  if (pinataGateway.isNotEmpty) {
    envV1 = envV1.copyWith(pinataGateway: pinataGateway);
  }

  if (pinataGatewayToken.isNotEmpty) {
    envV1 = envV1.copyWith(pinataGatewayToken: pinataGatewayToken);
  }

  getIt.registerSingleton<EnvEntity>(envV1);
}

///
Future<void> registerProviders() async {
  await PolygonIdSdk.init(env: getIt<EnvEntity>());
  getIt.registerLazySingleton<PolygonIdSdk>(() => PolygonIdSdk.I);
}

///
void registerSplashDependencies() {
  getIt.registerFactory(() => SplashBloc());
}

///
void registerHomeDependencies() {
  getIt.registerFactory(() => HomeBloc(getIt()));
}

///
void registerRegisterDependencies() {
  getIt.registerFactory(() => RegisterBloc(getIt(), getIt(), getIt(), getIt(),getIt()));

  // Use cases
  getIt.registerLazySingleton(() => RegisterUsecase(getIt()));
  getIt.registerLazySingleton(() => CallbackUsecase(getIt()));

  // // Repositories
  getIt.registerLazySingleton<RegisterRepository>(
      () => RegisterRepoImpl(registerRemoteDatasource: getIt()));

  // // Data sources
  getIt.registerLazySingleton<RegisterRemoteDatasource>(
      () => RegisterRemoteDatasourceImpl(client: getIt()));
}

void _initGetit() {
  getIt.registerLazySingleton(() => http.Client());
}

void registerLoginDependencies() {
  getIt.registerFactory(() => LoginBloc(getIt(), getIt(), getIt(), getIt()));

  // Use cases
  getIt.registerLazySingleton(() => LoginDoneUsecase(getIt()));
  getIt.registerLazySingleton(() => LoginStatusUsecase(getIt()));

  // // Repositories
  getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(loginRemoteDatasource: getIt()));

  // // Data sources
  getIt.registerFactory<LoginRemoteDatasource>(
      () => LoginRemoteDatasourceImpl(client: getIt()));
}

void fileUploadDependencies() {
  getIt.registerFactory(() => FileBloc( getIt(),
      getIt(),getIt(),getIt(),getIt(),getIt(),getIt()));

  // Use cases
  getIt.registerLazySingleton(() => FileUsecase(getIt()));
  getIt.registerLazySingleton(() => UseSpaceUsecase(getIt()));
  getIt.registerLazySingleton(() => FileNameUsecase(getIt()));
  getIt.registerLazySingleton(() => VerifyUploadUsecase(getIt()));

  // // Repositories
  getIt.registerLazySingleton<FileRepository>(
      () => FileRepoImpl(fileRemoteDatasource: getIt()));

  // // Data sources
  getIt.registerFactory<FileRemoteDatasource>(
      () => FileRemoteDatasourceImpl(client: getIt()));
}

void DownloadDependencies() {
  getIt.registerFactory(() => DownloadBloc( getIt(),
      getIt(),getIt(),getIt(),getIt(),getIt()));

      // Use cases
  getIt.registerLazySingleton(() => DownloadStatusUsecase(getIt()));
   getIt.registerLazySingleton(() => DownloadVerifyUsecase(getIt()));
   getIt.registerLazySingleton(() => CidsUsecase(getIt()));
   getIt.registerLazySingleton(() => DownloadUsecase(getIt()));

}

void ShareDependencies() {
  getIt.registerFactory(() => ShareBloc( getIt()));

      // Use cases
  getIt.registerLazySingleton(() => ShareUsecase(getIt()));
 

}

///
void addPlansDependencies() {
  getIt.registerFactory(() => AddPlansBloc( getIt(), getIt(), getIt(), getIt(), getIt(),));

  // Use cases
  getIt.registerLazySingleton(() => AddUserUsecase(getIt()));
  getIt.registerLazySingleton(() => GenerateSecretsUsecase(getIt()));
  getIt.registerLazySingleton(() => CreateProofUsecase(getIt()));
  getIt.registerLazySingleton(() => VerifyUsecase(getIt()));
  getIt.registerLazySingleton(() => FreeSpaceUsecase(getIt()));


  // // Repositories
  getIt.registerLazySingleton<AddPlansRepository>(
      () => AddplansRepositoryImpl(addPlansRemoteDatasource: getIt()));

  // // Data sources
  getIt.registerFactory<AddPlansRemoteDatasource>(
      () => AddPlansRemoteDatasourceImpl(client: getIt()));
}


///
void registerClaimsDependencies() {
  getIt.registerFactory(() => ClaimsBloc(
        getIt(),
        getIt(),
        getIt(),
      ));
}

///
void registerClaimDetailDependencies() {
  getIt.registerFactory(() => ClaimDetailBloc(getIt()));
}

///
void registerAuthDependencies() {
  getIt.registerFactory(() => AuthBloc(getIt(), getIt()));
}

///
void registerMappers() {
  getIt.registerFactory(() => ClaimModelMapper(getIt(), getIt()));
  getIt.registerFactory(() => ClaimModelStateMapper());
  getIt.registerFactory(() => ProofModelTypeMapper());
  getIt.registerFactory(() => Iden3MessageTypeMapper());
}

///
void registerSignDependencies() {
  getIt.registerFactory(() => SignBloc(getIt()));
}

///
void registerIdentityDependencies() {
  getIt.registerFactory<CheckIdentityValidityBloc>(
      () => CheckIdentityValidityBloc(getIt()));
}

///
void registerBackupIdentityDependencies() {
  getIt.registerFactory<BackupIdentityBloc>(() => BackupIdentityBloc(getIt()));
}

///
void registerRestoreIdentityDependencies() {
  getIt
      .registerFactory<RestoreIdentityBloc>(() => RestoreIdentityBloc(getIt()));
}

/// Register utilities
void registerUtilities() {
  getIt.registerLazySingleton<QrcodeParserUtils>(
      () => QrcodeParserUtils(getIt()));
}
