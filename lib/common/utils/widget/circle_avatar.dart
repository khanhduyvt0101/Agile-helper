import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/config.dart';

class CircleAvatarCustom extends StatelessWidget {
  final String userNameEncrypt;
  const CircleAvatarCustom({this.userNameEncrypt, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainBoxHeight = MediaQuery.of(context).size.height * 0.055;
    return Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
              Radius.circular(PaddingConfig.circleRadiusFrame)),
          child: userNameEncrypt == null
              ? SvgPicture.asset('assets/icon/avatar_default.svg',
                  width: mainBoxHeight,
                  height: mainBoxHeight,
                  fit: BoxFit.cover)
              : FadeInImage.assetNetwork(
                  width: mainBoxHeight,
                  height: mainBoxHeight,
                  placeholder: 'assets/image/avatar_default.png',
                  // width: double.infinity,
                  fit: BoxFit.cover,
                  image: GetHost.urlGetImage() + userNameEncrypt,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/image/avatar_default.png',
                        width: mainBoxHeight,
                        height: mainBoxHeight,
                        fit: BoxFit.cover);
                  },
                ),
        ));
  }
}
