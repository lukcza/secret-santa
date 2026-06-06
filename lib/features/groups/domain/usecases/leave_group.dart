import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';

class LeaveGroup {
  final GroupRepository repository;
  LeaveGroup(this.repository);
  Future<Either<Failure, void>> call(String groupCode) {
    return repository.leaveGroup(groupCode);
  }
}
