import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/ui/widgets/loader_widget/loader_view_cubit.dart';
import 'package:project/ui/navigation/main_navigation.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit, LoaderViewCubitState>(
      listenWhen: (prev, current) => current != LoaderViewCubitState.unknown,
      listener: _onStateChange,
      child: const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }

  void _onStateChange(BuildContext context, LoaderViewCubitState state) {
    final nextScreen = state == LoaderViewCubitState.authorized
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
