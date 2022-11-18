import 'dart:convert';
import '../../model/user/token_login.dart';
import 'package:http/http.dart' as http;
import '../../../common/config/config.dart';

class UserRepository {
  UserRepository();

  Future<TokenLogin> signInWithCredentialsLocal(
      String userName, String password) async {
    http.Response responseLogin;

    try {
      responseLogin = await postMethod(
          null,
          GetHost.urlLogin(),
          jsonEncode({
            "username": userName,
            "password": password,
            "rememberMe": true
          }));
    } catch (e) {
      print(e);
    }

    var body = json.decode(responseLogin.body);
    if (responseLogin.statusCode == 200) {
      var tokenExpiredDate = body["tokenExpiredDate"];
      http.Response responseAuthen;
      try {
        responseAuthen = await postMethod(
            null,
            GetHost.urlAuthenticate(),
            jsonEncode({
              "displayName": body["displayName"],
              "email": body["email"],
              "userNameEncrypt": body["userNameEncrypt"]
            }));
      } catch (e) {
        print(e);
      }

      if (responseAuthen.statusCode == 200) {
        var bodySignIn = json.decode(responseAuthen.body);
        var id = bodySignIn["id"];
        var token = bodySignIn["token"];
        var userNameEncrypt = bodySignIn['userNameEncrypt'];
        return TokenLogin(
            id: id,
            token: token,
            tokenExpiredDate: tokenExpiredDate,
            userNameEncrypt: userNameEncrypt,
            displayName: body["displayName"]);
      }
    }

    throw Exception("Can not connect to backend server");
  }

  Future<TokenLogin> signInWithCredentialsProduction(
      String userName, String password, String twoFACode) async {
    http.Response responseLogin;
    try {
      responseLogin = await postMethod(
          null,
          GetHost.urlLogin(),
          jsonEncode({
            "username": userName,
            "password": password,
            "rememberMe": true
          }));
    } catch (e) {
      print(e);
    }

    var bodyResponseLogin = json.decode(responseLogin.body);

    http.Response responseTwoFatorAuthen;
    try {
      responseTwoFatorAuthen = await postMethod(
          bodyResponseLogin["tokenFor2FA"],
          GetHost.urlTwoFactorAuth(),
          jsonEncode({"code": twoFACode, "rememberMe": true}));
    } catch (e) {
      print(e);
    }

    var bodyResponseTwoFatorAuthen = json.decode(responseTwoFatorAuthen.body);
    if (responseTwoFatorAuthen.statusCode == 200) {
      var tokenExpiredDate = bodyResponseTwoFatorAuthen["tokenExpiredDate"];
      http.Response responseAuthen;
      try {
        responseAuthen = await postMethod(
            null,
            GetHost.urlAuthenticate(),
            jsonEncode({
              "displayName": bodyResponseTwoFatorAuthen["displayName"],
              "email": bodyResponseTwoFatorAuthen["email"],
              "userNameEncrypt": bodyResponseTwoFatorAuthen["userNameEncrypt"]
            }));
      } catch (e) {
        print(e);
      }

      if (responseAuthen.statusCode == 200) {
        var bodySignIn = json.decode(responseAuthen.body);
        var id = bodySignIn["id"];
        var token = bodySignIn["token"];
        var userNameEncrypt = bodySignIn['userNameEncrypt'];
        return TokenLogin(
            id: id,
            token: token,
            tokenExpiredDate: tokenExpiredDate,
            userNameEncrypt: userNameEncrypt,
            displayName: bodyResponseTwoFatorAuthen["displayName"]);
      }
    }
    return null;
  }

  Future<http.Response> postMethod(token, url, body) async {
    if (token != null) {
      return await http.post(url,
          headers: {
            "Content-type": "application/json",
            "Accept": "*/*",
            'Authorization': 'Bearer $token'
          },
          body: body);
    }

    return await http.post(url,
        headers: {"Content-type": "application/json", "Accept": "*/*"},
        body: body);
  }
}
