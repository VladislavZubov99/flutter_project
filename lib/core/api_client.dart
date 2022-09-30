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

class ApiSettings {
  final String _accessToken =
      'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InRXTVZuUUlHT1ZTbGZFbXRGdUpnaUEiLCJ0eXAiOiJhdCtqd3QifQ.eyJuYmYiOjE2NjQ1MzY5MDAsImV4cCI6MTY2NDcwOTcwMCwiaXNzIjoiaHR0cHM6Ly9lYXJ0aC1pZGVudGl0eXNlcnZlcnNlcnZpY2UuYXp1cmV3ZWJzaXRlcy5uZXQiLCJhdWQiOiJlYXJ0aEFQSVNjb3BlIiwiY2xpZW50X2lkIjoiZWFydGhEZXZlbG9wQ29kZSIsInN1YiI6IjllZDMyMjExLWY0NjktNDEyZS04N2MzLTBmNmZlZjUzYjlkZCIsImF1dGhfdGltZSI6MTY2NDM1NzcyNCwiaWRwIjoibG9jYWwiLCJmYW1pbHlfbmFtZSI6IlJ5dCIsImdpdmVuX25hbWUiOiJNYXgiLCJzYXBoaXJfY3VzdG9tZXJfbnVtYmVyIjoiOTk5OTk5OTMiLCJyb2xlIjoiUHJldmlld19BY2Nlc3MiLCJlbWFpbCI6Im1yeXR3aW5za2lAc2FwaGlyLXNvZnR3YXJlLmRlIiwic2NvcGUiOlsib3BlbmlkIiwiZWFydGhBUElTY29wZSIsIm9mZmxpbmVfYWNjZXNzIl0sImFtciI6WyJwd2QiXX0.VMnrbAdasefKOeiCajExCVbZ1uFU0RX3rZmpMO3dJK22oMIRlKS7amtdsrFoghsFfjYk7KdKAeUaGOszmy95eva2SlkWMky3J0M4BzFRb32ME_pk_BfPCCveJwBufXQpVkxr1QpcPdRkv8c8ANbq6K7_EvOsPDCpCVQRCKYrSfTXrHOMN2_qnSVMNPpMb56GMeOUakdooYBYWJmVjeN8m2U3YbCYOCNf3os0NcQ5XDU4cqEChr82RjH19yM0VkzemJw6CiUSYHDSJEjRMgOvEWkDU6h124OiUVRiz3M2jjgwoIIiQke1ud83HHula7l9lj5Vi93N5PPtxMtEXOjy2w';

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

  Future<CompaniesWithPagination> getCompanies({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    Response response = await _authorizedDio.post(
      ApiSettings.companiesView,
      data: configuration.body,
    );

    final companies = CompaniesWithPagination.fromJson(response.data);
    return companies;
  }

  Future<RecipientsWithPagination> getRecipients({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    Response response = await _authorizedDio.post(
      ApiSettings.recipientsView,
      data: configuration.body,
    );

    final recipients = RecipientsWithPagination.fromJson(response.data);
    return recipients;
  }

  Future<PayersWithPagination> getPayers({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    Response response = await _authorizedDio.post(
      ApiSettings.payersView,
      data: configuration.body,
    );

    final payers = PayersWithPagination.fromJson(response.data);
    return payers;
  }

  Future<CombinationsWithPagination> getCombinations({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    Response response = await _authorizedDio.post(
      ApiSettings.combinationsView,
      data: configuration.body,
    );

    final combinations = CombinationsWithPagination.fromJson(response.data);
    return combinations;
  }

  Future<EmployeesWithPagination> getEmployees({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    Response response = await _authorizedDio.post(
      ApiSettings.employeesView,
      data: configuration.body,
    );

    final employees = EmployeesWithPagination.fromJson(response.data);
    return employees;
  }

  Future<WageTypesWithPagination> getWageTypes({
    required DashboardManagementEndpointConfiguration configuration,
  }) async {
    Response response = await _authorizedDio.post(
      ApiSettings.wageTypesView,
      data: configuration.body,
    );

    final wageTypes = WageTypesWithPagination.fromJson(response.data);
    return wageTypes;
  }
}

enum ApiClientExceptionType { network, auth, other }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;
  final String? message;

  ApiClientException(this.type, {this.message});
}


