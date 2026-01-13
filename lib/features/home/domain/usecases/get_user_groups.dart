import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/repositories/group_repository.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

class GetUserGroups {
  final GroupRepository repository;

  GetUserGroups(this.repository);

  Future<Either<Failure, List<GroupEntity>>> call() {
    return repository.getUserGroups();
  }
}