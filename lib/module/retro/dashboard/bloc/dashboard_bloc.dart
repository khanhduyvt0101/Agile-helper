import '../../../../data/model/retro/dashboard/action_item_model.dart';
import '../../../../data/model/retro/dashboard/board_model.dart';
import '../../../../data/model/retro/dashboard/template_board_model.dart';
import '../../../../data/repository/retro/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashboardRepository dashboardRepository;
  void setDashboardRepository(DashboardRepository _dashboardRepository) {
    dashboardRepository = _dashboardRepository;
  }

  DashBoardBloc() : super(DashBoardInitial()) {
    on<LoadPublicBoardEvent>((event, emit) => _loadPublicBoard(event, emit));
    on<LoadArchivedBoardEvent>(
        (event, emit) => _loadArchivedBoard(event, emit));
    on<LoadListActionItemEvent>(
        (event, emit) => _loadListActionItemBoard(event, emit));
    on<LoadListTemplateBoardEvent>(
        (event, emit) => _loadListTemplateBoard(event, emit));
    on<GetCountBoardForDashboardEvent>(
        (event, emit) => _loadCountBoardForDashboard(event, emit));
    on<CreateNewWithoutTemplateEvent>(
        (event, emit) => _createNewBoard(event, emit));
    on<CreateNewWithTemplateEvent>(
        (event, emit) => _createNewBoardWithTemplate(event, emit));
    on<ArchiveBoardEvent>((event, emit) => _archiveBoard(event, emit));
    on<CloneBoardEvent>((event, emit) => _cloneBoard(event, emit));
    on<DeleteBoardEvent>((event, emit) => _deleteBoard(event, emit));
    on<RestoreBoardEvent>((event, emit) => _restoreBoard(event, emit));
    on<SearchUserNameChange>(
        (event, emit) => _searchUserNameChange(event, emit));
    on<TransferBoardEvent>((event, emit) => _transferBoardEvent(event, emit));
  }

  Future<void> _loadPublicBoard(
      LoadPublicBoardEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    List<BoardModel> list = await dashboardRepository.getListPublicBoard();
    emit(LoadedBoardState(listPublicBoard: list));
  }

  Future<void> _archiveBoard(
      ArchiveBoardEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    CheckActionBoard check =
        await dashboardRepository.archivedBoard(event.idBoard);
    if (check != CheckActionBoard.Success) {
      print('delete fail with reason: ' + check.name);
    }
    add(LoadPublicBoardEvent());
  }

  Future<void> _deleteBoard(
      DeleteBoardEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    CheckDeleteBoard check =
        await dashboardRepository.deleteBoard(event.idBoard);
    if (check != CheckDeleteBoard.Success) {
      print('delete fail with reason: ' + check.name);
    }
    add(LoadArchivedBoardEvent());
  }

  Future<void> _restoreBoard(
      RestoreBoardEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    CheckDeleteBoard check =
        await dashboardRepository.restoreBoard(event.idBoard);
    if (check != CheckDeleteBoard.Success) {
      print('restore fail with reason: ' + check.name);
    }
    add(LoadArchivedBoardEvent());
  }

  Future<void> _cloneBoard(
      CloneBoardEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    CheckActionBoard check =
        await dashboardRepository.cloneBoard(event.idBoard);
    if (check != CheckActionBoard.Success) {
      print('clone fail with reason: ' + check.name);
    }
  }

  Future<void> _createNewBoard(
      CreateNewWithoutTemplateEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    String idBoard = await dashboardRepository.createNewBoard(
        event.name, event.password, null);
    if (idBoard != null) {
      emit(ReceivedInfoBoardState(idBoard: idBoard));
    } else {
      emit(DashBoardFailureNetWorkState());
    }
  }

  Future<void> _createNewBoardWithTemplate(
      CreateNewWithTemplateEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    String idBoard = await dashboardRepository.createNewBoard(
        event.name, event.password, event.templateId);
    if (idBoard != null) {
      emit(ReceivedInfoBoardState(idBoard: idBoard));
    } else {
      emit(DashBoardFailureNetWorkState());
    }
  }

  Future<void> _loadArchivedBoard(
      LoadArchivedBoardEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    List<BoardModel> list = await dashboardRepository.getListArchivedBoard();
    emit(LoadedBoardState(listPublicBoard: list));
  }

  Future<void> _loadListActionItemBoard(
      LoadListActionItemEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    List<ActionItemModel> list = await dashboardRepository.getListActionItem();
    emit(LoadedItemActionState(listActionItem: list));
  }

  Future<void> _loadListTemplateBoard(
      LoadListTemplateBoardEvent event, Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    List<TemplateBoardModel> list =
        await dashboardRepository.getListTemplateBoard();
    emit(LoadedTemplateBoardState(listTemplateBoard: list));
  }

  Future<void> _loadCountBoardForDashboard(GetCountBoardForDashboardEvent event,
      Emitter<DashBoardState> emit) async {
    emit(DashBoardLoadingState());
    Map<BoardType, int> data =
        await dashboardRepository.getCountBoardForDashboard();
    emit(LoadedCountBoardForDashboardState(data: data));
  }

  Future<void> _searchUserNameChange(
      SearchUserNameChange event, Emitter<DashBoardState> emit) async {
    if (event.keyword.isNotEmpty) {
      List<UserModel> listUserModels =
          await dashboardRepository.searchUsers(event.keyword);
      emit(SearchUsersState(listUserSearched: listUserModels));
    } else {
      emit(SearchUsersState(listUserSearched: const []));
    }
  }

  Future<void> _transferBoardEvent(
      TransferBoardEvent event, Emitter<DashBoardState> emit) async {
    if (event.userId.isNotEmpty) {
      await dashboardRepository.transferBoard(event.userId, event.boardId);
    }
  }
}
