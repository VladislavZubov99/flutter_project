part of 'dashboard_management_cubit.dart';

abstract class DashboardManagementState extends Equatable {}

class DashboardManagementInitial extends DashboardManagementState {
  @override
  List<Object> get props => [];
}

class DashboardManagementLoading extends DashboardManagementState {
  @override
  List<Object> get props => [];
}

class DashboardManagementSuccess extends DashboardManagementState {
  final Companies companies;

  DashboardManagementSuccess({required this.companies});

  @override
  List<Object> get props => [companies];

  DashboardManagementSuccess copyWith({
    Companies? companies,
  }) {
    return DashboardManagementSuccess(
      companies: companies ?? this.companies,
    );
  }
}

class DashboardManagementFailure extends DashboardManagementState {
  final Object error;

  DashboardManagementFailure(this.error);

  @override
  List<Object> get props => [error];
}
