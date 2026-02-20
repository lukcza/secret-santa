import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/repositories/group_repository.dart';

class JoinGroup {
  final GroupRepository repository;
  JoinGroup(this.repository);
  Future<Either<Failure, void>> call(String groupCode) {
    return repository.joinGroup(groupCode);
  }
}