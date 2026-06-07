import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';

class GetUserByEmail {
  final AuthRepository repository;

  GetUserByEmail(this.repository);

  Future<Either<Failure, UserEntity>> call({required String email}) {
    return repository.getUserByEmail(email: email);
  }
}
