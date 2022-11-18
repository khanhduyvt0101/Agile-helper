import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/config.dart';

class TextButtonFunction extends StatelessWidget {
  final String title;
  final Function onPressed;
  const TextButtonFunction({this.title, this.onPressed, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().screenWidth,
        height: 60.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius),
            color: AppColors.primary),
        child: MaterialButton(
            child: Text(title,
                style: TextStyle(
                  color: AppColors.whiteBackground,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                )),
            onPressed: onPressed));
  }
}

class ButtonOverlay extends StatelessWidget {
  final Function onTap;
  final String title;
  const ButtonOverlay({this.onTap, this.title, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: onTap,
        child: FittedBox(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().screenWidth * 0.02),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
