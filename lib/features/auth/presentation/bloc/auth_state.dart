import 'package:equatable/equatable.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
enum AuthStatus { initial, authenticated, unauthenticated, loading, error, registered }
class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  AuthState(
      {this.status = AuthStatus.initial, this.user, this.errorMessage}
  );
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    bool clearUser = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
  @override
  List<Object?> get props => [status, user, errorMessage];
}