import 'package:flutter/material.dart';
import 'package:project/domain/factories/screen_factory.dart';
import 'package:project/ui/widgets/screens/auth/login_widget.dart';
import 'package:project/ui/widgets/screens/home.dart';
import 'package:project/ui/widgets/screens/register.dart';

abstract class MainNavigationRouteNames {
  static const loaderWidget = '/loader_widget';
  static const auth = '/auth';
  static const register = '/register';
  static const mainScreen = '/main_screen';
  static const modulesScreen = '/main_screen/modules';
  static const optionsScreen = '/main_screen/modules/options';
  static const combinationsScreen = '/main_screen/modules/options/combinations';
  static const dashboardManagementScreen = '/main_screen/modules/options/dashboard_management';

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
    MainNavigationRouteNames.modulesScreen: (_) =>
        _screenFactory.makeModulesScreen(),
    MainNavigationRouteNames.optionsScreen: (_) =>
        _screenFactory.makeOptionsScreen(),
    MainNavigationRouteNames.combinationsScreen: (_) =>
        _screenFactory.makeCombinationsScreen(),
    MainNavigationRouteNames.dashboardManagementScreen: (_) =>
        _screenFactory.makeDashboardManagementScreen(),
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

  static void resetNavigation(NavigatorState state) {
    state.pushNamedAndRemoveUntil(
      MainNavigationRouteNames.loaderWidget,
      (route) => false,
    );
  }
}
