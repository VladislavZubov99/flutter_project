import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project/domain/data_providers/session_data_provider.dart';

class ApiClient {
  final _sessionDataProvider = SessionDataProvider();
  final _dio = Dio();
  static const _host = 'https://d9a5-95-174-105-30.ngrok.io/api';
  // static const _host = 'http://localhost:8080/api';

  Future<String> makeAccessToken(
      {required String login, required String password}) async {
    try {
      final parameters = <String, String>{
        'email': login,
        'password': password,
      };
      print('makeAccessToken');

      final response = await _dio.post('$_host/auth/sign_in',
          data: parameters);


      print({'response', response});
      final json = response.data as Map<String, dynamic>;

      final token = json['token'] as String;

      return token;
    } on SocketException {
      print('network');

      throw ApiClientException(ApiClientExceptionType.network);
    } on ApiClientException {
      rethrow;
    } catch (_) {
      print('other');
      throw ApiClientException(ApiClientExceptionType.other);
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final accessToken = await _sessionDataProvider.getAccessToken();
    final response = await _dio.get('$_host/users/profile', options: Options(
      headers: {
        'Authorization': accessToken
      }
    ));

    final json = response.data as Map<String, dynamic>;

    if (response.statusCode == 401) {
      throw ApiClientException(ApiClientExceptionType.auth,
          message: json['message']);
    }

    return json;
  }

  //
  // final String _endpoint = 'http://localhost:8080/api';
  //
  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic>? userData) async {
    try {
      Response response = await _dio.post(
        '$_host/auth/sign_up',
        data: userData,
      );

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
//
// Future<Map<String, dynamic>> login(String email, String password) async {
//   try {
//     Response response = await _dio.post(
//       '$_endpoint/auth/sign_in',
//       data: {
//         'email': email,
//         'password': password,
//       },
//       options: Options(headers: {
//         'Authorization': 'authKey',
//       }),
//     );
//
//     return response.data;
//   } on DioError catch (e) {
//     return e.response!.data;
//   }
// }
//
// Future<Map<String, dynamic>> getUserProfile() async {
//   try {
//     const String authToken = '123';
//
//     Response response = await _dio.get('$_endpoint/users/profile',
//         options: Options(headers: {'Authorization': authToken}));
//
//     return response.data;
//   } on DioError catch (e) {
//     return e.response!.data;
//   }
// }

}

enum ApiClientExceptionType { network, auth, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;
  final String? message;

  ApiClientException(this.type, {this.message = ''});
}
