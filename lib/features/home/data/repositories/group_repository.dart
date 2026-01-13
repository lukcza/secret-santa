import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/models/group_models.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

abstract class GroupRepository {
  Future<Either<Failure, void>> createGroup(GroupModel groupName);
  Future<Either<Failure, void>> joinGroup(String groupCode);
  Future<Either<Failure, List<GroupEntity>>> getUserGroups();
  Future<Either<Failure, void>> leaveGroup(String groupCode);
  Future<Either<Failure, String>> getUserGroupCode(String userId);
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId);
  Future<Either<Failure, void>> updateGroup(GroupModel group);
  Future<Either<Failure, void>> generateGroupCode(String groupId);
}