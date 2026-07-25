import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
  @override
  List<Object?> get props => [];
}
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
class AuthSignUpRequested extends AuthEvent {
  final String nickname;
  final String email;
  final String password;
  final Uint8List? avatarImageBytes;
  final int? avatarBgColorValue;

  const AuthSignUpRequested({
    required this.nickname,
    required this.email,
    required this.password,
    this.avatarImageBytes,
    this.avatarBgColorValue,
  });

  @override
  List<Object?> get props => [nickname, email, password, avatarImageBytes, avatarBgColorValue];
}
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
  @override
  List<Object?> get props => [];
}
class AuthCheckSession extends AuthEvent {
  const AuthCheckSession();
  @override
  List<Object?> get props => [];
}
class AuthGetCurrentUserRequested extends AuthEvent {
  const AuthGetCurrentUserRequested();
  @override
  List<Object?> get props => [];
}