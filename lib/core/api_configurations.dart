class _InitialValues {
  static const List<String> dateRange = [
    "2022-10-01T00:00:00.000Z",
    "2022-10-31T00:00:00.000Z"
  ];
  static const int page = 1;
  static const int pageSize = 4;
  static const String sortField = "name";
  static const bool orderByDesc = true;
  static const List<int> companyIds = [1, 2, 68, 67, 72, 70, 76, 77];
  static const List<int> emptyList = [];
  static const String searchType = "name";
  static const String searchField = "";
}

class DashboardManagementEndpointConfiguration {
  List<String> dateRange;
  int page;
  int pageSize;
  String sortField;
  String searchType;
  String searchField;
  bool orderByDesc;

  final FilterListsConfiguration filterLists;

  DashboardManagementEndpointConfiguration({
    this.dateRange = _InitialValues.dateRange,
    this.page = _InitialValues.page,
    this.pageSize = _InitialValues.pageSize,
    this.sortField = _InitialValues.sortField,
    this.orderByDesc = _InitialValues.orderByDesc,
    this.searchField = _InitialValues.searchField,
    this.searchType = _InitialValues.searchType,
    required this.filterLists,
  });

  Map<String, dynamic> get body => {
    "dateRange": dateRange,
    "page": page,
    "pageSize": pageSize,
    "sortField": sortField,
    "orderByDesc": orderByDesc,
    "companyIds": filterLists.companyIds,
    "recipientIds": filterLists.recipientIds,
    "payerIds": filterLists.payerIds,
    "combinationIds": filterLists.combinationIds,
    "employeeIds": filterLists.employeeIds,
    "wageTypeIds": filterLists.wageTypeIds,
    "searchType": searchType,
    "searchField": searchField,
  };

  DashboardManagementEndpointConfiguration copyWith({
    List<String>? dateRange,
    int? page,
    int? pageSize,
    String? sortField,
    bool? orderByDesc,
    FilterListsConfiguration? filterLists,
  }) {
    return DashboardManagementEndpointConfiguration(
      dateRange: dateRange ?? this.dateRange,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      sortField: sortField ?? this.sortField,
      orderByDesc: orderByDesc ?? this.orderByDesc,
      filterLists: filterLists ?? this.filterLists,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardManagementEndpointConfiguration &&
          runtimeType == other.runtimeType &&
          dateRange == other.dateRange &&
          pageSize == other.pageSize &&
          sortField == other.sortField &&
          orderByDesc == other.orderByDesc;

  @override
  int get hashCode =>
      dateRange.hashCode ^
      pageSize.hashCode ^
      sortField.hashCode ^
      orderByDesc.hashCode;
}

class FilterListsConfiguration {
   List<int> companyIds;
   List<int> recipientIds;
   List<int> payerIds;
   List<int> combinationIds;
   List<int> employeeIds;
   List<int> wageTypeIds;


  FilterListsConfiguration({
    this.companyIds = _InitialValues.companyIds,
    this.recipientIds = _InitialValues.emptyList,
    this.payerIds = _InitialValues.emptyList,
    this.combinationIds = _InitialValues.emptyList,
    this.employeeIds = _InitialValues.emptyList,
    this.wageTypeIds = _InitialValues.emptyList,
  });

   FilterListsConfiguration copyWith({
    List<int>? companyIds,
    List<int>? recipientIds,
    List<int>? payerIds,
    List<int>? combinationIds,
    List<int>? employeeIds,
    List<int>? wageTypeIds,
  }) {
    return FilterListsConfiguration(
      companyIds: companyIds ?? this.companyIds,
      recipientIds: recipientIds ?? this.recipientIds,
      payerIds: payerIds ?? this.payerIds,
      combinationIds: combinationIds ?? this.combinationIds,
      employeeIds: employeeIds ?? this.employeeIds,
      wageTypeIds: wageTypeIds ?? this.wageTypeIds,
    );
  }
}