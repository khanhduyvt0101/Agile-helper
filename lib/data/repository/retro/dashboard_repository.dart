import 'dart:convert';

import '../../../common/config/app_config.dart';
import '../../api/retro_api.dart';
import '../../model/retro/dashboard/action_item_model.dart';
import '../../model/retro/dashboard/board_model.dart';
import '../../model/retro/dashboard/template_board_model.dart';

class DashboardRepository {
  final String token;
  DashboardRepository({this.token});

  Future<List<BoardModel>> getListPublicBoard() async {
    List<BoardModel> listBoard = [];
    String dataDynamic = await RetroApi.getPublicBoard(token);
    List<dynamic> list = json.decode(dataDynamic);
    if (list.isNotEmpty) {
      for (var element in list) {
        listBoard.add(BoardModel.fromJson(element));
      }
      return listBoard;
    }
    return null;
  }

  Future<List<BoardModel>> getListArchivedBoard() async {
    List<BoardModel> listBoard = [];
    String dataDynamic = await RetroApi.getArchivedBoard(token);
    List<dynamic> list = json.decode(dataDynamic);
    if (list.isNotEmpty) {
      for (var element in list) {
        listBoard.add(BoardModel.fromJson(element));
      }
      return listBoard;
    }
    return null;
  }

  Future<List<ActionItemModel>> getListActionItem() async {
    List<ActionItemModel> listBoard = [];
    String dataDynamic = await RetroApi.getListActionItem(token);
    List<dynamic> list = json.decode(dataDynamic);
    if (list.isNotEmpty) {
      for (var element in list) {
        listBoard.add(ActionItemModel.fromJson(element));
      }
      return listBoard;
    }
    return null;
  }

  Future<List<TemplateBoardModel>> getListTemplateBoard() async {
    List<TemplateBoardModel> listBoard = [];
    String dataDynamic = await RetroApi.getListTemplateBoard(token);
    List<dynamic> list = json.decode(dataDynamic);
    if (list.isNotEmpty) {
      for (var element in list) {
        listBoard.add(TemplateBoardModel.fromJson(element));
      }
      return listBoard;
    }
    return null;
  }

  Future<Map<BoardType, int>> getCountBoardForDashboard() async {
    Map<BoardType, int> data;
    String dataDynamic = await RetroApi.getPublicBoard(token);
    List<dynamic> listPublicBoard = json.decode(dataDynamic);
    dataDynamic = await RetroApi.getArchivedBoard(token);
    List<dynamic> listArchivedBoard = json.decode(dataDynamic);
    dataDynamic = await RetroApi.getListActionItem(token);
    List<dynamic> listActionItem = json.decode(dataDynamic);
    data = {BoardType.Public: listPublicBoard.length};
    data[BoardType.Archived] = listArchivedBoard.length;
    data[BoardType.ActionItem] = listActionItem.length;
    return data;
  }

  Future<String> createNewBoard(
      String name, String password, String templateId) async {
    String data =
        await RetroApi.createNewBoard(token, name, password, templateId);
    Map<String, dynamic> dataJson;
    if (data != null) {
      dataJson = json.decode(data);
      return dataJson['id'];
    }
    return null;
  }

  Future<CheckActionBoard> archivedBoard(String idBoard) async {
    String data = await RetroApi.archivedBoard(token, idBoard);
    if (data != null) {
      var dataJson = json.decode(data);
      if (dataJson['boardId'] != null) {
        return CheckActionBoard.Success;
      }
      return CheckActionBoard.BoardNotValid;
    }
    return CheckActionBoard.Fail;
  }

  Future<CheckActionBoard> cloneBoard(String idBoard) async {
    String data = await RetroApi.cloneBoard(token, idBoard);
    if (data != null) {
      var dataJson = json.decode(data);
      if (dataJson['name'] != null) {
        return CheckActionBoard.Success;
      }
      return CheckActionBoard.BoardNotValid;
    }
    return CheckActionBoard.Fail;
  }

  Future<CheckDeleteBoard> deleteBoard(String idBoard) async {
    String data = await RetroApi.deleteBoard(token, idBoard);
    if (data != null) {
      var dataJson = json.decode(data);
      if (dataJson['boardId'] != null) {
        return CheckDeleteBoard.Success;
      } else if (dataJson['message'] != null &&
          dataJson['message'].toString().contains('author')) {
        return CheckDeleteBoard.NotAuthor;
      } else {
        return CheckDeleteBoard.BoardNotValid;
      }
    }
    return CheckDeleteBoard.Error;
  }

  Future<CheckDeleteBoard> restoreBoard(String idBoard) async {
    String data = await RetroApi.restoreBoard(token, idBoard);
    if (data != null) {
      var dataJson = json.decode(data);
      if (dataJson['boardId'] != null) {
        return CheckDeleteBoard.Success;
      } else if (dataJson['message'] != null &&
          dataJson['message'].toString().contains('author')) {
        return CheckDeleteBoard.NotAuthor;
      } else {
        return CheckDeleteBoard.BoardNotValid;
      }
    }
    return CheckDeleteBoard.Error;
  }

  Future<List<UserModel>> searchUsers(String keyword) async {
    List<UserModel> listUser = [];
    String dataDynamic = await RetroApi.searchUsers(keyword, token);
    List<dynamic> list = json.decode(dataDynamic);
    if (list.isNotEmpty) {
      for (var element in list) {
        listUser.add(UserModel.fromJson(element));
      }
    }

    return listUser;
  }

  Future<void> transferBoard(String userId, String boardId) async {
    await RetroApi.transferBoard(boardId, userId, token);
  }
}
