import '../../../../data/model/retro/dashboard/action_item_model.dart';
import '../../../../data/model/retro/dashboard/board_model.dart';
import '../../../../data/model/retro/dashboard/template_board_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/config/config.dart';

class DashBoardState extends Equatable {
  @override
  List<Object> get props => [];
}

class DashBoardInitial extends DashBoardState {}

class DashBoardLoadingState extends DashBoardState {}

class DashBoardFailureNetWorkState extends DashBoardState {}

class LoadedBoardState extends DashBoardState {
  final List<BoardModel> listPublicBoard;
  LoadedBoardState({this.listPublicBoard});

  @override
  List<Object> get props => [
        'list length: ' +
            (listPublicBoard != null ? listPublicBoard.length.toString() : '0')
      ];
}

class SearchUsersState extends DashBoardState {
  final List<UserModel> listUserSearched;

  SearchUsersState({this.listUserSearched});
  @override
  List<Object> get props => [
        'list length: ' +
            (listUserSearched != null
                ? listUserSearched.length.toString()
                : '0')
      ];
}

class TransferBoardState extends DashBoardState {
  final String userId;
  final String boardId;
  TransferBoardState({this.userId, this.boardId});

  @override
  List<Object> get props => ['userId: ' + userId, 'boardId: ' + boardId];
}

class LoadedItemActionState extends DashBoardState {
  final List<ActionItemModel> listActionItem;
  LoadedItemActionState({this.listActionItem});

  @override
  List<Object> get props => [
        'list length: ' +
            (listActionItem != null ? listActionItem.length.toString() : '0')
      ];
}

class LoadedTemplateBoardState extends DashBoardState {
  final List<TemplateBoardModel> listTemplateBoard;
  LoadedTemplateBoardState({this.listTemplateBoard});

  @override
  List<Object> get props => [
        'list length: ' +
            (listTemplateBoard != null
                ? listTemplateBoard.length.toString()
                : '0')
      ];
}

class LoadedCountBoardForDashboardState extends DashBoardState {
  final Map<BoardType, int> data;
  LoadedCountBoardForDashboardState({this.data});

  @override
  List<Object> get props => [data];
}

class ReceivedInfoBoardState extends DashBoardState {
  final String idBoard;
  ReceivedInfoBoardState({this.idBoard});

  @override
  List<Object> get props => ['idBoard: ' + idBoard];
}
