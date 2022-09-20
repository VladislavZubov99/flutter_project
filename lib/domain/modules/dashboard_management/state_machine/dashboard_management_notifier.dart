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

  get isLastStep => _machine.isWageType();
  get isFirstStep => _machine.isCompany();
  get currentStep => _machine.currentStep;
}