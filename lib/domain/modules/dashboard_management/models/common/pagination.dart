class DashboardManagementPagination<T> {
  List<String> dateRange;
  int page;
  int pageSize;
  int totalCount;
  List<T> list;
  List<int> currentStepIds;

  DashboardManagementPagination({
    required this.dateRange,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.list,
    required this.currentStepIds,
  });
}