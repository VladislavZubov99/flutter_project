import 'package:flutter/material.dart';

import 'package:project/domain/modules/dashboard_management/state_machine/dashboard_management_machine.dart';

class DashboardManagementMachineNotifier extends ChangeNotifier {
  late DashboardManagementMachine _machine;


  DashboardManagementMachineNotifier() {
    _machine = DashboardManagementMachine();
    notifyListeners();
  }

  toNextStep() {
    _machine.toNextStep();
    notifyListeners();
  }

  toBackStep() {
    _machine.toBackStep();
    notifyListeners();
  }

  bool get isLastStep => _machine.isWageType();
  bool get isFirstStep => _machine.isCompany();
  String get currentStep => _machine.currentStep;
  DashboardManagementMachineStates get currentStepState => _machine.currentStepState;

  String get stateName {
    return "${currentStep[0].toUpperCase()}${currentStep.substring(1)}";
  }


}