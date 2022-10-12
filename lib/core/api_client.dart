import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project/core/api_configurations.dart';
import 'package:project/domain/data_providers/session_data_provider.dart';
import 'package:project/domain/modules/dashboard_management/models/combinations/combinations_pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/companies/companies_pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/employees/employees_pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/payers/payers_pagination.dart';
import 'package:project/domain/modules/dashboard_management/models/wage_types/wage_types_pagination.dart';

import 'package:project/domain/modules/dashboard_management/models/recipients/recipients_pagination.dart';

import 'package:flutter_appauth/flutter_appauth.dart';


class ApiSettings {
  final _sessionDataProvider = SessionDataProvider();

  final String _accessToken =
      'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InRXTVZuUUlHT1ZTbGZFbXRGdUpnaUEiLCJ0eXAiOiJhdCtqd3QifQ.eyJuYmYiOjE2NjQ5NjQ4ODgsImV4cCI6MTY2NTEzNzY4OCwiaXNzIjoiaHR0cHM6Ly9lYXJ0aC1pZGVudGl0eXNlcnZlcnNlcnZpY2UuYXp1cmV3ZWJzaXRlcy5uZXQiLCJhdWQiOiJlYXJ0aEFQSVNjb3BlIiwiY2xpZW50X2lkIjoiZWFydGhEZXZlbG9wQ29kZSIsInN1YiI6IjllZDMyMjExLWY0NjktNDEyZS04N2MzLTBmNmZlZjUzYjlkZCIsImF1dGhfdGltZSI6MTY2NDk2NDg3OSwiaWRwIjoibG9jYWwiLCJmYW1pbHlfbmFtZSI6IlJ5dCIsImdpdmVuX25hbWUiOiJNYXgiLCJzYXBoaXJfY3VzdG9tZXJfbnVtYmVyIjoiOTk5OTk5OTMiLCJyb2xlIjoiUHJldmlld19BY2Nlc3MiLCJlbWFpbCI6Im1yeXR3aW5za2lAc2FwaGlyLXNvZnR3YXJlLmRlIiwic2NvcGUiOlsib3BlbmlkIiwiZWFydGhBUElTY29wZSIsIm9mZmxpbmVfYWNjZXNzIl0sImFtciI6WyJwd2QiXX0.dhAyXok2ZsDbnQ39w6MTzLQGqRLrYL4EoXFUqYIEykSHCfu-nqAenSGbcnviBTfsrd_hb1hJW6fRXJzZzNELb_girfCxcfCeexqIYQGCkWue42SsL5OTQkTiblR_sg9xgFfM6kkEWkKtfwJ3zqH78B7Q75NY1HNZq_9fY7t4iF-7MyfTktEcwR0tBgYvIxvJTZYlw01B4SmAkCzH8VmzhoT705uW9RAY3wzzDZ3oEGhbOp_OLwEXE_e-M2N4EBtiIW6kGJMqbE694n1VE3zlzOEKqAXe4jdrWxUo6-_onfz5MshM-Hv7C4JJNRri_tPSzPPOmh5jIpoeFGO3ZtVlbw';

  final String _programModuleId = '2483ef46-be8e-4bec-be6c-78be62f868c7';
  final String _tenantId = 'bd04b2ec-6ff8-4fab-8135-d21a4a3d2aa7';

  // final String;

  Future<Map<String, String>> getAuthorizedHeaders() async {
    final accessToken = await _sessionDataProvider.getAccessToken();
    return {
      'Authorization': accessToken ?? '',
      'X-PROGRAMMODULE-ID': _programModuleId,
      'X-TENANT-ID': _tenantId,
    };
  }

  static String companiesView =
      'https://earth-appservice.azurewebsites.net/api/v1/1/time-management/saphir5/plan-management/companies-view';
  static String combinationsView =
      'https://earth-appservice.azurewebsites.net/api/v1/1/time-management/saphir5/plan-management/combinations-view';
  static String employeesView =
      'https://earth-appservice.azurewebsites.net/api/v1/1/time-management/saphir5/plan-management/employees-view';
  static String wageTypesView =
      'https://earth-appservice.azurewebsites.net/api/v1/1/time-management/saphir5/plan-management/wagetypes-view';
  static String recipientsView =
      'https://earth-appservice.azurewebsites.net/api/v1/1/time-management/saphir5/plan-management/recipients-view';
  static String payersView =
      'https://earth-appservice.azurewebsites.net/api/v1/1/time-management/saphir5/plan-management/payers-view';
  static String allCombinationsEndpoint =
      'https://earth-appservice.azurewebsites.net/api/v1/1/time-management/combination/get-all-combinations-by-payer-grouping?recipientId=27&page=1&pagesize=40&startDate=2022/09/01';
}

class BaseApiClient {
  final _sessionDataProvider = SessionDataProvider();
  final _dio = Dio();

  static final _apiSettings = ApiSettings();

  getAuthorizedDio() async {
    final headers = await _apiSettings.getAuthorizedHeaders();
    return Dio(
      BaseOptions(
        headers: headers,
      ),
    );
  }

  static const _host = 'https://d9a5-95-174-105-30.ngrok.io/api';
}

class ApiClient extends BaseApiClient {
  Future<String> makeAccessToken(
      {required String login, required String password}) async {
    final accessToken = await _sessionDataProvider.getAccessToken();
    try {
      return Future.delayed(const Duration(milliseconds: 2000), () {
        if (login == 'admin@test.it' && password == '123456') {
          return accessToken ?? 'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InRXTVZuUUlHT1ZTbGZFbXRGdUpnaUEiLCJ0eXAiOiJhdCtqd3QifQ.eyJuYmYiOjE2NjQ5NzQ0NzksImV4cCI6MTY2NTE0NzI3OSwiaXNzIjoiaHR0cHM6Ly9lYXJ0aC1pZGVudGl0eXNlcnZlcnNlcnZpY2UuYXp1cmV3ZWJzaXRlcy5uZXQiLCJhdWQiOiJlYXJ0aEFQSVNjb3BlIiwiY2xpZW50X2lkIjoiZWFydGhEZXZlbG9wQ29kZSIsInN1YiI6IjllZDMyMjExLWY0NjktNDEyZS04N2MzLTBmNmZlZjUzYjlkZCIsImF1dGhfdGltZSI6MTY2NDk2NDg3OSwiaWRwIjoibG9jYWwiLCJmYW1pbHlfbmFtZSI6IlJ5dCIsImdpdmVuX25hbWUiOiJNYXgiLCJzYXBoaXJfY3VzdG9tZXJfbnVtYmVyIjoiOTk5OTk5OTMiLCJyb2xlIjoiUHJldmlld19BY2Nlc3MiLCJlbWFpbCI6Im1yeXR3aW5za2lAc2FwaGlyLXNvZnR3YXJlLmRlIiwic2NvcGUiOlsib3BlbmlkIiwiZWFydGhBUElTY29wZSIsIm9mZmxpbmVfYWNjZXNzIl0sImFtciI6WyJwd2QiXX0.Zf1RnBmBbtFiujGCoxdcmmAyD9q9M3hf0lsRAkgoKiBdKApmJt19yGDzfwO9sQmV_LUid1nQoaPsozM0R4xm0-uqnCh0Gv26s7LYTouo4UVoL_GLOMx6VogBGf6j4FcfwQN4rgOKwVQx1gBjCRkakYW1EI3SLHFAAMxLcJnP8GbIj5tqo6Kpd0iYOmHCY_bmL1qBjLftnBTJhAL5wWS46Y1sSkvLvBFuqsRhqJFb7ulie2soCM2oiRQv4pRo_c_ZOXw9hijAAoljP1IJYFlT4seJVT7tX22oL2wOJ758ux-PCBAr8N6vtNW3qGIGW0_ZFrchJc2PggDNBKBeu7n7Jw';
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

  Future<CompaniesWithPagination> getCompanies({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    try {
      final authorizedDio = await getAuthorizedDio();
      Response response = await authorizedDio.post(
        ApiSettings.companiesView,
        data: configuration.body,
      );

      final companies = CompaniesWithPagination.fromJson(response.data);
      return companies;
    } on DioError catch (e) {
      print(e.message);
      throw ApiClientException(ApiClientExceptionType.other, message: e.message);
    }
  }

  Future<RecipientsWithPagination> getRecipients({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    try {
      final authorizedDio = await getAuthorizedDio();
      Response response = await authorizedDio.post(
        ApiSettings.recipientsView,
        data: configuration.body,
      );
      final recipients = RecipientsWithPagination.fromJson(response.data);
      return recipients;
    } on DioError catch (e) {
      print(e.message);

      throw ApiClientException(ApiClientExceptionType.other, message: e.message);
    }
  }

  Future<PayersWithPagination> getPayers({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    try {
      final authorizedDio = await getAuthorizedDio();
      Response response = await authorizedDio.post(
        ApiSettings.payersView,
        data: configuration.body,
      );

      final payers = PayersWithPagination.fromJson(response.data);
      return payers;
    } on DioError catch (e) {
      print(e.message);

      throw ApiClientException(ApiClientExceptionType.other, message: e.message);
    }
  }

  Future<CombinationsWithPagination> getCombinations({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    try {
      final authorizedDio = await getAuthorizedDio();
      Response response = await authorizedDio.post(
        ApiSettings.combinationsView,
        data: configuration.body,
      );

      final combinations = CombinationsWithPagination.fromJson(response.data);
      return combinations;
    } on DioError catch (e) {
      print(e.message);

      throw ApiClientException(ApiClientExceptionType.other, message: e.message);
    }
  }

  Future<EmployeesWithPagination> getEmployees({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    try {
      final authorizedDio = await getAuthorizedDio();
      Response response = await authorizedDio.post(
        ApiSettings.employeesView,
        data: configuration.body,
      );

      final employees = EmployeesWithPagination.fromJson(response.data);
      return employees;
    } on DioError catch (e) {
      print(e.message);

      throw ApiClientException(ApiClientExceptionType.other, message: e.message);
    }
  }

  Future<WageTypesWithPagination> getWageTypes({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    try {
      final authorizedDio = await getAuthorizedDio();
      Response response = await authorizedDio.post(
        ApiSettings.wageTypesView,
        data: configuration.body,
      );

      final wageTypes = WageTypesWithPagination.fromJson(response.data);
      return wageTypes;
    } on DioError catch (e) {
      print(e.message);

      throw ApiClientException(ApiClientExceptionType.other, message: e.message);
    }
  }
}

enum ApiClientExceptionType { network, auth, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;
  final String? message;

  ApiClientException(this.type, {this.message});
}
