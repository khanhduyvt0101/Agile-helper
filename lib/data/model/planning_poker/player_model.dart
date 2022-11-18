// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';

import '../../../../common/config/config.dart';

class ListPlayerModel extends Equatable {
  List<PlayerModel> list;

  ListPlayerModel({this.list});

  static ListPlayerModel fromDynamic(Map<String, dynamic> _playerModel) {
    List<PlayerModel> _list = [];
    for (int i = 0; i < _playerModel[SerializeListPlayer.KEY].length; i++) {
      _list.add(PlayerModel.getPlayerFromFromListJson(
          _playerModel[SerializeListPlayer.KEY][i]));
    }
    ListPlayerModel playerModel = ListPlayerModel(list: _list);
    return playerModel;
  }

  @override
  List<Object> get props => [];
}

class PlayerModel extends Equatable {
  final String uid;
  final String displayName;
  final String userNameEncrypt;
  CardPlayer card;

  PlayerModel({this.displayName, this.userNameEncrypt, this.card, this.uid});

  static PlayerModel getPlayerHasJoinFromJson(
      Map<String, dynamic> _playerModel) {
    //{players: [{uid: c19bcbb0-2787-44a3-a093-47f5a3f515d6, displayName: Thuyen,
    //isSpectator: false, joinedId: h62_CX3--K0AAq4oAAA3, userNameEncrypt: 0wocuJ7q2hjFg65W644dNzoevV7sQycDVr5hFTxOijK,
    //card: {value: null, isSelected: false}}], type: onlinePlayers}
    Map<String, dynamic> playerModelDetail = _playerModel[SerializePlayer.KEY];
    PlayerModel playerModel = PlayerModel(
        displayName: playerModelDetail[SerializePlayer.DISPLAY_NAME],
        uid: playerModelDetail[SerializePlayer.UID],
        userNameEncrypt: playerModelDetail[SerializePlayer.USERNAME_ENCRYPT],
        card: CardPlayer.fromDynamic(playerModelDetail[SerializePlayer.CARD]));
    return playerModel;
  }

  static PlayerModel getPlayerFromFromListJson(
      Map<String, dynamic> _playerModel) {
    PlayerModel playerModel = PlayerModel(
        displayName: _playerModel[SerializePlayer.DISPLAY_NAME],
        uid: _playerModel[SerializePlayer.UID],
        userNameEncrypt: _playerModel[SerializePlayer.USERNAME_ENCRYPT],
        card: CardPlayer.fromDynamic(_playerModel[SerializeCard.CARD]));
    return playerModel;
  }

  //{type: newPlayerHasJoined, player: {uid: 415c3680-68c7-4909-a4b4-702fb1f24ea1,
  //displayName: Duy Trong Khanh Bui, userNameEncrypt: 1Eimfy6rM4DvSdWwAFxjWoOlU4a0iMcrHWln0u8kMZP,
  //isSpectator: false, joinedId: null, card: {value: null, isSelected: false}}}
  static String getUserIdFromPlayerHasLeftFromJson(Map<String, dynamic> data) {
    return data[SerializePlayer.USER_ID];
  }

  static String getAdminIdWhenAdminLeftFromJson(Map<String, dynamic> data) {
    return data[SerializePlayer.GAME][SerializePlayer.ADMIN_ID];
  }

  @override
  List<Object> get props => [];
}

class CardPlayer extends Equatable {
  final String value;
  final bool isSelected;

  const CardPlayer({this.value, this.isSelected});

  static CardPlayer fromDynamic(Map<String, dynamic> _card) {
    CardPlayer card = CardPlayer(
      value: _card[SerializeCard.VALUE],
      isSelected: _card[SerializeCard.IS_SELECTED],
    );
    return card;
  }

  @override
  List<Object> get props => [];
}
