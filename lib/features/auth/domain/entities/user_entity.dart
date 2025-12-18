import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String uid;
  final String email;
  final String? nickname;
  final String? photoUrl;
  final List<String>? groups;
  final List<String>? wishlist;

  const UserEntity({
    required this.uid,
    required this.email,
    this.nickname,
    this.photoUrl,
    this.groups,
    this.wishlist,
  });
  @override
  List<Object?> get props => [uid, email, nickname, photoUrl, groups, wishlist];
}