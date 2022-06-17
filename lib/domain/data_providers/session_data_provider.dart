import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const accessToken = 'accessToken';
}

class SessionDataProvider {
  static const _secureStorage = FlutterSecureStorage();

  Future<String?> getAccessToken() =>
      _secureStorage.read(key: _Keys.accessToken);

  Future<void> setAccessToken(String value) {
    return _secureStorage.write(key: _Keys.accessToken, value: value);
  }

  Future<void> deleteAccessToken() {
    return _secureStorage.delete(key: _Keys.accessToken);
  }
}
