import 'retro_home_event.dart';
import 'retro_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../data/repository/retro/board_retro_repository.dart';

class RetroHomeBloc extends Bloc<RetroHomeEvent, RetroHomeState> {
  BoardRetroRepository boardRetroRepository;
  RetroHomeBloc() : super(RetroHomeInitial()) {
    on<CheckBoardExistedEvent>((event, emit) => _checkExisted(event, emit));
  }

  Future<void> _checkExisted(
      CheckBoardExistedEvent event, Emitter<RetroHomeState> emit) async {
    emit(RetroHomeLoadingState());
    String result = await boardRetroRepository.checkIsCorrectUrl(event.idBoard);
    if (result == Alert.pingGameSuccess) {
      emit(CheckBoardExistedState(isSuccess: true));
    } else if (result == Alert.pingGameNotExist) {
      emit(CheckBoardExistedState(isNotExist: true));
    } else {
      emit(CheckBoardExistedState(isWrong: true));
    }
  }
}
