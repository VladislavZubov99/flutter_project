import 'package:flutter/material.dart';
import 'package:project/domain/factories/screen_factory.dart';
import 'package:project/ui/widgets/auth/login_widget.dart';
import 'package:project/ui/screens/home.dart';
import 'package:project/ui/screens/register.dart';

abstract class MainNavigationRouteNames {
  static const loaderWidget = '/';
  static const auth = '/auth';
  static const register = '/register';
  static const mainScreen = '/main_screen';
  static const userScreen = '/user_screen';
  static const userDetails = '/user_screen/user_details';
}

class MainNavigation {
  static final _screenFactory = ScreenFactory();

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.loaderWidget: (_) => _screenFactory.makeLoader(),
    MainNavigationRouteNames.auth: (_) => _screenFactory.makeAuth(),
    MainNavigationRouteNames.register: (context) => const RegisterScreen(),
    MainNavigationRouteNames.mainScreen: (_) => _screenFactory.makeMainScreen(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case MainNavigationRouteNames.userDetails:
      //   final arguments = settings.arguments;
      //   final userId = arguments is int ? arguments : 0;
      //   return MaterialPageRoute(builder: (context) => UserDetailsScreen(userId: userId));
      default:
        const widget = Text('Page not found: 404');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }

  static void resetNavigation(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRouteNames.loaderWidget,
      (route) => false,
    );
  }
}
