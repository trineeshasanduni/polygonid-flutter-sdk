// import 'package:bethel_wallet/core/mappers/mapper.dart';
// import 'package:bethel_wallet/features/register/data/mappers/credentialMapper.dart';
// import 'package:bethel_wallet/features/register/data/model/register_model.dart';
// import 'package:bethel_wallet/features/register/domain/entities/register_entity.dart';
// import 'bodymapper.dart';

// class RegisterMapper extends Mapper<RegisterModel, RegisterEntity> {
//   final Bodymapper _bodyMapper;

 

//   RegisterMapper(this._bodyMapper);

//   @override
//   RegisterEntity mapFrom(RegisterModel model) {
//     return RegisterEntity(
//       body: model.body != null ? _bodyMapper.mapFrom(model.body!) : null,
//       from: model.from,
//       id: model.id,
//       thid: model.thid,
//       to: model.to,
//       typ: model.typ,
//       type: model.type,
//     );
//   }

//   @override
//   RegisterModel mapTo(RegisterEntity entity) {
//     return RegisterModel(
//       body: entity.body != null ? _bodyMapper.mapTo(entity.body!) : null,
//       from: entity.from,
//       id: entity.id,
//       thid: entity.thid,
//       to: entity.to,
//       typ: entity.typ,
//       type: entity.type,
//     );
//   }
// }
