import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/repositories/group_repository.dart';

class GetGroupCode {
  final GroupRepository repository;
  GetGroupCode(this.repository);
  Future<Either<Failure, String>> call(String groupId) {
    return repository.getGroupCode(groupId);
  }
}