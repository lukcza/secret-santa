import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secret_santa/features/wishlist/domain/entities/wishlist_item_entity.dart';

class WishlistItemModel {
  final String id;
  final String title;
  final double? price;
  final String? link;
  final String? note;
  final String? imageUrl;
  final bool isHighPriority;

  const WishlistItemModel({
    required this.id,
    required this.title,
    this.price,
    this.link,
    this.note,
    this.imageUrl,
    this.isHighPriority = false,
  });

  factory WishlistItemModel.fromEntity(WishlistItemEntity entity) {
    return WishlistItemModel(
      id: entity.id,
      title: entity.title,
      price: entity.price,
      link: entity.link,
      note: entity.note,
      imageUrl: entity.imageUrl,
      isHighPriority: entity.isHighPriority,
    );
  }

  WishlistItemEntity toEntity() {
    return WishlistItemEntity(
      id: id,
      title: title,
      price: price,
      link: link,
      note: note,
      imageUrl: imageUrl,
      isHighPriority: isHighPriority,
    );
  }

  factory WishlistItemModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return WishlistItemModel(
      id: doc.id,
      title: data['title'] as String,
      price: (data['price'] as num?)?.toDouble(),
      link: data['link'] as String?,
      note: data['note'] as String?,
      imageUrl: data['imageUrl'] as String?,
      isHighPriority: data['isHighPriority'] as bool? ?? false,
    );
  }

  factory WishlistItemModel.fromMap(String id, Map<String, dynamic> data) {
    return WishlistItemModel(
      id: id,
      title: data['title'] as String,
      price: (data['price'] as num?)?.toDouble(),
      link: data['link'] as String?,
      note: data['note'] as String?,
      imageUrl: data['imageUrl'] as String?,
      isHighPriority: data['isHighPriority'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'link': link,
      'note': note,
      'imageUrl': imageUrl,
      'isHighPriority': isHighPriority,
    };
  }
}
