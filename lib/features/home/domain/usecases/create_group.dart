import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/repositories/group_repository.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

class CreateGroup {
  final GroupRepository repository;
  CreateGroup(this.repository);
  Future<Either<Failure, void>> call(GroupEntity group) {
    return repository.createGroup(group);
  }
}