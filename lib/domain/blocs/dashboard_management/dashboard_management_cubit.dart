import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project/domain/models/dashboard_management/companies.dart';
import 'package:project/domain/models/dashboard_management/company_view.dart';

part 'dashboard_management_state.dart';

class DashboardManagementCubit extends Cubit<DashboardManagementState> {
  DashboardManagementCubit() : super(DashboardManagementInitial());

  final List<String> dateRange = [];
  final int page = 1;
  final int pageSize = 5;

  void loadCompanies() {
    if( state is DashboardManagementLoading) return;
    final currentState = state;

    List<CompanyView> oldCompaniesList = [];
    if( currentState is DashboardManagementSuccess) {
      oldCompaniesList = currentState.companies.companiesList;
    };

    emit(DashboardManagementLoading());

  }
}
