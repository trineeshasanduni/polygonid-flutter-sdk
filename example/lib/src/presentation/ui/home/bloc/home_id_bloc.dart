// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:polygonid_flutter_sdk/common/domain/domain_logger.dart';
// import 'package:polygonid_flutter_sdk/common/domain/entities/chain_config_entity.dart';
// import 'package:polygonid_flutter_sdk/identity/domain/entities/private_identity_entity.dart';
// import 'package:polygonid_flutter_sdk/identity/domain/exceptions/identity_exceptions.dart';
// import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
// import 'package:polygonid_flutter_sdk_example/src/data/secure_storage.dart';
// import 'package:polygonid_flutter_sdk_example/utils/custom_strings.dart';
// import 'package:polygonid_flutter_sdk_example/utils/secure_storage_keys.dart';

// part 'home_id_event.dart';
// part 'home_id_state.dart';

// class HomeIdBloc extends Bloc<HomeIdEvent, HomeIdState> {
//   final PolygonIdSdk _polygonIdSdk;
//   HomeIdBloc(this._polygonIdSdk) : super(HomeIdInitial()) {
//     on<CreateIdentityHomeIDEvent>(_createIdentity);
//     on<GetIdentifierHomeIdEvent>(_getIdentifier);
//     on<RemoveIdentityHomeIdEvent>(_removeIdentity);
//   }

//   ///
//   Future<void> _getIdentifier(
//       GetIdentifierHomeIdEvent event, Emitter<HomeIdState> emit) async {
//     emit(HomeIdLoading('Loading...'));

//     String? privateKey =
//         await SecureStorage.read(key: SecureStorageKeys.privateKey);

//     if (privateKey == null) {
//       emit(HomeIdFailure( "no private key found"));
//       return;
//     }

//     final ChainConfigEntity chain = await _polygonIdSdk.getSelectedChain();

//     String? identifier = await _polygonIdSdk.identity.getDidIdentifier(
//       privateKey: privateKey,
//       blockchain: chain.blockchain,
//       network: chain.network,
//       method: chain.method,
//     );
//     print('loaded did1: $identifier');
//     emit(HomeIdSuccess(identifier));
//   }

//   ///
//   Future<void> _createIdentity(
//       CreateIdentityHomeIDEvent event, Emitter<HomeIdState> emit) async {
//     emit( HomeIdLoading('Loading...'));

//     try {
//       PrivateIdentityEntity identity =
//           await _polygonIdSdk.identity.addIdentity();
//       logger().i("identity: ${identity.privateKey}");
//       print('identity: ${identity.privateKey}');
//       await SecureStorage.write(
//           key: SecureStorageKeys.privateKey, value: identity.privateKey);
//       emit(HomeIdCreateSuccess( identity.did));
//       print('did created: ${identity.did}');
//     } on IdentityException catch (identityException) {
//       emit(HomeIdFailure( identityException.error));
//     } catch (_) {
//       emit( HomeIdFailure( CustomStrings.genericError));
//     }
//   }

//   ///
//   Future<void> _removeIdentity(
//       RemoveIdentityHomeIdEvent event, Emitter<HomeIdState> emit) async {
//     emit( HomeIdLoading('Loading...'));

//     String? privateKey =
//         await SecureStorage.read(key: SecureStorageKeys.privateKey);

//     if (privateKey == null) {
//       emit( HomeIdFailure( "no private key found"));
//       return;
//     }
    

//     final ChainConfigEntity chain = await _polygonIdSdk.getSelectedChain();

//     String did = await _polygonIdSdk.identity.getDidIdentifier(
//       privateKey: privateKey,
//       blockchain: chain.blockchain,
//       network: chain.network,
//       method: chain.method,
//     );
//     print('did: $did');

    

//     try {
//       await _polygonIdSdk.identity
//           .removeIdentity(genesisDid: did, privateKey: privateKey);
//       await SecureStorage.delete(key: SecureStorageKeys.privateKey);
//       emit( HomeIdRemoveSuccess());
//     } on IdentityException catch (identityException) {
//       emit(HomeIdFailure(identityException.error));
//     } catch (_) {
//       emit( HomeIdFailure(CustomStrings.genericError));
//     }
//   }

//   }

