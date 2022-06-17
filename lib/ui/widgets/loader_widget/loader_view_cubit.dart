import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:project/domain/blocs/auth/auth_events.dart';
import 'package:project/domain/blocs/auth/auth_state.dart';
import 'package:project/domain/data_providers/session_data_provider.dart';

import '../../../domain/blocs/auth/auth_bloc.dart';

enum LoaderViewCubitState { unknown, authorized, notAuthorized }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  LoaderViewCubit(LoaderViewCubitState initialState, this.authBloc)
      : super(initialState) {

    // final session = SessionDataProvider();
    // session.deleteAccessToken();
    Future.microtask(() {
      _onState(authBloc.state);
      authBlocSubscription = authBloc.stream.listen(_onState);
      authBloc.add(AuthCheckStatusEvent());
    });
  }

  void _onState(AuthState state) {
    print({'_onState', state});
    if (state is AuthAuthorizedState) {
      print('worked');

      emit(LoaderViewCubitState.authorized);
    } else if (state is AuthUnauthorizedState) {
      emit(LoaderViewCubitState.notAuthorized);
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }
}
