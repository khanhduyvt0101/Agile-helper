import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../common/config/config.dart';
import '../../model/planning_poker/create_game_model.dart';

class CreateGameRepository {
  static final http.Client httpClient = http.Client();

  static Future<List<dynamic>> getUserVotingOptions(String token) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    try {
      var url = GetHost.isProd
          ? Uri.https(GetHost.urlHostApi(), UserService.userVotingOptions)
          : Uri.http(
              GetHost.urlHostApi() + ':4000', UserService.userVotingOptions);
      var response = await httpClient.get(url, headers: headers);
      if (response.statusCode == 200) {
        var list = json.decode(response.body);
        return list ?? '';
      } else {
        print(response.statusCode);
        print(response.body);
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }

  static Future<Map<String, dynamic>> saveDesk(
      {VotingSystem votingSystem, String token}) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    var body = jsonEncode(votingSystem.toJson());
    try {
      var url = GetHost.isProd
          ? Uri.https(GetHost.urlHostApi(), UserService.saveUserDeck)
          : Uri.http(GetHost.urlHostApi() + ':4000', UserService.saveUserDeck);
      var response = await httpClient.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body) as Map<String, dynamic>;
        return result ?? '';
      } else {
        print(
            'Something wrong. Status code: ' + response.statusCode.toString());
        return null;
      }
    } catch (error) {
      print('error:' + error.toString());
      return null;
    }
  }
}
