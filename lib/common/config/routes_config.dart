// ignore_for_file: constant_identifier_names

import 'package:agile_helper/module/home/view/home_view.dart';
import 'package:agile_helper/module/login/view/login_view.dart';
import 'package:agile_helper/module/planning_poker/board_game/view/board_game_view.dart';
import 'package:agile_helper/module/planning_poker/create_game/view/create_game_view.dart';
import 'package:agile_helper/module/planning_poker/home/view/planning_poker_home_view.dart';
import 'package:agile_helper/module/retro/board_retro/view/board_retro_view.dart';
import 'package:agile_helper/module/retro/dashboard/view/action_item_list_view.dart';
import 'package:agile_helper/module/retro/dashboard/view/dashboard_home_view.dart';
import 'package:agile_helper/module/retro/dashboard/view/board_view.dart';
import 'package:agile_helper/module/retro/home/view/retro_home_view.dart';
import 'package:flutter/material.dart';

class ConfigRoutes {
  static const String CREATE_GAME = "/create_game";
  static const String HOME_VIEW = "/home_view";
  static const String LOGIN_VIEW = "/login_view";
  static const String BOARD_GAME = "/board_game";
  static const String PLANNING_POKER_HOME = "/planning_poker_home";
  static const String DASHBOARD_HOME_VIEW = "/dashboard_home_view";
  static const String BOARD_VIEW = "/board_view";
  static const String ACTION_ITEM_LIST_VIEW = "/action_item_list_view";
  static const String BOARD_RETRO_VIEW = "/board_retro_view";
  static const String RETRO_HOME_VIEW = "/retro_home_view";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CREATE_GAME:
        final args = settings.arguments as CreateGameViewArguments;
        return MaterialPageRoute(
          builder: (context) {
            return CreateGameView(tokenLogin: args.tokenLogin);
          },
        );
      case HOME_VIEW:
        return MaterialPageRoute(
          builder: (context) {
            return const HomeView();
          },
        );

      case LOGIN_VIEW:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginView();
          },
        );

      case BOARD_GAME:
        final args = settings.arguments as BoardGameViewArguments;
        return MaterialPageRoute(
          builder: (context) {
            return BoardGameView(
              gameId: args.gameId,
              tokenLogin: args.tokenLogin,
            );
          },
        );
      case PLANNING_POKER_HOME:
        final args = settings.arguments as PlanningPokerHomeViewArguments;
        return MaterialPageRoute(
          builder: (context) {
            return PlanningPokerHomeView(
              tokenLogin: args.tokenLogin,
            );
          },
        );
      case DASHBOARD_HOME_VIEW:
        final args = settings.arguments as DashBoardHomeViewArguments;
        return MaterialPageRoute(
          builder: (context) {
            return DashBoardHomeView(
              tokenLogin: args.tokenLogin,
            );
          },
        );
      case BOARD_VIEW:
        final args = settings.arguments as BoardViewArguments;
        return MaterialPageRoute(
          builder: (context) {
            return BoardView(
              tokenLogin: args.tokenLogin,
              boardType: args.boardType,
            );
          },
        );
      case ACTION_ITEM_LIST_VIEW:
        final args = settings.arguments as ActionItemListViewArguments;
        return MaterialPageRoute(
          builder: (context) {
            return ActionItemListView(
              tokenLogin: args.tokenLogin,
            );
          },
        );
      case BOARD_RETRO_VIEW:
        final args = settings.arguments as BoardRetroViewArguments;
        return MaterialPageRoute(
          builder: (context) {
            return BoardRetroView(
              boardId: args.boardId,
              tokenLogin: args.tokenLogin,
              nameBoard: args.nameBoard,
            );
          },
        );

      case RETRO_HOME_VIEW:
        final args = settings.arguments as RetroHomeViewArguments;
        return MaterialPageRoute(
          builder: (context) {
            return RetroHomeView(
              tokenLogin: args.tokenLogin,
            );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final ConfigRoutes _instance = ConfigRoutes._internal();

  factory ConfigRoutes() {
    return _instance;
  }

  ConfigRoutes._internal();
}
