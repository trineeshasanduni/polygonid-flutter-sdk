part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

// final class DashboardUserAdded extends DashboardState {
//   final List<UserEntity> users;

//   const DashboardUserAdded(this.users);

//   @override
//   List<Object> get props => [users];
// }

final class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}


