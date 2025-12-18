import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'Wystąpił nieznany błąd']);

  @override
  List<Object?> get props => [message];
}
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Wystąpił błąd serwera']) : super(message);
}
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Wystąpił błąd pamięci podręcznej']) : super(message);
}
class AuthFailure extends Failure {
  const AuthFailure([String message = 'Wystąpił błąd uwierzytelniania']) : super(message);
}