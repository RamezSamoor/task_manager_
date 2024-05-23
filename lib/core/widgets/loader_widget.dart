import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/utils/app_colors.dart';

loaderWidget({Color color = AppColors.colorPrimary, double size = 30.0}) {
  return Center(
    child: SpinKitThreeBounce(
      color: color,
      size: size,
    ),
  );
}