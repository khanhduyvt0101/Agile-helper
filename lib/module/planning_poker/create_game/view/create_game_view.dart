// ignore_for_file: file_names
import 'package:agile_helper/data/model/user/token_login.dart';
import 'package:agile_helper/module/planning_poker/create_game/bloc/create_game_bloc.dart';
import 'package:agile_helper/module/planning_poker/create_game/bloc/create_game_event.dart';
import 'package:agile_helper/module/planning_poker/create_game/bloc/create_game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/planning_poker/create_game_model.dart';
import '../../board_game/bloc/board_game_bloc.dart';
import '../../board_game/bloc/board_game_event.dart';
import '../../board_game/view/board_game_view.dart';
import 'custom_desk_view.dart';

class CreateGameViewArguments {
  final TokenLogin tokenLogin;
  CreateGameViewArguments({this.tokenLogin});
}

class CreateGameView extends StatefulWidget {
  final TokenLogin tokenLogin;
  const CreateGameView({this.tokenLogin, Key key}) : super(key: key);

  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGameView> {
  final _formKey = GlobalKey<FormState>();
  CreateGameBloc _createGameBloc = CreateGameBloc();
  List<String> _valueDeskForCreate = [];

  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createGameBloc = BlocProvider.of<CreateGameBloc>(context);
    _createGameBloc
        .add(CreateGameLoadVotingSystemEvent(token: widget.tokenLogin.token));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarDefault(
            const Icon(
              Icons.arrow_back,
              size: 35,
            ), () {
          Navigator.pop(context);
        }, Container()),
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: PaddingConfig.paddingLargeW * 2,
              vertical: PaddingConfig.paddingNormalH),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: ScreenUtil().screenHeight * 2 / 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose a name and a voting system for your game.',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                      _buildTextInput(),
                      _buildDropDownButton(),
                      _buildCreateCustomDesk(context, widget),
                      _buildButtonCreate(widget),
                    ],
                  )),
              Flexible(
                  child: CircleAvatarCustom(
                userNameEncrypt: widget.tokenLogin.userNameEncrypt,
              )),
            ],
          ),
        ));
  }

  Widget _buildCreateCustomDesk(context, args) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return CustomDesk(args.tokenLogin.token);
            });
      },
      child: Text(
        'Create custom desk...',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: AppColors.primary),
      ),
    );
  }

  Widget _buildButtonCreate(args) {
    return BlocListener(
      bloc: _createGameBloc,
      listener: (context, state) {
        if (state is CreateGamedState) {
          BlocProvider.of<BoardGameBloc>(context).add(
              JoinGameEvent(tokenLogin: args.tokenLogin, gameId: state.gameId));
          Navigator.pushNamed(context, ConfigRoutes.BOARD_GAME,
              arguments: BoardGameViewArguments(
                gameId: state.gameId,
                tokenLogin: args.tokenLogin,
              )).then((value) => setState(() {
                _createGameBloc.add(CreateGameLoadVotingSystemEvent(
                    token: widget.tokenLogin.token));
              }));
        }
        if (state is CreateGameFailureNetWorkState) {
          showDialog(
            context: context,
            builder: (_) => SizedBox(
              width: ScreenUtil().screenWidth * 2 / 3,
              child: CustomDialogReconnect(
                title: 'Cannot connect server!',
                nameBtn: 'Cancel',
                functionBtn: () {
                  _createGameBloc.add(
                      RetryLoadVotingSystemEvent(token: args.tokenLogin.token));
                  Navigator.pop(context);
                },
              ),
            ),
          );
          _createGameBloc
              .add(RetryLoadVotingSystemEvent(token: args.tokenLogin.token));
        }
      },
      child: TextButtonFunction(
          title: 'Create',
          onPressed: () {
            if (_valueDeskForCreate.isNotEmpty &&
                _textController.text.isNotEmpty) {
              _createGameBloc.add(CreateGameCreateBoardEvent(
                  createGame: CreateGame(
                      name: _textController.text.trim(),
                      userId: args.tokenLogin.id,
                      cardValue: CardValue(listValue: _valueDeskForCreate))));
            } else if (_valueDeskForCreate.isEmpty) {
              showDialog(
                context: context,
                builder: (_) => SizedBox(
                  width: ScreenUtil().screenWidth * 2 / 3,
                  child: CustomDialog(
                    title: 'Alert!',
                    content:
                        'Require choose desk Voting system or create custom desk',
                    ok: 'Ok',
                    onOk: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            } else {
              setState(() {
                if (!_formKey.currentState.validate()) {
                  return;
                }
              });
            }
          }),
    );
  }

  Widget _buildDropDownButton() {
    return Flexible(
      child: Container(
        padding: EdgeInsets.only(
            left: PaddingConfig.paddingLargeW,
            top: PaddingConfig.paddingNormalH + PaddingConfig.paddingSlightH,
            bottom: PaddingConfig.paddingNormalH,
            right: PaddingConfig.paddingLargeW),
        width: ScreenUtil().screenWidth,
        height: 65.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/voting_system_input.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: BlocBuilder<CreateGameBloc, CreateGameState>(
          bloc: _createGameBloc,
          builder: (context, state) {
            if (state is CreateGameLoadingState) {
              return Container(
                  margin: EdgeInsets.only(top: PaddingConfig.paddingNormalH),
                  child: const CustomLoadingWidget());
            }
            if (state is CreateGameLoadedVotingSystemState) {
              if (state.result == null ||
                  state.result.listVotingSystem.isEmpty) {
                return Center(
                  child: Container(
                      padding:
                          EdgeInsets.only(top: PaddingConfig.paddingNormalH),
                      child: const Text('No desk saved!')),
                );
              }
              return _dropdownButton(state.result.listVotingSystem);
            } else if (state is CreateGameFailureNetWorkState) {
              return Center(
                child: Container(
                    padding: EdgeInsets.only(top: PaddingConfig.paddingNormalH),
                    child: const Text(
                        'Can not get data from server, please check your internet!')),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _dropdownButton(List<VotingSystem> listVotingSystem) {
    bool isCheck = listVotingSystem.length > 3;
    _valueDeskForCreate =
        listVotingSystem[listVotingSystem.length - (isCheck ? 4 : 1)]
            .cardValue
            .listValue;
    String text =
        listVotingSystem[listVotingSystem.length - (isCheck ? 4 : 1)].name;
    int lengthResults = listVotingSystem.length;
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      hint: Text(
        text +
            ' (' +
            ((listVotingSystem[lengthResults - (isCheck ? 4 : 1)]
                    .cardValue
                    .getListValue()
                    .toString()
                    .split('['))[1]
                .split(']'))[0] +
            ')',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.hintText,
          fontSize: 16.sp,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      items: listVotingSystem.map((VotingSystem value) {
        return DropdownMenuItem<String>(
          value: value.name +
              ' (' +
              ((value.cardValue.getListValue().toString().split('['))[1]
                  .split(']'))[0] +
              ')',
          child: Text(
            value.name +
                ' (' +
                ((value.cardValue.getListValue().toString().split('['))[1]
                    .split(']'))[0] +
                ')',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
            //overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        for (var item in listVotingSystem) {
          if ((item.name +
                  ' (' +
                  ((item.cardValue.getListValue().toString().split('['))[1]
                      .split(']'))[0] +
                  ')') ==
              value) {
            _valueDeskForCreate = item.cardValue.listValue;
          }
        }
      },
    );
  }

  Widget _buildTextInput() {
    return Form(
        key: _formKey,
        child: TextInputCustom(
          hintText: "Game's Name",
          textController: _textController,
          obscureText: false,
          validator: (value) {
            if (value.trim().isEmpty) {
              return "Required enter name";
            } else {
              return null;
            }
          },
          onChange: (_) {
            if (!_formKey.currentState.validate()) {
              return;
            }
          },
        ));
  }
}
