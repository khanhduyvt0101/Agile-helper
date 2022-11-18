import 'create_game_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/config/config.dart';

class GameSettingModel extends Equatable {
  final String gameId;
  final String nameBoard;
  final String userHostId;
  final CardValue cardValue;

  const GameSettingModel(
      {this.gameId, this.nameBoard, this.userHostId, this.cardValue});

  static GameSettingModel fromDynamic(Map<String, dynamic> gameSettings) {
    Map<String, dynamic> gameSettingDetails =
        gameSettings[SerializeGameSetting.KEY];
    String list =
        gameSettingDetails[SerializeGameSetting.VOTING_SYSTEM].toString();
    list = list.split('[')[1].split(']')[0];
    List<String> listString = list.split(', ');

    //{type: gameSettings, game: {id: fee7d0b4-a7a3-4951-907b-429b2ea7142d, name: a,
    // voting_system: {decks: [1, 2, 3, 4, 5]}, faciliator: c19bcbb0-2787-44a3-a093-47f5a3f515d6,
    //userGames: [{id: f3da65b6-e092-4ecb-ae0d-bb0e348c6f45, user_id: c19bcbb0-2787-44a3-a093-47f5a3f515d6,
    //game_id: fee7d0b4-a7a3-4951-907b-429b2ea7142d}],
    //gamePlayers: [{id: 67459297-750b-4245-8ba8-d65d1a09670c, player_permissions: {},
    //user_id: c19bcbb0-2787-44a3-a093-47f5a3f515d6, game_id: fee7d0b4-a7a3-4951-907b-429b2ea7142d}],
    //gameIssue: []}}
    GameSettingModel gameSettingModel = GameSettingModel(
        gameId: gameSettingDetails[SerializeGameSetting.ID],
        nameBoard: gameSettingDetails[SerializeGameSetting.NAME],
        userHostId: gameSettingDetails[SerializeGameSetting.USER_GAME][0]
            [SerializeGameSetting.USER_ID],
        cardValue: CardValue.fromDynamic(listString));
    return gameSettingModel;
  }

  @override
  List<Object> get props => [];
}
