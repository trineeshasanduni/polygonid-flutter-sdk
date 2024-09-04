import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/usecases/file_usecase.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final FileUsecase fileUsecase;


  FileBloc(this.fileUsecase) : super(FileInitial()) {
    on<FileuploadEvent>(_handleFileUpload);


  }

  void _handleFileUpload(FileuploadEvent event, Emitter<FileState> emit) async{
    emit(FileUploading());
   final uploadResponse= await fileUsecase(UseCaseParams(
        did: event.did, ownerDid: event.ownerDid, fileData: event.fileData
    ));
    uploadResponse.fold(
    (failure) {
      print('failure get: $failure');
      emit(FileUploadFailed(failure.toString()));
    },
    
    (upload) {
      print('Emitting StatusLoaded with DID: $upload');
    emit(FileUploaded(upload));
    },
  );


     

  }
}
