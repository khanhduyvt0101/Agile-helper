import '../../../../data/model/user/token_login.dart';
import '../bloc/board_game_bloc.dart';
import '../bloc/board_game_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/config/config.dart';
import '../../../../common/utils/widget/widget.dart';
import '../../../../data/model/planning_poker/game_setting.dart';
import '../../../../data/model/planning_poker/player_model.dart';
import '../bloc/board_game_state.dart';

class BoardGameViewArguments {
  final String gameId;
  final TokenLogin tokenLogin;

  BoardGameViewArguments({this.gameId, this.tokenLogin});
}

class BoardGameView extends StatefulWidget {
  final String gameId;
  final TokenLogin tokenLogin;
  const BoardGameView({this.gameId, this.tokenLogin, Key key})
      : super(key: key);

  @override
  State<BoardGameView> createState() => _BoardGameViewState();
}

class _BoardGameViewState extends State<BoardGameView> {
  BoardGameBloc _boardGameBloc;
  final List<Map<String, dynamic>> _listPlayerCard = [];
  final List<Map<String, dynamic>> _listSelectCard = [];

  final List<String> _dataSelected = [];

  List<Map<String, dynamic>> _listSubPlayerCardRight = [];
  List<Map<String, dynamic>> _listSubPlayerCardLeft = [];
  bool showCard = false;
  GameSettingModel _gameSettingModel;
  ListPlayerModel _listPlayerModel;
  String _valueUserSelected;
  String _adminId;

  @override
  void initState() {
    super.initState();
    _boardGameBloc = BlocProvider.of<BoardGameBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setupPlayNewJoinGame(args) {
    //insert _listPlayerCard
    for (var element in _listPlayerModel.list) {
      bool isExisted = false;
      for (int i = 0; i < _listPlayerCard.length; i++) {
        if (_listPlayerCard[i]['userNameEncrypt']
            .contains(element.userNameEncrypt)) {
          isExisted = true;
          break;
        }
      }
      if (!isExisted) {
        _listPlayerCard.add({
          'userNameEncrypt': element.userNameEncrypt,
          'active': element.card.isSelected,
          'userId': element.uid,
          'valueSelected': element.card.value
        });
      }
    }

    //update _listSelectCard
    for (var item in _listPlayerModel.list) {
      if (args.tokenLogin.id == item.uid && item.card.isSelected) {
        _valueUserSelected = item.card.value;
      }
    }
    for (int i = 0; i < _listSelectCard.length; i++) {
      if (_valueUserSelected != null &&
          _valueUserSelected.contains(_listSelectCard[i]['value'])) {
        _listSelectCard[i]['active'] = true;
      }
    }

    //setup display Player Card
    int length = _listPlayerCard.length;
    if (length > 3) {
      int middleIndex = (length - 2) ~/ 2;
      _listSubPlayerCardRight = _listPlayerCard.sublist(0, middleIndex);
      if (length >= 4) {
        _listSubPlayerCardLeft =
            _listPlayerCard.sublist(middleIndex, length - 2);
      }
    }
  }

  void setupCardSelector(GameSettingModel gameSettingModel) {
    _gameSettingModel = gameSettingModel;
    if (_listSelectCard.isEmpty) {
      _adminId = _gameSettingModel.userHostId;
      for (var item in _gameSettingModel.cardValue.listValue) {
        _listSelectCard.add(
          {'value': item.toString(), 'active': false, 'count': 0},
        );
      }
    }
  }

  void handleStateListener(BoardGameState state, args) {
    if (state is JoinGameState) {
      if (state.gameSettingModel != null) {
        setupCardSelector(state.gameSettingModel);
      }
      if (state.listPlayerModel != null) {
        _listPlayerModel = state.listPlayerModel;
        setupPlayNewJoinGame(args);
      }
    }
    if (state is NewPlayerJoinedState) {
      bool isNotExisted = true;
      for (int i = 0; i < _listPlayerCard.length; i++) {
        if (state.playerModel.userNameEncrypt
            .contains(_listPlayerCard[i]['userNameEncrypt'].toString())) {
          isNotExisted = false;
          break;
        }
      }
      if (isNotExisted) {
        _listPlayerCard.add({
          'userNameEncrypt': state.playerModel.userNameEncrypt,
          'active': state.playerModel.card.isSelected,
          'userId': state.playerModel.uid,
          'valueSelected': state.playerModel.card.value
        });
      }
    }
    if (state is CardSelectorState) {
      if (state.cardSelectorModel != null) {
        for (var item in _listPlayerCard) {
          if (item['userId']
              .toString()
              .contains(state.cardSelectorModel.userId)) {
            item['active'] = state.cardSelectorModel.card.isSelected;
            item['valueSelected'] = state.cardSelectorModel.card.value;
            break;
          }
        }
      }
    }
    if (state is RevealCardsState) {
      showCard = true;
    }
    if (state is StartNewVotingState) {
      showCard = false;
      for (var item in _listPlayerCard) {
        item['active'] = false;
        item['valueSelected'] = null;
      }
      for (var item in _listSelectCard) {
        item['active'] = false;
      }
    }
    if (state is PlayerHasLeftState) {
      for (var item in _listPlayerCard) {
        if (item['userId'].toString().contains(state.userId.toString())) {
          _listPlayerCard.remove(item);
          break;
        }
      }
    }
    if (state is UpdateAdminState) {
      _adminId = state.adminId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarDefault(
          const Icon(
            Icons.close,
            size: 35,
          ),
          () {
            Navigator.pop(context);
          },
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return _DialogInvite(gameId: widget.gameId);
                  });
            },
            child: Container(
              margin: EdgeInsets.only(
                  top: PaddingConfig.paddingIconActionApBarH,
                  bottom: PaddingConfig.paddingIconActionApBarH,
                  right: PaddingConfig.paddingNormalW),
              height: 30.h,
              width: 70.w,
              decoration: BoxDecoration(
                  color: AppColors.whiteBackground,
                  border: Border.all(color: AppColors.whiteBackground),
                  borderRadius:
                      BorderRadius.circular(PaddingConfig.circleButtonRadius)),
              child: const Center(
                  child: Text(
                'Invite',
                style: TextStyle(color: AppColors.primary),
              )),
            ),
          ),
        ),
        body: BlocListener<BoardGameBloc, BoardGameState>(
            bloc: _boardGameBloc,
            listener: (context, state) {
              handleStateListener(state, widget);
            },
            child: BlocBuilder<BoardGameBloc, BoardGameState>(
                bloc: _boardGameBloc,
                builder: (context, state) {
                  if (state is BoardGameLoadingState) {
                    return const Center(child: CustomLoadingWidget());
                  }
                  if (state is JoinGameErrorFromServerState) {
                    return const Center(
                        child: Text(
                            'Something wrong from server, please try again'));
                  }
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: PaddingConfig.paddingNormalW * 2,
                        vertical: PaddingConfig.paddingNormalH),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Voting: ${_gameSettingModel != null ? _gameSettingModel.nameBoard : ''}',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        _buildPlayerCardBloc(widget),
                        SizedBox(
                            height: ScreenUtil().screenHeight * 1 / 5,
                            child: showCard
                                ? _buildResultSelectorCards()
                                : _buildSelectorCard(widget)),
                        SizedBox(
                          height: 2 * PaddingConfig.paddingNormalH,
                        ),
                      ],
                    ),
                  );
                })));
  }

  Widget _buildPlayerCardBloc(args) {
    return Column(
      children: [
        _listPlayerCard.isNotEmpty && _listSubPlayerCardLeft.isNotEmpty
            ? SizedBox(
                height: ScreenUtil().screenHeight * 1 / 6,
                child: _buildPlayerCardHorizontal(_listSubPlayerCardRight))
            : const SizedBox.shrink(),
        SizedBox(
            height: ScreenUtil().screenHeight * 1 / 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _listPlayerCard.isNotEmpty
                    ? TableCard(
                        userNameEncrypt:
                            _listPlayerCard[_listPlayerCard.length - 1]
                                    ['userNameEncrypt']
                                .toString()
                                .trim()
                                .split(' ')[0],
                        valueSelected:
                            _listPlayerCard[_listPlayerCard.length - 1]
                                ['valueSelected'],
                        active: _listPlayerCard[_listPlayerCard.length - 1]
                            ['active'],
                        isTopCard: true,
                        showCard: showCard)
                    : const SizedBox.shrink(),
                Container(
                  width: ScreenUtil().screenWidth * 0.6,
                  decoration: BoxDecoration(
                      color: AppColors.greenBackground,
                      border: Border.all(color: AppColors.primary),
                      borderRadius:
                          BorderRadius.circular(PaddingConfig.cornerRadius)),
                  child: _adminId == args.tokenLogin.id
                      ? Center(
                          child: SizedBox(
                          width: ScreenUtil().screenWidth * 0.5,
                          child: showCard
                              ? TextButtonFunction(
                                  title: "Start new voting",
                                  onPressed: () => {
                                        _boardGameBloc.add(StartNewVotingEvent(
                                            gameId: args.gameId)),
                                        //hard code for waiting BE fix not emit event after client emit start new vote event
                                        setState(() {
                                          showCard = false;
                                          for (var item in _listPlayerCard) {
                                            item['active'] = false;
                                            item['valueSelected'] = null;
                                          }
                                          for (var item in _listSelectCard) {
                                            item['active'] = false;
                                          }
                                        })
                                      })
                              : TextButtonFunction(
                                  title: "Show cards",
                                  onPressed: () => {
                                        _dataSelected.clear(),
                                        for (var item in _listPlayerCard)
                                          {
                                            if (item['active'])
                                              {
                                                _dataSelected.add(
                                                    item['valueSelected']
                                                        .toString()),
                                              }
                                          },
                                        if (_dataSelected.isNotEmpty)
                                          {
                                            _boardGameBloc.add(ShowCardEvent(
                                                gameId: args.gameId)),
                                            //hard code for waiting BE fix not emit event after client emit reveal event
                                            setState(() => showCard = true),
                                          }
                                      }),
                        ))
                      : SizedBox(
                          height: ScreenUtil().screenHeight * 0.3,
                        ),
                ),
                _listPlayerCard.isNotEmpty && _listPlayerCard.length > 1
                    ? TableCard(
                        userNameEncrypt:
                            _listPlayerCard[_listPlayerCard.length - 2]
                                    ['userNameEncrypt']
                                .toString()
                                .trim(),
                        valueSelected:
                            _listPlayerCard[_listPlayerCard.length - 2]
                                ['valueSelected'],
                        active: _listPlayerCard[_listPlayerCard.length - 2]
                            ['active'],
                        isTopCard: true,
                        showCard: showCard)
                    : SizedBox(
                        height: 90.h,
                        width: 40.w,
                      ),
              ],
            )),
        _listPlayerCard.isNotEmpty && _listSubPlayerCardLeft.isNotEmpty
            ? SizedBox(
                height: ScreenUtil().screenHeight * 1 / 6,
                child: _buildPlayerCardHorizontal(_listSubPlayerCardLeft))
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildSelectorCard(args) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _listSelectCard.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              SizedBox(
                height: ScreenUtil().screenHeight * 1 / 5,
                child: InkWell(
                    onTap: () {
                      setState(() {
                        for (var i = 0; i < _listSelectCard.length; i++) {
                          if (i != index) {
                            _listSelectCard[i]['active'] = false;
                          }
                        }
                        _listSelectCard[index]['active'] =
                            !_listSelectCard[index]['active'];

                        //update status user SelectorCard when joinGame
                        for (var item in _listPlayerCard) {
                          if (item['userId']
                              .toString()
                              .contains(args.tokenLogin.id)) {
                            item['active'] = _listSelectCard[index]['active'];
                            item['valueSelected'] =
                                _listSelectCard[index]['value'];
                            break;
                          }
                        }

                        _boardGameBloc.add(CardSelectorEvent(
                            playerModel: PlayerModel(
                                uid: args.tokenLogin.id,
                                card: CardPlayer(
                                    value: _listSelectCard[index]['value']
                                        .toString()
                                        .trim(),
                                    isSelected: _listSelectCard[index]
                                        ['active'])),
                            gameId: args.gameId,
                            event: _listSelectCard[index]['active']
                                ? PokerSocketEvent.SELECT_CARD
                                : PokerSocketEvent.DESELECT_CARD,
                            item: _listSelectCard[index]['value']
                                .toString()
                                .trim()));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CardGame(
                            value_cards: _listSelectCard[index]['value']
                                .toString()
                                .trim(),
                            active: _listSelectCard[index]['active'],
                            data: ''),
                        _listSelectCard[index]['active']
                            ? SizedBox(
                                height: PaddingConfig.paddingSuperLargeH,
                              )
                            : Container()
                      ],
                    )),
              ),
              SizedBox(
                width: PaddingConfig.paddingLargeW,
              )
            ],
          );
        });
  }

  Widget _buildResultSelectorCards() {
    _dataSelected.clear();
    for (var item in _listPlayerCard) {
      if (item['active']) {
        _dataSelected.add(item['valueSelected'].toString());
      }
    }

    var map = {};
    for (var x in _dataSelected) {
      map[x] = !map.containsKey(x) ? (1) : (map[x] + 1);
    }
    List<ResultObject> list = [];
    map.forEach((k, v) => list.add(ResultObject(value: k, count: v)));

    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              SizedBox(
                height: ScreenUtil().screenHeight * 1 / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardGame(
                        value_cards: list[index].value,
                        active: false,
                        data: (list[index].count * 100 / _dataSelected.length)
                                .toStringAsFixed(2) +
                            "%")
                  ],
                ),
              ),
              SizedBox(
                width: PaddingConfig.paddingLargeW,
              )
            ],
          );
        });
  }

  Widget _buildPlayerCardHorizontal(List<Map<String, dynamic>> listValue) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listValue.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              SizedBox(
                height: ScreenUtil().screenHeight * 1 / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TableCard(
                        userNameEncrypt: listValue[index]['userNameEncrypt']
                            .toString()
                            .trim(),
                        valueSelected: listValue[index]['valueSelected'],
                        active: listValue[index]['active'],
                        isTopCard: false,
                        showCard: showCard),
                  ],
                ),
              ),
              SizedBox(
                width: PaddingConfig.paddingLargeW,
              )
            ],
          );
        });
  }
}

class _DialogInvite extends StatelessWidget {
  final String gameId;
  const _DialogInvite({this.gameId, Key key}) : super(key: key);

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
                      GetHost.urlInviteGame() + gameId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
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
                              text: GetHost.urlInviteGame() + gameId));
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultObject {
  final String value;
  final int count;
  ResultObject({this.value, this.count});
}
