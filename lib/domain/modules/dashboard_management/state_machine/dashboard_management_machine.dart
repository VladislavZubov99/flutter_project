import 'package:state_machine/state_machine.dart';

enum DashboardManagementMachineStates {
  company,
  recipient,
  payer,
  combination,
  employee,
  wageType
}

enum DashboardManagementMachineTransitions {
  toCompany,
  toRecipient,
  toPayer,
  toCombination,
  toEmployee,
  toWageType
}

class DashboardManagementMachine {
  late StateMachine _dashboardMachine;

  late State isCompany,
      isRecipient,
      isPayer,
      isCombination,
      isEmployee,
      isWageType;

  late StateTransition toCompany,
      toRecipient,
      toPayer,
      toCombination,
      toEmployee,
      toWageType;

  DashboardManagementMachine() {
    _dashboardMachine = StateMachine(
      'dashboard_management',
    );

    initStates();
    initTransitions();
    _dashboardMachine.start(isCompany);
  }

  void initStates() {
    isCompany = _dashboardMachine
        .newState(DashboardManagementMachineStates.company.name);
    isRecipient = _dashboardMachine
        .newState(DashboardManagementMachineStates.recipient.name);
    isPayer = _dashboardMachine
        .newState(DashboardManagementMachineStates.payer.name);
    isCombination = _dashboardMachine
        .newState(DashboardManagementMachineStates.combination.name);
    isEmployee = _dashboardMachine
        .newState(DashboardManagementMachineStates.employee.name);
    isWageType = _dashboardMachine
        .newState(DashboardManagementMachineStates.wageType.name);
  }

  void initTransitions() {
    toCompany = _dashboardMachine.newStateTransition(
      DashboardManagementMachineTransitions.toCompany.name,
      [isRecipient],
      isCompany,
    );

    toRecipient = _dashboardMachine.newStateTransition(
      DashboardManagementMachineTransitions.toRecipient.name,
      [isCompany, isPayer],
      isRecipient,
    );

    toPayer = _dashboardMachine.newStateTransition(
      DashboardManagementMachineTransitions.toPayer.name,
      [isRecipient, isCombination],
      isPayer,
    );

    toCombination = _dashboardMachine.newStateTransition(
      DashboardManagementMachineTransitions.toCombination.name,
      [isPayer, isEmployee],
      isCombination,
    );

    toEmployee = _dashboardMachine.newStateTransition(
      DashboardManagementMachineTransitions.toEmployee.name,
      [isCombination, isWageType],
      isEmployee,
    );

    toWageType = _dashboardMachine.newStateTransition(
      DashboardManagementMachineTransitions.toWageType.name,
      [isEmployee],
      isWageType,
    );
  }

  toNextStep() {
    if (isCompany()) {
      toRecipient();
      return;
    }
    if (isRecipient()) {
      toPayer();
      return;
    }
    if (isPayer()) {
      toCombination();
      return;
    }
    if (isCombination()) {
      toEmployee();
      return;
    }
    if (isEmployee()) {
      toWageType();
      return;
    }
  }

  toBackStep() {
    if (isRecipient()) {
      toCompany();
      return;
    }
    if (isPayer()) {
      toRecipient();
      return;
    }
    if (isCombination()) {
      toPayer();
      return;
    }
    if (isEmployee()) {
      toCombination();
      return;
    }
    if (isWageType()) {
      toEmployee();
      return;
    }
  }


  String get currentStep {

    if (isCompany()) return 'Companies';
    if (isRecipient()) return 'Recipients';
    if (isPayer()) return 'Payers';
    if (isCombination()) return 'Combinations';
    if (isEmployee()) return 'Employees';
    if (isWageType()) return 'Wage Types';

    return '';
  }

  DashboardManagementMachineStates get currentStepState {

    if (isCompany()) return DashboardManagementMachineStates.company;
    if (isRecipient()) return DashboardManagementMachineStates.recipient;
    if (isPayer()) return DashboardManagementMachineStates.payer;
    if (isCombination()) return DashboardManagementMachineStates.combination;
    if (isEmployee()) return DashboardManagementMachineStates.employee;
    if (isWageType()) return DashboardManagementMachineStates.wageType;

    return DashboardManagementMachineStates.company;
  }
}

