import 'dart:convert';

class TokenLogin {
  final String id;
  final String token;
  final String tokenExpiredDate;
  final String userNameEncrypt;
  final String displayName;
  TokenLogin(
      {this.id,
      this.token,
      this.tokenExpiredDate,
      this.userNameEncrypt,
      this.displayName});

  factory TokenLogin.fromJson(String json) {
    var data = jsonDecode(json);
    return TokenLogin(
        id: data['id'],
        token: data['token'],
        userNameEncrypt: data['userNameEncrypt'],
        tokenExpiredDate: data['tokenExpiredDate'],
        displayName: data['displayName']);
  }

  static Map<String, dynamic> toMap(TokenLogin tokenLogin) => {
        'id': tokenLogin.id,
        'token': tokenLogin.token,
        'tokenExpiredDate': tokenLogin.tokenExpiredDate,
        'userNameEncrypt': tokenLogin.userNameEncrypt,
        'displayName': tokenLogin.displayName
      };

  static String serialize(TokenLogin model) =>
      json.encode(TokenLogin.toMap(model));

  static TokenLogin deserialize(String json) => TokenLogin.fromJson(json);
}
