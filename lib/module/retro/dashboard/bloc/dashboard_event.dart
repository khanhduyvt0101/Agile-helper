import 'package:equatable/equatable.dart';

abstract class DashBoardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPublicBoardEvent extends DashBoardEvent {
  LoadPublicBoardEvent();
  @override
  List<Object> get props => [];
}

class TransferBoardEvent extends DashBoardEvent {
  final String userId;
  final String boardId;
  TransferBoardEvent({this.userId, this.boardId});
  @override
  List<Object> get props => [];
}

class SearchUserNameChange extends DashBoardEvent {
  final String keyword;
  SearchUserNameChange({this.keyword});
  @override
  List<Object> get props => [];
}

class LoadArchivedBoardEvent extends DashBoardEvent {
  LoadArchivedBoardEvent();
  @override
  List<Object> get props => [];
}

class LoadListActionItemEvent extends DashBoardEvent {
  final String token;
  LoadListActionItemEvent({this.token});
  @override
  List<Object> get props => [];
}

class LoadListTemplateBoardEvent extends DashBoardEvent {
  LoadListTemplateBoardEvent();
  @override
  List<Object> get props => [];
}

class GetCountBoardForDashboardEvent extends DashBoardEvent {
  GetCountBoardForDashboardEvent();
  @override
  List<Object> get props => [];
}

class CreateNewWithoutTemplateEvent extends DashBoardEvent {
  final String name;
  final String password;
  CreateNewWithoutTemplateEvent({this.name, this.password});
  @override
  List<Object> get props => [];
}

class CreateNewWithTemplateEvent extends DashBoardEvent {
  final String name;
  final String password;
  final String templateId;
  CreateNewWithTemplateEvent({this.name, this.password, this.templateId});
  @override
  List<Object> get props => [];
}

class ArchiveBoardEvent extends DashBoardEvent {
  final String idBoard;
  ArchiveBoardEvent({this.idBoard});
  @override
  List<Object> get props => [];
}

class CloneBoardEvent extends DashBoardEvent {
  final String idBoard;
  CloneBoardEvent({this.idBoard});
  @override
  List<Object> get props => [];
}

class DeleteBoardEvent extends DashBoardEvent {
  final String idBoard;
  DeleteBoardEvent({this.idBoard});
  @override
  List<Object> get props => [];
}

class RestoreBoardEvent extends DashBoardEvent {
  final String idBoard;
  RestoreBoardEvent({this.idBoard});
  @override
  List<Object> get props => [];
}
