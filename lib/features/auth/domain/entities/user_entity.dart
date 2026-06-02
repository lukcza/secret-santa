import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String uid;
  final String email;
  final String? nickname;
  final String? photoUrl;
  final List<String>? groups;
  final List<String>? wishlist;
  final int? avatarBgColorValue;
  final int? avatarForegroundColorValue;
  final int? avatarIconCodePoint;

  const UserEntity({
    required this.uid,
    required this.email,
    this.nickname,
    this.photoUrl,
    this.groups,
    this.wishlist,
    this.avatarBgColorValue,
    this.avatarForegroundColorValue,
    this.avatarIconCodePoint,
  });

  String get displayName => nickname ?? email.split('@').first;

  String get initials {
    final name = displayName.trim();
    if (name.isEmpty) return 'ME';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length > 1) {
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      return (first + second).toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : name.length).toUpperCase();
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        nickname,
        photoUrl,
        groups,
        wishlist,
        avatarBgColorValue,
        avatarForegroundColorValue,
        avatarIconCodePoint,
      ];
}