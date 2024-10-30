import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polygonid_flutter_sdk/dashboard/domain/entities/networkUsageEntity.dart';
import 'package:polygonid_flutter_sdk/dashboard/domain/usecases/network_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final NetworkUsageUsecase networkUsageUsecase;

  DashboardBloc(this.networkUsageUsecase) : super(DashboardInitial()) {
    on<networkUsageEvent>(_handleNetworkUsage);
  }

  Future<void> _handleNetworkUsage(
    
      networkUsageEvent event, Emitter<DashboardState> emit) async {
        print('fetch network usage bloc');
    emit(DashboardLoading());

    final failureOrusage = await networkUsageUsecase(UseCaseParams(
          did: event.did,
          ));
           print('fetch network usage bloc1');
        
    failureOrusage.fold(
      (failure) => emit(DashboardError(failure.toString())),
      (usage) => emit(DashboardLoaded(usage)),
    );
  }
  }
// }
