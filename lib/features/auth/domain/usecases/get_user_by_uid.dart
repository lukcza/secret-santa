import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';

class GetUserByUid {
  final AuthRepository repository;

  GetUserByUid(this.repository);

  Future<Either<Failure, UserEntity>> call({required String uid}) {
    return repository.getUserByUid(uid: uid);
  }
}
