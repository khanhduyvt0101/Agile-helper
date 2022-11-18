import 'widget.dart';
import '../../../module/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../module/authentication/authentication_bloc/authentication_event.dart';
import '../../../module/login/view/login_view.dart';
import '../../config/config.dart';
import '../style.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final String ok;
  final Function onOk;
  const CustomDialog({
    Key key,
    this.title,
    this.content,
    this.ok,
    this.onOk,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      actions: [
        TextButton(
          onPressed: onOk,
          child: Text(
            ok,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}

class CustomDialogReconnect extends StatelessWidget {
  final String title;
  final String nameBtn;
  final Function functionBtn;
  const CustomDialogReconnect({
    Key key,
    this.title,
    this.nameBtn,
    this.functionBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Reconnecting',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Container(
              margin: EdgeInsets.all(PaddingConfig.paddingSlightW),
              child: const CustomLoadingWidget())
        ],
      ),
      actions: [
        TextButton(
          onPressed: functionBtn,
          child: Text(
            nameBtn,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}

class DialogRetro extends StatelessWidget {
  final String title;
  final String hintText;
  final String textButton;
  final TextEditingController textController;
  final Function actionButton;
  final Function onChange;
  final GlobalKey formKey;
  const DialogRetro(
      {this.textController,
      this.title,
      this.hintText,
      this.textButton,
      this.actionButton,
      this.onChange,
      this.formKey,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: const Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.only(
          left: PaddingConfig.paddingNormalW,
          top: PaddingConfig.paddingNormalH,
          bottom: PaddingConfig.paddingNormalH,
          right: PaddingConfig.paddingNormalW),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: ScreenUtil().screenHeight * 2 / 6,
            width: ScreenUtil().screenWidth,
            child: Container(
              padding: EdgeInsets.only(
                  left: PaddingConfig.paddingLargeW,
                  right: PaddingConfig.paddingNormalW),
              color: AppColors.whiteBackground,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: TextInputCustom(
                        textController: textController,
                        hintText: hintText,
                        onChange: onChange,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Required enter text";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                          width: ScreenUtil().screenWidth * 3 / 5,
                          child: TextButtonFunction(
                              title: textButton, onPressed: actionButton)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialogChangeColorStage extends StatelessWidget {
  final String currentColor;
  final Function function;

  const DialogChangeColorStage({this.currentColor, this.function, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color defaultColor;
    for (var element in AppColors.listTypeColorsUse) {
      if (element
          .toString()
          .contains(currentColor.split('#')[1].toLowerCase())) {
        defaultColor = element;
      }
    }
    return Dialog(
      insetAnimationDuration: const Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.only(
          left: PaddingConfig.paddingNormalW,
          top: PaddingConfig.paddingNormalH,
          bottom: PaddingConfig.paddingNormalH,
          right: PaddingConfig.paddingNormalW),
      child: SingleChildScrollView(
        child: SizedBox(
            height: ScreenUtil().screenHeight * 2 / 6,
            width: ScreenUtil().screenWidth,
            child: Container(
              color: AppColors.whiteBackground,
              child: BlockPicker(
                  pickerColor: defaultColor,
                  availableColors: AppColors.listTypeColorsUse,
                  onColorChanged: function),
            )),
      ),
    );
  }
}

class DialogLogout extends StatelessWidget {
  const DialogLogout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ElevatedButton(
        onPressed: () {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationTokenExpired(tokenLogin: null));
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LoginView()));
        },
        child: Text(
          'Logout',
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: AppColors.black),
        ),
        style: Style.buttonStyle(),
      ),
    );
  }
}
