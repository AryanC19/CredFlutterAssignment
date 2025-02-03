// lib/models/data_api_model.dart

class DataAPIModel {
  List<ItemData>? items;

  DataAPIModel({this.items});

  DataAPIModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ItemData>[];
      json['items'].forEach((v) {
        items!.add(ItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemData {
  OpenState? openState;
  ClosedState? closedState; // Corrected to ClosedState
  String? ctaText;

  ItemData({this.openState, this.closedState, this.ctaText});

  ItemData.fromJson(Map<String, dynamic> json) {
    openState = json['open_state'] != null
        ? OpenState.fromJson(json['open_state'])
        : null;
    closedState = json['closed_state'] != null
        ? ClosedState.fromJson(json['closed_state'])
        : null;
    ctaText = json['cta_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (openState != null) {
      data['open_state'] = openState!.toJson();
    }
    if (closedState != null) {
      data['closed_state'] = closedState!.toJson();
    }
    data['cta_text'] = ctaText;
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
    final Map<String, dynamic> data = {};
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class OpenStateBody {
  String? title;
  String? subtitle;
  CardData? card;
  String? footer;

  // Instead of List<ItemData>, store them as a list of raw maps.
  // This matches the EMI or account "items" that do NOT have open_state/closed_state.
  List<Map<String, dynamic>>? items;

  OpenStateBody({
    this.title,
    this.subtitle,
    this.card,
    this.footer,
    this.items,
  });

  OpenStateBody.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    card = json['card'] != null ? CardData.fromJson(json['card']) : null;
    footer = json['footer'];

    // items are plain maps (like EMI or bank details)
    if (json['items'] != null) {
      items = <Map<String, dynamic>>[];
      (json['items'] as List).forEach((v) {
        // v is a Map like { "emi": "...", "duration": "...", etc. }
        items!.add(v as Map<String, dynamic>);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['subtitle'] = subtitle;
    if (card != null) {
      data['card'] = card!.toJson();
    }
    data['footer'] = footer;
    if (items != null) {
      data['items'] = items!;
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
    final Map<String, dynamic> data = {};
    data['header'] = header;
    data['description'] = description;
    data['max_range'] = maxRange;
    data['min_range'] = minRange;
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
    final Map<String, dynamic> data = {};
    if (body != null) {
      data['body'] = body!.toJson();
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
    final Map<String, dynamic> data = {};
    data['key1'] = key1;
    data['key2'] = key2;
    return data;
  }
}
