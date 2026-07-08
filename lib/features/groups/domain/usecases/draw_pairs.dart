import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

class DrawPairs {
  final GroupRepository repository;
  DrawPairs(this.repository);
  Future<Either<Failure, GroupEntity>> call(String groupId) {
    return repository.drawPairs(groupId);
  }
}
