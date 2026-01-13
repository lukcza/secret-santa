import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/repositories/group_repository.dart';

class GenerateGroupCode {
  final GroupRepository repository;
  GenerateGroupCode(this.repository);
  Future<Either<Failure, void>> call(String groupId) {
    return repository.generateGroupCode(groupId);
  }
}