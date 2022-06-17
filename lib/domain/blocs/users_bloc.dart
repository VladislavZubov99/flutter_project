import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:project/domain/data_providers/user_data_provider.dart';
import 'package:project/domain/entity/user.dart';

class UsersBlocState {
  final User currentUser;

  const UsersBlocState({
    required this.currentUser,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersBlocState &&
          runtimeType == other.runtimeType &&
          currentUser == other.currentUser);

  @override
  int get hashCode => currentUser.hashCode;

  @override
  String toString() {
    return 'UsersState{ currentUser: $currentUser,}';
  }

  UsersBlocState copyWith({
    User? currentUser,
  }) {
    return UsersBlocState(
      currentUser: currentUser ?? this.currentUser,
    );
  }
}

abstract class UsersEvents {}

class Increment extends UsersEvents {}

class Decrement extends UsersEvents {}

class Initialize extends UsersEvents {}

class UsersBloc extends Bloc<UsersEvents, UsersBlocState> {
  final _userDataProvider = UserDataProvider();

  UsersBloc() : super(UsersBlocState(currentUser: User(0))) {
    on<UsersEvents>(_setupEvents, transformer: sequential());
    add(Initialize());
  }

  FutureOr<void> _setupEvents(UsersEvents event, Emitter<UsersBlocState> emit) async {
    if(event is Initialize) {
      await _onInitialize(event, emit);
    } else if (event is Increment) {
      await _onIncrement(event, emit);
    } else if (event is Decrement) {
      await _onDecrement(event, emit);
    }
  }
  /*
  UsersBloc() : super(UsersBlocState(currentUser: User(0))) {
    _setupEvents();
    add(Initialize());
  }

  void _setupEvents() {
    on<Initialize>(_onInitialize);
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
  }
  */
  FutureOr<void> _onDecrement(Decrement event, Emitter<UsersBlocState> emit) async {
    var user = state.currentUser;
    user = user.copyWith(age: user.age - 1);
    await _userDataProvider.saveValue(user);
    emit(UsersBlocState(currentUser: user));
  }

  FutureOr<void> _onIncrement(Increment event, Emitter<UsersBlocState> emit) async {
    var user = state.currentUser;
    user = user.copyWith(age: user.age + 1);
    await _userDataProvider.saveValue(user);
    emit(UsersBlocState(currentUser: user));
  }

  FutureOr<void> _onInitialize(Initialize event, Emitter<UsersBlocState> emit) async {
    final user = await _userDataProvider.loadValue();
    emit(UsersBlocState(currentUser: user));
  }
  
}
