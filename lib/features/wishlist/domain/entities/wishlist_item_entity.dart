import 'package:equatable/equatable.dart';

class WishlistItemEntity extends Equatable {
  final String id;
  final String title;
  final double? price;
  final String? link;
  final String? note;
  final String? imageUrl;
  final bool isHighPriority;

  const WishlistItemEntity({
    required this.id,
    required this.title,
    this.price,
    this.link,
    this.note,
    this.imageUrl,
    this.isHighPriority = false,
  });

  WishlistItemEntity copyWith({
    String? id,
    String? title,
    double? price,
    String? link,
    String? note,
    String? imageUrl,
    bool? isHighPriority,
  }) {
    return WishlistItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      link: link ?? this.link,
      note: note ?? this.note,
      imageUrl: imageUrl ?? this.imageUrl,
      isHighPriority: isHighPriority ?? this.isHighPriority,
    );
  }

  @override
  List<Object?> get props => [id, title, price, link, note, imageUrl, isHighPriority];
}
