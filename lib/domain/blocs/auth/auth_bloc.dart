import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/blocs/auth/auth_events.dart';
import 'package:project/domain/blocs/auth/auth_state.dart';
import 'package:project/domain/data_providers/session_data_provider.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  AuthBloc(AuthState initialState) : super(initialState) {
    on<AuthEvents>(_setupEvents, transformer: sequential());
    add(AuthCheckStatusEvent());
  }

  FutureOr<void> _setupEvents(AuthEvents event, Emitter<AuthState> emit) async {
    if (event is AuthLoginEvent) {
      await _onLogin(event, emit);
    } else if (event is AuthLogoutEvent) {
      await _onLogout(event, emit);
    } else if (event is AuthCheckStatusEvent) {
      await _onCheckStatus(event, emit);
    }
  }

  FutureOr<void> _onLogin(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthInProgressState());
      final accessToken = await _apiClient.makeAccessToken(
        login: event.login,
        password: event.password,
      );
      await _sessionDataProvider.setAccessToken(accessToken);
      emit(AuthAuthorizedState());
    } catch (e) {
      emit(AuthFailedState(e));
    }

    // on ApiClientException catch (e) {
    //   var error = "";
    //   switch (e.type) {
    //     case ApiClientExceptionType.network:
    //       return "Server is not available. Check network connection";
    //     case ApiClientExceptionType.auth:
    //       return e.message ?? "Login or/and Password is not correct";
    //     case ApiClientExceptionType.other:
    //       return "Something is happened. Try it again";
    //   }
    // }
  }

  FutureOr<void> _onLogout(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _sessionDataProvider.deleteAccessToken();
      emit(AuthUnauthorizedState());
    } catch (e) {
      emit(AuthFailedState(e));
    }
  }

  FutureOr<void> _onCheckStatus(
      AuthCheckStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthInProgressState());
    final sessionId = await _sessionDataProvider.getAccessToken();
    final newState =
        sessionId != null ? AuthAuthorizedState() : AuthUnauthorizedState();
    emit(newState);
  }
}
