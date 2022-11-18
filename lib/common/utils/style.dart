import 'package:flutter/material.dart';

import '../config/config.dart';

class Style {
  static ButtonStyle buttonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(AppColors.whiteBackground),
      elevation: MaterialStateProperty.all(0),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius),
              side: const BorderSide(color: AppColors.shadow))),
    );
  }
}
