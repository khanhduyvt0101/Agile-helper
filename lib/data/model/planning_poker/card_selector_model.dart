import 'player_model.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/config/config.dart';

class CardSelectorModel extends Equatable {
  final String userId;
  final String gameId;
  final String event;
  final CardPlayer card;

  const CardSelectorModel({this.userId, this.gameId, this.event, this.card});

  static CardSelectorModel fromDynamic(Map<String, dynamic> gameSettings) {
    //{userId: 415c3680-68c7-4909-a4b4-702fb1f24ea1, card: {value: 2, isSelected: true},
    //gameId: d30193a3-774b-4030-aa56-6d71065ac41e, event: selectCard, type: selectCard}
    CardSelectorModel cardSelectorModel = CardSelectorModel(
        userId: gameSettings[SerializeGameSetting.USERID],
        event: gameSettings[SerializeGameSetting.EVENT],
        card: CardPlayer.fromDynamic(gameSettings[SerializeCard.CARD]));
    return cardSelectorModel;
  }

  Map<String, Object> toJson() {
    return {
      "userId": userId,
      "card": {
        "value": card.isSelected ? card.value : null,
        "isSelected": card.isSelected
      },
      "gameId": gameId,
      "event": event
    };
  }

  @override
  List<Object> get props => [];
}
