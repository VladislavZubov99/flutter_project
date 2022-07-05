import 'package:flutter/material.dart';
import 'package:project/domain/data_providers/json_data_provider.dart';

import 'fromJson.dart';

class Combinations extends FromJson {
  List<Combination>? items;
  int? pageNumber;
  int? pageSize;
  int? total;
  int? totalPages;

  Combinations(
      {this.items,
      this.pageNumber,
      this.pageSize,
      this.total,
      this.totalPages});

  Combinations.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Combination>[];
      json['items'].forEach((v) {
        items!.add(Combination.fromJson(v));
      });
    }
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    total = json['total'];
    totalPages = json['totalPages'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    data['total'] = total;
    data['totalPages'] = totalPages;
    return data;
  }


}

class CombinationsNotifier extends ChangeNotifier {
  bool loading = false;
  Combinations combinations = Combinations();
  final JsonDataProvider _jsonDataProvider = JsonDataProvider();

  CombinationsNotifier() {
    fetchNewCombinations();
  }

  Future<void> fetchNewCombinations({String searchValue = ''}) async {
    loading = true;
    notifyListeners();


    combinations = await _jsonDataProvider.getCombinationsFromJson();

    if(searchValue.isNotEmpty) {
      combinations.items = getItemsByName(searchValue);
      combinations.total = combinations.items != null ? combinations.items!.length : 0;

      if(combinations.pageSize != null &&  combinations.items != null) {
        combinations.totalPages = (combinations.total! / combinations.pageSize!).round();
      }

    }

    loading = false;
    notifyListeners();
  }

  bool get hasData =>
      combinations.items != null && combinations.items!.isNotEmpty;


  List<Combination> getItemsByName(String searchValue) {
    final items = combinations.items;

    if (items != null) {

      return items.where((element) {
        if (element.kdName == null) {
          return false;
        } else {
          if (element.kdName!
              .toLowerCase()
              .contains(searchValue.toLowerCase())) {
            return true;
          } else {
            return false;
          }
        }
      }).toList();
    } else {
      return <Combination>[];
    }
  }

}

class Combination extends FromJson {
  int? id;
  int? mainId;
  int? internalNumber;
  int? number;
  String? name;
  String? land;
  int? federalStateId;
  String? kdNumber;
  String? kdName;
  String? kdCity;
  String? kdStreet;
  String? kdHouseNumber;
  String? kdPostcode;
  String? kdLand;
  String? note;
  String? deviceNumbers;
  String? city;
  String? street;
  String? houseNumber;
  String? postcode;
  String? payerPersonName;
  String? payerPersonEmail;
  String? payerPersonPhoneNumber;
  int? statusPlansEnum;
  List<ActivityAndAreaInPlanDtos>? activityAndAreaInPlanDtos;

//TODO: What types
  // Null? activities;
  // Null? areas;
  // Null? recipientDtos;

  Combination({
    this.id,
    this.mainId,
    this.internalNumber,
    this.number,
    this.name,
    this.land,
    this.federalStateId,
    this.kdNumber,
    this.kdName,
    this.kdCity,
    this.kdStreet,
    this.kdHouseNumber,
    this.kdPostcode,
    this.kdLand,
    this.note,
    this.deviceNumbers,
    this.city,
    this.street,
    this.houseNumber,
    this.postcode,
    this.payerPersonName,
    this.payerPersonEmail,
    this.payerPersonPhoneNumber,
    this.statusPlansEnum,
    this.activityAndAreaInPlanDtos,
    // this.activities,
    // this.areas,
    // this.recipientDtos,
  });

  Combination.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainId = json['mainId'];
    internalNumber = json['internalNumber'];
    number = json['number'];
    name = json['name'];
    land = json['land'];
    federalStateId = json['federalStateId'];
    kdNumber = json['kdNumber'];
    kdName = json['kdName'];
    kdCity = json['kdCity'];
    kdStreet = json['kdStreet'];
    kdHouseNumber = json['kdHouseNumber'];
    kdPostcode = json['kdPostcode'];
    kdLand = json['kdLand'];
    note = json['note'];
    deviceNumbers = json['deviceNumbers'];
    city = json['city'];
    street = json['street'];
    houseNumber = json['houseNumber'];
    postcode = json['postcode'];
    payerPersonName = json['payerPersonName'];
    payerPersonEmail = json['payerPersonEmail'];
    payerPersonPhoneNumber = json['payerPersonPhoneNumber'];
    statusPlansEnum = json['statusPlansEnum'];
    if (json['activityAndAreaInPlanDtos'] != null) {
      activityAndAreaInPlanDtos = <ActivityAndAreaInPlanDtos>[];
      json['activityAndAreaInPlanDtos'].forEach((v) {
        activityAndAreaInPlanDtos!.add(ActivityAndAreaInPlanDtos.fromJson(v));
      });
    }
    // activities = json['activities'];
    // areas = json['areas'];
    // recipientDtos = json['recipientDtos'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mainId'] = mainId;
    data['internalNumber'] = internalNumber;
    data['number'] = number;
    data['name'] = name;
    data['land'] = land;
    data['federalStateId'] = federalStateId;
    data['kdNumber'] = kdNumber;
    data['kdName'] = kdName;
    data['kdCity'] = kdCity;
    data['kdStreet'] = kdStreet;
    data['kdHouseNumber'] = kdHouseNumber;
    data['kdPostcode'] = kdPostcode;
    data['kdLand'] = kdLand;
    data['note'] = note;
    data['deviceNumbers'] = deviceNumbers;
    data['city'] = city;
    data['street'] = street;
    data['houseNumber'] = houseNumber;
    data['postcode'] = postcode;
    data['payerPersonName'] = payerPersonName;
    data['payerPersonEmail'] = payerPersonEmail;
    data['payerPersonPhoneNumber'] = payerPersonPhoneNumber;
    data['statusPlansEnum'] = statusPlansEnum;
    if (activityAndAreaInPlanDtos != null) {
      data['activityAndAreaInPlanDtos'] =
          activityAndAreaInPlanDtos!.map((v) => v.toJson()).toList();
    }

    // data['activities'] = this.activities;
    // data['areas'] = this.areas;
    // data['recipientDtos'] = this.recipientDtos;
    return data;
  }
}

class ActivityAndAreaInPlanDtos extends FromJson {
  int? id;
  int? mainId;
  int? planId;
  String? statusEnum;
  int? processedDatesCount;
  int? notProcessedDatesCount;
  String? deviceNumber;
  Plan? plan;
  Activity? activity;
  Activity? area;

  ActivityAndAreaInPlanDtos({
    this.id,
    this.mainId,
    this.planId,
    this.statusEnum,
    this.processedDatesCount,
    this.notProcessedDatesCount,
    this.deviceNumber,
    this.plan,
    this.activity,
    this.area,
  });

  ActivityAndAreaInPlanDtos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainId = json['mainId'];
    planId = json['planId'];
    statusEnum = json['statusEnum'];
    processedDatesCount = json['processedDatesCount'];
    notProcessedDatesCount = json['notProcessedDatesCount'];
    deviceNumber = json['deviceNumber'];
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    activity =
        json['activity'] != null ? Activity.fromJson(json['activity']) : null;
    area = json['area'] != null ? Activity.fromJson(json['area']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mainId'] = mainId;
    data['planId'] = planId;
    data['statusEnum'] = statusEnum;
    data['processedDatesCount'] = processedDatesCount;
    data['notProcessedDatesCount'] = notProcessedDatesCount;
    data['deviceNumber'] = deviceNumber;
    if (plan != null) {
      data['plan'] = plan!.toJson();
    }
    if (activity != null) {
      data['activity'] = activity!.toJson();
    }
    if (area != null) {
      data['area'] = area!.toJson();
    }
    return data;
  }
}

class Plan extends FromJson {
  int? id;
  int? mainId;
  String? mainCreateDate;
  Recipient? recipient;
  String? plannedDate;
  String? lastTimeUpdate;
  String? statusEnum;

  //TODO: What types
  // Null? payer;
  // Null? signatureClose;
  // Null? wageType;
  // Null? recipientDtos;
  // Null? activityAndAreaInPlansDto;
  // Null? activities;

  Plan({
    this.id,
    this.mainId,
    this.mainCreateDate,
    this.recipient,
    this.plannedDate,
    this.lastTimeUpdate,
    this.statusEnum,
    // this.payer,
    // this.signatureClose,
    // this.wageType,
    // this.recipientDtos,
    // this.activityAndAreaInPlansDto,
    // this.activities,
  });

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainId = json['mainId'];
    mainCreateDate = json['mainCreateDate'];
    recipient = json['recipient'] != null
        ? Recipient.fromJson(json['recipient'])
        : null;
    plannedDate = json['plannedDate'];
    lastTimeUpdate = json['lastTimeUpdate'];
    statusEnum = json['statusEnum'];
    // payer = json['payer'];
    // signatureClose = json['signatureClose'];
    // wageType = json['wageType'];
    // recipientDtos = json['recipientDtos'];
    // activityAndAreaInPlansDto = json['activityAndAreaInPlansDto'];
    // activities = json['activities'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mainId'] = mainId;
    data['mainCreateDate'] = mainCreateDate;
    if (recipient != null) {
      data['recipient'] = recipient!.toJson();
    }
    data['plannedDate'] = plannedDate;
    data['lastTimeUpdate'] = lastTimeUpdate;
    data['statusEnum'] = statusEnum;
    // data['payer'] = this.payer;
    // data['signatureClose'] = this.signatureClose;
    // data['wageType'] = this.wageType;
    // data['recipientDtos'] = this.recipientDtos;
    // data['activityAndAreaInPlansDto'] = this.activityAndAreaInPlansDto;
    // data['activities'] = this.activities;
    return data;
  }
}

class Recipient extends FromJson {
  int? id;
  int? mainId;
  String? name;
  String? phoneNumber;
  String? email;
  String? city;
  String? street;
  String? houseNumber;
  String? postcode;
  String? contactPerson;
  String? userId;
  String? dataTransferType;
  String? dataPath;
  String? saphirBoxAccount;
  String? saphirBoxPassword;
  String? note;
  int? pwLevel;
  int? latenessInterval;
  String? company;
  RecipientFilters? recipientFilters;

  Recipient(
      {this.id,
      this.mainId,
      this.name,
      this.phoneNumber,
      this.email,
      this.city,
      this.street,
      this.houseNumber,
      this.postcode,
      this.contactPerson,
      this.userId,
      this.dataTransferType,
      this.dataPath,
      this.saphirBoxAccount,
      this.saphirBoxPassword,
      this.note,
      this.pwLevel,
      this.latenessInterval,
      this.company,
      this.recipientFilters});

  Recipient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainId = json['mainId'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    city = json['city'];
    street = json['street'];
    houseNumber = json['houseNumber'];
    postcode = json['postcode'];
    contactPerson = json['contactPerson'];
    userId = json['userId'];
    dataTransferType = json['dataTransferType'];
    dataPath = json['dataPath'];
    saphirBoxAccount = json['saphirBoxAccount'];
    saphirBoxPassword = json['saphirBoxPassword'];
    note = json['note'];
    pwLevel = json['pwLevel'];
    latenessInterval = json['latenessInterval'];
    company = json['company'];
    recipientFilters = json['recipientFilters'] != null
        ? RecipientFilters.fromJson(json['recipientFilters'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mainId'] = mainId;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['city'] = city;
    data['street'] = street;
    data['houseNumber'] = houseNumber;
    data['postcode'] = postcode;
    data['contactPerson'] = contactPerson;
    data['userId'] = userId;
    data['dataTransferType'] = dataTransferType;
    data['dataPath'] = dataPath;
    data['saphirBoxAccount'] = saphirBoxAccount;
    data['saphirBoxPassword'] = saphirBoxPassword;
    data['note'] = note;
    data['pwLevel'] = pwLevel;
    data['latenessInterval'] = latenessInterval;
    data['company'] = company;
    if (recipientFilters != null) {
      data['recipientFilters'] = recipientFilters!.toJson();
    }
    return data;
  }
}

class RecipientFilters extends FromJson {
  int? id;
  bool? isSollView;
  bool? isDefaultEdit;
  bool? isAutoSynchronization;
  bool? isStandardTimeFormat;
  bool? isShowHalfMonth;
  bool? isMaleFilter;
  bool? isFemaleFilter;
  bool? isActiveFilter;
  bool? isSocialTypeSVFilter;
  bool? isSocialTypeGBFilter;
  bool? isSallaryReminder;
  int? planViewPageSize;

  // Null? recipient;

  RecipientFilters({
    this.id,
    this.isSollView,
    this.isDefaultEdit,
    this.isAutoSynchronization,
    this.isStandardTimeFormat,
    this.isShowHalfMonth,
    this.isMaleFilter,
    this.isFemaleFilter,
    this.isActiveFilter,
    this.isSocialTypeSVFilter,
    this.isSocialTypeGBFilter,
    this.isSallaryReminder,
    this.planViewPageSize,
    // this.recipient,
  });

  RecipientFilters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSollView = json['isSollView'];
    isDefaultEdit = json['isDefaultEdit'];
    isAutoSynchronization = json['isAutoSynchronization'];
    isStandardTimeFormat = json['isStandardTimeFormat'];
    isShowHalfMonth = json['isShowHalfMonth'];
    isMaleFilter = json['isMaleFilter'];
    isFemaleFilter = json['isFemaleFilter'];
    isActiveFilter = json['isActiveFilter'];
    isSocialTypeSVFilter = json['isSocialTypeSVFilter'];
    isSocialTypeGBFilter = json['isSocialTypeGBFilter'];
    isSallaryReminder = json['isSallaryReminder'];
    planViewPageSize = json['planViewPageSize'];
    // recipient = json['recipient'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isSollView'] = isSollView;
    data['isDefaultEdit'] = isDefaultEdit;
    data['isAutoSynchronization'] = isAutoSynchronization;
    data['isStandardTimeFormat'] = isStandardTimeFormat;
    data['isShowHalfMonth'] = isShowHalfMonth;
    data['isMaleFilter'] = isMaleFilter;
    data['isFemaleFilter'] = isFemaleFilter;
    data['isActiveFilter'] = isActiveFilter;
    data['isSocialTypeSVFilter'] = isSocialTypeSVFilter;
    data['isSocialTypeGBFilter'] = isSocialTypeGBFilter;
    data['isSallaryReminder'] = isSallaryReminder;
    data['planViewPageSize'] = planViewPageSize;
    // data['recipient'] = this.recipient;
    return data;
  }
}

class Activity extends FromJson {
  int? id;
  int? mainId;
  int? internalNumber;
  int? number;
  String? name;

  Activity({this.id, this.mainId, this.internalNumber, this.number, this.name});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainId = json['mainId'];
    internalNumber = json['internalNumber'];
    number = json['number'];
    name = json['name'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mainId'] = mainId;
    data['internalNumber'] = internalNumber;
    data['number'] = number;
    data['name'] = name;
    return data;
  }
}
