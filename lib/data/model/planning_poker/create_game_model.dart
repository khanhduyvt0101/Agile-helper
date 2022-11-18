// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';

import '../../../../common/config/config.dart';

class ListVotingSystem extends Equatable {
  final List<VotingSystem> listVotingSystem;
  const ListVotingSystem({this.listVotingSystem});

  static ListVotingSystem fromListDynamic(List<dynamic> data) {
    List<Map<String, dynamic>> _result;
    List<VotingSystem> _list;
    if (data != null && data.isNotEmpty) {
      _result = data.map((e) => e as Map<String, dynamic>)?.toList();
      _list = _result.map((e) => VotingSystem.fromDynamic(e)).toList();
      var seen = <VotingSystem>{};
      _list = _list.where((votingSystem) => seen.add(votingSystem)).toList();
    } else {
      print('error: value is invalid');
    }

    ListVotingSystem listVotingSystem =
        ListVotingSystem(listVotingSystem: _list);
    return listVotingSystem;
  }

  @override
  List<Object> get props => [listVotingSystem];
}

class VotingSystem extends Equatable {
  final String name;
  final CardValue cardValue;

  const VotingSystem({this.name, this.cardValue});

  static VotingSystem fromDynamic(Map<String, dynamic> data) {
    VotingSystem votingSystem = VotingSystem(
        name: data[SerializeGameSetting.NAME],
        cardValue: CardValue.fromDynamic(
            data[SerializeCard.CARD_VALUE][SerializeCard.VALUES]));
    return votingSystem;
  }

  Map<String, Object> toJson() {
    return {
      "name": name,
      "card_values": cardValue.listValue,
    };
  }

  @override
  List<Object> get props => [name, cardValue];
}

class CardValue extends Equatable {
  List<String> listValue;

  List<String> getListValue() {
    return listValue;
  }

  static CardValue fromDynamic(List<dynamic> data) {
    List<String> result;
    result = data.map((el) => el.toString()).toList();
    CardValue cardValue = CardValue(listValue: result);
    return cardValue;
  }

  CardValue({this.listValue});

  @override
  List<Object> get props => [listValue];
}

class CreateGame extends Equatable {
  final String userId;
  final CardValue cardValue;
  final String name;

  Map<String, String> toJson() {
    Map<String, String> temp = {
      "userId": userId,
      "votingSystem": {"decks": cardValue.listValue}.toString(),
      "name": name
    };
    return temp;
  }

  const CreateGame({this.userId, this.cardValue, this.name});

  @override
  List<Object> get props => [];
}
