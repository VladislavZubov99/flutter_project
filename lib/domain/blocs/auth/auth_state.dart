import 'package:equatable/equatable.dart';

enum AuthStateStatus { authorized, notAuthorized, inProgress }

abstract class AuthState extends Equatable{}

class AuthUnauthorizedState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthAuthorizedState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthFailedState extends AuthState {
  final Object error;

  AuthFailedState(this.error);

  @override
  List<Object> get props => [error];
}

class AuthInProgressState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthCheckStatusInProgressState extends AuthState {
  @override
  List<Object> get props => [];
}

