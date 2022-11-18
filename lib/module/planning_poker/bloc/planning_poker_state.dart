// ignore_for_file: must_be_immutable
import 'package:agile_helper/data/model/user/token_login.dart';
import 'package:equatable/equatable.dart';

class PlanningPokerState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlanningPokerInitial extends PlanningPokerState {}

class PlanningPokerLoadingState extends PlanningPokerState {}

class CheckGameExistedState extends PlanningPokerState {
  final bool isSuccess;
  final bool isNotExist;
  final bool isWrong;
  final TokenLogin tokenLogin;
  CheckGameExistedState(
      {this.isSuccess, this.isNotExist, this.isWrong, this.tokenLogin});

  @override
  List<Object> get props => [isSuccess, isNotExist];
}
