import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/core/api_client.dart';
import 'package:project/ui/navigation/main_navigation.dart';
import 'package:project/ui/screens/home.dart';
import 'package:project/ui/widgets/auth/login_view_cubit.dart';
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
      listenWhen: (_, current) => current is AuthViewCubitAuthSuccessState,
      child: Provider<_AuthDataStorage>(
          create: (_) => _AuthDataStorage(), child: const _LoginWidget()),
    );
  }

  void _onStateChange(BuildContext context, AuthViewCubitState state) {
    MainNavigation.resetNavigation(context);
  }
}

class _LoginWidget extends StatefulWidget {
  const _LoginWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<_LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final ApiClient _apiClient = ApiClient();

  //
  // Future<void> login() async {
  //   if (_formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text('Processing Data'),
  //       backgroundColor: Colors.green.shade300,
  //     ));
  //
  //     String res = await _apiClient.makeAccessToken(
  //       login: emailController.text,
  //       password: passwordController.text,
  //     );
  //
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //
  //     unawaited(Navigator.of(context)
  //         .pushReplacementNamed(MainNavigationRouteNames.mainScreen));
  //     // if (res['message'] == null) {
  //     //   String accessToken = res['token'] as String;
  //     //
  //     // } else {
  //     //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     //     content: Text('Error: ${res['message']}'),
  //     //     backgroundColor: Colors.red.shade300,
  //     //   ));
  //     // }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final authDataStorage = context.read<_AuthDataStorage>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/background_wave.png'),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            const _Header(),
            Form(
              key: _formKey,
              child: Stack(children: [
                SizedBox(
                  width: size.width,
                  height: size.height - 240,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 0.85,
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.8),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // SizedBox(height: size.height * 0.08),
                              SizedBox(
                                height: 70,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff2f2f2),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade500,
                                          offset: const Offset(0, .5),
                                          spreadRadius: 0),
                                    ],
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(3),
                                      topLeft: Radius.circular(3),
                                    ),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.04,
                                    vertical: size.height * 0.04),
                                child: Column(
                                  children: [
                                    const _DecoratedEmailTextField(),
                                    SizedBox(height: size.height * 0.04),
                                    _DecoratedPasswordTextField(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 70,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: const Color(0xfff2f2f2),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade500,
                                            offset: const Offset(0, -.5),
                                            spreadRadius: 0),
                                      ],
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(3),
                                        bottomLeft: Radius.circular(3),
                                      ),
                                      border: Border.all(
                                          color: Colors.transparent)),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          _AuthButtonWidget(formKey: _formKey)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            const _Footer(),
          ],
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Processing Data'),
          backgroundColor: Colors.green.shade300,
        ));

        authViewCubit.auth(
            login: authDataStorage.login, password: authDataStorage.password);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // if (res['message'] == null) {
        //   String accessToken = res['token'] as String;
        //
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text('Error: ${res['message']}'),
        //     backgroundColor: Colors.red.shade300,
        //   ));
        // }
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
              color: Colors.black,
            ),
          );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: const Color(0xffdddddd),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: Colors.grey.withOpacity(0.8),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: SizedOverflowBox(
        size: const Size.fromHeight(50),
        alignment: Alignment.topCenter,
        child: TextFormField(
          onChanged: (text) => authDataStorage.login = text,
          validator: (value) {
            return Validator.validateEmail(value ?? "");
          },
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 1),
              child: SizedBox(
                width: 50,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xfff2f2f2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          offset: const Offset(2, 0),
                          spreadRadius: 0),
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(3),
                      topLeft: Radius.circular(3),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            fillColor: Colors.white,
            hintText: "Email",
            isDense: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
            ),
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: Colors.grey.withOpacity(0.8),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: SizedOverflowBox(
        size: const Size.fromHeight(50),
        alignment: Alignment.topCenter,
        child: TextFormField(
          obscureText: !_showPassword,
          onChanged: (text) => authDataStorage.password = text,
          validator: (value) {
            return Validator.validatePassword(value ?? "");
          },
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 1),
              child: SizedBox(
                width: 50,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xfff2f2f2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          offset: const Offset(2, 0),
                          spreadRadius: 0),
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(3),
                      topLeft: Radius.circular(3),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(() {
                _showPassword = !_showPassword;
              }),
              behavior: HitTestBehavior.translucent,
              child: AbsorbPointer(
                child: Container(
                  child: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            hintText: "Password",
            isDense: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
            ),
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
        height: 200,
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
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 200,
                    height: 140,
                    child: SvgPicture.asset('assets/saphir_logo.svg'),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class _Footer extends StatelessWidget {
  const _Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
        width: size.width,
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: size.width,
            decoration: const BoxDecoration(
              color: Color(0xff1e988a),
            ),
          ),
        ));
  }
}
