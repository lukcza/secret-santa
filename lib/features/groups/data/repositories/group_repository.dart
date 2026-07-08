import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/domain/usecases/get_user_by_uid.dart';
import 'package:secret_santa/features/groups/data/models/group_model.dart';

import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

abstract class GroupRepository {
  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group);
  Future<Either<Failure, void>> joinGroup(String groupCode);
  Future<Either<Failure, List<GroupEntity>>> getUserGroups();
  Future<Either<Failure, void>> leaveGroup(String groupCode);
  Future<Either<Failure, String>> getGroupCode(String groupId);
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId);
  Future<Either<Failure, void>> updateGroup({required GroupEntity group});
  Future<Either<Failure, void>> generateGroupCode(String groupId);
  Stream<List<GroupEntity>> getUserGroupsStream();
  Future<Either<Failure, List<UserEntity>>> getGroupParticipants(
    String groupId,
    GetUserByUid getUserByUid,
  );
  Future<Either<Failure, GroupEntity>> drawPairs(String groupId);
}
