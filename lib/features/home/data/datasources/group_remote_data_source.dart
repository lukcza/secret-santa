import 'package:secret_santa/features/home/data/models/group_model.dart';

abstract class GroupRemoteDataSource {
  Future<void> createGroup(GroupModel group);
  Future<List<GroupModel>> getUserGroups(String userId);
  Future<void> joinGroup(String groupCode, String userId);
  Future<void> leaveGroup(String groupCode, String userId);
  Future<GroupModel> getGroupById(String groupId);
  Future<void> updateGroup(GroupModel group);
  Future<void> generateGroupCode(String groupId);
  Stream<List<GroupModel>> getUserGroupsStream(String userId);
}