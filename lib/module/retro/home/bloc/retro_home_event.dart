import 'package:equatable/equatable.dart';

abstract class RetroHomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckBoardExistedEvent extends RetroHomeEvent {
  final String idBoard;
  CheckBoardExistedEvent({this.idBoard});
  @override
  List<Object> get props => [idBoard];
}

class JoinBoardErrorFromServerEvent extends RetroHomeEvent {
  final String error;
  JoinBoardErrorFromServerEvent({this.error});
  @override
  List<Object> get props => [error];
}
