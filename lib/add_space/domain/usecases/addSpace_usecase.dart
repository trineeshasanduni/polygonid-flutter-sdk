// import 'dart:ffi';

// import 'package:fpdart/fpdart.dart';
// import 'package:polygonid_flutter_sdk/add_space/domain/entities/freeSpace_entity.dart';
// import 'package:polygonid_flutter_sdk/add_space/domain/repositories/addSpace_repository.dart';
// import 'package:polygonid_flutter_sdk/common/errors/server_failure.dart';
// import 'package:polygonid_flutter_sdk/common/usecase/usecase.dart';


// class FreeSpaceUsecase implements UseCase<FreeSpaceEntity, FreeSpaceParams> {
//   final AddSpaceRepository addSpaceRepository;
//   const FreeSpaceUsecase(this.addSpaceRepository);
//   @override
//   Future<Either<Failure, FreeSpaceEntity>> call(FreeSpaceParams params) async {
//     print('registering1234: ${params.did}');
//     print('registering12341: ${params.owner}');
//     return await addSpaceRepository.freeSpace(
//         did: params.did,
//         owner: params.owner);
//   }
// }

// class FreeSpaceParams{
  
//   final String did;
//   final String owner;
 

//   FreeSpaceParams(
//       {required this.did,
//       required this.owner,
     
//      });
// }


