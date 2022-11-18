// ignore_for_file: constant_identifier_names

import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaddingConfig {
  static final double paddingAppW = 32.w;
  static final double paddingAppH = 32.h;
  static final double paddingSlightW = 4.w;
  static final double paddingSlightH = 4.h;
  static final double paddingNormalW = 8.w;
  static final double paddingNormalH = 8.h;
  static final double paddingLargeW = 16.w;
  static final double paddingLargeH = 16.h;
  static final double paddingIconActionApBarH = 14.h;
  static final double paddingSuperLargeW = 40.w;
  static final double paddingSuperLargeH = 40.h;
  static final double paddingForBottomButtonH = 70.h;
  static const double cornerRadius = 10;
  static const double circleButtonRadius = 30;
  static const double cornerRadiusFrame = 5;
  static const double circleRadiusFrame = 100;
  static final double cornerRadiusHighlightBox = 10.w;
  static const int dateDanger = 7;
  static double iconAppBar = 20;
}

class PokerSocketEvent {
  static const String CREATE_GAME = 'createGame';
  static const String JOIN_GAME = 'joinGame';
  static const String LEAVE_GAME = 'leaveGame';
  static const String MESSAGE = 'message';
  static const String SELECT_CARD = 'selectCard';
  static const String REVEAL_CARDS = 'revealCards';
  static const String UPDATE_CARD = 'updateCard';
  static const String RECONNECT = 'reconnect';
  static const String ONLINE_PLAYERS = 'onlinePlayers';
  static const String GAME_SETTINGS = 'gameSettings';
  static const String SET_GAME_NAME = 'setGameName';
  static const String DESELECT_CARD = 'deselectCard';
  static const String START_NEW_VOTING = 'startNewVoting';
  static const String NEW_PLAYER_HAS_JOINED = 'newPlayerHasJoined';
  static const String A_PLAYER_HAS_LEFT = 'aPlayerHasLeft';
  static const String SET_GAME_VOTING_SYSTEM = 'setGameVotingSystem';
  static const String USER_DISPLAY_NAME_CHANGED = 'userDisplayNameChanged';
  static const String UPDATE_GAME_SETTINGS = 'updateGameSettings';
  static const String ERROR = 'error';
}

class RetroSocketEvent {
  static const String JOIN_BOARD = 'joinBoard';
  static const String ADD_STAGE = 'addStage';
  static const String RENAME_STAGE = 'renameStage';
  static const String MESSAGE = 'message';
  static const String DRAG_STAGE = 'dragStage';
  static const String CHANGE_STAGE_COLOR = 'changeStageColor';
  static const String ADD_CARD = 'addCard';
  static const String DRAG_CARD = 'dragCard';
  static const String RENAME_CARD = 'renameCard';
  static const String CHANGE_CARD_COLOR = 'changeCardColor';
  static const String LIKE_CARD = 'likeCard';
  static const String COMMENT_CARD = 'commentCard';
  static const String SET_STAGE_DESCRIPTION = 'setStageDescription';
  static const String CLEAR_STAGE = 'clearStage';
  static const String DELETE_STAGE = 'deleteStage';
  static const String SET_IS_COMPLETED_CARD = 'setIsCompletedCard';
  static const String EDIT_CARD_COMMENT = 'editCardComment';
  static const String DELETE_CARD_COMMENT = 'deleteCardComment';
  static const String DELETE_CARD = 'deleteCard';
  static const String ERROR = 'error';
  static const String UNLIKE_CARD = 'unlikeCard';
  static const String SET_CARD_AS_ACTION_ITEM = 'setCardAsActionItem';
}

class GetHost {
  //change value isProd is false to test local and true to prod
  static const bool isProd = true;
  static String urlHostApi() {
    return isProd ? HostProductionUrl.URL_HOST_API : HostUrl.URL_HOST_API_LOCAL;
  }

  static String urlApiSocket() {
    return isProd
        ? HostProductionUrl.URL_API_SOCKET
        : HostUrl.URL_API_SOCKET_LOCAL;
  }

  static String urlApiSocketRetro() {
    return isProd
        ? HostProductionUrl.URL_API_SOCKET_RETRO
        : HostUrl.URL_API_SOCKET_RETRO_LOCAL;
  }

  static Uri urlLogin() {
    return isProd ? HostProductionUrl.loginURL : HostUrl.loginURL;
  }

  static Uri urlTwoFactorAuth() {
    return HostProductionUrl.twoFactorAuthURL;
  }

  static Uri urlAuthenticate() {
    return isProd ? HostProductionUrl.authenURL : HostUrl.authenURL;
  }

  static String urlGetImage() {
    return isProd ? HostProductionUrl.URL_GET_IMAGE : HostUrl.URL_GET_IMAGE;
  }

  static String urlInviteGame() {
    return isProd ? HostProductionUrl.URL_INVITE_GAME : HostUrl.URL_INVITE_GAME;
  }

  static String urlInviteBoardRetro() {
    return isProd
        ? HostProductionUrl.URL_INVITE_BOARD_RETRO
        : HostUrl.URL_INVITE_BOARD_RETRO;
  }
}

class HostUrl {
  //url est for emulator: 10.0.2.2
  static const String URL_HOST_API_LOCAL = 'localhost';
  static const String URL_API_SOCKET_LOCAL = 'http://localhost:4000/';
  static const String URL_API_SOCKET_RETRO_LOCAL =
      'http://localhost:4000/retro';
  static Uri loginURL =
      Uri.parse('xyz');
  static Uri authenURL = Uri.parse('xyz');
  static const String URL_GET_IMAGE =
      'xyz';
  static const String URL_INVITE_GAME =
      'xyz';
  static const String URL_INVITE_BOARD_RETRO =
      'xyz';
}

class HostProductionUrl {
  static const String URL_HOST_API = 'xyz';
  static const String URL_API_SOCKET =
      'xyz';
  static const String URL_API_SOCKET_RETRO =
      'xyz';
  static Uri loginURL =
      Uri.parse('xyz');

  static Uri twoFactorAuthURL =
      Uri.parse('xyz');
  static Uri authenURL =
      Uri.parse('xyz');

  static const String URL_GET_IMAGE =
      'xyz';
  static const String URL_INVITE_GAME =
      'xyz';
  static const String URL_INVITE_BOARD_RETRO =
      'xyz';
}

class UserService {
  //authenticate
  static const String loginWithEmail = '/auth/login';

  //planning poker
  static const String userVotingOptions =
      GetHost.isProd ? '/api/custom_deck' : '/custom_deck';
  static const String saveUserDeck =
      GetHost.isProd ? '/api/custom_deck' : '/custom_deck';
  static const String pingGame =
      GetHost.isProd ? '/api/game/ping' : '/game/ping';

  //easy retro
  static const String publicBoard = '/easy-retro/dashboard';
  static const String transferBoard = '/easy-retro/board/transfer';
  static const String archivedBoard = '/easy-retro/board/archived';
  static const String templatesBoard = '/easy-retro/templates';
  static const String listActionItem = '/easy-retro/cards/action_item';
  static const String board = '/easy-retro/board';
  static const String cloneBoard = '/easy-retro/board/clone';
  static const String forceBoard = '/easy-retro/board/force';
  static const String restoreBoard = '/easy-retro/board/restore';
}

class Alert {
  static const String pingGameSuccess = 'Game exists';
  static const String pingGameNotExist = 'Game not exists';
  static const String pingGameWrong = 'Something wrong';
}

class SerializeGameSetting {
  static const String KEY = 'game';
  static const String NAME = 'name';
  static const String ID = 'id';
  static const String USER_GAME = 'userGames';
  static const String USER_ID = 'user_id';
  static const String USERID = 'userId';
  static const String VOTING_SYSTEM = 'voting_system';
  static const String EVENT = 'event';
}

class SerializeListPlayer {
  static const String KEY = 'players';
}

class SerializePlayer {
  static const String KEY = 'player';
  static const String DISPLAY_NAME = 'displayName';
  static const String UID = 'uid';
  static const String USERNAME_ENCRYPT = 'userNameEncrypt';
  static const String CARD = 'card';
  static const String USER_ID = 'userId';
  static const String ADMIN_ID = 'adminId';
  static const String GAME = 'game';
}

class SerializeCard {
  static const String VALUE = 'value';
  static const String VALUES = 'values';
  static const String IS_SELECTED = 'isSelected';
  static const String UID = 'uid';
  static const String CARD_VALUE = 'card_values';
  static const String CARD = 'card';
  static const String USER_ID = 'userId';
  static const String ADMIN_ID = 'adminId';
}

enum BoardType { Public, Archived, ActionItem }

enum CheckPass { True, False, IncorrectUrl }

enum CheckActionBoard { Success, BoardNotValid, Fail }

enum CheckDeleteBoard { Success, BoardNotValid, NotAuthor, Error }

enum CheckRestoreBoard { Success, BoardNotValid, NotAuthor, Error }
