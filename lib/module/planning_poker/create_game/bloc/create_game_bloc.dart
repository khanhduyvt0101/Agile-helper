import '../../../../data/repository/planning_poker/create_game_repository.dart';
import '../../../../data/repository/socket_repository.dart';
import 'create_game_event.dart';
import 'create_game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';

class CreateGameBloc extends Bloc<CreateGameEvent, CreateGameState> {
  final SocketRepository _socketRepository;
  CreateGameBloc({SocketRepository socketRepository})
      : _socketRepository = socketRepository,
        super(CreateGameInitial()) {
    on<CreateGameLoadVotingSystemEvent>(
        (event, emit) => _loadVotingSystem(event, emit));
    on<CreateGameCreateBoardEvent>((event, emit) => _createBoard(event, emit));
    on<CreateGameCreateDeskEvent>((event, emit) => _createDesk(event, emit));
    on<CreateGameCreateBoardSuccessEvent>(
        (event, emit) => emit(CreateGamedState(gameId: event.gameId)));
    on<RetryLoadVotingSystemEvent>(
        (event, emit) => _retryLoadVotingSystem(event, emit));
  }

  Future<void> _loadVotingSystem(CreateGameLoadVotingSystemEvent event,
      Emitter<CreateGameState> emit) async {
    emit(CreateGameLoadingState());
    var result = await CreateGameRepository.getUserVotingOptions(event.token);
    if (result != null) {
      emit(CreateGameLoadedVotingSystemState(value: result));
    } else {
      emit(CreateGameFailureNetWorkState());
    }
  }

  Future<void> _retryLoadVotingSystem(
      RetryLoadVotingSystemEvent event, Emitter<CreateGameState> emit) async {
    var result = await CreateGameRepository.getUserVotingOptions(event.token);
    if (result != null) {
      emit(CreateGameLoadedVotingSystemState(value: result));
    }
  }

  Future<void> _createDesk(
      CreateGameCreateDeskEvent event, Emitter<CreateGameState> emit) async {
    emit(CreateGameLoadingState());
    var result = await CreateGameRepository.saveDesk(
        votingSystem: event.votingSystem, token: event.token);
    if (result != null) {
      add(CreateGameLoadVotingSystemEvent(token: event.token));
    } else {
      emit(CreateGameFailureNetWorkState());
    }
  }

  Future<void> _createBoard(
      CreateGameCreateBoardEvent event, Emitter<CreateGameState> emit) async {
    emit(CreateGameLoadingState());
    await _socketRepository.emitCreateGameEvent(
        PokerSocketEvent.CREATE_GAME, event.createGame, (gameId) {
      add(CreateGameCreateBoardSuccessEvent(gameId: gameId));
    });
  }
}
