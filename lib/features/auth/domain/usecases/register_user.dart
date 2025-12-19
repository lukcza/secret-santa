import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
class RegisterUser {
  final AuthRepository repository;
  RegisterUser(this.repository);
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String nickname,
  }) async{
    return await repository.signUp(
      email: email,
      password: password, 
      nickname: nickname,
    );
  }
}