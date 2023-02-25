import 'dart:convert';

import 'content.dart';

class Item {
  String? id;
  dynamic blockchainId;
  String? title;
  String? description;
  int? quantity;
  int? quantityMinted;
  List<dynamic>? nfts;
  String? status;
  String? rarity;
  Content? content;

  Item({
    this.id,
    this.blockchainId,
    this.title,
    this.description,
    this.quantity,
    this.quantityMinted,
    this.nfts,
    this.status,
    this.rarity,
    this.content,
  });

  @override
  String toString() {
    return 'Item(id: $id, blockchainId: $blockchainId, title: $title, description: $description, quantity: $quantity, quantityMinted: $quantityMinted, nfts: $nfts, status: $status, rarity: $rarity, content: $content)';
  }

  factory Item.fromMap(Map<String, dynamic> data) => Item(
        id: data['id'] as String?,
        blockchainId: data['blockchainId'] as dynamic,
        title: data['title'] as String?,
        description: data['description'] as String?,
        quantity: data['quantity'] as int?,
        quantityMinted: data['quantityMinted'] as int?,
        nfts: data['nfts'] as List<dynamic>?,
        status: data['status'] as String?,
        rarity: data['rarity'] as String?,
        content: data['content'] == null
            ? null
            : Content.fromMap(data['content'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'blockchainId': blockchainId,
        'title': title,
        'description': description,
        'quantity': quantity,
        'quantityMinted': quantityMinted,
        'nfts': nfts,
        'status': status,
        'rarity': rarity,
        'content': content?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Item].
  factory Item.fromJson(String data) {
    return Item.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Item] to a JSON string.
  String toJson() => json.encode(toMap());

  Item copyWith({
    String? id,
    dynamic blockchainId,
    String? title,
    String? description,
    int? quantity,
    int? quantityMinted,
    List<dynamic>? nfts,
    String? status,
    String? rarity,
    Content? content,
  }) {
    return Item(
      id: id ?? this.id,
      blockchainId: blockchainId ?? this.blockchainId,
      title: title ?? this.title,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      quantityMinted: quantityMinted ?? this.quantityMinted,
      nfts: nfts ?? this.nfts,
      status: status ?? this.status,
      rarity: rarity ?? this.rarity,
      content: content ?? this.content,
    );
  }
}
