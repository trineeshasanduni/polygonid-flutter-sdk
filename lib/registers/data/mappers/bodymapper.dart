// import 'package:bethel_wallet/core/mappers/mapper.dart';
// import 'package:bethel_wallet/features/register/data/mappers/registerMapper.dart';
// import 'package:bethel_wallet/features/register/data/model/register_model.dart';
// import 'package:bethel_wallet/features/register/domain/entities/register_entity.dart';

// import 'credentialMapper.dart';

// class Bodymapper extends Mapper< Body,BodyEntity> {
//   final Credentialmapper _credentialsMapper;

//   Bodymapper(this._credentialsMapper);
  
//   @override
//   Body mapTo(BodyEntity model) {
//     return Body(
//       credentials:List.from(model.credentials!.map((e) => _credentialsMapper.mapFrom(e as Credentials))),
//       url: model.url,
//     );
//   }
  
//   @override
//   BodyEntity mapFrom(Body entity) {
//     return BodyEntity(
//       credentials: List.from(entity.credentials!.map((e) => _credentialsMapper.mapTo(e as CredentialsEntity))),
//       url: entity.url,
//     );
//   }
  
 
// }