import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project/domain/data_providers/session_data_provider.dart';

class ApiSettings {
  final String _accessToken =
      'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InRXTVZuUUlHT1ZTbGZFbXRGdUpnaUEiLCJ0eXAiOiJhdCtqd3QifQ.eyJuYmYiOjE2NjI2Mjg3NjEsImV4cCI6MTY2MjgwMTU2MSwiaXNzIjoiaHR0cHM6Ly9lYXJ0aC1pZGVudGl0eXNlcnZlcnNlcnZpY2UuYXp1cmV3ZWJzaXRlcy5uZXQiLCJhdWQiOiJlYXJ0aEFQSVNjb3BlIiwiY2xpZW50X2lkIjoiZWFydGhEZXZlbG9wQ29kZSIsInN1YiI6IjllZDMyMjExLWY0NjktNDEyZS04N2MzLTBmNmZlZjUzYjlkZCIsImF1dGhfdGltZSI6MTY2MjU1MTYzNCwiaWRwIjoibG9jYWwiLCJmYW1pbHlfbmFtZSI6IlJ5dCIsImdpdmVuX25hbWUiOiJNYXgiLCJzYXBoaXJfY3VzdG9tZXJfbnVtYmVyIjoiOTk5OTk5OTMiLCJyb2xlIjoiUHJldmlld19BY2Nlc3MiLCJlbWFpbCI6Im1yeXR3aW5za2lAc2FwaGlyLXNvZnR3YXJlLmRlIiwic2NvcGUiOlsib3BlbmlkIiwiZWFydGhBUElTY29wZSIsIm9mZmxpbmVfYWNjZXNzIl0sImFtciI6WyJwd2QiXX0.OsvmF2bFSvnrzaCLiCjatEMns54swGawOvTCZzkQQ_obqGCd7x7A9321rHxlh_tzZhvd0HQBmCKRdz-9J8qQO0hErsnIh0RW7z-U0dHxoWL49rHl1-8djPXs3EO1MK_s1JqSuOncl7mll6V27dEtmN2EZOnkkTsSzRnVscowlD2bllKRogKEcrSjmz04uBXTYOQhkUCsggY7czc5q1McojYIMnYHUrtHgiN9jCtMwEPeHhaGzMZYecgkWAb8bgN4aJmQzTKpcGo_1GUSsv1_ajuW1kLUczSiDCMslqS9wQUWzdeqlDrKz3a8AADwWDf2aEoiMPcKBHiFLNTvWPrnUA';

  final String _programModuleId = '2483ef46-be8e-4bec-be6c-78be62f868c7';
  final String _tenantId = 'bd04b2ec-6ff8-4fab-8135-d21a4a3d2aa7';

  // final String;

  getAuthorizedHeaders() {
    return {
      'Authorization': _accessToken,
      'X-PROGRAMMODULE-ID': _programModuleId,
      'X-TENANT-ID': _tenantId,
    };
  }

  static String allCombinationsEndpoint =
      'https://earth-appservice.azurewebsites.net/api/v1/1/time-management/combination/get-all-combinations-by-payer-grouping?recipientId=27&page=1&pagesize=40&startDate=2022/09/01';
}

class BaseApiClient {
  final _sessionDataProvider = SessionDataProvider();
  final _dio = Dio();

  static final _apiSettings = ApiSettings();

  final _authorizedDio = Dio(
    BaseOptions(
      headers: _apiSettings.getAuthorizedHeaders(),
    ),
  );

  static const _host = 'https://d9a5-95-174-105-30.ngrok.io/api';
}

class ApiClient extends BaseApiClient {
  Future<String> makeAccessToken(
      {required String login, required String password}) async {
    try {
      return Future.delayed(const Duration(milliseconds: 2000), () {
        if (login == 'admin@test.it' && password == '123456') {
          return 'logged';
        } else {
          throw ApiClientException(ApiClientExceptionType.auth);
        }
      });

      // final parameters = <String, String>{
      //   'email': login,
      //   'password': password,
      // };
      // print('makeAccessToken');
      //
      // final response = await _dio.post('$_host/auth/sign_in',
      //     data: parameters);
      //
      //
      // print({'response', response});
      // final json = response.data as Map<String, dynamic>;
      //
      // final token = json['token'] as String;
      //
      // return token;
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
    final response = await _dio.get('${BaseApiClient._host}/users/profile',
        options: Options(headers: {'Authorization': accessToken}));

    final json = response.data as Map<String, dynamic>;

    if (response.statusCode == 401) {
      throw ApiClientException(ApiClientExceptionType.auth,
          message: json['message']);
    }

    return json;
  }

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic>? userData) async {
    try {
      Response response = await _dio.post(
        '${BaseApiClient._host}/auth/sign_up',
        data: userData,
      );

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  getData() async {
    try {
      Response response = await _authorizedDio.post(
        ApiSettings.allCombinationsEndpoint,
        data: {
          "positive": true,
          "negative": true,
          "zero": true,
          "isProcessed": true,
        },
      );

      print(response.data);

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}

enum ApiClientExceptionType { network, auth, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;
  final String? message;

  ApiClientException(this.type, {this.message});
}
