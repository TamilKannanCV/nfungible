import 'dart:convert';

import 'item.dart';

class NftModel {
  List<Item>? items;
  dynamic cursor;

  NftModel({this.items, this.cursor});

  @override
  String toString() => 'NftModel(items: $items, cursor: $cursor)';

  factory NftModel.fromMap(Map<String, dynamic> data) => NftModel(
        items: (data['items'] as List<dynamic>?)
            ?.map((e) => Item.fromMap(e as Map<String, dynamic>))
            .toList(),
        cursor: data['cursor'] as dynamic,
      );

  Map<String, dynamic> toMap() => {
        'items': items?.map((e) => e.toMap()).toList(),
        'cursor': cursor,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NftModel].
  factory NftModel.fromJson(String data) {
    return NftModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [NftModel] to a JSON string.
  String toJson() => json.encode(toMap());

  NftModel copyWith({
    List<Item>? items,
    dynamic cursor,
  }) {
    return NftModel(
      items: items ?? this.items,
      cursor: cursor ?? this.cursor,
    );
  }
}
