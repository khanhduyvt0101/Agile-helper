import '../../../data/repository/planning_poker/join_game_repository.dart';
import 'planning_poker_event.dart';
import 'planning_poker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/config/config.dart';

class PlanningPokerBloc extends Bloc<PlanningPokerEvent, PlanningPokerState> {
  PlanningPokerBloc() : super(PlanningPokerInitial()) {
    on<CheckGameExistedEvent>((event, emit) => _checkExisted(event, emit));
  }

  Future<void> _checkExisted(
      CheckGameExistedEvent event, Emitter<PlanningPokerState> emit) async {
    emit(PlanningPokerLoadingState());
    String result = await JoinGameRepository.getGameExists(
        event.tokenLogin.token, event.gameId);
    if (result == Alert.pingGameSuccess) {
      emit(
          CheckGameExistedState(isSuccess: true, tokenLogin: event.tokenLogin));
    } else if (result == Alert.pingGameNotExist) {
      emit(CheckGameExistedState(isNotExist: true));
    } else {
      emit(CheckGameExistedState(isWrong: true));
    }
  }
}
