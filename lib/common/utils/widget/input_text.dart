import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/config.dart';

class TextInputCustom extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final bool obscureText;
  final Function validator;
  final Function onChange;
  const TextInputCustom(
      {this.hintText,
      this.textController,
      this.obscureText,
      this.validator,
      this.onChange,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      style: Theme.of(context).textTheme.headline2,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          left: PaddingConfig.paddingLargeW,
          top: PaddingConfig.paddingNormalH,
          bottom: PaddingConfig.paddingNormalH,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.hintText,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
        ),
        filled: true,
        fillColor: AppColors.grey,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PaddingConfig.cornerRadiusFrame),
          borderSide: BorderSide(
            width: 1.w,
            color: AppColors.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PaddingConfig.cornerRadiusFrame),
          borderSide: BorderSide(
            width: 1.w,
            color: AppColors.stroke,
          ),
        ),
        errorStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: AppColors.danger,
        ),
      ),
      onChanged: onChange,
      obscureText: obscureText ?? false,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
    );
  }
}

class TextInputForCmtInCard extends StatelessWidget {
  final String hintText;
  final TextEditingController textController;
  final Function validator;
  final Function onChange;
  final bool autofocus;
  const TextInputForCmtInCard(
      {this.hintText,
      this.textController,
      this.validator,
      this.onChange,
      this.autofocus,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      style: Theme.of(context).textTheme.bodyText2,
      autofocus: autofocus ?? false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          left: PaddingConfig.paddingLargeW,
        ),
        hintText: hintText ?? '',
        hintStyle: Theme.of(context).textTheme.bodyText2,
        filled: true,
        fillColor: AppColors.pinkSlight,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius),
          borderSide: BorderSide(
            width: 1.w,
            color: AppColors.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius),
            borderSide: BorderSide.none),
        errorStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: AppColors.danger,
        ),
      ),
      onChanged: onChange,
      keyboardType: TextInputType.multiline,
      validator: validator,
    );
  }
}
