import 'dart:convert';

import 'set.dart';

class NftSet {
  List<Set>? sets;

  NftSet({this.sets});

  @override
  String toString() => 'NftSet(sets: $sets)';

  factory NftSet.fromMap(Map<String, dynamic> data) => NftSet(
        sets: (data['sets'] as List<dynamic>?)
            ?.map((e) => Set.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'sets': sets?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NftSet].
  factory NftSet.fromJson(String data) {
    return NftSet.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [NftSet] to a JSON string.
  String toJson() => json.encode(toMap());

  NftSet copyWith({
    List<Set>? sets,
  }) {
    return NftSet(
      sets: sets ?? this.sets,
    );
  }
}
