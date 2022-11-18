import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginUserNameChange extends LoginEvent {
  final String userName;

  LoginUserNameChange({this.userName});

  @override
  List<Object> get props => [userName];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({this.password});

  @override
  List<Object> get props => [password];
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String userName;
  final String password;
  final String twoFACode;

  LoginWithCredentialsPressed({this.userName, this.password, this.twoFACode});

  @override
  List<Object> get props => [userName, password, twoFACode];
}
