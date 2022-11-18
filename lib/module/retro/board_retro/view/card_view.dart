import '../bloc/board_retro_event.dart';
import 'comment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/style.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/retro/board_retro/board_retro_model.dart';
import '../../../../data/model/user/token_login.dart';
import '../bloc/board_retro_bloc.dart';

class CardItem extends StatefulWidget {
  final Cards cards;
  final TokenLogin tokenLogin;
  final List<String> orderCards;
  const CardItem({this.cards, this.tokenLogin, this.orderCards, Key key})
      : super(key: key);

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool isOverlayOpen = false;
  bool _isShowChat = false;
  GlobalKey elevateButtonKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final _textCreateCmtController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: PaddingConfig.paddingLargeH),
        child: ElevatedButton(
          onPressed: () {},
          style: Style.buttonStyle().copyWith(
            elevation: MaterialStateProperty.all(8),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: PaddingConfig.paddingNormalH,
            ),
            Text(
              widget.cards.title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: PaddingConfig.paddingNormalH,
            ),
            Container(
                width: ScreenUtil().screenWidth,
                height: 5.h,
                decoration: BoxDecoration(
                    color: Color(
                        int.parse('0xff' + widget.cards.color.split('#')[1])),
                    borderRadius:
                        BorderRadius.circular(PaddingConfig.cornerRadius))),
            Row(
              children: [
                Expanded(
                  child: widget.cards.isActionItem
                      ? Align(
                          alignment: const Alignment(-1.1, 0),
                          child: Checkbox(
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            value: widget.cards.isActionDone,
                            onChanged: (newValue) {
                              setState(() {
                                BlocProvider.of<BoardRetroBloc>(context).add(
                                    SetIsActionDoneEvent(
                                        boardId: widget.cards.boardId,
                                        userId: widget.tokenLogin.id,
                                        cardId: widget.cards.id,
                                        isActionDone: newValue));
                              });
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                    child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            !_checkUserLiked(widget.cards.likeCards)
                                ? BlocProvider.of<BoardRetroBloc>(context).add(
                                    LikeCardEvent(
                                        boardId: widget.cards.boardId,
                                        userId: widget.tokenLogin.id,
                                        stageId: widget.cards.stageId,
                                        cardId: widget.cards.id))
                                : BlocProvider.of<BoardRetroBloc>(context).add(
                                    UnLikeCardEvent(
                                        boardId: widget.cards.boardId,
                                        userId: widget.tokenLogin.id,
                                        stageId: widget.cards.stageId,
                                        cardId: widget.cards.id));
                          },
                          icon: _checkUserLiked(widget.cards.likeCards)
                              ? Image.asset('assets/image/liked.png')
                              : Image.asset('assets/image/like.png')),
                      Text(
                        widget.cards.numberOfVotes.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _isShowChat = !_isShowChat;
                            });
                          },
                          icon: _isShowChat
                              ? Image.asset('assets/image/chatted.png')
                              : Image.asset('assets/image/chat.png')),
                      Text(
                        widget.cards.numberOfComments.toString(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isOverlayOpen = !isOverlayOpen;
                            });
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: AppColors.black,
                          )),
                    ],
                  ),
                ))
              ],
            ),
            isOverlayOpen
                ? overlaySettingCard(context)
                : const SizedBox.shrink(),
            _isShowChat
                ? Column(
                    children: [
                      _containerCreateComment('Enter your comment...'),
                      _listViewComment(context),
                    ],
                  )
                : const SizedBox.shrink(),
          ]),
        ),
      ),
    );
  }

  Column overlaySettingCard(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buttonOverlay(context, () {
              Clipboard.setData(ClipboardData(text: widget.cards.title));
            }, 'Copy Card Text'),
            const Spacer(
              flex: 1,
            ),
            buttonOverlay(context, () {
              BlocProvider.of<BoardRetroBloc>(context).add(SetActionCardEvent(
                  boardId: widget.cards.boardId,
                  userId: widget.tokenLogin.id,
                  cardId: widget.cards.id,
                  isActionItem: !widget.cards.isActionItem ? true : false));
            },
                !widget.cards.isActionItem
                    ? 'Set As Action Item'
                    : 'Remove Action Item')
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buttonOverlay(context, () {
              showDialog(
                  context: context,
                  builder: (_) {
                    final _formKey = GlobalKey<FormState>();
                    final _textController = TextEditingController();
                    return DialogRetro(
                      formKey: _formKey,
                      textController: _textController,
                      title: 'Rename Title Card',
                      hintText: 'title',
                      textButton: 'Rename',
                      onChange: (_) {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                      },
                      actionButton: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        BlocProvider.of<BoardRetroBloc>(context).add(
                            RenameCardEvent(
                                boardId: widget.cards.boardId,
                                stageId: widget.cards.stageId,
                                cardId: widget.cards.id,
                                title: _textController.text));
                        Navigator.pop(context);
                      },
                    );
                  });
            }, 'Edit Card'),
            const Spacer(),
            buttonOverlay(context, () {
              showDialog(
                  context: context,
                  builder: (_) => DialogChangeColorStage(
                        currentColor: widget.cards.color,
                        function: (Color color) {
                          String stringColor = '#' +
                              color.toString().split('xff')[1].split(')')[0];
                          BlocProvider.of<BoardRetroBloc>(context).add(
                              ChangeColorCardEvent(
                                  boardId: widget.cards.boardId,
                                  stageId: widget.cards.stageId,
                                  cardId: widget.cards.id,
                                  color: stringColor));
                          Navigator.pop(context);
                        },
                      ));
            }, 'Set Color'),
            const Spacer(),
            buttonOverlay(context, () {
              showDialog(
                  context: context,
                  builder: (_) => CustomDialog(
                        title: 'Delete card',
                        content: 'Are you sure to delete this card?',
                        ok: 'Delete',
                        onOk: () {
                          BlocProvider.of<BoardRetroBloc>(context).add(
                              DeleteCardEvent(
                                  boardId: widget.cards.boardId,
                                  cardId: widget.cards.id,
                                  stageId: widget.cards.stageId,
                                  orderCards: widget.orderCards));
                          Navigator.pop(context);
                          setState(() {
                            isOverlayOpen = !isOverlayOpen;
                          });
                        },
                      ));
            }, 'Delete Card'),
          ],
        ),
      ],
    );
  }

  Widget buttonOverlay(BuildContext context, Function onTap, String title) {
    return ElevatedButton(
      onPressed: onTap,
      style: Style.buttonStyle().copyWith(
        elevation: MaterialStateProperty.all(3),
      ),
      child: FittedBox(
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: AppColors.primary, fontSize: 10.sp),
        ),
      ),
    );
  }

  Widget _containerCreateComment(String hintText) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: PaddingConfig.paddingNormalH,
        ),
        padding: EdgeInsets.symmetric(horizontal: PaddingConfig.paddingNormalW),
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius),
            color: AppColors.pinkSlight),
        child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: _dialogCreateCmt(hintText, context),
                    ));
          },
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Create comment',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText2),
              const Icon(
                Icons.add,
                color: AppColors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _dialogCreateCmt(String hintText, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: PaddingConfig.paddingNormalH,
      ),
      padding: EdgeInsets.symmetric(horizontal: PaddingConfig.paddingNormalW),
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight * 0.14,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius),
          color: AppColors.grey),
      child: Column(
        children: [
          SizedBox(
            height: PaddingConfig.paddingLargeH,
          ),
          _buildTextInput(hintText, _textCreateCmtController),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    BlocProvider.of<BoardRetroBloc>(context).add(
                        CreateCommentCardEvent(
                            boardId: widget.cards.boardId,
                            userId: widget.tokenLogin.id,
                            stageId: widget.cards.stageId,
                            cardId: widget.cards.id,
                            content: _textCreateCmtController.text));
                    setState(() {
                      _textCreateCmtController.clear();
                    });
                    Navigator.pop(context);
                  },
                  icon: Image.asset('assets/image/check_mark_blue.png')),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.black,
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextInput(
      String hintText, TextEditingController textEditingController) {
    return Form(
        key: _formKey,
        child: TextInputForCmtInCard(
          autofocus: true,
          hintText: hintText,
          textController: textEditingController,
          validator: (value) {
            if (value.trim().isEmpty) {
              return "Required enter text";
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

  Widget _listViewComment(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.only(
          top: PaddingConfig.paddingNormalH,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.cards.comments.length,
        itemBuilder: ((context, index) {
          return ContainerComment(
            stageId: widget.cards.stageId,
            boardId: widget.cards.boardId,
            comments: widget.cards.comments[index],
            userId: widget.tokenLogin.id,
            content: widget.cards.comments[index].content,
            updatedAt: widget.cards.comments[index].updatedAt,
            isOwnerComment:
                widget.tokenLogin.id == widget.cards.comments[index].userId,
          );
        }));
  }

  bool _checkUserLiked(List<LikeCards> list) {
    for (var element in list) {
      if (element.userId.contains(widget.tokenLogin.id)) {
        return true;
      }
    }
    return false;
  }
}
