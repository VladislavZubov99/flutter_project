import 'package:project/domain/data_providers/session_data_provider.dart';

class MyAppModel {
  final _sessionDataProvider = SessionDataProvider();

  var _isAuth = false;

  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final accessToken = await _sessionDataProvider.getAccessToken();
    _isAuth = accessToken != null;
  }
}