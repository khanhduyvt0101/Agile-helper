import '../../../../data/repository/retro/board_retro_repository.dart';
import '../../../../data/repository/socket_repository.dart';
import '../bloc/retro_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/user/token_login.dart';
import '../../board_retro/view/board_retro_view.dart';
import '../../dashboard/view/dashboard_home_view.dart';
import '../bloc/retro_home_event.dart';
import '../bloc/retro_home_state.dart';

class RetroHomeViewArguments {
  final TokenLogin tokenLogin;

  RetroHomeViewArguments({this.tokenLogin});
}

class RetroHomeView extends StatefulWidget {
  final TokenLogin tokenLogin;
  const RetroHomeView({this.tokenLogin, Key key}) : super(key: key);

  @override
  State<RetroHomeView> createState() => _RetroHomeViewState();
}

class _RetroHomeViewState extends State<RetroHomeView> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  RetroHomeBloc _retroHomeBloc;

  @override
  void initState() {
    _retroHomeBloc = BlocProvider.of<RetroHomeBloc>(context);
    _retroHomeBloc.boardRetroRepository =
        BoardRetroRepository(token: widget.tokenLogin.token);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarDefault(
            const Icon(
              Icons.arrow_back,
              size: 35,
            ), () {
          Navigator.pop(context);
          SocketRepository.disconnect();
        }, Container()),
        body: BlocListener(
          bloc: _retroHomeBloc,
          listener: (context, state) {
            if (state is CheckBoardExistedState) {
              if (state.isSuccess != null) {
                int length = _textController.text.split('/').length;
                Navigator.pushNamed(context, ConfigRoutes.BOARD_RETRO_VIEW,
                    arguments: BoardRetroViewArguments(
                        boardId: _textController.text.split('/')[length - 1],
                        tokenLogin: widget.tokenLogin));
              } else if (state.isNotExist != null) {
                showDialog(
                  context: context,
                  builder: (_) => CustomDialog(
                    title: 'Join fail',
                    content: 'Incorrect url link',
                    ok: 'Ok',
                    onOk: () => Navigator.pop(context),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (_) => CustomDialog(
                    title: 'Something wrong from client',
                    content: 'Please check connection with internet',
                    ok: 'Ok',
                    onOk: () => Navigator.pop(context),
                  ),
                );
              }
            }
          },
          child: Container(
            height: ScreenUtil().screenHeight,
            margin: EdgeInsets.symmetric(
                horizontal: PaddingConfig.paddingAppW,
                vertical: PaddingConfig.paddingAppH),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: ScreenUtil().screenHeight * 2 / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const TitleScreen(
                          title: 'Online Retro',
                        ),
                        SizedBox(
                            child: Column(
                          children: [
                            TextButtonFunction(
                                title: "Join Board",
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return _dialogInvite(context);
                                      });
                                }),
                            SizedBox(
                              height: PaddingConfig.paddingLargeH,
                            ),
                            TextButtonFunction(
                                title: "Dashboard",
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, ConfigRoutes.DASHBOARD_HOME_VIEW,
                                      arguments: DashBoardHomeViewArguments(
                                          tokenLogin: widget.tokenLogin));
                                }),
                          ],
                        )),
                      ],
                    )),
                Flexible(
                    child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => const DialogLogout());
                  },
                  child: CircleAvatarCustom(
                    userNameEncrypt: widget.tokenLogin.userNameEncrypt,
                  ),
                )),
              ],
            ),
          ),
        ));
  }

  Dialog _dialogInvite(BuildContext context) {
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
            padding: EdgeInsets.only(
                left: PaddingConfig.paddingLargeW,
                top: PaddingConfig.paddingLargeH,
                bottom: PaddingConfig.paddingNormalH,
                right: PaddingConfig.paddingNormalW),
            color: AppColors.whiteBackground,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enter link board',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: PaddingConfig.paddingLargeW,
                      top: PaddingConfig.paddingLargeH,
                      right: PaddingConfig.paddingNormalW),
                  child: Form(
                      key: _formKey,
                      child: TextInputCustom(
                        hintText: "Enter link",
                        textController: _textController,
                        obscureText: false,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return "Required enter link";
                          } else {
                            return null;
                          }
                        },
                        onChange: (_) {
                          setState(() {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                          });
                        },
                      )),
                ),
                SizedBox(
                    width: ScreenUtil().screenWidth * 3 / 5,
                    child: TextButtonFunction(
                        title: 'Join Board',
                        onPressed: () {
                          if (_textController.text.trim().isNotEmpty) {
                            int length = _textController.text.split('/').length;
                            _retroHomeBloc.add(
                              CheckBoardExistedEvent(
                                  idBoard: _textController.text
                                      .split('/')[length - 1]),
                            );
                          } else {
                            setState(() {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                            });
                          }
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
