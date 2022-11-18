// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';

import '../../../../data/model/planning_poker/create_game_model.dart';

class CreateGameState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateGameInitial extends CreateGameState {}

class CreateGameLoadingState extends CreateGameState {}

class CreateGameFailureNetWorkState extends CreateGameState {}

class CreateGameLoadedVotingSystemState extends CreateGameState {
  ListVotingSystem result;
  CreateGameLoadedVotingSystemState({List<dynamic> value}) {
    if (value.isNotEmpty) result = ListVotingSystem.fromListDynamic(value);
  }

  @override
  List<Object> get props => [];
}

class CreateGamedState extends CreateGameState {
  String gameId;
  CreateGamedState({this.gameId});

  @override
  List<Object> get props => ['gameId: ' + gameId];
}
