enum AuthStateStatus { authorized, notAuthorized, inProgress }

abstract class AuthState {}

class AuthUnauthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUnauthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthAuthorizedState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAuthorizedState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthFailedState extends AuthState {
  final Object error;

  AuthFailedState(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthFailedState &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}

class AuthInProgressState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthInProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthCheckStatusInProgressState extends AuthState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCheckStatusInProgressState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

