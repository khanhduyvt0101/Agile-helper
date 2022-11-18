// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/config.dart';

class CardGame extends StatelessWidget {
  final String value_cards;
  final bool active;
  final String data;
  const CardGame({this.value_cards, this.active, this.data, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 100.h,
        width: 50.w,
        decoration: BoxDecoration(
            color:
                active == true ? AppColors.primary : AppColors.whiteBackground,
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius)),
        child: Center(
            child: Text(
          value_cards,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            color:
                active != true ? AppColors.primary : AppColors.whiteBackground,
          ),
        )),
      ),
      Center(
          child: Text(
        data,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: active != true ? AppColors.primary : AppColors.whiteBackground,
        ),
      )),
    ]);
  }
}

class TableCard extends StatelessWidget {
  final String userNameEncrypt;
  final String valueSelected;
  final bool active;
  final bool isTopCard;
  final bool showCard;

  const TableCard(
      {this.userNameEncrypt,
      this.valueSelected,
      this.active,
      this.isTopCard,
      this.showCard,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isTopCard
            ? SizedBox(
                height: 6 * PaddingConfig.paddingNormalH,
              )
            : Container(),
        Container(
            height: 90.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: showCard ? AppColors.background : AppColors.primary,
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius),
            ),
            child: showCard && valueSelected != null && valueSelected.isNotEmpty
                ? Center(
                    child: Text(
                      valueSelected,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : (active
                    ? Image.asset('assets/image/check_mark_icon.png',
                        fit: BoxFit.contain)
                    : Container())),
        SizedBox(
          height: PaddingConfig.paddingSlightH,
        ),
        Center(
          child: SizedBox(
            height: 30.h,
            width: 30.h,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                  Radius.circular(PaddingConfig.circleRadiusFrame)),
              child: userNameEncrypt == null
                  ? SvgPicture.asset(
                      'assets/icon/avatar_default.svg',
                    )
                  : FadeInImage.assetNetwork(
                      placeholder: 'assets/image/avatar_default.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      image: GetHost.urlGetImage() + userNameEncrypt,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/image/avatar_default.png',
                            fit: BoxFit.contain);
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
