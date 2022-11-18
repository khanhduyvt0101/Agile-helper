import '../../../../data/model/retro/board_retro/action_card_model.dart';
import '../../../../data/model/retro/board_retro/save_template_model.dart';
import 'package:equatable/equatable.dart';

abstract class BoardRetroEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//Stage
class JoinBoardRetroEvent extends BoardRetroEvent {
  final String idBoard;
  JoinBoardRetroEvent({this.idBoard});
  @override
  List<Object> get props => [];
}

class JoinBoardRetroWithPasswordEvent extends BoardRetroEvent {
  final String idBoard;
  final String password;
  JoinBoardRetroWithPasswordEvent({this.idBoard, this.password});
  @override
  List<Object> get props => [];
}

class SaveTemplateEvent extends BoardRetroEvent {
  final SaveTemplateModel saveTemplateModel;
  SaveTemplateEvent({this.saveTemplateModel});
  @override
  List<Object> get props => [];
}

class AddStageEvent extends BoardRetroEvent {
  final String boardId;
  final String title;
  final String color;
  final int position;

  AddStageEvent({this.boardId, this.title, this.color, this.position});
  @override
  List<Object> get props => [];
}

class ChangeColorStageEvent extends BoardRetroEvent {
  final String boardId;
  final String stageId;
  final String color;

  ChangeColorStageEvent({this.boardId, this.stageId, this.color});
  @override
  List<Object> get props => [];
}

class DeleteStageEvent extends BoardRetroEvent {
  final String boardId;
  final String stageId;
  final List<String> orderStages;

  DeleteStageEvent({this.boardId, this.stageId, this.orderStages});
  @override
  List<Object> get props => [];
}

class ClearStageEvent extends BoardRetroEvent {
  final String boardId;
  final String stageId;

  ClearStageEvent({this.boardId, this.stageId});
  @override
  List<Object> get props => [];
}

class RenameStageEvent extends BoardRetroEvent {
  final String boardId;
  final String stageId;
  final String title;

  RenameStageEvent({this.boardId, this.stageId, this.title});
  @override
  List<Object> get props => [];
}

//Cards
class CreateCardEvent extends BoardRetroEvent {
  final String boardId;
  final CreateCardModel createCardModel;

  CreateCardEvent({this.boardId, this.createCardModel});
  @override
  List<Object> get props => [];
}

class LikeCardEvent extends BoardRetroEvent {
  final String boardId;
  final String userId;
  final String stageId;
  final String cardId;

  LikeCardEvent({this.boardId, this.userId, this.stageId, this.cardId});
  @override
  List<Object> get props => [];
}

class UnLikeCardEvent extends BoardRetroEvent {
  final String boardId;
  final String userId;
  final String stageId;
  final String cardId;

  UnLikeCardEvent({this.boardId, this.userId, this.stageId, this.cardId});
  @override
  List<Object> get props => [cardId];
}

class CreateCommentCardEvent extends BoardRetroEvent {
  final String boardId;
  final String userId;
  final String stageId;
  final String cardId;
  final String content;

  CreateCommentCardEvent(
      {this.boardId, this.userId, this.stageId, this.cardId, this.content});
  @override
  List<Object> get props => [cardId];
}

class DeleteCommentCardEvent extends BoardRetroEvent {
  final String boardId;
  final String userId;
  final String stageId;
  final String cardId;
  final String commentId;

  DeleteCommentCardEvent(
      {this.boardId, this.userId, this.stageId, this.cardId, this.commentId});
  @override
  List<Object> get props => [cardId];
}

class EditCommentCardEvent extends BoardRetroEvent {
  final String boardId;
  final String userId;
  final String stageId;
  final String cardId;
  final String commentId;
  final String content;

  EditCommentCardEvent(
      {this.boardId,
      this.userId,
      this.stageId,
      this.cardId,
      this.commentId,
      this.content});
  @override
  List<Object> get props => [cardId];
}

class RenameCardEvent extends BoardRetroEvent {
  final String boardId;
  final String stageId;
  final String cardId;
  final String title;

  RenameCardEvent({this.boardId, this.stageId, this.cardId, this.title});
  @override
  List<Object> get props => [cardId];
}

class SetActionCardEvent extends BoardRetroEvent {
  final String boardId;
  final String userId;
  final String cardId;
  final bool isActionItem;

  SetActionCardEvent(
      {this.boardId, this.userId, this.cardId, this.isActionItem});
  @override
  List<Object> get props => [cardId];
}

class ChangeColorCardEvent extends BoardRetroEvent {
  final String boardId;
  final String stageId;
  final String cardId;
  final String color;

  ChangeColorCardEvent({this.boardId, this.stageId, this.cardId, this.color});
  @override
  List<Object> get props => [cardId];
}

class DeleteCardEvent extends BoardRetroEvent {
  final String boardId;
  final String stageId;
  final String cardId;
  final List<String> orderCards;

  DeleteCardEvent({this.boardId, this.stageId, this.cardId, this.orderCards});
  @override
  List<Object> get props => [cardId];
}

class SetIsActionDoneEvent extends BoardRetroEvent {
  final String boardId;
  final String userId;
  final String cardId;
  final bool isActionDone;

  SetIsActionDoneEvent(
      {this.boardId, this.userId, this.cardId, this.isActionDone});
  @override
  List<Object> get props => [cardId];
}

class OnMessageEvent extends BoardRetroEvent {
  final Map<String, dynamic> data;
  OnMessageEvent({this.data});
  @override
  List<Object> get props => [data['type']];
}

class ErrorFromServerEvent extends BoardRetroEvent {
  final String error;
  ErrorFromServerEvent({this.error});
  @override
  List<Object> get props => [error];
}
