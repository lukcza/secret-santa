import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String uid;
  final String email;
  final String? nickname;
  final String? photoUrl;
  final List<String>? groups;
  final List<String>? wishlist;
  final int? avatarBgColorValue;
  final int? avatarForegroundColorValue;
  final int? avatarIconCodePoint;

  const UserModel({
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

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      nickname: entity.nickname,
      photoUrl: entity.photoUrl,
      groups: entity.groups,
      wishlist: entity.wishlist,
      avatarBgColorValue: entity.avatarBgColorValue,
      avatarForegroundColorValue: entity.avatarForegroundColorValue,
      avatarIconCodePoint: entity.avatarIconCodePoint,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      nickname: nickname,
      photoUrl: photoUrl,
      groups: groups,
      wishlist: wishlist,
      avatarBgColorValue: avatarBgColorValue,
      avatarForegroundColorValue: avatarForegroundColorValue,
      avatarIconCodePoint: avatarIconCodePoint,
    );
  }
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      nickname: data['nickname'],
      photoUrl: data['photoUrl'],
      groups: List<String>.from(data['groups'] ?? []),
      wishlist: List<String>.from(data['wishlist'] ?? []),
      avatarBgColorValue: data['avatarBgColorValue'],
      avatarForegroundColorValue: data['avatarForegroundColorValue'],
      avatarIconCodePoint: data['avatarIconCodePoint'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'photoUrl': photoUrl,
      'groups': groups,
      'wishlist': wishlist,
      'avatarBgColorValue': avatarBgColorValue,
      'avatarForegroundColorValue': avatarForegroundColorValue,
      'avatarIconCodePoint': avatarIconCodePoint,
    };
  }
}