// ignore_for_file: must_be_immutable
import 'package:agile_helper/module/retro/dashboard/bloc/dashboard_event.dart';
import 'package:agile_helper/module/retro/dashboard/bloc/dashboard_state.dart';
import 'package:agile_helper/module/retro/dashboard/view/create_board_view.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/style.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/retro/dashboard/board_model.dart';
import '../../../../data/model/user/token_login.dart';
import '../../board_retro/view/board_retro_view.dart';
import '../bloc/dashboard_bloc.dart';

class BoardViewArguments {
  final BoardType boardType;
  final TokenLogin tokenLogin;

  BoardViewArguments({this.tokenLogin, this.boardType});
}

class BoardView extends StatefulWidget {
  final BoardType boardType;
  final TokenLogin tokenLogin;
  const BoardView({this.tokenLogin, Key key, this.boardType}) : super(key: key);

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  DashBoardBloc _dashBoardBloc;

  @override
  void initState() {
    _dashBoardBloc = BlocProvider.of<DashBoardBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarRetro(
          title: widget.boardType == BoardType.Public
              ? 'Public boards'
              : 'Archived boards',
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
                      if (state is LoadedBoardState) {
                        return state.listPublicBoard != null
                            ? ListView.builder(
                                padding: EdgeInsets.only(
                                  top: PaddingConfig.paddingSuperLargeH,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.listPublicBoard.length,
                                itemBuilder: (context, index) {
                                  return CardBoard(
                                    tokenLogin: widget.tokenLogin,
                                    titleBoard:
                                        state.listPublicBoard[index].nameBoard,
                                    date: state.listPublicBoard[index].createAt
                                        .split(',')[0],
                                    countCard: state
                                        .listPublicBoard[index].numberCard
                                        .toString(),
                                    boardType: widget.boardType,
                                    idInvite: state.listPublicBoard[index].id,
                                    oldAuthor:
                                        state.listPublicBoard[index].oldAuthor,
                                  );
                                })
                            : Center(
                                child: Text(
                                  'No board',
                                  style: Theme.of(context).textTheme.bodyText1,
                                  textAlign: TextAlign.center,
                                ),
                              );
                      } else {
                        return const CustomLoadingWidget();
                      }
                    }),
                widget.boardType == BoardType.Public
                    ? InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                _dashBoardBloc
                                    .add(LoadListTemplateBoardEvent());
                                return CreateBoardView(
                                  tokenLogin: widget.tokenLogin,
                                );
                              }).then((value) {
                            if (widget.boardType == BoardType.Public) {
                              _dashBoardBloc.add(
                                LoadPublicBoardEvent(),
                              );
                            } else if (widget.boardType == BoardType.Archived) {
                              _dashBoardBloc.add(
                                LoadArchivedBoardEvent(),
                              );
                            } else {
                              _dashBoardBloc.add(
                                LoadListActionItemEvent(
                                    token: widget.tokenLogin.token),
                              );
                            }
                          });
                        },
                        child: const CreateNewBoard())
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ));
  }
}

class CreateNewBoard extends StatelessWidget {
  const CreateNewBoard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppColors.shadow,
      strokeWidth: 3,
      dashPattern: const [10, 6],
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: PaddingConfig.paddingSuperLargeH),
          height: ScreenUtil().screenHeight * 0.16,
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

class CardBoard extends StatefulWidget {
  final TokenLogin tokenLogin;
  final String idInvite;
  final String titleBoard;
  final String oldAuthor;
  final String date;
  final String countCard;
  final BoardType boardType;

  const CardBoard({
    this.tokenLogin,
    this.idInvite,
    this.titleBoard,
    this.oldAuthor,
    this.date,
    this.countCard,
    this.boardType,
    Key key,
  }) : super(key: key);

  @override
  State<CardBoard> createState() => _CardBoardState();
}

class _CardBoardState extends State<CardBoard> {
  bool isOverlayOpen = false;
  DashBoardBloc _dashBoardBloc;

  @override
  void initState() {
    _dashBoardBloc = BlocProvider.of<DashBoardBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String count = widget.countCard ?? '0';
    String text = widget.countCard != null && int.parse(widget.countCard) > 1
        ? ' cards'
        : ' card';
    return Container(
      margin: EdgeInsets.only(bottom: PaddingConfig.paddingSuperLargeH),
      height: ScreenUtil().screenHeight * 0.2,
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              isOverlayOpen = false;
              widget.boardType == BoardType.Public
                  ? Navigator.pushNamed(context, ConfigRoutes.BOARD_RETRO_VIEW,
                          arguments: BoardRetroViewArguments(
                              boardId: widget.idInvite,
                              tokenLogin: widget.tokenLogin,
                              nameBoard: widget.titleBoard))
                      .then((value) => {
                            BlocProvider.of<DashBoardBloc>(context).add(
                              LoadPublicBoardEvent(),
                            )
                          })
                  : showDialog(
                      context: context,
                      builder: (_) => CustomDialog(
                            title: 'Cannot join board',
                            content:
                                'Need to restore this board for accessible!',
                            ok: 'OK',
                            onOk: () => Navigator.pop(context),
                          ));
            });
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.titleBoard,
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  widget.oldAuthor != null
                      ? Expanded(
                          child: Center(
                            child: Text(
                              "Tranfered by ${widget.oldAuthor}",
                              style: Theme.of(context).textTheme.titleSmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.date,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              count + text,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: GetHost.urlInviteBoardRetro() +
                                      widget.idInvite));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.link,
                                  size: 30,
                                  color: AppColors.black,
                                ),
                                Text(
                                  'URL',
                                  style: Theme.of(context).textTheme.bodyText2,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isOverlayOpen = !isOverlayOpen;
                            });
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.whiteBackground),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      side: BorderSide.none))),
                          child: const Icon(
                            Icons.settings,
                            size: 30,
                            color: AppColors.black,
                          ),
                        )),
                      ],
                    ),
                  )
                ],
              ),
              isOverlayOpen
                  ? (widget.boardType == BoardType.Public
                      ? _overlayPublish(context)
                      : _overlayArchived(context))
                  : const SizedBox.shrink(),
            ],
          ),
          style: Style.buttonStyle()),
    );
  }

  Align _overlayPublish(BuildContext context) {
    return Align(
      alignment: const Alignment(0.8, -0.3),
      child: FractionallySizedBox(
        heightFactor: 0.6,
        widthFactor: 0.4,
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
                    BlocProvider.of<DashBoardBloc>(context)
                        .add(ArchiveBoardEvent(idBoard: widget.idInvite));
                    setState(() {});
                  },
                  title: 'Archived'),
              const Expanded(child: Divider(color: Colors.black)),
              ButtonOverlay(
                  onTap: () {
                    BlocProvider.of<DashBoardBloc>(context)
                        .add(CloneBoardEvent(idBoard: widget.idInvite));
                    setState(() {
                      isOverlayOpen = false;
                      Navigator.pushNamed(
                              context, ConfigRoutes.BOARD_RETRO_VIEW,
                              arguments: BoardRetroViewArguments(
                                  boardId: widget.idInvite,
                                  tokenLogin: widget.tokenLogin,
                                  nameBoard: widget.titleBoard))
                          .then((value) => {
                                BlocProvider.of<DashBoardBloc>(context).add(
                                  LoadPublicBoardEvent(),
                                )
                              });
                    });
                  },
                  title: 'Clone board'),
              const Expanded(child: Divider(color: Colors.black)),
              ButtonOverlay(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return TransferBoardView(
                              tokenLogin: widget.tokenLogin,
                              boardId: widget.idInvite);
                        }).then((value) => {
                          if (widget.boardType == BoardType.Public)
                            {
                              _dashBoardBloc.add(
                                LoadPublicBoardEvent(),
                              )
                            }
                          else if (widget.boardType == BoardType.Archived)
                            {
                              _dashBoardBloc.add(
                                LoadArchivedBoardEvent(),
                              )
                            }
                          else
                            {
                              _dashBoardBloc.add(
                                LoadListActionItemEvent(
                                    token: widget.tokenLogin.token),
                              )
                            }
                        });
                  },
                  title: 'Transfer board')
            ],
          ),
        ),
      ),
    );
  }

  Align _overlayArchived(BuildContext context) {
    return Align(
      alignment: const Alignment(0.8, -0.3),
      child: FractionallySizedBox(
        heightFactor: 0.6,
        widthFactor: 0.4,
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
                    BlocProvider.of<DashBoardBloc>(context)
                        .add(DeleteBoardEvent(idBoard: widget.idInvite));
                    setState(() {});
                  },
                  title: 'Delete board'),
              const Expanded(flex: 1, child: Divider(color: Colors.black)),
              ButtonOverlay(
                  onTap: () {
                    BlocProvider.of<DashBoardBloc>(context)
                        .add(RestoreBoardEvent(idBoard: widget.idInvite));
                    setState(() {});
                  },
                  title: 'Restore board')
            ],
          ),
        ),
      ),
    );
  }
}

class TransferBoardView extends StatefulWidget {
  final List<UserModel> userList;
  final List<String> userNames;
  final String boardId;

  final TokenLogin tokenLogin;
  const TransferBoardView(
      {this.tokenLogin, Key key, this.userList, this.userNames, this.boardId})
      : super(key: key);

  @override
  State<TransferBoardView> createState() => _TransferBoardViewState();
}

class _TransferBoardViewState extends State<TransferBoardView> {
  DashBoardBloc _dashBoardBloc;
  String keyword = "";
  UserModel selectedUser;
  final userNameController = TextEditingController();

  @override
  void initState() {
    _dashBoardBloc = BlocProvider.of<DashBoardBloc>(context);
    _dashBoardBloc.add(SearchUserNameChange(keyword: ""));
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.only(
            left: PaddingConfig.paddingNormalW,
            top: PaddingConfig.paddingNormalH,
            bottom: PaddingConfig.paddingNormalH,
            right: PaddingConfig.paddingNormalW),
        child: SizedBox(
          height: ScreenUtil().screenHeight * 2 / 8,
          width: ScreenUtil().screenWidth,
          child: Container(
            padding: EdgeInsets.only(
                left: PaddingConfig.paddingLargeW,
                top: PaddingConfig.paddingLargeH,
                bottom: PaddingConfig.paddingNormalH,
                right: PaddingConfig.paddingNormalW),
            color: AppColors.whiteBackground,
            child: BlocBuilder<DashBoardBloc, DashBoardState>(
                builder: (context, state) {
              if (state is SearchUsersState) {
                List<UserModel> usersSearched = [];
                if (state.listUserSearched.isNotEmpty) {
                  usersSearched = state.listUserSearched;
                }
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextInputCustom(
                          hintText: "Type to find user",
                          textController: userNameController,
                          obscureText: false,
                          onChange: (value) => _onSearchChange(value),
                        ),
                      ),
                    ),
                    usersSearched.isNotEmpty
                        ? Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: ListView(
                                padding: EdgeInsets.only(
                                    bottom: PaddingConfig.paddingNormalH),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  ...usersSearched
                                      .map(
                                        (user) => ListTile(
                                          title: Text(user.displayName,
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                          onTap: () => {
                                            userNameController.text =
                                                user.displayName,
                                            selectedUser = user
                                          },
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => {Navigator.pop(context)},
                            child: Text(
                              "CANCEL",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          TextButton(
                            onPressed: () => {
                              _dashBoardBloc.add(TransferBoardEvent(
                                  userId: selectedUser.id,
                                  boardId: widget.boardId)),
                              Navigator.pop(context)
                            },
                            child: Text(
                              "CONFIRM",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return Container();
            }),
          ),
        ));
  }

  void _onSearchChange(String value) {
    print("on search change keyword:: " + value);
    keyword = value;
    _dashBoardBloc.add(SearchUserNameChange(keyword: keyword));
  }
}
