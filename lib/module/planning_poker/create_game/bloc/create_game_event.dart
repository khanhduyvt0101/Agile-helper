// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';

import '../../../../data/model/planning_poker/create_game_model.dart';

abstract class CreateGameEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateGameLoadVotingSystemEvent extends CreateGameEvent {
  final String token;
  CreateGameLoadVotingSystemEvent({this.token});
  @override
  List<Object> get props => [];
}

class RetryLoadVotingSystemEvent extends CreateGameEvent {
  final String token;
  RetryLoadVotingSystemEvent({this.token});
  @override
  List<Object> get props => [];
}

class CreateGameCreateBoardEvent extends CreateGameEvent {
  final CreateGame createGame;

  CreateGameCreateBoardEvent({this.createGame});

  @override
  List<Object> get props => [createGame];
}

class CreateGameCreateBoardSuccessEvent extends CreateGameEvent {
  final String gameId;

  CreateGameCreateBoardSuccessEvent({this.gameId});

  @override
  List<Object> get props => [gameId];
}

class CreateGameCreateDeskEvent extends CreateGameEvent {
  final String token;
  VotingSystem votingSystem;

  CreateGameCreateDeskEvent({this.token, this.votingSystem});

  @override
  List<Object> get props => [token, votingSystem];
}
