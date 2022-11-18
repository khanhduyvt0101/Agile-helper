import 'package:equatable/equatable.dart';

class JoinGameModel extends Equatable {
  final String gameId;
  final Player player;

  const JoinGameModel({this.gameId, this.player});

  Map<String, Object> toJson() {
    return {"gameId": gameId, "player": player.toJson()};
  }

  @override
  List<Object> get props => [];
}

class Player extends Equatable {
  final String uid;
  final String displayName;
  final String userNameEncrypt;

  const Player({this.uid, this.displayName, this.userNameEncrypt});

  Map<String, Object> toJson() {
    return {
      "uid": uid,
      "displayName": displayName,
      "userNameEncrypt": userNameEncrypt,
      "isSpectator": false,
      "joinedId": null,
      "card": {
        "value": null,
        "isSelected": false,
      },
    };
  }

  @override
  List<Object> get props => [];
}
