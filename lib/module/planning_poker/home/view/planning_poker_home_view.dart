import '../../../../data/model/user/token_login.dart';
import '../../../../data/repository/socket_repository.dart';
import '../../bloc/planning_poker_bloc.dart';
import '../../bloc/planning_poker_event.dart';
import '../../bloc/planning_poker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../board_game/bloc/board_game_bloc.dart';
import '../../board_game/bloc/board_game_event.dart';
import '../../board_game/view/board_game_view.dart';
import '../../create_game/view/create_game_view.dart';

class PlanningPokerHomeViewArguments {
  final TokenLogin tokenLogin;

  PlanningPokerHomeViewArguments({this.tokenLogin});
}

class PlanningPokerHomeView extends StatefulWidget {
  final TokenLogin tokenLogin;
  const PlanningPokerHomeView({this.tokenLogin, Key key}) : super(key: key);

  @override
  State<PlanningPokerHomeView> createState() => _PlanningPokerHomeViewState();
}

class _PlanningPokerHomeViewState extends State<PlanningPokerHomeView> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  PlanningPokerBloc _planningPokerBloc;

  @override
  void initState() {
    super.initState();
    _planningPokerBloc = BlocProvider.of<PlanningPokerBloc>(context);
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
        body: BlocListener<PlanningPokerBloc, PlanningPokerState>(
            bloc: _planningPokerBloc,
            listener: (context, state) {
              if (state is CheckGameExistedState) {
                if (state.isSuccess != null) {
                  int length = _textController.text.split('/').length;
                  BlocProvider.of<BoardGameBloc>(context).add(JoinGameEvent(
                      tokenLogin: state.tokenLogin,
                      gameId: _textController.text.split('/')[length - 1]));
                  Navigator.pushNamed(context, ConfigRoutes.BOARD_GAME,
                      arguments: BoardGameViewArguments(
                          tokenLogin: state.tokenLogin,
                          gameId: _textController.text.split('/')[length - 1]));
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
                            title: 'Planning Poker',
                          ),
                          SizedBox(
                              child: Column(
                            children: [
                              TextButtonFunction(
                                  title: "Join Game",
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return _dialogJoinGame(
                                              widget, context);
                                        });
                                  }),
                              SizedBox(
                                height: PaddingConfig.paddingLargeH,
                              ),
                              TextButtonFunction(
                                  title: "Create Game",
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ConfigRoutes.CREATE_GAME,
                                        arguments: CreateGameViewArguments(
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
            )));
  }

  Widget _dialogJoinGame(args, context) {
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
                  'Enter link room',
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
                        title: 'Join Game',
                        onPressed: () {
                          if (_textController.text.trim().isNotEmpty) {
                            int length = _textController.text.split('/').length;
                            _planningPokerBloc.add(
                              CheckGameExistedEvent(
                                  tokenLogin: args.tokenLogin,
                                  gameId: _textController.text
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
