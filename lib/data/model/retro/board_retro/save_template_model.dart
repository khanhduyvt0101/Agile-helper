class SaveTemplateModel {
  String title;
  String description;
  List<StagesTemplate> stagesTemplate;

  SaveTemplateModel({this.title, this.description, this.stagesTemplate});

  SaveTemplateModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    if (json['stagesTemplate'] != null) {
      stagesTemplate = <StagesTemplate>[];
      json['stagesTemplate'].forEach((v) {
        stagesTemplate.add(StagesTemplate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    if (stagesTemplate != null) {
      data['stagesTemplate'] = stagesTemplate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StagesTemplate {
  String title;
  String description;
  String color;
  int position;

  StagesTemplate({this.title, this.description, this.color, this.position});

  StagesTemplate.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    color = json['color'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['color'] = color;
    data['position'] = position;
    return data;
  }
}
