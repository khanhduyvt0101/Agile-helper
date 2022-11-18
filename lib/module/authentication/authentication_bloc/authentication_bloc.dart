import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationStarted>((event, emit) {});

    on<AuthenticationLoggedIn>((event, emit) {
      emit(AuthenticationSuccess(event.tokenLogin));
    });

    on<AuthenticationLoggedOut>((event, emit) {
      emit(AuthenticationFailure());
    });

    on<AuthenticationTokenExpired>((event, emit) {
      emit(IsAuthenticationTokenExpired(event.tokenLogin));
    });
  }
}
