import 'package:equatable/equatable.dart';

class BoardModel extends Equatable {
  final String nameBoard;
  final String createAt;
  final int numberCard;
  final String id;
  final String oldAuthor;

  const BoardModel(
      {this.nameBoard,
      this.createAt,
      this.numberCard,
      this.id,
      this.oldAuthor});

  static BoardModel fromJson(Map<String, dynamic> data) {
    BoardModel boardModel = BoardModel(
        nameBoard: data['name'],
        createAt: data['createdAt'],
        numberCard: data['stagesLength'],
        id: data['id'],
        oldAuthor: data['oldAuthor']);
    return boardModel;
  }

  @override
  List<Object> get props => [];
}

class UserModel extends Equatable {
  final String id;
  final String displayName;

  const UserModel({this.id, this.displayName});

  Map<String, Object> toJson() {
    return {"id": id, "display_name": displayName};
  }

  static UserModel fromJson(Map<String, dynamic> data) {
    UserModel userModel =
        UserModel(id: data['id'], displayName: data['display_name']);
    return userModel;
  }

  @override
  List<Object> get props => [];
}
