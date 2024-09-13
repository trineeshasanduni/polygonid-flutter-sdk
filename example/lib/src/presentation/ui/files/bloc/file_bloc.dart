import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/fileName_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/file_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/usecases/file_usecase.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final FileUsecase fileUsecase;
  final UseSpaceUsecase useSpaceUsecase;
  final FileNameUsecase getFileNameUsecase;
  


  FileBloc(this.fileUsecase,this.useSpaceUsecase,this.getFileNameUsecase) : super(FileInitial()) {
    on<FileuploadEvent>(_handleFileUpload);
    on<UseSpaceEvent>(_handleUseSpace);
    on<GetFileNameEvent>(_handleGetFileName);


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
  );}


  void _handleUseSpace(UseSpaceEvent event, Emitter<FileState> emit) async{
    print('fetching use space12');
    emit(FileUploading());
   final useSpaceResponse= await useSpaceUsecase(
        UseSpaceParam(did: event.did, ownerDid: event.ownerDid, batchSize: event.batchSize)
   );
    useSpaceResponse.fold(
    (failure) {
      print('failure get: $failure');
      emit(FileUploadFailed(failure.toString()));
    },
    
    (useSpace) {
      print('Emitting StatusLoaded with DID1: $useSpace');
    emit(FileUsingSpaced(useSpace));
    },
  );
  }

  void _handleGetFileName(GetFileNameEvent event, Emitter<FileState> emit) async{
    emit(FileUploading());
   final fileNameResponse= await getFileNameUsecase(FileNameParam(BatchHash: event.BatchHash));
    fileNameResponse.fold(
    (failure) {
      print('failure get: $failure');
      emit(FileNameFetchedFailed(failure.toString()));
    },
    
    (fileName) {
      print('Emitting StatusLoaded with DID12: $fileName');
    emit(FileNameLoaded(fileName));
    },
  );

  }

}

