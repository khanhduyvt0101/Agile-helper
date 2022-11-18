import 'dart:convert';
import 'dart:io';

import '../model/retro/board_retro/save_template_model.dart';

import '../../common/config/config.dart';
import 'package:http/http.dart' as http;

class RetroApi {
  static final http.Client httpClient = http.Client();
  static Map<String, String> _setHeaders(String token) {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    return headers;
  }

  static Future<String> searchUsers(String keyWorld, String token) async {
    var url = GetHost.isProd
        ? Uri.https(GetHost.urlHostApi(), '/api/users')
        : Uri.http(GetHost.urlHostApi() + ':4000', '/users');
    url = url.replace(queryParameters: {'search': keyWorld});
    try {
      var response = await httpClient.get(url, headers: _setHeaders(token));
      if (response.statusCode == 200 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<void> transferBoard(
      String boadId, String userId, String token) async {
    var url = GetHost.isProd
        ? Uri.https(GetHost.urlHostApi(),
            '/api' + UserService.transferBoard + '/' + boadId)
        : Uri.http(GetHost.urlHostApi() + ':4000',
            UserService.transferBoard + '/' + boadId);
    var body = {'uid': userId};
    try {
      var response = await httpClient.post(url,
          headers: _setHeaders(token), body: jsonEncode(body));

      if (response.statusCode == 200 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        print('sucesssful transferred board');
      } else {
        print('some thing error with server side please contact admin!');
      }
    } catch (error) {
      print('error:' + error.toString());
    }
  }

  static Future<String> getPublicBoard(String token) async {
    try {
      var url = GetHost.isProd
          ? Uri.https(GetHost.urlHostApi(), '/api' + UserService.publicBoard)
          : Uri.http(GetHost.urlHostApi() + ':4000', UserService.publicBoard);
      var response = await httpClient.get(url, headers: _setHeaders(token));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<String> getArchivedBoard(String token) async {
    try {
      var url = GetHost.isProd
          ? Uri.https(GetHost.urlHostApi(), '/api' + UserService.archivedBoard)
          : Uri.http(GetHost.urlHostApi() + ':4000', UserService.archivedBoard);
      var response = await httpClient.get(url, headers: _setHeaders(token));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<String> getListActionItem(String token) async {
    try {
      var url = GetHost.isProd
          ? Uri.https(GetHost.urlHostApi(), '/api' + UserService.listActionItem)
          : Uri.http(
              GetHost.urlHostApi() + ':4000', UserService.listActionItem);
      var response = await httpClient.get(url, headers: _setHeaders(token));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<String> getListTemplateBoard(String token) async {
    try {
      var url = GetHost.isProd
          ? Uri.https(GetHost.urlHostApi(), '/api' + UserService.templatesBoard)
          : Uri.http(
              GetHost.urlHostApi() + ':4000', UserService.templatesBoard);
      var response = await httpClient.get(url, headers: _setHeaders(token));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<String> createNewBoard(
      String token, String name, String password, String templateId) async {
    var url = GetHost.isProd
        ? Uri.https(GetHost.urlHostApi(), '/api' + UserService.board)
        : Uri.http(GetHost.urlHostApi() + ':4000', UserService.board);
    var body = {'name': name, 'password': password, 'templateId': templateId};

    try {
      var response = await httpClient.post(url,
          headers: _setHeaders(token), body: jsonEncode(body));
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<String> getInfoBoard(
      String token, String idBoard, String password) async {
    var url = GetHost.isProd
        ? Uri.https(
            GetHost.urlHostApi(), '/api' + UserService.board + '/' + idBoard)
        : Uri.http(
            GetHost.urlHostApi() + ':4000', UserService.board + '/' + idBoard);
    var body = {
      'password': password,
    };
    try {
      var response = await httpClient.post(url,
          headers: _setHeaders(token), body: jsonEncode(body));
      if (response.statusCode == 200 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<String> archivedBoard(String token, String idBoard) async {
    var url = GetHost.isProd
        ? Uri.https(
            GetHost.urlHostApi(), '/api' + UserService.board + '/' + idBoard)
        : Uri.http(
            GetHost.urlHostApi() + ':4000', UserService.board + '/' + idBoard);
    try {
      var response = await httpClient.delete(url, headers: _setHeaders(token));
      if (response.statusCode == 200 || response.statusCode == 404) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<String> deleteBoard(String token, String idBoard) async {
    var url = GetHost.isProd
        ? Uri.https(GetHost.urlHostApi(),
            '/api' + UserService.forceBoard + '/' + idBoard)
        : Uri.http(GetHost.urlHostApi() + ':4000',
            UserService.forceBoard + '/' + idBoard);
    try {
      var response = await httpClient.delete(url, headers: _setHeaders(token));
      if (response.statusCode == 200 ||
          response.statusCode == 403 ||
          response.statusCode == 500) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<String> restoreBoard(String token, String idBoard) async {
    var url = GetHost.isProd
        ? Uri.https(GetHost.urlHostApi(),
            '/api' + UserService.restoreBoard + '/' + idBoard)
        : Uri.http(GetHost.urlHostApi() + ':4000',
            UserService.restoreBoard + '/' + idBoard);
    try {
      var response = await httpClient.post(url, headers: _setHeaders(token));
      if (response.statusCode == 200 ||
          response.statusCode == 403 ||
          response.statusCode == 500) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<String> cloneBoard(String token, String idBoard) async {
    var url = GetHost.isProd
        ? Uri.https(GetHost.urlHostApi(),
            '/api' + UserService.cloneBoard + '/' + idBoard)
        : Uri.http(GetHost.urlHostApi() + ':4000',
            UserService.cloneBoard + '/' + idBoard);
    try {
      var response = await httpClient.post(url, headers: _setHeaders(token));
      if (response.statusCode == 200 || response.statusCode == 500) {
        return response.body;
      } else {
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<bool> saveTemplate(
      String token, SaveTemplateModel saveTemplateModel) async {
    var url = GetHost.isProd
        ? Uri.https(GetHost.urlHostApi(), '/api' + UserService.templatesBoard)
        : Uri.http(GetHost.urlHostApi() + ':4000', UserService.templatesBoard);
    try {
      var response = await httpClient.post(url,
          headers: _setHeaders(token),
          body: jsonEncode(saveTemplateModel.toJson()));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('error:' + error.toString());
      return false;
    }
  }
}
