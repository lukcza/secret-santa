import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/groups/data/models/group_model.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';

class UpdateGroup {
  final GroupRepository repository;
  UpdateGroup(this.repository);
  Future<Either<Failure, void>> call(GroupModel group) {
    return repository.updateGroup(group);
  }
}
