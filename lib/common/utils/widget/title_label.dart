import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/config.dart';

class TitleLabel extends StatelessWidget {
  final String title;
  const TitleLabel(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.caption,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class TitleScreen extends StatelessWidget {
  final String title;
  const TitleScreen({this.title, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary),
      textAlign: TextAlign.center,
    );
  }
}
