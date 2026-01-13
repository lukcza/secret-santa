import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

abstract class GroupRepository {
  Future<Either<Failure, void>> createGroup(String groupName);
  Future<Either<Failure, void>> joinGroup(String groupCode);
  Future<Either<Failure, List<GroupEntity>>> getUserGroups(String userId);
  //Future<Either<Failure, List<String>>> getGroupMembers(String groupCode);
  Future<Either<Failure, void>> leaveGroup(String groupCode);
  //Future<Either<Failure, String>> getUserGroupCode(String userId);
}