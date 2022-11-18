import 'save_template_model.dart';

class BoardRetroModel {
  BoardInfo boardInfo;
  bool isEditable;

  BoardRetroModel({this.boardInfo, this.isEditable});

  BoardRetroModel.fromJson(Map<String, dynamic> json) {
    boardInfo = json['boardInfo'] != null
        ? BoardInfo.fromJson(json['boardInfo'])
        : null;
    isEditable = json['isEditable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (boardInfo != null) {
      data['boardInfo'] = boardInfo.toJson();
    }
    data['isEditable'] = isEditable;
    return data;
  }
}

class BoardInfo {
  String id;
  String name;
  String templateId;
  String userId;
  String password;
  bool isDeleted;
  List<String> orderStages;
  String createdAt;
  String updatedAt;
  List<Stages> stages;

  BoardInfo(
      {this.id,
      this.name,
      this.templateId,
      this.userId,
      this.password,
      this.isDeleted,
      this.orderStages,
      this.createdAt,
      this.updatedAt,
      this.stages});

  void setOrderStages(List<String> list) {
    orderStages = list;
  }

  BoardInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    templateId = json['templateId'];
    userId = json['userId'];
    password = json['password'];
    isDeleted = json['isDeleted'];
    orderStages = json['orderStages'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['stages'] != null) {
      stages = <Stages>[];
      json['stages'].forEach((v) {
        stages.add(Stages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['templateId'] = templateId;
    data['userId'] = userId;
    data['password'] = password;
    data['isDeleted'] = isDeleted;
    data['orderStages'] = orderStages;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (stages != null) {
      data['stages'] = stages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stages {
  String id;
  String title;
  String description;
  String color;
  int position;
  List<String> orderCards;
  String boardId;
  String createdAt;
  List<Cards> cards;

  Stages(
      {this.id,
      this.title,
      this.description,
      this.color,
      this.position,
      this.orderCards,
      this.boardId,
      this.createdAt,
      this.cards});

  void changeColor(String color) {
    this.color = color;
  }

  void clearStages() {
    cards = [];
    orderCards = [];
  }

  void setOrderCardsAndClearCard(List<String> _orderCards) {
    cards = [];
    orderCards = _orderCards;
  }

  void setOrderCardsAndAddCard(Cards _cards, List<String> _orderCards) {
    cards.map((e) {
      if (e.id == _cards.id) return;
    });
    cards.add(_cards);
    orderCards = _orderCards;
  }

  Stages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    color = json['color'];
    position = json['position'];
    orderCards = json['orderCards'].cast<String>();
    boardId = json['boardId'];
    createdAt = json['createdAt'];
    if (json['cards'] != null) {
      cards = <Cards>[];
      json['cards'].forEach((v) {
        cards.add(Cards.fromJson(v));
      });
    }
  }

  Stages.fromAddStageEvenJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json['result']['savedStage'];
    title = data['title'];
    description = data['description'];
    color = data['color'];
    position = data['position'];
    orderCards = [];
    boardId = data['boardId'];
    createdAt = data['createdAt'];
    id = data['id'];
    cards = [];
  }

  static Map<String, dynamic> getInfoChangeStageColor(
      Map<String, dynamic> json) {
    Map<String, dynamic> data = {
      'id': json['stage']['id'],
      'color': json['stage']['color']
    };
    return data;
  }

  static Map<String, dynamic> getInfoDeleteStageColor(
      Map<String, dynamic> json) {
    Map<String, dynamic> data = {
      'stageId': json['result']['stageId'],
      'orderStages': json['result']['orderStages'].cast<String>()
    };
    return data;
  }

  static Map<String, dynamic> getInfoRenameStageColor(
      Map<String, dynamic> json) {
    Map<String, dynamic> data = {
      'id': json['stage']['id'],
      'title': json['stage']['title']
    };
    return data;
  }

  StagesTemplate getStagesForSaveTemplate(Stages stages) {
    return StagesTemplate(
        title: title,
        description: description,
        color: color,
        position: position);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['color'] = color;
    data['position'] = position;
    data['orderCards'] = orderCards;
    data['boardId'] = boardId;
    data['createdAt'] = createdAt;
    if (cards != null) {
      data['cards'] = cards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cards {
  String id;
  String title;
  int numberOfVotes;
  int numberOfComments;
  bool isPin;
  bool archive;
  bool isActionItem;
  bool isActionDone;
  String stageId;
  String boardId;
  int position;
  String color;
  String userId;
  String createdAt;
  String updatedAt;
  List<LikeCards> likeCards;
  List<Comments> comments;

  Cards(
      {this.id,
      this.title,
      this.numberOfVotes,
      this.numberOfComments,
      this.isPin,
      this.archive,
      this.isActionItem,
      this.isActionDone,
      this.stageId,
      this.boardId,
      this.position,
      this.color,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.likeCards,
      this.comments});

  void setLikeCardsAndNumberOfVote(int number, List<LikeCards> _likeCards) {
    numberOfVotes = number;
    likeCards = _likeCards;
  }

  void setCommentsAndNumberOfComments(
      int _numberOfComments, List<Comments> _comments) {
    numberOfComments = _numberOfComments;
    comments = _comments;
  }

  Cards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    numberOfVotes = json['numberOfVotes'];
    numberOfComments = json['numberOfComments'];
    isPin = json['isPin'];
    archive = json['archive'];
    isActionItem = json['isActionItem'];
    isActionDone = json['isActionDone'];
    stageId = json['stageId'];
    boardId = json['boardId'];
    position = json['position'];
    color = json['color'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['likeCards'] != null) {
      likeCards = <LikeCards>[];
      json['likeCards'].forEach((v) {
        likeCards.add(LikeCards.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments.add(Comments.fromJson(v));
      });
    }
  }

  static Map<String, dynamic> getInfoLikeCard(Map<String, dynamic> json) {
    Map<String, dynamic> data = {
      'numberOfVotes': json['result']['updateCard']['numberOfVotes'],
      'stageId': json['result']['stageId'],
      'cardId': json['result']['updateCard']['id'],
      'cardLikes': json['result']['cardLikes'],
    };
    return data;
  }

  Cards.fromCreateCardJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json['card']['savedCard'];
    id = data['id'];
    title = data['title'];
    numberOfVotes = data['numberOfVotes'];
    numberOfComments = data['numberOfComments'];
    isPin = data['isPin'];
    archive = data['archive'];
    isActionItem = data['isActionItem'];
    isActionDone = data['isActionDone'];
    stageId = data['stageId'];
    boardId = data['boardId'];
    position = data['position'];
    color = data['color'];
    userId = data['userId'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
    likeCards = [];
    comments = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['numberOfVotes'] = numberOfVotes;
    data['numberOfComments'] = numberOfComments;
    data['isPin'] = isPin;
    data['archive'] = archive;
    data['isActionItem'] = isActionItem;
    data['isActionDone'] = isActionDone;
    data['stageId'] = stageId;
    data['boardId'] = boardId;
    data['position'] = position;
    data['color'] = color;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (likeCards != null) {
      data['likeCards'] = likeCards.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      data['comments'] = comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LikeCards {
  String id;
  String cardId;
  String userId;

  LikeCards({this.id, this.cardId, this.userId});

  LikeCards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardId = json['cardId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cardId'] = cardId;
    data['userId'] = userId;
    return data;
  }
}

class Comments {
  String id;
  String content;
  String userId;
  String cardId;
  String createdAt;
  String updatedAt;

  Comments(
      {this.id,
      this.content,
      this.userId,
      this.cardId,
      this.createdAt,
      this.updatedAt});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    userId = json['userId'];
    cardId = json['cardId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['userId'] = userId;
    data['cardId'] = cardId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
