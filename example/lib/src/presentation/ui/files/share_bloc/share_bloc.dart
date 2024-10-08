import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/file/domain/entities/share_entity.dart';
import 'package:polygonid_flutter_sdk/file/domain/usecases/file_usecase.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  final ShareUsecase shareUsecase;

  ShareBloc(this.shareUsecase) : super(ShareInitial()) {
    on<onClickShare>(_handleShare);

    on<ResetShareStateEvent>((event, emit) {
      emit(ShareInitial()); // Reset state to initial
    });
  }

  Future<void> _handleShare(
      onClickShare event, Emitter<ShareState> emit) async {
    emit(Sharing());
    final failureOrShare = await shareUsecase(ShareUrlParams(
        BatchHash: event.batch_hash,
        FileHash: event.file_hash,
        OwnerDid: event.OwnerDid,
        FileName: event.FileName,
        ShareDid: event.ShareDid,
        Owner: event.Owner));
    failureOrShare.fold((failure) => emit(ShareFailed(failure.toString())),
        (Share) => emit(Shared(Share)));
  }
}
