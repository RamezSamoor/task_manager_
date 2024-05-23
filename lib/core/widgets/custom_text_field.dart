import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  TextEditingController controller;
  Function(String? string)? onChangedCallback;
  Function()? onTap;
  double? paddingHorizontal;
  int? maxLine;
  int? minLines;
  int? maxLength;
  double? fontSize;
  String? hintText;
  bool isPassword;
  bool readOnly;
  FocusNode? nextFocusNode;
  FocusNode? focusNode;
  TextInputType? keyboardType;
  Widget? prefixIcon;
  Widget? suffixIcon;
  EdgeInsetsGeometry? contentPadding;
  InputDecoration? decoration;
  bool autofocus;
  TextStyle? style;
  TextAlign? textAlign;
  List<TextInputFormatter>? inputFormatters;
  String? Function(String? value)? validator;
  Function(String? string)? onFieldSubmitted;


  CustomTextField(
      {super.key, required this.controller,
        this.onChangedCallback,
        this.paddingHorizontal,
        this.fontSize,
        this.maxLine = 1,
        this.minLines,
        this.maxLength,
        this.onTap,
        this.readOnly = false,
        this.hintText,
        this.focusNode,
        this.isPassword = false,
        this.autofocus = false,
        this.prefixIcon,
        this.suffixIcon,
        this.contentPadding,
        this.keyboardType,
        this.inputFormatters,
        this.nextFocusNode,
        this.style,
        this.textAlign,
        this.decoration,
        this.validator,
        this.onFieldSubmitted });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingHorizontal ?? 0),
      child: TextFormField(
        cursorColor: AppColors.darkBlueColor,
        controller: widget.controller,
        focusNode: widget.focusNode,
        maxLines: widget.maxLine,
        minLines: widget.minLines,
        validator: widget.validator,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        textAlign: widget.textAlign ?? TextAlign.start,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        autofocus: widget.autofocus,
        obscureText: widget.isPassword,
        style: widget.style ??
        Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: widget.fontSize ?? 13.sp,
            color: AppColors.grey),
        inputFormatters: widget.inputFormatters ?? [],
        decoration: widget.decoration ?? InputDecoration(
          counterText: '',
          contentPadding: widget.contentPadding,
          focusColor: AppColors.colorPrimary,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.grayBorder, width: 0.5),),
          focusedBorder:  UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.textColorPrimary.withOpacity(0.8), width: 0.5),),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.grayBorder, width: 0.5),),
          labelText: widget.hintText,
          labelStyle:
          Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize:  widget.fontSize ?? 12.sp ,
              color: AppColors.textColorPrimary.withOpacity(0.4)),
          hintStyle: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontSize: widget.fontSize?? 12.sp,
              color: AppColors.textColorPrimary.withOpacity(0.4)),
        ),
        onChanged: (message) {
          if (widget.onChangedCallback != null) {
            widget.onChangedCallback!(message);
          }
        },
        onFieldSubmitted: (s) {
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
          if (widget.onFieldSubmitted != null) {
            widget.onFieldSubmitted!(s);
          }
        },
      ),
    );
  }
}
