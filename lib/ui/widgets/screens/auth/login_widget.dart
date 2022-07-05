import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/ui/navigation/main_navigation.dart';
import 'package:project/ui/widgets/screens/auth/login_view_cubit.dart';
import 'package:project/utils/validator.dart';
import 'package:provider/provider.dart';

class _AuthDataStorage {
  String login = "";
  String password = "";
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewCubit, AuthViewCubitState>(
      listener: _onStateChange,
      child: Provider<_AuthDataStorage>(
          create: (_) => _AuthDataStorage(), child: const _LoginWidget()),
    );
  }

  void _onStateChange(BuildContext context, AuthViewCubitState state) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (state is AuthViewCubitAuthSuccessState) {
      MainNavigation.resetNavigation(Navigator.of(context));
    } else if (state is AuthViewCubitAuthErrorState) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(state.errorMessage),
      //   backgroundColor: Colors.red.shade300,
      // ));
    }
    if (state is AuthViewCubitAuthProgressState) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));
    }
  }
}

class _LoginWidget extends StatefulWidget {
  const _LoginWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<_LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff1e988a),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const _Header(),
              Container(
                height: size.height - 200,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(70)),
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/background_wave.png'),
                      fit: BoxFit.cover,
                    )),
                child: Form(
                  key: _formKey,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 40.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: size.height * 0.1),
                            const _DecoratedEmailTextField(),
                            SizedBox(height: size.height * 0.04),
                            _DecoratedPasswordTextField(),
                            SizedBox(height: size.height * 0.05),
                            SizedBox(
                                width: size.width,
                                child: _AuthButtonWidget(formKey: _formKey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const _AuthButtonWidget({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewCubit = context.watch<AuthViewCubit>();
    final authDataStorage = context.read<_AuthDataStorage>();

    final canStartAuth =
        authViewCubit.state is AuthViewCubitFormFillInProgressState ||
            authViewCubit.state is AuthViewCubitAuthErrorState;
    Future<void> login() async {
      if (formKey.currentState!.validate()) {
        authViewCubit.auth(
            login: authDataStorage.login, password: authDataStorage.password);
      }
    }

    final onPressed = canStartAuth ? login : null;

    final child = authViewCubit.state is AuthViewCubitAuthProgressState
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text(
            "Login",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: const Color(0xff1e988a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      ),
      child: child,
    );
  }
}

class _DecoratedEmailTextField extends StatelessWidget {
  const _DecoratedEmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authDataStorage = context.read<_AuthDataStorage>();
    final authViewCubit = context.watch<AuthViewCubit>();
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: const Color(0xff1e988a).withOpacity(0.3),
                offset: const Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 50)
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: SizedOverflowBox(
        size: const Size.fromHeight(59),
        alignment: Alignment.topCenter,
        child: TextFormField(
          onChanged: (text) => authDataStorage.login = text,
          validator: (value) {
            return Validator.validateEmail(value ?? "");
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorText: authViewCubit.state is AuthViewCubitAuthErrorState
                ? (authViewCubit.state as AuthViewCubitAuthErrorState)
                    .errorMessage
                : null,
            fillColor: Colors.white,
            hintText: "Email",
            isDense: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
      ),
    );
  }
}

class _DecoratedPasswordTextField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DecoratedPasswordTextFieldState();
}

class _DecoratedPasswordTextFieldState
    extends State<_DecoratedPasswordTextField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final authDataStorage = context.read<_AuthDataStorage>();
    final authViewCubit = context.watch<AuthViewCubit>();

    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: const Color(0xff1e988a).withOpacity(0.3),
                offset: const Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 50)
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: SizedOverflowBox(
        size: const Size.fromHeight(59),
        alignment: Alignment.topCenter,
        child: TextFormField(
          obscureText: !_showPassword,
          onChanged: (text) => authDataStorage.password = text,
          validator: (value) {
            return Validator.validatePassword(value ?? "");
          },
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            errorText: authViewCubit.state is AuthViewCubitAuthErrorState
                ? (authViewCubit.state as AuthViewCubitAuthErrorState)
                    .errorMessage
                : null,
            fillColor: Colors.white,
            suffixIcon: GestureDetector(
              onTap: () => setState(() {
                _showPassword = !_showPassword;
              }),
              behavior: HitTestBehavior.translucent,
              child: AbsorbPointer(
                child: Icon(
                  _showPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
              ),
            ),
            hintText: "Password",
            isDense: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
        width: size.width,
        height: 150,
        child: Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                color: Color(0xff1e988a),
              ),
              child: SizedBox(
                width: size.width,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    height: 100,
                    child: SvgPicture.asset('assets/saphir_logo.svg'),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
