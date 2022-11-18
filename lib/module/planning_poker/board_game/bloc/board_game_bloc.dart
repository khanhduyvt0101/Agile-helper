import '../../../../data/repository/socket_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../data/model/planning_poker/card_selector_model.dart';
import '../../../../data/model/planning_poker/game_setting.dart';
import '../../../../data/model/planning_poker/join_game_model.dart';
import '../../../../data/model/planning_poker/player_model.dart';
import 'board_game_event.dart';
import 'board_game_state.dart';

class BoardGameBloc extends Bloc<BoardGameEvent, BoardGameState> {
  final SocketRepository _socketRepository;

  BoardGameBloc({SocketRepository socketRepository})
      : _socketRepository = socketRepository,
        super(BoardGameInitial()) {
    on<JoinGameEvent>((event, emit) => _joinGame(event, emit));
    on<JoinGameErrorFromServerEvent>((event, emit) =>
        emit(JoinGameErrorFromServerState(error: event.error)));
    on<OnMessageEvent>((event, emit) => _onMessage(event, emit));
    on<CardSelectorEvent>((event, emit) => _cardSelector(event, emit));
    on<ShowCardEvent>((event, emit) => _revealCards(event, emit));
    on<StartNewVotingEvent>((event, emit) => _startNewVoting(event, emit));
  }

  Future<void> _startNewVoting(
      StartNewVotingEvent event, Emitter<BoardGameState> emit) async {
    await _socketRepository.emitStartNewVoting(event.gameId);
  }

  Future<void> _revealCards(
      ShowCardEvent event, Emitter<BoardGameState> emit) async {
    await _socketRepository.emitRevealCards(event.gameId);
  }

  Future<void> _cardSelector(
      CardSelectorEvent event, Emitter<BoardGameState> emit) async {
    await _socketRepository.emitCardSelector(CardSelectorModel(
        userId: event.playerModel.uid,
        gameId: event.gameId,
        event: event.event,
        card: event.playerModel.card));
  }

  Future<void> _joinGame(
      JoinGameEvent event, Emitter<BoardGameState> emit) async {
    emit(BoardGameLoadingState());
    await _socketRepository.emitJoinGameEvent(
        JoinGameModel(
            gameId: event.gameId,
            player: Player(
                uid: event.tokenLogin.id,
                displayName: event.tokenLogin.displayName,
                userNameEncrypt: event.tokenLogin.userNameEncrypt)), (data) {
      add(JoinGameErrorFromServerEvent(error: data));
    });
    await _socketRepository.onEvent(PokerSocketEvent.MESSAGE, (data) {
      add(OnMessageEvent(data: data));
    });
  }

  Future<void> _onMessage(
      OnMessageEvent event, Emitter<BoardGameState> emit) async {
    emit(BoardGameLoadingState());
    switch (event.data['type']) {
      case PokerSocketEvent.GAME_SETTINGS:
        emit(JoinGameState(
            gameSettingModel: GameSettingModel.fromDynamic(event.data)));
        break;
      case PokerSocketEvent.ONLINE_PLAYERS:
        emit(JoinGameState(
            listPlayerModel: ListPlayerModel.fromDynamic(event.data)));
        break;
      case PokerSocketEvent.NEW_PLAYER_HAS_JOINED:
        emit(NewPlayerJoinedState(
            playerModel: PlayerModel.getPlayerHasJoinFromJson(event.data)));
        break;
      case PokerSocketEvent.SELECT_CARD:
        emit(CardSelectorState(
            cardSelectorModel: CardSelectorModel.fromDynamic(event.data)));
        break;
      case PokerSocketEvent.DESELECT_CARD:
        emit(CardSelectorState(
            cardSelectorModel: CardSelectorModel.fromDynamic(event.data)));
        break;
      case PokerSocketEvent.REVEAL_CARDS:
        emit(RevealCardsState());
        break;
      case PokerSocketEvent.START_NEW_VOTING:
        emit(StartNewVotingState());
        break;
      case PokerSocketEvent.A_PLAYER_HAS_LEFT:
        emit(PlayerHasLeftState(
            userId:
                PlayerModel.getUserIdFromPlayerHasLeftFromJson(event.data)));
        break;
      case PokerSocketEvent.UPDATE_GAME_SETTINGS:
        emit(UpdateAdminState(
            adminId: PlayerModel.getAdminIdWhenAdminLeftFromJson(event.data)));
        break;
      default:
    }
  }
}
