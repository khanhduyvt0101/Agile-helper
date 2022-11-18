import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../common/config/config.dart';

class JoinGameRepository {
  static final http.Client httpClient = http.Client();

  static Future<String> getGameExists(String token, String gameId) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    try {
      var url = GetHost.isProd
          ? Uri.https(GetHost.urlHostApi(), UserService.pingGame + '/$gameId')
          : Uri.http(GetHost.urlHostApi() + ':4000',
              UserService.pingGame + '/$gameId');
      var response = await httpClient.get(url, headers: headers);
      if (response.statusCode == 200) {
        return Alert.pingGameSuccess;
      } else if (response.statusCode == 404) {
        return Alert.pingGameNotExist;
      } else {
        return Alert.pingGameWrong;
      }
    } catch (error) {
      print(error);
      return Alert.pingGameWrong;
    }
  }
}
