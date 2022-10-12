import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/blocs/auth/auth_state.dart';
import 'package:project/domain/models/expand_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/combinations/combination_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/company_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/employees/employee_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/payers/payer_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/recipients/recipient_notifier.dart';
import 'package:project/domain/modules/dashboard_management/models/wage_types/wage_type_notifier.dart';
import 'package:project/domain/modules/dashboard_management/state_machine/dashboard_management_notifier.dart';
import 'package:project/ui/widgets/screens/auth/login_view_cubit.dart';
import 'package:project/ui/widgets/screens/auth/login_widget.dart';
import 'package:project/ui/widgets/loader_widget/loader_view_cubit.dart';
import 'package:project/ui/widgets/screens/combinations_widget.dart';
import 'package:project/ui/widgets/screens/dashboard_management_widget/dashboard_management_widget.dart';
import 'package:project/ui/widgets/screens/home.dart';
import 'package:project/ui/widgets/loader_widget/loader_widget.dart';
import 'package:project/ui/widgets/screens/modules.dart';
import 'package:project/ui/widgets/screens/options.dart';

import 'package:project/domain/blocs/auth/auth_bloc.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  AuthBloc? _authBloc;

  Widget makeLoader() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    _authBloc = authBloc;
    return BlocProvider<LoaderViewCubit>(
      create: (context) =>
          LoaderViewCubit(LoaderViewCubitState.unknown, authBloc),
      lazy: false,
      child: const LoaderWidget(),
    );
  }

  Widget makeAuth() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    _authBloc = authBloc;
    return BlocProvider<AuthViewCubit>(
      create: (context) =>
          AuthViewCubit(AuthViewCubitFormFillInProgressState(), authBloc),
      child: const LoginScreen(),
    );
  }

  Widget makeMainScreen() {
    // Future.microtask(() {
    _authBloc?.close();
    _authBloc = null;
    // });

    return const HomeScreen();
  }

  Widget makeModulesScreen() {
    return const Modules();
  }

  Widget makeOptionsScreen() {
    return const Options();
  }

  Widget makeCombinationsScreen() {
    return const CombinationsScreen();
  }

  Widget makeDashboardManagementScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CompanyNotifier>(
            create: (_) => CompanyNotifier()),
        ChangeNotifierProvider<RecipientNotifier>(
            create: (_) => RecipientNotifier()),
        ChangeNotifierProvider<PayerNotifier>(create: (_) => PayerNotifier()),
        ChangeNotifierProvider<CombinationNotifier>(
            create: (_) => CombinationNotifier()),
        ChangeNotifierProvider<EmployeeNotifier>(
            create: (_) => EmployeeNotifier()),
        ChangeNotifierProvider<WageTypeNotifier>(
            create: (_) => WageTypeNotifier()),
        ChangeNotifierProvider<DashboardManagementMachineNotifier>(
            create: (_) => DashboardManagementMachineNotifier()),
        ChangeNotifierProvider<ExpandNotifier>(create: (_) => ExpandNotifier())
      ],
      child: const DashboardManagementWidget(),
    );
  }
}
