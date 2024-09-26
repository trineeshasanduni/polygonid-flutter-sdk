import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    // on<addUserEvent>(_handleAddUser);
  }

  // void _handleAddUser(addUserEvent event, Emitter<DashboardState> emit) {
  //   emit(DashboardLoading());
  //  final addUserresponse= await fileUsecase(UseCaseParams(
  //       did: event.did, ownerDid: event.ownerDid, fileData: event.fileData
  //   ));
  //   uploadResponse.fold(
  //   (failure) {
  //     print('failure get: $failure');
  //     emit(FileUploadFailed(failure.toString()));
  //   },
    
  //   (upload) {
  //     print('Emitting StatusLoaded with DID: $upload');
  //   emit(FileUploaded(upload));
  //   },
  // );
  }
// }
