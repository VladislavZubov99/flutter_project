import 'package:flutter/cupertino.dart';
import 'package:project/ui/app_settings/app_colors.dart';

class AppTextStyles {
  late final double Function(double val) _scaling;

  AppTextStyles({double Function(double val)? scaling}) {
    _scaling = scaling ?? _scalingInitial;
  }

  TextStyle get commonButtonText => TextStyle(fontSize: _scaling(16));

  TextStyle get commonTitleText => TextStyle(
        fontSize: _scaling(18),
      );

  TextStyle get secondaryTitleText =>
      TextStyle(fontSize: _scaling(18), color: AppColors.primary);

  double _scalingInitial(double val) {
    return val;
  }
}
