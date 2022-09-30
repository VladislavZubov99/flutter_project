import 'package:flutter/material.dart';

class ExpandNotifier extends ChangeNotifier {
  bool initialExpandedValue = false;
  List<ExpandableElement> expandableElements = [];

  _isExpandedElement(int index) {
    return expandableElements
        .contains(ExpandableElement(index: index, isExpanded: true));
  }

  isExpanded(index) {
    return isContains(index) ? _isExpandedElement(index): initialExpandedValue;
  }

  _isCollapsedElement(int index) {
    return expandableElements
        .contains(ExpandableElement(index: index, isExpanded: false));
  }

  isCollapsed(index) {
    return isContains(index) ? _isCollapsedElement(index): !initialExpandedValue;
  }

  isContains(int index) {
    return _isExpandedElement(index) || _isCollapsedElement(index);
  }

  setAllExpanded() {
    expandableElements =
        expandableElements.map((e) => e.copyWith(isExpanded: true)).toList();
    notifyListeners();
  }

  setAllCollapsed() {
    expandableElements =
        expandableElements.map((e) => e.copyWith(isExpanded: false)).toList();
    notifyListeners();
  }

  setInitialExpandedValue(bool value) {
    initialExpandedValue = value;
    notifyListeners();

  }

  addExpandedElement(int index) {
    if (isContains(index)) {
      return;
    }
    expandableElements
        .add(ExpandableElement(index: index, isExpanded: initialExpandedValue));

  }

  initExpandableElements(List<int> indexes) {
    for (var element in indexes) {
      addExpandedElement(element);
    }
    notifyListeners();

  }

  onChangeExpandable(int index) {
    final foundEl = expandableElements.firstWhere((element) => element.index == index);
    foundEl.isExpanded = !foundEl.isExpanded;
    notifyListeners();
  }
}

class ExpandableElement {
  int index;
  bool isExpanded;

  ExpandableElement({required this.index, required this.isExpanded});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpandableElement &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          isExpanded == other.isExpanded;

  @override
  int get hashCode => index.hashCode ^ isExpanded.hashCode;

  ExpandableElement copyWith({
    int? index,
    bool? isExpanded,
  }) {
    return ExpandableElement(
      index: index ?? this.index,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  String toString() {
    return 'index: $index | isExpanded: $isExpanded';
  }
}
