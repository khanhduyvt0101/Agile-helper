// ignore_for_file: must_be_immutable

import 'package:agile_helper/data/model/user/token_login.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthenticationState extends Equatable {
  AuthenticationState();
  bool isTokenExpire = true;
  TokenLogin tokenLogin;
  final storage = const FlutterSecureStorage();

  @override
  List<Object> get props => [isTokenExpire];
}

class AuthenticationInitial extends AuthenticationState {
  AuthenticationInitial() {
    isTokenExpire = false;
  }
}

class AuthenticationSuccess extends AuthenticationState {
  final TokenLogin _tokenLogin;
  AuthenticationSuccess([this._tokenLogin]) : super() {
    storage.write(key: "tokenLogin", value: TokenLogin.serialize(_tokenLogin));
    tokenLogin = _tokenLogin;
  }

  @override
  List<Object> get props => [tokenLogin];
}

class AuthenticationFailure extends AuthenticationState {
  AuthenticationFailure() {
    isTokenExpire = true;
  }
}

class IsAuthenticationTokenExpired extends AuthenticationState {
  final TokenLogin _tokenLogin;
  IsAuthenticationTokenExpired([this._tokenLogin]) {
    if (_tokenLogin == null) return;

    DateTime tokenExpiredDateTimeStorage =
        DateTime.parse(_tokenLogin.tokenExpiredDate);
    DateTime now = DateTime.now();
    if (tokenExpiredDateTimeStorage != null &&
        tokenExpiredDateTimeStorage.isAfter(now)) {
      isTokenExpire = false;
      tokenLogin = _tokenLogin;
    }
  }

  @override
  List<Object> get props => [tokenLogin];
}
