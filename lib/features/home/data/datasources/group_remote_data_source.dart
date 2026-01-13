import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secret_santa/features/home/data/datasources/group_remote_data_source.dart';
import 'package:secret_santa/features/home/data/models/group_models.dart';

class GroupRemoteDataSource{
  final FirebaseFirestore _firestore;

  GroupRemoteDataSource(this._firestore);

  @override
  Future<void> createGroup(GroupModel group) async {
    // .add() automatycznie generuje ID dokumentu
    await _firestore.collection('groups').add(group.toDocument());
  }

  @override
  Future<List<GroupModel>> fetchUserGroups(String userId) async {
    final querySnapshot = await _firestore
        .collection('groups')
        .where('participantsUIDs', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => GroupModel.fromSnapshot(doc))
        .toList();
  }

  @override
  Future<void> joinGroup(String groupCode, String userId) async {
    final query = await _firestore
        .collection('groups')
        .where('inviteCode', isEqualTo: groupCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('Group with provided code not found');
    }

    final groupDoc = query.docs.first;
    
    await groupDoc.reference.update({
      'participantsUIDs': FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future<void> leaveGroup(String groupCode, String userId) async {
    final query = await _firestore
        .collection('groups')
        .where('inviteCode', isEqualTo: groupCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('Group not found');
    }

    final groupDoc = query.docs.first;

    await groupDoc.reference.update({
      'participantsUIDs': FieldValue.arrayRemove([userId])
    });
  }
  Future<void> updateGroup(GroupModel group) async {
    final groupRef = _firestore.collection('groups').doc(group.id);
    await groupRef.update(group.toDocument());
  }
  Future<void> generateGroupCode(String groupId) async {
    final groupRef = _firestore.collection('groups').doc(groupId);
    final newCode = GroupModel.generateGroupCode(); // Generate a 6-character code
    await groupRef.update({'inviteCode': newCode});
  }
}