import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/models/group_model.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

abstract class GroupRepository {
  Future<Either<Failure, void>> createGroup(GroupEntity groupName);
  Future<Either<Failure, void>> joinGroup(String groupCode);
  Future<Either<Failure, List<GroupEntity>>> getUserGroups();
  Future<Either<Failure, void>> leaveGroup(String groupCode);
  Future<Either<Failure, String>> getGroupCode(String groupId);
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId);
  Future<Either<Failure, void>> updateGroup(GroupModel group);
  Future<Either<Failure, void>> generateGroupCode(String groupId);
  Stream<List<GroupEntity>> getUserGroupsStream();
}