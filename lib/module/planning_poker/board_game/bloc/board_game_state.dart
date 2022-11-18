// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';

import '../../../../data/model/planning_poker/card_selector_model.dart';
import '../../../../data/model/planning_poker/game_setting.dart';
import '../../../../data/model/planning_poker/player_model.dart';

class BoardGameState extends Equatable {
  @override
  List<Object> get props => [];
}

class BoardGameInitial extends BoardGameState {}

class BoardGameLoadingState extends BoardGameState {}

class JoinGameState extends BoardGameState {
  GameSettingModel gameSettingModel;
  ListPlayerModel listPlayerModel;
  JoinGameState({this.gameSettingModel, this.listPlayerModel});

  @override
  List<Object> get props => [gameSettingModel, listPlayerModel];
}

class NewPlayerJoinedState extends BoardGameState {
  PlayerModel playerModel;
  NewPlayerJoinedState({this.playerModel});

  @override
  List<Object> get props => [playerModel];
}

class CardSelectorState extends BoardGameState {
  CardSelectorModel cardSelectorModel;
  CardSelectorState({this.cardSelectorModel});

  @override
  List<Object> get props => [cardSelectorModel];
}

class RevealCardsState extends BoardGameState {
  RevealCardsState();

  @override
  List<Object> get props => [];
}

class StartNewVotingState extends BoardGameState {
  StartNewVotingState();

  @override
  List<Object> get props => [];
}

class UpdateAdminState extends BoardGameState {
  final String adminId;
  UpdateAdminState({this.adminId});

  @override
  List<Object> get props => [];
}

class PlayerHasLeftState extends BoardGameState {
  final String userId;
  PlayerHasLeftState({this.userId});

  @override
  List<Object> get props => [];
}

class JoinGameErrorFromServerState extends BoardGameState {
  final String error;
  JoinGameErrorFromServerState({this.error});

  @override
  List<Object> get props => [error];
}
