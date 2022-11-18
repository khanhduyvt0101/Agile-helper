import 'dart:convert';

import '../../../common/config/app_config.dart';
import '../../model/retro/board_retro/board_retro_model.dart';
import '../../model/retro/board_retro/save_template_model.dart';

import '../../api/retro_api.dart';

class BoardRetroRepository {
  final String token;
  BoardRetroRepository({this.token});

  Future<bool> checkIsHavePass(String idBoard) async {
    String dataDynamic = await RetroApi.getInfoBoard(token, idBoard, '');
    if (dataDynamic != null) {
      var data = json.decode(dataDynamic);
      if (data['message'] != null &&
          data['message'].toString().contains('assword')) {
        return true;
      }
      return false;
    }
    return null;
  }

  Future<String> checkIsCorrectUrl(String idBoard) async {
    String dataDynamic = await RetroApi.getInfoBoard(token, idBoard, '');
    if (dataDynamic != null) {
      var data = json.decode(dataDynamic);
      if (data['message'] != null &&
          data['message']
              .toString()
              .contains('The URL you have passed is invalid')) {
        return Alert.pingGameNotExist;
      }
      return Alert.pingGameSuccess;
    }
    return Alert.pingGameWrong;
  }

  Future<BoardRetroModel> getInfoBoardWithoutPass(String idBoard) async {
    String dataDynamic = await RetroApi.getInfoBoard(token, idBoard, '');
    Map<String, dynamic> data = json.decode(dataDynamic);
    if (data != null) {
      return BoardRetroModel.fromJson(data);
    }
    return null;
  }

  Future<CheckPass> checkPassJoinGame(String idBoard, String password) async {
    String dataDynamic = await RetroApi.getInfoBoard(token, idBoard, password);

    var data = jsonDecode(dataDynamic);
    if (data['boardInfo'] != null) {
      return CheckPass.True;
    }
    if (data['message'] != null &&
        data['message'].toString().contains('assword')) {
      return CheckPass.False;
    }
    return CheckPass.IncorrectUrl;
  }

  Future<BoardRetroModel> getInfoBoardWithPass(
      String idBoard, String password) async {
    String dataDynamic = await RetroApi.getInfoBoard(token, idBoard, password);
    Map<String, dynamic> data = json.decode(dataDynamic);
    if (data != null) {
      return BoardRetroModel.fromJson(data);
    }
    return null;
  }

  Future<bool> saveTemplate(SaveTemplateModel saveTemplateModel) async {
    bool isSuccess = await RetroApi.saveTemplate(token, saveTemplateModel);
    return isSuccess;
  }
}
