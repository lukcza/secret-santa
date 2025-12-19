import 'package:equatable/equatable.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
enum AuthStatus { initial, authenticated, unauthenticated, loading, error }
class AuthState extends Equatable {
  AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  AuthState(
      {this.status = AuthStatus.initial, this.user, this.errorMessage}
  );
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  @override
  List<Object?> get props => [];
}