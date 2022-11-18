import 'package:equatable/equatable.dart';

class ActionItemModel extends Equatable {
  final String nameItem;
  final String createAt;
  final bool isDone;
  final String idBoard;
  final String titleBoard;
  final List<Assignee> userNameEncryptAssignee;

  const ActionItemModel(
      {this.nameItem,
      this.createAt,
      this.idBoard,
      this.isDone,
      this.titleBoard,
      this.userNameEncryptAssignee});

  static ActionItemModel fromJson(Map<String, dynamic> data) {
    ActionItemModel actionItemModel = ActionItemModel(
        nameItem: data['title'],
        createAt: data['createdAt'],
        isDone: data['isActionDone'],
        idBoard: data['board']['id'],
        titleBoard: data['board']['name'],
        userNameEncryptAssignee: Assignee.fromJson(data['assignCard']));
    return actionItemModel;
  }

  @override
  List<Object> get props => throw UnimplementedError();
}

class Assignee {
  final String userNameEncrypt;
  Assignee({this.userNameEncrypt});

  static List<Assignee> fromJson(List<dynamic> listData) {
    List<Assignee> listAssignee = [];
    for (var element in listData) {
      listAssignee
          .add(Assignee(userNameEncrypt: element['user']['userNameEncrypt']));
    }

    return listAssignee;
  }
}
