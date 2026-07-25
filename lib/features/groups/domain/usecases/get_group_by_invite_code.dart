import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

class GetGroupByInviteCode {
  final GroupRepository repository;

  GetGroupByInviteCode(this.repository);

  Future<Either<Failure, GroupEntity>> call(String groupCode) async {
    return repository.getGroupByInviteCode(groupCode);
  }
}
