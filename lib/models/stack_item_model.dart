class StackItemModel {
  List<ItemData>? items;

  StackItemModel({this.items});

  StackItemModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ItemData>[];
      json['items'].forEach((v) {
        items!.add(ItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemData {
  OpenState? openState;
  OpenState? closedState;
  String? ctaText;

  ItemData({this.openState, this.closedState, this.ctaText});

  ItemData.fromJson(Map<String, dynamic> json) {
    openState = json['open_state'] != null
        ? OpenState.fromJson(json['open_state'])
        : null;
    closedState = json['closed_state'] != null
        ? OpenState.fromJson(json['closed_state'])
        : null;
    ctaText = json['cta_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.openState != null) {
      data['open_state'] = this.openState!.toJson();
    }
    if (this.closedState != null) {
      data['closed_state'] = this.closedState!.toJson();
    }
    data['cta_text'] = this.ctaText;
    return data;
  }
}

class OpenState {
  OpenStateBody? body;

  OpenState({this.body});

  OpenState.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? OpenStateBody.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class OpenStateBody {
  String? title;
  String? subtitle;
  CardData? card;
  String? footer;
  List<ItemData>? items;

  OpenStateBody({this.title, this.subtitle, this.card, this.footer, this.items});

  OpenStateBody.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    card = json['card'] != null ? CardData.fromJson(json['card']) : null;
    footer = json['footer'];
    if (json['items'] != null) {
      items = <ItemData>[];
      json['items'].forEach((v) {
        items!.add(ItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    if (this.card != null) {
      data['card'] = this.card!.toJson();
    }
    data['footer'] = this.footer;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CardData {
  String? header;
  String? description;
  int? maxRange;
  int? minRange;

  CardData({this.header, this.description, this.maxRange, this.minRange});

  CardData.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    description = json['description'];
    maxRange = json['max_range'];
    minRange = json['min_range'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['header'] = this.header;
    data['description'] = this.description;
    data['max_range'] = this.maxRange;
    data['min_range'] = this.minRange;
    return data;
  }
}

class ClosedState {
  ClosedStateBody? body;

  ClosedState({this.body});

  ClosedState.fromJson(Map<String, dynamic> json) {
    body = json['body'] != null ? ClosedStateBody.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class ClosedStateBody {
  String? key1;
  String? key2;

  ClosedStateBody({this.key1, this.key2});

  ClosedStateBody.fromJson(Map<String, dynamic> json) {
    key1 = json['key1'];
    key2 = json['key2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['key1'] = this.key1;
    data['key2'] = this.key2;
    return data;
  }
}
