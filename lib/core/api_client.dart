import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project/domain/data_providers/session_data_provider.dart';
import 'package:project/domain/models/dashboard_management/companies.dart';

class ApiSettings {
  final String _accessToken =
      'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InRXTVZuUUlHT1ZTbGZFbXRGdUpnaUEiLCJ0eXAiOiJhdCtqd3QifQ.eyJuYmYiOjE2NjMxNDUyODEsImV4cCI6MTY2MzMxODA4MSwiaXNzIjoiaHR0cHM6Ly9lYXJ0aC1pZGVudGl0eXNlcnZlcnNlcnZpY2UuYXp1cmV3ZWJzaXRlcy5uZXQiLCJhdWQiOiJlYXJ0aEFQSVNjb3BlIiwiY2xpZW50X2lkIjoiZWFydGhEZXZlbG9wQ29kZSIsInN1YiI6IjllZDMyMjExLWY0NjktNDEyZS04N2MzLTBmNmZlZjUzYjlkZCIsImF1dGhfdGltZSI6MTY2MzE0NTI3NCwiaWRwIjoibG9jYWwiLCJmYW1pbHlfbmFtZSI6IlJ5dCIsImdpdmVuX25hbWUiOiJNYXgiLCJzYXBoaXJfY3VzdG9tZXJfbnVtYmVyIjoiOTk5OTk5OTMiLCJyb2xlIjoiUHJldmlld19BY2Nlc3MiLCJlbWFpbCI6Im1yeXR3aW5za2lAc2FwaGlyLXNvZnR3YXJlLmRlIiwic2NvcGUiOlsib3BlbmlkIiwiZWFydGhBUElTY29wZSIsIm9mZmxpbmVfYWNjZXNzIl0sImFtciI6WyJwd2QiXX0.B6pVGj9Bx92rGE5L8Urzslgsbf783Qpb0I2kAaf9Lq9sJSVD9KtrGyNwu868dH-uH7jjlsNAGDdr8hcQh7bAOdGzu3xUC-sFhnK4eAoMC8vmibTRthAXgmPqVDMGYj1gOOMse-psPLx_ibyPY3pbF0Ac15UYxqlk6EEdu1WEL4kZZ60sDzaYPWP-7BPWI5_XTwNuRhLPJNK8QztuotdqwEIYx9NUSUUMfPnkTQZkzUoKPyOoFaZF3PMMc8Ndpes0RsNQENyA9A2UsOigfKjx_xxq1it43q2Z_aF1UcVglbExXenOcwKbfPBUT00qyXuoeKGxDEO-XCgjG-dC_6W4sg';

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

  static String companiesView =
      'https://earth-appservice.azurewebsites.net/api/v1/1/time-management/saphir5/plan-management/companies-view';
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

  Future<Companies> getCompanies() async {
      Response response = await _authorizedDio.post(
        ApiSettings.companiesView,
        data: {
          "dateRange": [],
          "page": 1,
          "pageSize": 300,
          "sortField": "name",
          "orderByDesc": true
        },
      );

      final companies = Companies.fromJson(response.data);
      print(companies);
      return companies;
  }
}

enum ApiClientExceptionType { network, auth, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;
  final String? message;

  ApiClientException(this.type, {this.message});
}
