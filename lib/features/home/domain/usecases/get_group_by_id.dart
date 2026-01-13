import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/repositories/group_repository.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

class GetGroupById {
  final GroupRepository repository;
  GetGroupById(this.repository);
  Future<Either<Failure, GroupEntity>> call(String groupId) {
    return repository.getGroupById(groupId);
  }
}