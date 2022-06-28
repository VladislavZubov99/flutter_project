import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:project/domain/models/combination.dart';

import '../models/tenant.dart';

class JsonDataProvider {
  static Future<String> getJson(String jsonFilename) {
    return rootBundle.loadString(jsonFilename);
  }

  Future<List<Tenant>> getTenantFromJson() async {
    try {
      String jsonStr = await getJson('assets/json_tenant_list.json');
      final List<dynamic> myData = json.decode(jsonStr);
      await Future.delayed(const Duration(seconds: 1));
      return myData.map((e) => Tenant.fromJson(e)).toList();
    } catch (e) {
      print(e);
      throw Exception('Error json loading');
    }
  }

  Future<Combinations> getCombinationsFromJson() async {
    try {
      String jsonStr = await getJson('assets/json_items.json');
      final dynamic myData = json.decode(jsonStr);
      return Combinations.fromJson(myData);
    } catch (e) {
      print(e);
      throw Exception('Error json loading');
    }
  }
}
