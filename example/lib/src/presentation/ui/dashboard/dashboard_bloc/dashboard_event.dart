part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}


class networkUsageEvent extends DashboardEvent {
  final String did;
  
  const networkUsageEvent( {required this.did});
}
