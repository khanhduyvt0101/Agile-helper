import 'widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/config.dart';

class AppBarDefault extends StatelessWidget with PreferredSizeWidget {
  final Widget leftIcon;
  final Function leftAction;
  final Widget rightWidget;
  const AppBarDefault(this.leftIcon, this.leftAction, this.rightWidget,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.whiteBackground,
            child: SvgPicture.asset(
              'assets/icon/logo.svg',
            ),
          ),
          SizedBox(width: PaddingConfig.paddingNormalW),
          Text(
            'Agile Helper',
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
      centerTitle: true,
      leading: InkWell(
        onTap: leftAction,
        child: leftIcon,
      ),
      actions: [rightWidget],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarRetro extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool isLogo;
  final String userNameEncrypt;
  final Function rightFunction;
  final Function leadingAction;
  const AppBarRetro(
      {this.title,
      this.isLogo,
      this.userNameEncrypt,
      this.rightFunction,
      this.leadingAction,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          isLogo
              ? Container(
                  color: AppColors.whiteBackground,
                  child: SvgPicture.asset(
                    'assets/icon/logo.svg',
                  ),
                )
              : const SizedBox.shrink(),
          SizedBox(width: PaddingConfig.paddingNormalW),
          Text(
            title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: leadingAction ??
            () {
              Navigator.pop(context);
            },
        icon: const Icon(
          Icons.arrow_back,
          size: 35,
        ),
      ),
      actions: [
        userNameEncrypt != null
            ? CircleAvatarCustom(
                userNameEncrypt: userNameEncrypt,
              )
            : IconButton(
                onPressed: rightFunction,
                icon: const Icon(
                  Icons.settings,
                  color: AppColors.whiteBackground,
                  size: 30,
                )),
        SizedBox(
          width: PaddingConfig.paddingLargeW,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
