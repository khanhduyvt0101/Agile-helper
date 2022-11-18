import '../../../data/model/user/token_login.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final TokenLogin tokenLogin;

  AuthenticationLoggedIn({this.tokenLogin});

  @override
  List<Object> get props => [tokenLogin];
}

class AuthenticationLoggedOut extends AuthenticationEvent {}

class AuthenticationTokenExpired extends AuthenticationEvent {
  final TokenLogin tokenLogin;

  AuthenticationTokenExpired({this.tokenLogin});

  @override
  List<Object> get props => [tokenLogin];
}
