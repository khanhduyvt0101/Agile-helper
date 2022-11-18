import '../model/retro/board_retro/action_card_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../common/config/config.dart';
import '../model/planning_poker/card_selector_model.dart';
import '../model/planning_poker/join_game_model.dart';

class SocketRepository {
  static Socket _socket;
  final String urlSocket;
  SocketRepository({this.urlSocket}) {
    if (_socket == null || !_socket.connected || _socket.disconnected) {
      _socket = io(
        urlSocket,
        OptionBuilder().setTransports(['websocket']).setTimeout(3000).build(),
      );
      _socket.onConnecting((data) => print(data));
      _socket.onConnectError(
          (data) => print("Socket connect error: " + data.toString()));
      _socket.onConnect((data) => print('Socket connected'));
    }
  }

  static Socket getSocket() {
    if (_socket != null && !_socket.connected) {
      _socket.emit('connect');
    }
    return _socket;
  }

  static void disconnect() {
    if (_socket != null && _socket.connected) {
      _socket.disconnect();
    }
  }

  Future<void> onEvent(
      String event, Function(Map<String, dynamic>) callback) async {
    try {
      getSocket().on(event, (data) => callback(data));
    } catch (error) {
      print('error: ' + error);
      callback(Map<String, dynamic>.from(error));
    }
  }

  Future<void> onErrorEvent(String event, Function(String) callbackString,
      Function(Map<String, dynamic>) callbackMap) async {
    try {
      getSocket().on(event, (data) {
        print(data);
        callbackMap(data);
      });
    } catch (error) {
      print('error: ' + error);
      callbackString(error);
    }
  }

  //planning poker
  Future<String> emitCreateGameEvent(
      String event, var data, Function(String) callback) async {
    getSocket().emitWithAck(event, data, ack: (List<dynamic> data) {
      List<String> temp = data.map((e) => e.toString()).toList();
      if (temp[0] != null) {
        callback(temp[0].toString());
      } else {
        print('error: ' + temp[1]);
      }
    });
    return null;
  }

  Future<void> emitJoinGameEvent(
      JoinGameModel joinGameModel, Function(String) callback) async {
    getSocket().emit(PokerSocketEvent.JOIN_GAME, joinGameModel.toJson());
    getSocket().on(PokerSocketEvent.ERROR, (data) {
      callback(data.toString());
    });
  }

  Future<void> emitCardSelector(CardSelectorModel cardSelectorModel) async {
    getSocket().emit(PokerSocketEvent.UPDATE_CARD, cardSelectorModel.toJson());
  }

  Future<void> emitRevealCards(String gameId) async {
    getSocket().emit(PokerSocketEvent.REVEAL_CARDS, {"gameId": gameId});
  }

  Future<void> emitStartNewVoting(String gameId) async {
    getSocket().emit(PokerSocketEvent.START_NEW_VOTING, {"gameId": gameId});
  }

  //easy retro
  //Stage
  Future<void> emitJoinBoardRetro(String boardId) async {
    getSocket().emit(RetroSocketEvent.JOIN_BOARD, boardId);
  }

  Future<void> emitAddStage(
      String boardId, String title, String color, int position) async {
    Map<String, dynamic> option = {
      'title': title,
      'color': color,
      'position': position,
      'description': '',
    };
    getSocket().emit(RetroSocketEvent.ADD_STAGE, [boardId, option]);
  }

  Future<void> emitChangeColorStage(
      String boardId, String stageId, String color) async {
    Map<String, dynamic> option = {
      'stageId': stageId,
      'color': color,
    };
    getSocket().emit(RetroSocketEvent.CHANGE_STAGE_COLOR, [boardId, option]);
  }

  Future<void> emitDeleteStage(
      String boardId, String stageId, List<String> orderStages) async {
    Map<String, dynamic> option = {
      'stageId': stageId,
      'orderStages': orderStages,
    };
    getSocket().emit(RetroSocketEvent.DELETE_STAGE, [boardId, option]);
  }

  Future<void> emitClearStage(String boardId, String stageId) async {
    Map<String, dynamic> option = {
      'stageId': stageId,
    };
    getSocket().emit(RetroSocketEvent.CLEAR_STAGE, [boardId, option]);
  }

  Future<void> emitRenameStage(
      String boardId, String title, String stageId) async {
    Map<String, dynamic> option = {
      'title': title,
      'stageId': stageId,
    };
    getSocket().emit(RetroSocketEvent.RENAME_STAGE, [boardId, option]);
  }

  //Cards
  Future<void> emitCreateCard(
      String boardId, CreateCardModel createCardModel) async {
    getSocket()
        .emit(RetroSocketEvent.ADD_CARD, [boardId, createCardModel.toJson()]);
  }

  Future<void> emitLikeCard(
      String boardId, String cardId, String userId, String stageId) async {
    Map<String, dynamic> option = {
      'cardId': cardId,
      'userId': userId,
      'stageId': stageId,
    };
    getSocket().emit(RetroSocketEvent.LIKE_CARD, [boardId, option]);
  }

  Future<void> emitUnLikeCard(
      String boardId, String cardId, String userId, String stageId) async {
    Map<String, dynamic> option = {
      'cardId': cardId,
      'userId': userId,
      'stageId': stageId,
    };
    getSocket().emit(RetroSocketEvent.UNLIKE_CARD, [boardId, option]);
  }

  Future<void> emitCreateCommentCard(String boardId, String cardId,
      String userId, String stageId, String content) async {
    Map<String, dynamic> option = {
      'cardId': cardId,
      'userId': userId,
      'stageId': stageId,
      'content': content,
    };
    getSocket().emit(RetroSocketEvent.COMMENT_CARD, [boardId, option]);
  }

  Future<void> emitDeleteCommentCard(String boardId, String cardId,
      String userId, String stageId, String commentId) async {
    Map<String, dynamic> option = {
      'cardId': cardId,
      'userId': userId,
      'commentId': commentId,
      'stageId': stageId,
    };
    getSocket().emit(RetroSocketEvent.DELETE_CARD_COMMENT, [boardId, option]);
  }

  Future<void> emitEditCommentCard(String boardId, String cardId, String userId,
      String stageId, String commentId, String content) async {
    Map<String, dynamic> option = {
      'cardId': cardId,
      'userId': userId,
      'commentId': commentId,
      'content': content,
      'stageId': stageId,
    };
    getSocket().emit(RetroSocketEvent.EDIT_CARD_COMMENT, [boardId, option]);
  }

  Future<void> emitRenameCard(
      String boardId, String cardId, String stageId, String title) async {
    Map<String, dynamic> option = {
      'cardId': cardId,
      'title': title,
      'stageId': stageId,
    };
    getSocket().emit(RetroSocketEvent.RENAME_CARD, [boardId, option]);
  }

  Future<void> emitSetActionCard(
      String boardId, String cardId, String userId, bool isActionItem) async {
    Map<String, dynamic> option = {
      'userId': userId,
      'cardId': cardId,
      'isActionItem': isActionItem,
    };
    getSocket()
        .emit(RetroSocketEvent.SET_CARD_AS_ACTION_ITEM, [boardId, option]);
  }

  Future<void> emitChangeColorCard(
      String boardId, String cardId, String stageId, String color) async {
    Map<String, dynamic> option = {
      'cardId': cardId,
      'color': color,
      'stageId': stageId,
    };
    getSocket().emit(RetroSocketEvent.CHANGE_CARD_COLOR, [boardId, option]);
  }

  Future<void> emitDeleteCard(String boardId, String cardId, String stageId,
      List<String> orderCards) async {
    Map<String, dynamic> option = {
      'stageId': stageId,
      'cardId': cardId,
      'orderCards': orderCards,
    };
    getSocket().emit(RetroSocketEvent.DELETE_CARD, [boardId, option]);
  }

  Future<void> emitSetIsCompleteCard(
      String boardId, String cardId, String userId, bool isActionDone) async {
    Map<String, dynamic> option = {
      'userId': userId,
      'cardId': cardId,
      'isActionItem': true,
      'isActionDone': isActionDone,
    };
    getSocket().emit(RetroSocketEvent.SET_IS_COMPLETED_CARD, [boardId, option]);
  }
}
