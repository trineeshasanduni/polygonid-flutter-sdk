// import 'dart:ffi';

// import 'package:fpdart/fpdart.dart';

// import 'package:polygonid_flutter_sdk/add_space/data/dataSources/remote/addSpace_remote_datasource_impl.dart';
// import 'package:polygonid_flutter_sdk/add_space/data/model/freeSpace_model.dart';
// import 'package:polygonid_flutter_sdk/add_space/domain/entities/freeSpace_entity.dart';
// import 'package:polygonid_flutter_sdk/add_space/domain/repositories/addSpace_repository.dart';
// import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
// // import 'package:polygonid_flutter_sdk/login/data/dataSources/login_remote_datasource.dart';


// class AddSpaceRepositoryImpl implements AddSpaceRepository {
//   final AddSpaceRemoteDatasource addSpaceRemoteDatasource;

//   AddSpaceRepositoryImpl({required this.addSpaceRemoteDatasource});

 

//   @override
//   Future<Either<Failure, FreeSpaceEntity>> freeSpace(
//       {required String did, required String owner}) async {
//     try {
//       final FreeSpaceModel addSpaceModel =
//           await addSpaceRemoteDatasource.freeSpace(
//         did: did,
//         owner: owner,
//       );

//       return right(FreeSpaceEntity(
//         TXHash : addSpaceModel.TXHash,
//       ));
//     } catch (e) {
//       return Left(Failure());
//     }
//   }
// }
