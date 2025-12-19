import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String uid;
  final String email;
  final String? nickname;
  final String? photoUrl;
  final List<String>? groups;
  final List<String>? wishlist;

  const UserModel({
    required this.uid,
    required this.email,
    this.nickname,
    this.photoUrl,
    this.groups,
    this.wishlist,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      nickname: entity.nickname,
      photoUrl: entity.photoUrl,
      groups: entity.groups,
      wishlist: entity.wishlist,
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
    };
  }
}