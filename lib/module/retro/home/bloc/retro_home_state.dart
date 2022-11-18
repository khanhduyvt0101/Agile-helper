import 'package:equatable/equatable.dart';

class RetroHomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class RetroHomeInitial extends RetroHomeState {}

class RetroHomeLoadingState extends RetroHomeState {}

class CheckBoardExistedState extends RetroHomeState {
  final bool isSuccess;
  final bool isNotExist;
  final bool isWrong;
  CheckBoardExistedState({this.isSuccess, this.isNotExist, this.isWrong});

  @override
  List<Object> get props => [isSuccess, isNotExist];
}
