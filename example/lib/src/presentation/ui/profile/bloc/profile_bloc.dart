import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/profile/data/models/activityModel.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/activityEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/getEmailEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/validateOTPEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/verifyEmailEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/entities/verifyTelEntity.dart';
import 'package:polygonid_flutter_sdk/profile/domain/usecases/profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUsecase profileUsecase;
  final VerifyEmailUsecase verifyEmailUsecase;
  final UpdateVerifyEmailUsecase updateVerifyEmailUsecase;
  final GetVerifyEmailUsecase getVerifyEmailUsecase;
  final VerifyTelUsecase verifyTelUsecase;
  final ValidateOTPUsecase validateOTPUsecase;

  ProfileBloc(this.profileUsecase, this.verifyEmailUsecase,
      this.updateVerifyEmailUsecase, this.getVerifyEmailUsecase,this.verifyTelUsecase,this.validateOTPUsecase)
      : super(ProfileInitial()) {
    on<ActivityLogsEvent>(_handleActivityLogs);
    on<VerifyEmailEvent>(_handleVerifyEmail);
    on<UpdateVerifyEmailEvent>(_handleUpdateVerifyEmail);
    on<GetVerifyEmailEvent>(_handleGetVerifyEmail);
    on<VerifyTelEvent>(_handleVerifyTel);
    on<ValidateOTPEvent>(_handleValidateOTP);
  }

  void _handleActivityLogs(
      ActivityLogsEvent event, Emitter<ProfileState> emit) async {
    emit(LogsUpdating());
    final uploadResponse = await profileUsecase(ProfileParams(did: event.did));
    uploadResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(LogsUpdateFailed(failure.toString()));
      },
      (upload) {
        print('Emitting StatusLoaded with DID: $upload');
        emit(LogsUpdated(upload));
      },
    );
  }

  void _handleVerifyEmail(
      VerifyEmailEvent event, Emitter<ProfileState> emit) async {
    emit(Sending());
    final uploadResponse = await verifyEmailUsecase(VerifyEmailParams(
      Did: event.Did,
      UserEmail: event.UserEmail,
    ));
    uploadResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(VerifyFailed(failure.toString()));
      },
      (upload) {
        print('Emitting EmailVerified with DID: $upload');
        emit(EmailSend(upload));
      },
    );
  }

  void _handleUpdateVerifyEmail(
      UpdateVerifyEmailEvent event, Emitter<ProfileState> emit) async {
    emit(Updating());
    final uploadResponse =
        await updateVerifyEmailUsecase(UpdateVerifyEmailParams(
      Did: event.Did,
      UserEmail: event.UserEmail,
      Token: event.Token,
    ));
    uploadResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(UpdateFailed(failure.toString()));
      },
      (upload) {
        print('Emitting EmailVerified with DID: $upload');
        emit(EmailVerified(upload));
      },
    );
  }

  void _handleGetVerifyEmail(
      GetVerifyEmailEvent event, Emitter<ProfileState> emit) async {
    emit(Verifying());
    final uploadResponse = await getVerifyEmailUsecase(GetVerifyEmailParams(
      Did: event.Did,
    ));
    uploadResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(EmailGettingFailed(failure.toString()));
      },
      (email) {
        print('Emitting get Is Verified: $email');
        emit(EmailUpdated(email));
      },
    );
  }


  void _handleVerifyTel(
      VerifyTelEvent event, Emitter<ProfileState> emit) async {
    emit(Sending());
    final uploadResponse = await verifyTelUsecase(VerifyTelParams(
      DID: event.DID,
      Mobile: event.Mobile,
    ));
    uploadResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(VerifyFailed(failure.toString()));
      },
      (upload) {
        print('Emitting TelVerified with DID: $upload');
        emit(OTPSend(upload));
      },
    );
  } 

  void _handleValidateOTP(
      ValidateOTPEvent event, Emitter<ProfileState> emit) async {
    emit(OtpVerifiying());
    final validateResponse = await validateOTPUsecase(ValidateOTPParams(
      Did: event.Did,
      OTP: event.OTP,
    ));
    validateResponse.fold(
      (failure) {
        print('failure get: $failure');
        emit(ValidateFailed(failure.toString()));
      },
      (validate) {
        print('Emitting TelVerified with DID: $validate');
        emit(Validate(validate));
      },
    );
  } 




  //////////////////update user profile//////////////////////////
}
