import '../../../../data/model/retro/board_retro/action_card_model.dart';
import '../../../../data/model/user/token_login.dart';
import '../bloc/board_retro_event.dart';
import 'card_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/style.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/retro/board_retro/board_retro_model.dart';
import '../bloc/board_retro_bloc.dart';

class StagesView extends StatefulWidget {
  final List<Stages> listStages;
  final TokenLogin tokenLogin;
  final List<String> orderStages;
  const StagesView(
      {this.listStages, this.tokenLogin, this.orderStages, Key key})
      : super(key: key);

  @override
  State<StagesView> createState() => _StagesViewState();
}

class _StagesViewState extends State<StagesView> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: widget.listStages.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          StagesContainer(
        stages: widget.listStages[itemIndex],
        tokenLogin: widget.tokenLogin,
        orderStages: widget.orderStages,
      ),
      options: CarouselOptions(
        height: ScreenUtil().screenHeight * 0.8,
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 0.8,
        aspectRatio: 2.0,
        enableInfiniteScroll: false,
      ),
    );
  }
}

class StagesContainer extends StatefulWidget {
  final Stages stages;
  final TokenLogin tokenLogin;
  final List<String> orderStages;
  const StagesContainer(
      {this.tokenLogin, this.stages, this.orderStages, Key key})
      : super(key: key);

  @override
  State<StagesContainer> createState() => _StagesContainerState();
}

class _StagesContainerState extends State<StagesContainer> {
  bool isOverlayOpen = false;
  final _formKey = GlobalKey<FormState>();
  bool _isCreateCmt = false;
  final _textCreateCmtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: PaddingConfig.paddingLargeW),
      color: AppColors.whiteBackground,
      width: ScreenUtil().screenWidth * 0.9,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.stages.title,
              style: Theme.of(context).textTheme.headline1,
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
                size: 35,
              ),
            ),
          ],
        ),
        const Divider(color: Colors.black),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0.0),
                        shrinkWrap: true,
                        children: <Widget>[
                          _createCardContainer(context),
                        ]),
                    _listViewCard(),
                  ],
                ),
              ),
              isOverlayOpen ? _overlaySetting(context) : const SizedBox.shrink()
            ],
          ),
        ),
      ]),
    );
  }

  Widget _createCardContainer(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      style: Style.buttonStyle().copyWith(
        elevation: MaterialStateProperty.all(3),
      ),
      child: Container(
        margin: EdgeInsets.only(
          top: PaddingConfig.paddingNormalH,
          bottom: PaddingConfig.paddingNormalH,
        ),
        padding: EdgeInsets.symmetric(horizontal: PaddingConfig.paddingNormalW),
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PaddingConfig.cornerRadius),
            color: _isCreateCmt ? AppColors.grey : AppColors.pinkSlight),
        child: _isCreateCmt
            ? Column(
                children: [
                  SizedBox(
                    height: PaddingConfig.paddingLargeH,
                  ),
                  _buildTextInput('Enter title', _textCreateCmtController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            BlocProvider.of<BoardRetroBloc>(context).add(
                                CreateCardEvent(
                                    boardId: widget.stages.boardId,
                                    createCardModel: CreateCardModel(
                                        color: widget.stages.color,
                                        stageId: widget.stages.id,
                                        title: _textCreateCmtController.text,
                                        position: widget.stages.position,
                                        userId: widget.tokenLogin.id,
                                        orderCards: widget.stages.orderCards)));
                            setState(() {
                              _isCreateCmt = !_isCreateCmt;
                              _textCreateCmtController.clear();
                            });
                          },
                          icon:
                              Image.asset('assets/image/check_mark_blue.png')),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              _isCreateCmt = !_isCreateCmt;
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.black,
                          )),
                    ],
                  )
                ],
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    _isCreateCmt = !_isCreateCmt;
                  });
                },
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add new card ',
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

  ListView _listViewCard() {
    return ListView.builder(
        padding: EdgeInsets.only(
          top: PaddingConfig.paddingNormalH,
        ),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: widget.stages.cards.length,
        itemBuilder: (context, index) {
          List<Cards> lisCard = [];
          //sort cards follow orderCards
          for (var element in widget.stages.orderCards) {
            for (var ele in widget.stages.cards) {
              if (ele.id == element) {
                lisCard.add(ele);
                break;
              }
            }
          }

          Cards cards = lisCard[index];

          return CardItem(
            orderCards: widget.stages.orderCards,
            cards: cards,
            tokenLogin: widget.tokenLogin,
          );
        });
  }

  Align _overlaySetting(BuildContext context) {
    return Align(
      alignment: const Alignment(1.2, -1.05),
      child: FractionallySizedBox(
        heightFactor: 0.2,
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
                        builder: (_) => DialogChangeColorStage(
                              currentColor: widget.stages.color,
                              function: (Color color) {
                                String stringColor = '#' +
                                    color
                                        .toString()
                                        .split('xff')[1]
                                        .split(')')[0];
                                BlocProvider.of<BoardRetroBloc>(context).add(
                                    ChangeColorStageEvent(
                                        boardId: widget.stages.boardId,
                                        stageId: widget.stages.id,
                                        color: stringColor));
                                Navigator.pop(context);
                              },
                            )).then((value) {
                      setState(() {
                        isOverlayOpen = false;
                      });
                    });
                  },
                  title: 'Set Color'),
              const Expanded(child: Divider(color: Colors.black)),
              ButtonOverlay(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => CustomDialog(
                              title: 'Delete column',
                              content: 'Are you sure to delete this column?',
                              ok: 'Delete',
                              onOk: () {
                                List<String> _orderStages = widget.orderStages;
                                _orderStages.remove(widget.stages.id);
                                BlocProvider.of<BoardRetroBloc>(context).add(
                                    DeleteStageEvent(
                                        boardId: widget.stages.boardId,
                                        stageId: widget.stages.id,
                                        orderStages: _orderStages));
                                Navigator.pop(context);
                                setState(() {
                                  isOverlayOpen = false;
                                });
                              },
                            ));
                  },
                  title: 'Delete column'),
              const Expanded(child: Divider(color: Colors.black)),
              ButtonOverlay(
                  onTap: () {
                    BlocProvider.of<BoardRetroBloc>(context).add(
                        ClearStageEvent(
                            boardId: widget.stages.boardId,
                            stageId: widget.stages.id));
                    setState(() {
                      isOverlayOpen = false;
                    });
                  },
                  title: 'Clear column'),
              const Expanded(child: Divider(color: Colors.black)),
              ButtonOverlay(
                  onTap: () {
                    final _formKey = GlobalKey<FormState>();
                    final _textController = TextEditingController();
                    showDialog(
                        context: context,
                        builder: (_) => DialogRetro(
                              formKey: _formKey,
                              onChange: (_) {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                              },
                              textController: _textController,
                              title: 'Rename column',
                              hintText: 'Name',
                              textButton: 'Rename',
                              actionButton: () {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                BlocProvider.of<BoardRetroBloc>(context).add(
                                    RenameStageEvent(
                                        boardId: widget.stages.boardId,
                                        title: _textController.text,
                                        stageId: widget.stages.id));
                                Navigator.pop(context);
                              },
                            )).then((value) {
                      setState(() {
                        isOverlayOpen = false;
                      });
                    });
                  },
                  title: 'Rename Column'),
            ],
          ),
        ),
      ),
    );
  }
}
