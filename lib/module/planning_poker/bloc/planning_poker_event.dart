// ignore_for_file: must_be_immutable`
import 'package:agile_helper/data/model/user/token_login.dart';
import 'package:equatable/equatable.dart';

abstract class PlanningPokerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckGameExistedEvent extends PlanningPokerEvent {
  final TokenLogin tokenLogin;
  final String gameId;
  CheckGameExistedEvent({this.tokenLogin, this.gameId});
  @override
  List<Object> get props => [tokenLogin];
}

class JoinGameErrorFromServerEvent extends PlanningPokerEvent {
  final String error;
  JoinGameErrorFromServerEvent({this.error});
  @override
  List<Object> get props => [error];
}
