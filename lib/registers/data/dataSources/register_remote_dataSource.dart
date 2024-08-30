import 'package:polygonid_flutter_sdk/registers/data/model/register_model.dart';

abstract class RegisterRemoteDatasource {

  Future<RegisterModel> registerWithDID(
      {required String did,
      required String first,
      required String last,
      required String email,
      }
  );

 
}