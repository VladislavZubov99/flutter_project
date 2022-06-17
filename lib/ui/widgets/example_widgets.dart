import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:project/domain/blocs/user_cubit.dart';
import 'package:project/domain/blocs/users_bloc.dart';
import 'package:provider/provider.dart';

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UsersBlocState>(
      listener: (context, state) {
        print(state.currentUser.age);
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _AgeTitle(),
                SizedBox(height: 5),
                _AgeIncrementWidget(),
                SizedBox(height: 5),
                _AgeDecrementWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final age = context.select((UsersBloc bloc) => bloc.state.currentUser.age);
    return Text("$age");
    
    // return BlocBuilder<UsersBloc, UsersBlocState>(
    //   builder: (context, state) {
    //     final age = state.currentUser.age;
    //     return Text("$age");
    //   },
    // );
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();

    return ElevatedButton(
      onPressed: () => bloc.add(Increment()),
      child: const Text('+'),
    );
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();

    return ElevatedButton(
      onPressed: () => bloc.add(Decrement()),
      child: const Text('-'),
    );
  }
}
