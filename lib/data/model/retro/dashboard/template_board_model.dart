import 'package:equatable/equatable.dart';

class TemplateBoardModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final int countStages;

  const TemplateBoardModel(
      {this.id, this.title, this.description, this.countStages});

  static TemplateBoardModel fromJson(Map<String, dynamic> data) {
    List<dynamic> list = data['templateSetting']['stages'];
    TemplateBoardModel templateBoardModel = TemplateBoardModel(
        title: data['title'],
        id: data['id'],
        description: data['description'],
        countStages: list.length);
    return templateBoardModel;
  }

  @override
  List<Object> get props => throw UnimplementedError();
}
