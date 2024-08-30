

// import 'package:bethel_wallet/core/errors/server_failure.dart';
// import 'package:bethel_wallet/features/register/data/dataSources/register_remote_dataSource.dart';
// import 'package:bethel_wallet/features/register/data/mappers/registerMapper.dart';
// import 'package:bethel_wallet/features/register/data/model/register_model.dart';
// import 'package:bethel_wallet/features/register/domain/entities/register_entity.dart';
// import 'package:bethel_wallet/features/register/domain/repositories/register_repo.dart';
// import 'package:fpdart/fpdart.dart';

// class RegisterRepoImpl extends RegisterRepository {
//   final RegisterRemoteDatasource registerRemoteDatasource;
//   final RegisterMapper registerMapper;

//   RegisterRepoImpl({required this.registerRemoteDatasource, required this.registerMapper});

//   @override
//   Future<Either<Failure, RegisterEntity>> registerWithDID({
//     required String did,
//     required String first,
//     required String last,
//     required String email,
//   }) async {
//     try {
//       RegisterModel registerModel =
//           await registerRemoteDatasource.registerWithDID(
//         did: did,
//         first: first,
//         last: last,
//         email: email,
//       );
//       final RegisterEntity registerEntity = registerMapper.mapFrom(registerModel);
//       return right(registerEntity);
    
          
//     } catch (error) {
//       return left(Failure('Failed to register: $error'));
//     }
//   }
// }
