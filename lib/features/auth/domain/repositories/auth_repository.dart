import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({required String email, required String password});
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, UserEntity>> signUp({required String nickname,required String email, required String password});
  Stream<UserEntity?> get getCurrentUserStream;
}