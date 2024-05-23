
import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final void Function() buttonPressed;
  final Widget widget;
  final bool disabled;
  final double? height;
  final double? width;
  final Color? buttonColor;
  final bool withBorder;
  final EdgeInsets? padding;
  final double? borderRadius;

  const CustomButton(
      {Key? key,
      required this.buttonPressed,
      required this.widget,
      this.disabled = false,
      this.width = double.infinity,
      this.buttonColor,
      this.withBorder = true,
        this.padding,
        this.borderRadius,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: disabled ? null : buttonPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: padding,
          foregroundColor: buttonColor ?? AppColors.blueGray,
          backgroundColor: buttonColor ?? AppColors.blueGray,
          disabledForegroundColor: buttonColor == null ? AppColors.colorPrimary : buttonColor?.withOpacity(0.38),
          disabledBackgroundColor: buttonColor == null ? AppColors.colorPrimary : buttonColor?.withOpacity(0.12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius?? 70.0),
              side: BorderSide(color:  AppColors.textColorPrimary.withOpacity(withBorder?1:0), width: withBorder ? 0.5 : 0)),
        ),
        child: widget,
      ),
    );
  }
}

