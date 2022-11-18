import '../../../../data/model/retro/board_retro/board_retro_model.dart';
import '../../../../data/repository/retro/board_retro_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../data/repository/socket_repository.dart';
import 'board_retro_event.dart';
import 'board_retro_state.dart';

class BoardRetroBloc extends Bloc<BoardRetroEvent, BoardRetroState> {
  final SocketRepository _socketRepository;
  BoardRetroRepository boardRetroRepository;

  BoardRetroBloc({SocketRepository socketRepository})
      : _socketRepository = socketRepository,
        super(BoardRetroInitial()) {
    on<JoinBoardRetroEvent>((event, emit) => _joinGame(event, emit));

    on<OnMessageEvent>((event, emit) => _onMessage(event, emit));

    on<JoinBoardRetroWithPasswordEvent>(
        (event, emit) => _joinGameWithPassword(event, emit));

    on<SaveTemplateEvent>((event, emit) => _saveTemplate(event, emit));

    //Stage
    on<AddStageEvent>((event, emit) async => await _socketRepository
        .emitAddStage(event.boardId, event.title, event.color, event.position));
    on<ChangeColorStageEvent>((event, emit) async => await _socketRepository
        .emitChangeColorStage(event.boardId, event.stageId, event.color));
    on<DeleteStageEvent>((event, emit) async => await _socketRepository
        .emitDeleteStage(event.boardId, event.stageId, event.orderStages));
    on<ClearStageEvent>((event, emit) async =>
        await _socketRepository.emitClearStage(event.boardId, event.stageId));
    on<RenameStageEvent>((event, emit) async => await _socketRepository
        .emitRenameStage(event.boardId, event.title, event.stageId));

    //Cards
    on<CreateCardEvent>((event, emit) async => await _socketRepository
        .emitCreateCard(event.boardId, event.createCardModel));
    on<LikeCardEvent>((event, emit) async =>
        await _socketRepository.emitLikeCard(
            event.boardId, event.cardId, event.userId, event.stageId));
    on<UnLikeCardEvent>((event, emit) async =>
        await _socketRepository.emitUnLikeCard(
            event.boardId, event.cardId, event.userId, event.stageId));
    on<CreateCommentCardEvent>((event, emit) async =>
        await _socketRepository.emitCreateCommentCard(event.boardId,
            event.cardId, event.userId, event.stageId, event.content));
    on<DeleteCommentCardEvent>((event, emit) async =>
        await _socketRepository.emitDeleteCommentCard(event.boardId,
            event.cardId, event.userId, event.stageId, event.commentId));
    on<EditCommentCardEvent>((event, emit) async =>
        await _socketRepository.emitEditCommentCard(event.boardId, event.cardId,
            event.userId, event.stageId, event.commentId, event.content));
    on<RenameCardEvent>((event, emit) async =>
        await _socketRepository.emitRenameCard(
            event.boardId, event.cardId, event.stageId, event.title));
    on<SetActionCardEvent>((event, emit) async =>
        await _socketRepository.emitSetActionCard(
            event.boardId, event.cardId, event.userId, event.isActionItem));
    on<ChangeColorCardEvent>((event, emit) async =>
        await _socketRepository.emitChangeColorCard(
            event.boardId, event.cardId, event.stageId, event.color));
    on<DeleteCardEvent>((event, emit) async =>
        await _socketRepository.emitDeleteCard(
            event.boardId, event.cardId, event.stageId, event.orderCards));
    on<SetIsActionDoneEvent>((event, emit) async =>
        await _socketRepository.emitSetIsCompleteCard(
            event.boardId, event.cardId, event.userId, event.isActionDone));
  }

  Future<void> _joinGame(
      JoinBoardRetroEvent event, Emitter<BoardRetroState> emit) async {
    emit(BoardRetroLoadingState());
    bool havePass = await boardRetroRepository.checkIsHavePass(event.idBoard);
    if (havePass) {
      emit(state.update(havePassJoinBoard: true));
    } else {
      BoardRetroModel boardRetroModel =
          await boardRetroRepository.getInfoBoardWithoutPass(event.idBoard);
      await _socketRepository.emitJoinBoardRetro(event.idBoard);
      emit(JoinedBoardState(boardRetroModel: boardRetroModel));
    }
    await _socketRepository.onEvent(RetroSocketEvent.MESSAGE, (data) {
      add(OnMessageEvent(data: data));
    });

    await _socketRepository.onErrorEvent(PokerSocketEvent.ERROR, (data) {
      print(data);
      add(ErrorFromServerEvent(error: data));
    }, (data) {
      print(data);
    });
  }

  Future<void> _saveTemplate(
      SaveTemplateEvent event, Emitter<BoardRetroState> emit) async {
    bool isSuccess =
        await boardRetroRepository.saveTemplate(event.saveTemplateModel);
    emit(JoinedBoardState(isSaveTemplateSuccess: isSuccess));
  }

  Future<void> _joinGameWithPassword(JoinBoardRetroWithPasswordEvent event,
      Emitter<BoardRetroState> emit) async {
    emit(BoardRetroLoadingState());
    CheckPass checkPass = await boardRetroRepository.checkPassJoinGame(
        event.idBoard, event.password);
    if (checkPass == CheckPass.True) {
      BoardRetroModel boardRetroModel = await boardRetroRepository
          .getInfoBoardWithPass(event.idBoard, event.password);
      await _socketRepository.emitJoinBoardRetro(event.idBoard);
      emit(JoinedBoardState(boardRetroModel: boardRetroModel));
    } else {
      emit(CheckPassJoinBoardState(checkPass: checkPass));
    }
  }

  Future<void> _onMessage(
      OnMessageEvent event, Emitter<BoardRetroState> emit) async {
    emit(BoardRetroLoadingState());
    if (event.data['type'].toString().contains('Stage')) {
      handleSwitchStageEvent(event, emit);
    } else {
      handleSwitchCardsEvent(event, emit);
    }
  }
}

void handleSwitchStageEvent(
    OnMessageEvent event, Emitter<BoardRetroState> emit) {
  switch (event.data['type']) {
    case RetroSocketEvent.ADD_STAGE:
      emit(AddedStageState(stages: Stages.fromAddStageEvenJson(event.data)));
      break;
    case RetroSocketEvent.CHANGE_STAGE_COLOR:
      emit(ChangedColorStageState(
          data: Stages.getInfoChangeStageColor(event.data)));
      break;
    case RetroSocketEvent.DELETE_STAGE:
      emit(DeletedStageState(data: Stages.getInfoDeleteStageColor(event.data)));
      break;
    case RetroSocketEvent.CLEAR_STAGE:
      emit(ClearedStageState(stageId: event.data['stageId']));
      break;
    case RetroSocketEvent.RENAME_STAGE:
      emit(RenameStageState(data: Stages.getInfoRenameStageColor(event.data)));
      break;
    case RetroSocketEvent.DRAG_STAGE:
      emit(DraggedStageState(
          orderStages: event.data['orderStages'].cast<String>()));
      break;
    default:
  }
}

void handleSwitchCardsEvent(
    OnMessageEvent event, Emitter<BoardRetroState> emit) {
  switch (event.data['type']) {
    case RetroSocketEvent.ADD_CARD:
      emit(CreatedCardsState(
          orderCards:
              event.data['card']['updatedStage']['orderCards'].cast<String>(),
          cards: Cards.fromCreateCardJson(event.data)));
      break;
    case RetroSocketEvent.LIKE_CARD:
      var data = Cards.getInfoLikeCard(event.data);
      var likeCards = <LikeCards>[];
      data['cardLikes'].forEach((v) {
        likeCards.add(LikeCards.fromJson(v));
      });
      emit(LikedCardsState(
          numberOfVotes: data['numberOfVotes'],
          stageId: data['stageId'],
          cardId: data['cardId'],
          listLikeCards: likeCards));
      break;
    case RetroSocketEvent.UNLIKE_CARD:
      var data = Cards.getInfoLikeCard(event.data);
      var likeCards = <LikeCards>[];
      data['cardLikes'].forEach((v) {
        likeCards.add(LikeCards.fromJson(v));
      });
      emit(UnLikedCardsState(
          numberOfVotes: data['numberOfVotes'],
          stageId: data['stageId'],
          cardId: data['cardId'],
          listLikeCards: likeCards));
      break;
    case RetroSocketEvent.COMMENT_CARD:
      var listCommentCards = <Comments>[];
      event.data['result']['comments'].forEach((v) {
        listCommentCards.add(Comments.fromJson(v));
      });
      emit(CreatedCommentCardsState(
          numberOfComments: event.data['result']['updateCard']
              ['numberOfComments'],
          stageId: event.data['result']['stageId'],
          cardId: event.data['result']['updateCard']['id'],
          listComment: listCommentCards));
      break;
    case RetroSocketEvent.DELETE_CARD_COMMENT:
      var listCommentCards = <Comments>[];
      event.data['result']['comments'].forEach((v) {
        listCommentCards.add(Comments.fromJson(v));
      });
      emit(DeletedCommentCardsState(
          numberOfComments: event.data['result']['updateCard']
              ['numberOfComments'],
          stageId: event.data['result']['stageId'],
          cardId: event.data['result']['updateCard']['id'],
          listComment: listCommentCards));
      break;
    case RetroSocketEvent.EDIT_CARD_COMMENT:
      var listCommentCards = <Comments>[];
      event.data['result']['comments'].forEach((v) {
        listCommentCards.add(Comments.fromJson(v));
      });
      emit(EditedCommentCardsState(
          stageId: event.data['result']['stageId'],
          cardId: event.data['result']['updateCard']['id'],
          listComment: listCommentCards));
      break;
    case RetroSocketEvent.RENAME_CARD:
      emit(RenamedCardsState(
          stageId: event.data['result']['stageId'],
          cardId: event.data['result']['id'],
          title: event.data['result']['title']));
      break;
    case RetroSocketEvent.SET_CARD_AS_ACTION_ITEM:
      emit(SetActionCardsState(
          stageId: event.data['card']['stageId'],
          cardId: event.data['card']['id'],
          isActionItem: event.data['card']['isActionItem']));
      break;
    case RetroSocketEvent.CHANGE_CARD_COLOR:
      emit(ChangedColorCardsState(
          stageId: event.data['result']['stageId'],
          cardId: event.data['result']['id'],
          color: event.data['result']['color']));
      break;
    case RetroSocketEvent.DELETE_CARD:
      emit(DeletedCardsState(
          stageId: event.data['result']['stageId'],
          cardId: event.data['result']['cardId'],
          orderCards: event.data['result']['orderCards'].cast<String>()));
      break;
    case RetroSocketEvent.SET_IS_COMPLETED_CARD:
      emit(SetIsActionDoneState(
          stageId: event.data['card']['stageId'],
          cardId: event.data['card']['id'],
          isActionDone: event.data['card']['isActionDone']));
      break;
    case RetroSocketEvent.DRAG_CARD:
      if (event.data['result'].length > 1) {
        emit(DraggedCardState(
          stageIdFirst: event.data['result'][0]['stageId'],
          orderCardsFirst: event.data['result'][0]['orderCards'].cast<String>(),
          stageIdSecond: event.data['result'][1]['stageId'],
          orderCardsSecond:
              event.data['result'][1]['orderCards'].cast<String>(),
        ));
      } else {
        emit(DraggedCardState(
          stageIdFirst: event.data['result'][0]['stageId'],
          orderCardsFirst: event.data['result'][0]['orderCards'].cast<String>(),
        ));
      }

      break;
    default:
  }
}
