class _InitialValues {
  static const List<String> dateRange = [
    "2022-07-01T00:00:00.000Z",
    "2022-08-01T00:00:00.000Z"
  ];
  static const int page = 1;
  static const int pageSize = 4;
  static const String sortField = "name";
  static const bool orderByDesc = true;
  static const List<int> companyIds = [1, 2, 68, 67, 72, 70, 76, 77];
  static const List<int> emptyList = [];
}

class DashboardManagementEndpointConfiguration {
  List<String> dateRange;
  int page;
  int pageSize;
  String sortField;
  bool orderByDesc;

  final FilterListsConfiguration filterLists;

  DashboardManagementEndpointConfiguration({
    this.dateRange = _InitialValues.dateRange,
    this.page = _InitialValues.page,
    this.pageSize = _InitialValues.pageSize,
    this.sortField = _InitialValues.sortField,
    this.orderByDesc = _InitialValues.orderByDesc,
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
}