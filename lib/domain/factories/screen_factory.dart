import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/domain/blocs/auth/auth_state.dart';
import 'package:project/ui/widgets/screens/auth/login_view_cubit.dart';
import 'package:project/ui/widgets/screens/auth/login_widget.dart';
import 'package:project/ui/widgets/loader_widget/loader_view_cubit.dart';
import 'package:project/ui/widgets/screens/combinations_widget.dart';
import 'package:project/ui/widgets/screens/dashborad_management/dashboard_management_widget.dart';
import 'package:project/ui/widgets/screens/home.dart';
import 'package:project/ui/widgets/loader_widget/loader_widget.dart';
import 'package:project/ui/widgets/screens/modules.dart';
import 'package:project/ui/widgets/screens/options.dart';

import '../blocs/auth/auth_bloc.dart';

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
    return const DashboardManagementWidget();
  }
}
