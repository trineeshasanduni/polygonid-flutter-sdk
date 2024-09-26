part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}


class addUserEvent extends DashboardEvent {
  final String Commitment;
  final String Did;
  final String NullifierHash;
  final String Owner;
  const addUserEvent( {required this.Commitment,required this.Did, required this.NullifierHash, required this.Owner});
}
