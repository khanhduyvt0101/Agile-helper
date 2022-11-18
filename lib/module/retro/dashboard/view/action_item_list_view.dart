import '../../../../common/utils/convert.dart';
import '../../../../common/utils/style.dart';
import '../../../../data/model/retro/dashboard/action_item_model.dart';
import '../../../../data/repository/retro/dashboard_repository.dart';
import '../bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/user/token_login.dart';
import '../../board_retro/view/board_retro_view.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';

class ActionItemListViewArguments {
  final TokenLogin tokenLogin;

  ActionItemListViewArguments({this.tokenLogin});
}

class ActionItemListView extends StatefulWidget {
  final TokenLogin tokenLogin;
  const ActionItemListView({this.tokenLogin, Key key}) : super(key: key);

  @override
  State<ActionItemListView> createState() => _ActionItemListViewState();
}

class _ActionItemListViewState extends State<ActionItemListView> {
  DashBoardBloc _dashBoardBloc;

  @override
  void initState() {
    _dashBoardBloc.setDashboardRepository(
        DashboardRepository(token: widget.tokenLogin.token));
    _dashBoardBloc = BlocProvider.of<DashBoardBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarRetro(
        title: 'Action item list',
        isLogo: true,
        userNameEncrypt: widget.tokenLogin.userNameEncrypt,
        leadingAction: () {
          _dashBoardBloc.add(GetCountBoardForDashboardEvent());
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: PaddingConfig.paddingAppW,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder(
                  bloc: _dashBoardBloc,
                  builder: (context, state) {
                    if (state is LoadedItemActionState) {
                      return state.listActionItem != null
                          ? ListView.builder(
                              padding: EdgeInsets.only(
                                top: PaddingConfig.paddingSuperLargeH,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.listActionItem.length,
                              itemBuilder: (context, index) {
                                ActionItemModel actionItemModel =
                                    state.listActionItem[index];
                                return CardItem(
                                  titleItem: actionItemModel.nameItem,
                                  date: DateConvert
                                      .convertStringToDayAndNameOfMonth(
                                          actionItemModel.createAt),
                                  isCheck: actionItemModel.isDone,
                                  userNameEncryptAssignee:
                                      actionItemModel.userNameEncryptAssignee,
                                  idBoard: actionItemModel.idBoard,
                                  tokenLogin: widget.tokenLogin,
                                  titleBoard: actionItemModel.titleBoard,
                                );
                              })
                          : Center(
                              child: Text(
                                'No item',
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.center,
                              ),
                            );
                    } else {
                      return const CustomLoadingWidget();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatefulWidget {
  final String titleItem;
  final String date;
  final bool isCheck;
  final String titleBoard;
  final String idBoard;
  final TokenLogin tokenLogin;
  final List<Assignee> userNameEncryptAssignee;

  const CardItem({
    this.titleItem,
    this.date,
    this.isCheck,
    this.titleBoard,
    this.idBoard,
    this.tokenLogin,
    this.userNameEncryptAssignee,
    Key key,
  }) : super(key: key);

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool _checkedValue;
  bool isOverlayOpen = false;
  @override
  void initState() {
    _checkedValue = widget.isCheck;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: PaddingConfig.paddingSuperLargeH),
      height: ScreenUtil().screenHeight * 0.2,
      width: ScreenUtil().screenWidth,
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              isOverlayOpen = false;
            });
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: const Alignment(-1, -0.5),
                      child: Text(
                        widget.titleItem,
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: const Alignment(-1, 0),
                            child: FractionallySizedBox(
                              widthFactor: 0.3,
                              child: FittedBox(
                                child: Text(
                                  widget.date,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FractionallySizedBox(
                            alignment: Alignment.centerRight,
                            widthFactor: 1.3,
                            heightFactor: 1.3,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.centerRight,
                              child: Checkbox(
                                value: _checkedValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _checkedValue = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: const Alignment(-1, 0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                        context, ConfigRoutes.BOARD_RETRO_VIEW,
                                        arguments: BoardRetroViewArguments(
                                            boardId: widget.idBoard,
                                            tokenLogin: widget.tokenLogin,
                                            nameBoard: widget.titleBoard))
                                    .then((value) => {
                                          BlocProvider.of<DashBoardBloc>(
                                                  context)
                                              .add(
                                            LoadListActionItemEvent(
                                                token: widget.tokenLogin.token),
                                          )
                                        });
                              },
                              child: FractionallySizedBox(
                                widthFactor: 0.7,
                                heightFactor: 0.7,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icon/go_links.svg',
                                      ),
                                      SizedBox(
                                        width: PaddingConfig.paddingNormalW,
                                      ),
                                      Text(
                                        'Go to board',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isOverlayOpen = !isOverlayOpen;
                              });
                            },
                            child: FractionallySizedBox(
                              widthFactor: 0.7,
                              heightFactor: 0.7,
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.userNameEncryptAssignee.length
                                              .toString() +
                                          ' Assignee',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: PaddingConfig.paddingNormalW,
                                    ),
                                    widget.userNameEncryptAssignee.isNotEmpty &&
                                            !isOverlayOpen
                                        ? SvgPicture.asset(
                                            'assets/icon/narrow_right.svg',
                                          )
                                        : Container(
                                            width:
                                                PaddingConfig.paddingNormalW *
                                                    3,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              widget.userNameEncryptAssignee.isNotEmpty && isOverlayOpen
                  ? _overlayAvatar(context)
                  : const SizedBox.shrink()
            ],
          ),
          style: Style.buttonStyle()),
    );
  }

  Align _overlayAvatar(BuildContext context) {
    return Align(
      alignment: const Alignment(0.9, -0.3),
      child: FractionallySizedBox(
        heightFactor: 0.6,
        widthFactor: 0.2,
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.whiteBackground,
              border: Border.all(width: 0),
              borderRadius:
                  BorderRadius.circular(PaddingConfig.cornerRadiusFrame)),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: widget.userNameEncryptAssignee.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(top: PaddingConfig.paddingNormalH),
                  child: CircleAvatarCustom(
                    userNameEncrypt:
                        widget.userNameEncryptAssignee[index].userNameEncrypt,
                  ),
                );
              }),
        ),
      ),
    );
  }
}
