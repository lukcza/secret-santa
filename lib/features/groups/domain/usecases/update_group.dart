import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

class UpdateGroup {
  final GroupRepository repository;
  UpdateGroup(this.repository);
  Future<Either<Failure, void>> call(GroupEntity group) {
    return repository.updateGroup(group: group);
  }
}
