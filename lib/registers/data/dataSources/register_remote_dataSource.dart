import 'package:polygonid_flutter_sdk/registers/data/model/callbackResponse_model.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/registerQr_model.dart';
import 'package:polygonid_flutter_sdk/registers/data/model/register_model.dart';
import 'package:polygonid_flutter_sdk/registers/domain/entities/callback_response_entity.dart';

abstract class RegisterRemoteDatasource {

  Future<RegisterModel> registerWithDID(
      {required String did,
      required String first,
      required String last,
      required String email,
      }
  );

  Future<CallbackResponseModel> FetchWithCallbackUrl(
    {required String callbackUrl,
    required String did,
    }
      
  );

 
}