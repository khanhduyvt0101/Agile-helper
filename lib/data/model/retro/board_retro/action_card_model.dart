class CreateCardModel {
  String stageId;
  String title;
  String color;
  int position;
  String userId;
  List<String> orderCards;

  CreateCardModel(
      {this.stageId,
      this.title,
      this.color,
      this.position,
      this.userId,
      this.orderCards});

  CreateCardModel.fromJson(Map<String, dynamic> json) {
    stageId = json['stageId'];
    title = json['title'];
    color = json['color'];
    position = json['position'];
    userId = json['userId'];
    orderCards = json['orderCards'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stageId'] = stageId;
    data['title'] = title;
    data['color'] = color;
    data['position'] = position;
    data['userId'] = userId;
    data['orderCards'] = orderCards;
    return data;
  }
}
