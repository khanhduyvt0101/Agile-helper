import 'package:flutter/material.dart';
import '../../config/config.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: const [
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          )
        ],
      ),
    );
  }
}
