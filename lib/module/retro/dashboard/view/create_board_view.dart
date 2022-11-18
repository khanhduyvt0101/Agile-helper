import 'dart:math';

import '../../../../common/utils/style.dart';
import '../../../../data/model/user/token_login.dart';
import '../../board_retro/view/board_retro_view.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/widget/widget.dart';
import '../bloc/dashboard_bloc.dart';

class CreateBoardView extends StatefulWidget {
  final TokenLogin tokenLogin;
  const CreateBoardView({this.tokenLogin, Key key}) : super(key: key);

  @override
  State<CreateBoardView> createState() => _CreateBoardViewState();
}

class _CreateBoardViewState extends State<CreateBoardView> {
  DashBoardBloc _dashBoardBloc;

  @override
  void initState() {
    _dashBoardBloc = BlocProvider.of<DashBoardBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(PaddingConfig.paddingLargeH),
      insetAnimationDuration: const Duration(milliseconds: 200),
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight * 0.8,
        padding: EdgeInsets.symmetric(horizontal: PaddingConfig.paddingLargeW),
        child: SingleChildScrollView(
          child: Column(children: [
            BlocBuilder(
                bloc: _dashBoardBloc,
                builder: (context, state) {
                  if (state is DashBoardLoadingState) {
                    return const CustomLoadingWidget();
                  } else if (state is LoadedTemplateBoardState) {
                    return state.listTemplateBoard != null
                        ? ListView.builder(
                            padding: EdgeInsets.only(
                              top: PaddingConfig.paddingSuperLargeH,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.listTemplateBoard.length,
                            itemBuilder: (context, index) {
                              return CardTemplateBoard(
                                  tokenLogin: widget.tokenLogin,
                                  templateId: state.listTemplateBoard[index].id,
                                  countColumn: state
                                      .listTemplateBoard[index].countStages,
                                  nameBoard:
                                      state.listTemplateBoard[index].title,
                                  description: state
                                      .listTemplateBoard[index].description);
                            })
                        : SizedBox(
                            height: PaddingConfig.paddingLargeH,
                          );
                  } else {
                    return const Center(
                      child: Text(
                          'Can not get data from server, please check your internet!'),
                    );
                  }
                }),
            CreateNewTemplateButton(
              tokenLogin: widget.tokenLogin,
            )
          ]),
        ),
      ),
    );
  }
}

class CreateNewTemplateButton extends StatelessWidget {
  final TokenLogin tokenLogin;
  const CreateNewTemplateButton({
    this.tokenLogin,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: PaddingConfig.paddingLargeH,
      ),
      height: ScreenUtil().screenHeight * 0.2,
      child: FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 1,
        child: ElevatedButton(
          style: Style.buttonStyle(),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return DialogCreateNewBoard(
                    tokenLogin: tokenLogin,
                  );
                });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.add,
                size: 50,
                color: AppColors.black,
              ),
              Text(
                'Create new board',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogCreateNewBoard extends StatefulWidget {
  final String templateId;
  final TokenLogin tokenLogin;
  const DialogCreateNewBoard({this.tokenLogin, this.templateId, Key key})
      : super(key: key);

  @override
  State<DialogCreateNewBoard> createState() => _DialogCreateNewBoardState();
}

class _DialogCreateNewBoardState extends State<DialogCreateNewBoard> {
  final _nameKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textPassWordController = TextEditingController();
  bool checkedValue = false;

  @override
  void initState() {
    _textPassWordController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(PaddingConfig.paddingLargeH),
      insetAnimationDuration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight * 0.6,
        child: Column(children: [
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(PaddingConfig.paddingAppW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Add new board',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'To add a new board, please specify the name of the board.',
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    child: _buildTextInput(
                        _nameKey, _textNameController, 'Name board'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Row(children: [
                            Text(
                              'Use password',
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                            Checkbox(
                              value: checkedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  checkedValue = newValue;
                                });
                              },
                            ),
                          ]),
                        ),
                        checkedValue
                            ? Align(
                                alignment: Alignment.center,
                                child: _buildTextInput(_passwordKey,
                                    _textPassWordController, 'Password'),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBlockButtonBottom(context)
        ]),
      ),
    );
  }

  Expanded _buildBlockButtonBottom(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.7,
          child: Container(
            width: ScreenUtil().screenWidth,
            height: PaddingConfig.paddingForBottomButtonH,
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _button(context, 'Cancel', () => Navigator.pop(context)),
                BlocListener<DashBoardBloc, DashBoardState>(
                  listener: (context, state) {
                    if (state is ReceivedInfoBoardState) {
                      Navigator.pushNamed(
                              context, ConfigRoutes.BOARD_RETRO_VIEW,
                              arguments: BoardRetroViewArguments(
                                  boardId: state.idBoard,
                                  tokenLogin: widget.tokenLogin,
                                  nameBoard: _textNameController.text.trim()))
                          .then((value) => {
                                BlocProvider.of<DashBoardBloc>(context)
                                    .add(LoadListTemplateBoardEvent())
                              });
                    }
                  },
                  child: _button(
                      context,
                      'Create',
                      () => {
                            if (_textNameController.text.trim().isNotEmpty)
                              {
                                widget.templateId == null
                                    ? BlocProvider.of<DashBoardBloc>(context)
                                        .add(CreateNewWithoutTemplateEvent(
                                            name:
                                                _textNameController.text.trim(),
                                            password: _textPassWordController
                                                .text
                                                .trim()))
                                    : BlocProvider.of<DashBoardBloc>(context)
                                        .add(CreateNewWithTemplateEvent(
                                            name:
                                                _textNameController.text.trim(),
                                            password: _textPassWordController
                                                .text
                                                .trim(),
                                            templateId: widget.templateId)),
                              }
                            else
                              {
                                setState(() {
                                  if (!_nameKey.currentState.validate()) {
                                    return;
                                  }
                                  _nameKey.currentState.save();
                                }),
                              }
                          }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(key, textController, String hintTitle) {
    return Form(
        key: key,
        child: TextInputCustom(
          hintText: hintTitle,
          textController: textController,
          obscureText: false,
          validator: (value) {
            if (value.trim().isEmpty) {
              return "Required enter name";
            } else {
              return null;
            }
          },
          onChange: (_) {
            if (!key.currentState.validate()) {
              return;
            }
            key.currentState.save();
          },
        ));
  }

  FractionallySizedBox _button(
      BuildContext context, String title, Function action) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: ElevatedButton(
          child: Center(
              child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: title.contains('Cancel')
                  ? AppColors.whiteBackground
                  : AppColors.primary,
            ),
          )),
          style: Style.buttonStyle().copyWith(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                  title.contains('Cancel')
                      ? AppColors.primary
                      : AppColors.whiteBackground),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side:
                          const BorderSide(color: AppColors.whiteBackground)))),
          onPressed: action),
    );
  }
}

class CardTemplateBoard extends StatefulWidget {
  final String templateId;
  final TokenLogin tokenLogin;
  final int countColumn;
  final String nameBoard;
  final String description;
  const CardTemplateBoard({
    this.templateId,
    this.tokenLogin,
    this.countColumn,
    this.nameBoard,
    this.description,
    Key key,
  }) : super(key: key);

  @override
  State<CardTemplateBoard> createState() => _CardTemplateBoardState();
}

class _CardTemplateBoardState extends State<CardTemplateBoard> {
  Random random = Random();
  List<Color> listColor = [];
  bool isShowDes = false;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    for (int i = 0; i < widget.countColumn; i++) {
      listColor.add(AppColors.listColors[index]);
      index++;
      if (index == 4) index = 0;
    }
    return Container(
      margin: EdgeInsets.only(
        bottom: PaddingConfig.paddingSuperLargeH,
      ),
      height: ScreenUtil().screenHeight * 0.2,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return DialogCreateNewBoard(
                            tokenLogin: widget.tokenLogin,
                            templateId: widget.templateId);
                      });
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: PaddingConfig.paddingLargeW,
                    ),
                    Text(
                      widget.nameBoard ?? 'no name',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: !isShowDes
                          ? ListView.builder(
                              padding: EdgeInsets.only(
                                  bottom: PaddingConfig.paddingNormalH),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: widget.countColumn,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().screenHeight * 0.15 -
                                          (random.nextDouble() *
                                                  (ScreenUtil().screenHeight *
                                                          0.2 *
                                                          0.6 -
                                                      ScreenUtil()
                                                              .screenHeight *
                                                          0.2 *
                                                          0.3) +
                                              ScreenUtil().screenHeight *
                                                  0.2 *
                                                  0.3),
                                      left: PaddingConfig.paddingSlightW,
                                      right: PaddingConfig.paddingSlightW),
                                  width: ScreenUtil().screenWidth *
                                      0.6 /
                                      widget.countColumn,
                                  color: listColor[index],
                                  height: 10,
                                );
                              })
                          : Text(
                              widget.description,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 7,
                            ),
                    )
                  ],
                ),
                style: Style.buttonStyle()),
          ),
          Align(
            alignment: const Alignment(0.9, -1),
            child: InkWell(
              onTap: () {
                setState(() {
                  isShowDes = !isShowDes;
                });
              },
              child: Container(
                padding: EdgeInsets.only(
                    right: PaddingConfig.paddingNormalW,
                    top: PaddingConfig.paddingNormalH),
                child: SvgPicture.asset(
                  'assets/icon/attention.svg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
