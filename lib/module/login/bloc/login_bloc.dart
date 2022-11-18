import '../../../common/config/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/utils/helper.dart';
import '../../../data/repository/user/user_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginState.initial()) {
    on<LoginUserNameChange>((event, emit) {
      emit(state.update(
          isEmailValid: Validators.isValidUsername(event.userName)));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.update(
          isPasswordValid: Validators.isValidPassword(event.password)));
    });

    on<LoginWithCredentialsPressed>((event, emit) async {
      emit(LoginState.loading());
      try {
        var tokenLogin = GetHost.isProd
            ? await _userRepository.signInWithCredentialsProduction(
                event.userName, event.password, event.twoFACode)
            : await _userRepository.signInWithCredentialsLocal(
                event.userName, event.password);
        if (tokenLogin == null) {
          emit(LoginState.serverWrong());
        } else {
          emit(LoginState.success(tokenLogin));
        }
      } catch (_) {
        emit(LoginState.failure());
      }
    });
  }
}
