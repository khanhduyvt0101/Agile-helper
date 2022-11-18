import 'dart:math';

import '../../../../data/model/retro/board_retro/board_retro_model.dart';
import '../../../../data/model/retro/board_retro/save_template_model.dart';
import '../../../../data/model/user/token_login.dart';
import '../../../../data/repository/retro/board_retro_repository.dart';
import '../bloc/board_retro_bloc.dart';
import '../bloc/board_retro_state.dart';
import 'stage_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/widget/widget.dart';
import '../bloc/board_retro_event.dart';

class BoardRetroViewArguments {
  final String boardId;
  final TokenLogin tokenLogin;
  final String nameBoard;

  BoardRetroViewArguments({this.boardId, this.tokenLogin, this.nameBoard});
}

class BoardRetroView extends StatefulWidget {
  final String boardId;
  final TokenLogin tokenLogin;
  final String nameBoard;
  const BoardRetroView({this.boardId, this.tokenLogin, this.nameBoard, Key key})
      : super(key: key);

  @override
  State<BoardRetroView> createState() => _BoardRetroViewState();
}

class _BoardRetroViewState extends State<BoardRetroView> {
  BoardRetroBloc _boardRetroBloc;
  bool isOverlayOpen = false;
  BoardRetroModel _boardRetroModel;
  final List<Stages> listStages = [];
  String titleBoard;
  @override
  void initState() {
    _boardRetroBloc = BlocProvider.of<BoardRetroBloc>(context);
    _boardRetroBloc.boardRetroRepository =
        BoardRetroRepository(token: widget.tokenLogin.token);
    _boardRetroBloc.add(JoinBoardRetroEvent(idBoard: widget.boardId));
    titleBoard = widget.nameBoard ?? '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void sortListStages() {
    //sort stage follow orderStages
    listStages.clear();
    for (var element in _boardRetroModel.boardInfo.orderStages) {
      for (var ele in _boardRetroModel.boardInfo.stages) {
        if (ele.id == element) {
          listStages.add(ele);
          break;
        }
      }
    }
  }

  void handleStageEvent(BoardRetroState state) {
    if (state is AddedStageState) {
      for (var element in _boardRetroModel.boardInfo.stages) {
        if (element.id == state.stages.id) {
          return;
        }
      }
      _boardRetroModel.boardInfo.stages.add(state.stages);
      _boardRetroModel.boardInfo.orderStages.add(state.stages.id);
      sortListStages();
    }

    if (state is ChangedColorStageState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.data['id'])
          .first
          .changeColor(state.data['color'].toString().toUpperCase());
    }

    if (state is DeletedStageState) {
      _boardRetroModel.boardInfo.stages
          .removeWhere((element) => element.id == state.data['stageId']);
      _boardRetroModel.boardInfo.setOrderStages(state.data['orderStages']);
      sortListStages();
    }

    if (state is DraggedStageState) {
      _boardRetroModel.boardInfo.orderStages = state.orderStages;
      sortListStages();
    }

    if (state is ClearedStageState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .clearStages();
    }

    if (state is RenameStageState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.data['id'])
          .first
          .title = state.data['title'];
    }
  }

  void handleCardEvent(BoardRetroState state) {
    if (state is CreatedCardsState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.cards.stageId)
          .first
          .setOrderCardsAndAddCard(state.cards, state.orderCards);
      sortListStages();
    }

    if (state is LikedCardsState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .cards
          .where((element) => element.id == state.cardId)
          .first
          .setLikeCardsAndNumberOfVote(
              state.numberOfVotes, state.listLikeCards);
    }

    if (state is UnLikedCardsState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .cards
          .where((element) => element.id == state.cardId)
          .first
          .setLikeCardsAndNumberOfVote(
              state.numberOfVotes, state.listLikeCards);
    }

    if (state is CreatedCommentCardsState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .cards
          .where((element) => element.id == state.cardId)
          .first
          .setCommentsAndNumberOfComments(
              state.numberOfComments, state.listComment);
    }

    if (state is DeletedCommentCardsState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .cards
          .where((element) => element.id == state.cardId)
          .first
          .setCommentsAndNumberOfComments(
              state.numberOfComments, state.listComment);
      sortListStages();
    }

    if (state is EditedCommentCardsState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .cards
          .where((element) => element.id == state.cardId)
          .first
          .comments = state.listComment;
    }

    if (state is RenamedCardsState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .cards
          .where((element) => element.id == state.cardId)
          .first
          .title = state.title;
    }

    if (state is SetActionCardsState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .cards
          .where((element) => element.id == state.cardId)
          .first
          .isActionItem = state.isActionItem;
    }

    if (state is ChangedColorCardsState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .cards
          .where((element) => element.id == state.cardId)
          .first
          .color = state.color.toString().toUpperCase();
    }

    if (state is DeletedCardsState) {
      for (var element in _boardRetroModel.boardInfo.stages) {
        if (element.id == state.stageId) {
          element.cards.removeWhere((element) => element.id == state.cardId);
          element.orderCards = state.orderCards;
          break;
        }
      }
    }

    if (state is SetIsActionDoneState) {
      _boardRetroModel.boardInfo.stages
          .where((element) => element.id == state.stageId)
          .first
          .cards
          .where((element) => element.id == state.cardId)
          .first
          .isActionDone = state.isActionDone;
    }

    if (state is DraggedCardState) {
      if (state.stageIdSecond != null) {
        List<Cards> _listCards = [];
        _listCards.addAll(_boardRetroModel.boardInfo.stages
            .where((element) => element.id == state.stageIdFirst)
            .first
            .cards);
        _listCards.addAll(_boardRetroModel.boardInfo.stages
            .where((element) => element.id == state.stageIdSecond)
            .first
            .cards);
        _boardRetroModel.boardInfo.stages
            .where((element) => element.id == state.stageIdFirst)
            .first
            .setOrderCardsAndClearCard(state.orderCardsFirst);
        _boardRetroModel.boardInfo.stages
            .where((element) => element.id == state.stageIdSecond)
            .first
            .setOrderCardsAndClearCard(state.orderCardsSecond);
        List<String> listOrderCardsFirst = _boardRetroModel.boardInfo.stages
            .where((element) => element.id == state.stageIdFirst)
            .first
            .orderCards;
        for (int i = 0; i < _listCards.length; i++) {
          if (listOrderCardsFirst.contains(_listCards[i].id)) {
            _boardRetroModel.boardInfo.stages
                .where((element) => element.id == state.stageIdFirst)
                .first
                .cards
                .add(_listCards[i]);
          } else {
            _boardRetroModel.boardInfo.stages
                .where((element) => element.id == state.stageIdSecond)
                .first
                .cards
                .add(_listCards[i]);
          }
        }
        sortListStages();
      } else {
        _boardRetroModel.boardInfo.stages
            .where((element) => element.id == state.stageIdFirst)
            .first
            .orderCards = state.orderCardsFirst;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarRetro(
          title: titleBoard,
          isLogo: false,
          rightFunction: () {
            setState(() {
              isOverlayOpen = !isOverlayOpen;
            });
          },
        ),
        body: BlocListener<BoardRetroBloc, BoardRetroState>(
          bloc: _boardRetroBloc,
          listener: ((context, state) {
            if (state.havePassJoinBoard) {
              showDialog(
                  context: context,
                  builder: (_) => _DialogEnterPassword(
                        idBoard: widget.boardId,
                      ));
            }

            if (state is JoinedBoardState && _boardRetroModel == null) {
              _boardRetroModel = state.boardRetroModel;
              sortListStages();
              setState(() {
                titleBoard = _boardRetroModel.boardInfo.name;
              });
            }

            //stages
            handleStageEvent(state);

            //cards
            handleCardEvent(state);
          }),
          child: BlocBuilder<BoardRetroBloc, BoardRetroState>(
              bloc: _boardRetroBloc,
              builder: ((context, state) {
                if (state is BoardRetroLoadingState) {
                  return const Center(child: CustomLoadingWidget());
                }
                if (state is BoardRetroFailureNetWorkState) {
                  return const Center(
                      child: Text(
                          'Something wrong with the server, please try again'));
                }
                return Stack(
                  children: [
                    Container(
                        color: AppColors.shadow,
                        height: ScreenUtil().screenHeight,
                        width: ScreenUtil().screenWidth,
                        child: StagesView(
                          listStages: listStages,
                          tokenLogin: widget.tokenLogin,
                          orderStages: _boardRetroModel?.boardInfo?.orderStages,
                        )),
                    isOverlayOpen
                        ? _overlaySettingAppBar(context)
                        : const SizedBox.shrink(),
                  ],
                );
              })),
        ));
  }

  Align _overlaySettingAppBar(BuildContext context) {
    return Align(
      alignment: const Alignment(1, -1),
      child: FractionallySizedBox(
        heightFactor: 0.15,
        widthFactor: 0.3,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.whiteBackground,
              border: Border.all(color: AppColors.black),
              borderRadius:
                  BorderRadius.circular(PaddingConfig.cornerRadiusFrame)),
          child: Column(
            children: [
              ButtonOverlay(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return _DialogInvite(boardId: widget.boardId);
                        });
                  },
                  title: 'Share board'),
              const Expanded(child: Divider(color: Colors.black)),
              ButtonOverlay(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          final _formKey = GlobalKey<FormState>();
                          final _textController = TextEditingController();
                          return DialogRetro(
                            formKey: _formKey,
                            textController: _textController,
                            title: 'New column',
                            hintText: 'Column name',
                            textButton: 'Add new column',
                            onChange: (_) {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                            },
                            actionButton: () {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              final _random = Random();
                              String randomColor = AppColors.listColorsUse[
                                  _random
                                      .nextInt(AppColors.listColorsUse.length)];
                              BlocProvider.of<BoardRetroBloc>(context).add(
                                  AddStageEvent(
                                      boardId: widget.boardId,
                                      title: _textController.text,
                                      color: randomColor,
                                      position: _boardRetroModel
                                              .boardInfo.stages.length +
                                          1));
                              Navigator.pop(context);
                            },
                          );
                        }).then((value) {
                      setState(() {
                        isOverlayOpen = false;
                      });
                    });
                  },
                  title: 'Add column'),
              const Expanded(child: Divider(color: Colors.black)),
              ButtonOverlay(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => _DialogSaveTemplate(
                              boardRetroModel: _boardRetroModel,
                            )).then((value) {
                      setState(() {
                        isOverlayOpen = false;
                        if (value != null && value) {
                          showDialog(
                              context: context,
                              builder: (_) => CustomDialog(
                                    title: 'Status',
                                    content: 'Saved Template',
                                    ok: 'ok',
                                    onOk: () {
                                      Navigator.pop(context);
                                    },
                                  ));
                        }
                      });
                    });
                  },
                  title: 'Save as template')
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogEnterPassword extends StatefulWidget {
  final String idBoard;
  const _DialogEnterPassword({this.idBoard, Key key}) : super(key: key);

  @override
  State<_DialogEnterPassword> createState() => __DialogEnterPasswordState();
}

class __DialogEnterPasswordState extends State<_DialogEnterPassword> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  CheckPass checkPass;

  @override
  void initState() {
    super.initState();
  }

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
            child: BlocListener<BoardRetroBloc, BoardRetroState>(
                listener: ((context, state) {
                  if (state is CheckPassJoinBoardState &&
                      state.checkPass == CheckPass.False) {
                    checkPass = CheckPass.False;
                    setState(() {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                    });
                  }
                  if (state is JoinedBoardState) {
                    checkPass = CheckPass.True;
                    Navigator.pop(context);
                  }
                }),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Enter password board',
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
                            hintText: "Enter password",
                            textController: _textController,
                            obscureText: false,
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "Required enter password";
                              } else if (checkPass == CheckPass.False) {
                                return "Wrong password";
                              } else {
                                return null;
                              }
                            },
                            onChange: (_) {
                              checkPass = CheckPass.True;
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                            },
                          )),
                    ),
                    SizedBox(
                        width: ScreenUtil().screenWidth * 3 / 5,
                        child: TextButtonFunction(
                            title: 'Submit',
                            onPressed: () {
                              if (_textController.text.trim().isNotEmpty) {
                                BlocProvider.of<BoardRetroBloc>(context).add(
                                    JoinBoardRetroWithPasswordEvent(
                                        idBoard: widget.idBoard,
                                        password: _textController.text.trim()));
                              } else {
                                setState(() {
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }
                                });
                              }
                            }))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class _DialogInvite extends StatelessWidget {
  final String boardId;
  const _DialogInvite({this.boardId, Key key}) : super(key: key);

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
                  'Invite players',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: PaddingConfig.paddingLargeW,
                      top: PaddingConfig.paddingNormalH,
                      right: PaddingConfig.paddingLargeW),
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenHeight * 0.072,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/voting_system_input.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      GetHost.urlInviteBoardRetro() + boardId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                    width: ScreenUtil().screenWidth * 3 / 5,
                    child: TextButtonFunction(
                        title: 'Copy invitation link',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: GetHost.urlInviteBoardRetro() + boardId));
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogSaveTemplate extends StatelessWidget {
  final BoardRetroModel boardRetroModel;
  final _formKey = GlobalKey<FormState>();
  final _textTitleController = TextEditingController();
  final _textDesController = TextEditingController();

  _DialogSaveTemplate({this.boardRetroModel, Key key}) : super(key: key);

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
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Create template',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextInputCustom(
                          textController: _textTitleController,
                          hintText: 'Template title',
                          onChange: (_) {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                          },
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "Required enter text";
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextInputCustom(
                          textController: _textDesController,
                          hintText: 'Template description',
                          onChange: (_) {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                          },
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return "Required enter text";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                        width: ScreenUtil().screenWidth * 3 / 5,
                        child: TextButtonFunction(
                            title: 'Save',
                            onPressed: () {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              List<StagesTemplate> listStagesTemplate = [];
                              for (var element
                                  in boardRetroModel.boardInfo.stages) {
                                listStagesTemplate.add(
                                    element.getStagesForSaveTemplate(element));
                              }
                              BlocProvider.of<BoardRetroBloc>(context).add(
                                  SaveTemplateEvent(
                                      saveTemplateModel: SaveTemplateModel(
                                          title: _textTitleController.text,
                                          description: _textDesController.text,
                                          stagesTemplate: listStagesTemplate)));
                              Navigator.pop(context, true);
                            })),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
