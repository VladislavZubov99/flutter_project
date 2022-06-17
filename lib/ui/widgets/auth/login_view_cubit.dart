import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/core/api_client.dart';
import 'package:project/domain/blocs/auth/auth_bloc.dart';
import 'package:project/domain/blocs/auth/auth_events.dart';
import 'package:project/domain/blocs/auth/auth_state.dart';


abstract class AuthViewCubitState {}


class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitFormFillInProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitAuthErrorState extends AuthViewCubitState {
  final String errorMessage;

  AuthViewCubitAuthErrorState(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthErrorState &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;
}

class AuthViewCubitAuthProgressState extends AuthViewCubitState {

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitAuthSuccessState extends AuthViewCubitState {

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthSuccessState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authBlocSubscription;

  AuthViewCubit(AuthViewCubitState initialState, this.authBloc)
      : super(initialState) {
    _onState(authBloc.state);
    authBlocSubscription = authBloc.stream.listen(_onState);
  }


  void auth({required String login, required String password}) {
    if(!_isValid(login, password)) {
      emit(AuthViewCubitAuthErrorState('Please provide login an password'));
    }
    authBloc.add(AuthLoginEvent(login: login, password: password));
  }

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;


  void _onState(AuthState state) {
    if (state is AuthAuthorizedState) {
      authBlocSubscription.cancel();
      emit(AuthViewCubitAuthSuccessState());
    } else if (state is AuthUnauthorizedState) {
      emit(AuthViewCubitFormFillInProgressState());
    } else if (state is AuthInProgressState || state is AuthCheckStatusEvent) {
      emit(AuthViewCubitAuthProgressState());
    } else if (state is AuthFailedState) {
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewCubitAuthErrorState(message));
    }
  }

  @override
  Future<void> close() {
    authBlocSubscription.cancel();
    return super.close();
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
     return "Something is happened. Try it again, please";
    }

    switch (error.type) {
      case ApiClientExceptionType.network:
        return "Server is not available. Check network connection";
      case ApiClientExceptionType.auth:
        return error.message ?? "Login or/and Password is not correct";
      case ApiClientExceptionType.other:
        return "Something is happened. Try it again";
    }
  }
}
