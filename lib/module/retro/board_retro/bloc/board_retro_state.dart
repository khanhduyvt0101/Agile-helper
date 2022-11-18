import 'dart:developer';

import '../../../../common/config/app_config.dart';
import '../../../../data/model/retro/board_retro/board_retro_model.dart';
import 'package:equatable/equatable.dart';

class BoardRetroState extends Equatable {
  final bool havePassJoinBoard;
  final bool saveTemplateSuccess;

  const BoardRetroState(
      [this.havePassJoinBoard = false, this.saveTemplateSuccess = false]);

  BoardRetroState update({bool havePassJoinBoard}) {
    return copyWith(havePassJoinBoard: havePassJoinBoard);
  }

  BoardRetroState copyWith({bool havePassJoinBoard, CheckPass correctPass}) {
    return BoardRetroState(
      havePassJoinBoard ?? this.havePassJoinBoard,
    );
  }

  @override
  List<Object> get props => [];
}

class BoardRetroInitial extends BoardRetroState {}

class BoardRetroLoadingState extends BoardRetroState {}

class BoardRetroFailureNetWorkState extends BoardRetroState {}

class JoinedBoardState extends BoardRetroState {
  final BoardRetroModel boardRetroModel;
  final bool isSaveTemplateSuccess;
  const JoinedBoardState({this.boardRetroModel, this.isSaveTemplateSuccess});

  @override
  List<Object> get props =>
      [inspect(boardRetroModel), isSaveTemplateSuccess ?? ''];
}

class CheckPassJoinBoardState extends BoardRetroState {
  final CheckPass checkPass;
  const CheckPassJoinBoardState({this.checkPass});

  @override
  List<Object> get props => [checkPass.name];
}

//Stages
class AddedStageState extends BoardRetroState {
  final Stages stages;
  const AddedStageState({this.stages});

  @override
  List<Object> get props => ['title: ' + stages.title];
}

class ChangedColorStageState extends BoardRetroState {
  final Map<String, dynamic> data;
  const ChangedColorStageState({this.data});

  @override
  List<Object> get props => [data];
}

class DeletedStageState extends BoardRetroState {
  final Map<String, dynamic> data;
  const DeletedStageState({this.data});

  @override
  List<Object> get props => [data];
}

class RenameStageState extends BoardRetroState {
  final Map<String, dynamic> data;
  const RenameStageState({this.data});

  @override
  List<Object> get props => [data];
}

class ClearedStageState extends BoardRetroState {
  final String stageId;
  const ClearedStageState({this.stageId});

  @override
  List<Object> get props => [stageId];
}

class DraggedStageState extends BoardRetroState {
  final List<String> orderStages;
  const DraggedStageState({this.orderStages});

  @override
  List<Object> get props => [];
}

//Cards
class CreatedCardsState extends BoardRetroState {
  final List<String> orderCards;
  final Cards cards;
  const CreatedCardsState({this.orderCards, this.cards});

  @override
  List<Object> get props => [];
}

class LikedCardsState extends BoardRetroState {
  final int numberOfVotes;
  final String stageId;
  final String cardId;
  final List<LikeCards> listLikeCards;
  const LikedCardsState(
      {this.numberOfVotes, this.stageId, this.cardId, this.listLikeCards});

  @override
  List<Object> get props => [];
}

class UnLikedCardsState extends BoardRetroState {
  final int numberOfVotes;
  final String stageId;
  final String cardId;
  final List<LikeCards> listLikeCards;
  const UnLikedCardsState(
      {this.numberOfVotes, this.stageId, this.cardId, this.listLikeCards});

  @override
  List<Object> get props => [];
}

class CreatedCommentCardsState extends BoardRetroState {
  final int numberOfComments;
  final String stageId;
  final String cardId;
  final List<Comments> listComment;
  const CreatedCommentCardsState(
      {this.numberOfComments, this.stageId, this.cardId, this.listComment});

  @override
  List<Object> get props => [];
}

class DeletedCommentCardsState extends BoardRetroState {
  final int numberOfComments;
  final String stageId;
  final String cardId;
  final List<Comments> listComment;
  const DeletedCommentCardsState(
      {this.numberOfComments, this.stageId, this.cardId, this.listComment});

  @override
  List<Object> get props => [];
}

class EditedCommentCardsState extends BoardRetroState {
  final String stageId;
  final String cardId;
  final List<Comments> listComment;
  const EditedCommentCardsState({this.stageId, this.cardId, this.listComment});

  @override
  List<Object> get props => [];
}

class RenamedCardsState extends BoardRetroState {
  final String stageId;
  final String cardId;
  final String title;
  const RenamedCardsState({this.stageId, this.cardId, this.title});

  @override
  List<Object> get props => [];
}

class SetActionCardsState extends BoardRetroState {
  final String stageId;
  final String cardId;
  final bool isActionItem;
  const SetActionCardsState({this.stageId, this.cardId, this.isActionItem});

  @override
  List<Object> get props => [];
}

class ChangedColorCardsState extends BoardRetroState {
  final String stageId;
  final String cardId;
  final String color;
  const ChangedColorCardsState({this.stageId, this.cardId, this.color});

  @override
  List<Object> get props => [];
}

class DeletedCardsState extends BoardRetroState {
  final String stageId;
  final String cardId;
  final List<String> orderCards;
  const DeletedCardsState({this.stageId, this.cardId, this.orderCards});

  @override
  List<Object> get props => [];
}

class SetIsActionDoneState extends BoardRetroState {
  final String stageId;
  final String cardId;
  final bool isActionDone;
  const SetIsActionDoneState({this.stageId, this.cardId, this.isActionDone});

  @override
  List<Object> get props => [];
}

class DraggedCardState extends BoardRetroState {
  final String stageIdFirst;
  final List<String> orderCardsFirst;
  final String stageIdSecond;
  final List<String> orderCardsSecond;
  const DraggedCardState(
      {this.stageIdFirst,
      this.orderCardsFirst,
      this.stageIdSecond,
      this.orderCardsSecond});

  @override
  List<Object> get props => [];
}
