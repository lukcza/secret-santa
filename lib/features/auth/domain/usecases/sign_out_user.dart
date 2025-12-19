import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository_impl.dart';

class SignOutUser {
  final AuthRepository _repository;
  SignOutUser(this._repository);
  Future<Either<Failure,void>> call() async {
    return await _repository.signOut();
  }
}