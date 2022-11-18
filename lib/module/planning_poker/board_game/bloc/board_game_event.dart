// ignore_for_file: must_be_immutable`, must_be_immutable
import 'package:equatable/equatable.dart';

import '../../../../data/model/planning_poker/player_model.dart';
import '../../../../data/model/user/token_login.dart';

abstract class BoardGameEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class JoinGameEvent extends BoardGameEvent {
  final TokenLogin tokenLogin;
  final String gameId;
  JoinGameEvent({this.tokenLogin, this.gameId});
  @override
  List<Object> get props => [tokenLogin];
}

class JoinGameErrorFromServerEvent extends BoardGameEvent {
  final String error;
  JoinGameErrorFromServerEvent({this.error});
  @override
  List<Object> get props => [error];
}

class OnMessageEvent extends BoardGameEvent {
  Map<String, dynamic> data;
  OnMessageEvent({this.data});
  @override
  List<Object> get props => [data['type']];
}

class CardSelectorEvent extends BoardGameEvent {
  final PlayerModel playerModel;
  final String gameId;
  final String event;
  final String item;
  CardSelectorEvent({this.playerModel, this.gameId, this.event, this.item});
  @override
  List<Object> get props => [event, item];
}

class ShowCardEvent extends BoardGameEvent {
  final String gameId;
  ShowCardEvent({this.gameId});
  @override
  List<Object> get props => [gameId];
}

class StartNewVotingEvent extends BoardGameEvent {
  final String gameId;
  StartNewVotingEvent({this.gameId});
  @override
  List<Object> get props => [gameId];
}
