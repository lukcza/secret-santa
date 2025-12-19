import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async{
    return await repository.signIn(
      email: email,
      password: password, 
    );
  }
}