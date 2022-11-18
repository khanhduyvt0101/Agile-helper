import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/convert.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/retro/board_retro/board_retro_model.dart';
import '../bloc/board_retro_bloc.dart';
import '../bloc/board_retro_event.dart';

class ContainerComment extends StatefulWidget {
  final String stageId;
  final String boardId;
  final Comments comments;
  final String userId;
  final String content;
  final String updatedAt;
  final bool isOwnerComment;
  const ContainerComment(
      {this.content,
      this.updatedAt,
      this.isOwnerComment,
      this.comments,
      this.userId,
      this.boardId,
      this.stageId,
      Key key})
      : super(key: key);

  @override
  State<ContainerComment> createState() => _ContainerCommentState();
}

class _ContainerCommentState extends State<ContainerComment> {
  final _textEditCmtController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
          margin: EdgeInsets.only(
            bottom: PaddingConfig.paddingNormalH,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: PaddingConfig.paddingNormalW,
              vertical: PaddingConfig.paddingNormalH),
          width: ScreenUtil().screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius),
              color: AppColors.grey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: PaddingConfig.paddingNormalH),
                child: Text(widget.content,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyText2),
              ),
              Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                          DateConvert.convertStringToDayForCommentCard(
                              widget.updatedAt),
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                    Expanded(
                      child: widget.isOwnerComment
                          ? FittedBox(
                              child: Row(
                                children: [
                                  IconButton(
                                      splashColor: AppColors.primary,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return _dialogEditComment();
                                            });
                                      },
                                      icon: Image.asset(
                                          'assets/image/pencil.png')),
                                  IconButton(
                                      splashColor: AppColors.primary,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => CustomDialog(
                                                  title: 'Delete comment',
                                                  content:
                                                      'Are you sure to delete this comment?',
                                                  ok: 'Delete',
                                                  onOk: () {
                                                    BlocProvider.of<
                                                                BoardRetroBloc>(
                                                            context)
                                                        .add(DeleteCommentCardEvent(
                                                            boardId:
                                                                widget.boardId,
                                                            userId:
                                                                widget.userId,
                                                            stageId:
                                                                widget.stageId,
                                                            cardId: widget
                                                                .comments
                                                                .cardId,
                                                            commentId: widget
                                                                .comments.id));
                                                    Navigator.pop(context);
                                                  },
                                                ));
                                      },
                                      icon: Image.asset(
                                          'assets/image/recycle_bin.png'))
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _dialogEditComment() {
    _textEditCmtController.text = widget.content;
    return Dialog(
      child: Container(
          margin: EdgeInsets.only(
            bottom: PaddingConfig.paddingNormalH,
          ),
          padding:
              EdgeInsets.symmetric(horizontal: PaddingConfig.paddingNormalW),
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
              _buildTextInput(_textEditCmtController),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        BlocProvider.of<BoardRetroBloc>(context).add(
                            EditCommentCardEvent(
                                boardId: widget.boardId,
                                userId: widget.userId,
                                stageId: widget.stageId,
                                cardId: widget.comments.cardId,
                                commentId: widget.comments.id,
                                content: _textEditCmtController.text));
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
          )),
    );
  }

  Widget _buildTextInput(TextEditingController textEditingController) {
    return Form(
        key: _formKey,
        child: TextInputForCmtInCard(
          autofocus: false,
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
}
