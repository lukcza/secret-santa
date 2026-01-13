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
  Future<GroupModel> getGroupById(String groupId) async {
    final doc = await _firestore.collection('groups').doc(groupId).get();

    if (doc.exists) {
      return GroupModel.fromSnapshot(doc);
    } else {
      // Rzucamy wyjątek, a nie zwracamy Left
      throw Exception('Group not found');
    }
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
    
    // arrayUnion dodaje element tylko jeśli go tam nie ma (bezpieczne)
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
}