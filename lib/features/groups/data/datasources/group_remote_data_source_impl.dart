import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secret_santa/features/groups/data/models/group_model.dart';
import 'package:secret_santa/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:secret_santa/features/wishlist/data/models/wishlist_item_model.dart';

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final FirebaseFirestore _firestore;

  GroupRemoteDataSourceImpl(this._firestore);

  @override
  Future<GroupModel> createGroup(GroupModel group) async {
    final docRef = await _firestore
        .collection('groups')
        .add(group.toDocument());
    final groupWithId = group.copyWith(id: docRef.id);
    await docRef.update(groupWithId.toDocument());
    return groupWithId;
  }

  @override
  Future<List<GroupModel>> getUserGroups(String userId) async {
    final querySnapshot =
        await _firestore
            .collection('groups')
            .where('participantsUIDs', arrayContains: userId)
            .get();

    final list = querySnapshot.docs
        .map((doc) => GroupModel.fromSnapshot(doc))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> joinGroup(String groupCode, String userId) async {
    final query =
        await _firestore
            .collection('groups')
            .where('inviteCode', isEqualTo: groupCode)
            .limit(1)
            .get();

    if (query.docs.isEmpty) {
      throw Exception('Group with provided code not found');
    }

    final groupDoc = query.docs.first;

    await groupDoc.reference.update({
      'participantsUIDs': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Future<void> leaveGroup(String groupCode, String userId) async {
    final query =
        await _firestore
            .collection('groups')
            .where('inviteCode', isEqualTo: groupCode)
            .limit(1)
            .get();

    if (query.docs.isEmpty) {
      throw Exception('Group not found');
    }

    final groupDoc = query.docs.first;

    await groupDoc.reference.update({
      'participantsUIDs': FieldValue.arrayRemove([userId]),
    });
  }

  @override
  Future<void> updateGroup(GroupModel group) async {
    final groupRef = _firestore.collection('groups').doc(group.id);
    await groupRef.update(group.toDocument());
  }

  @override
  Future<void> generateGroupCode(String groupId) async {
    final groupRef = _firestore.collection('groups').doc(groupId);
    final newCode =
        GroupModel.generateGroupCode(); // Generate a 6-character code
    await groupRef.update({'inviteCode': newCode});
  }

  @override
  Future<GroupModel> getGroupById(String groupId) async {
    final groupRef = _firestore.collection('groups').doc(groupId);
    final groupDoc = await groupRef.get();
    if (!groupDoc.exists) {
      throw Exception('Group not found');
    }
    return GroupModel.fromSnapshot(groupDoc);
  }

  Stream<List<GroupModel>> getUserGroupsStream(String userId) {
    return _firestore
        .collection('groups')
        .where('participantsUIDs', arrayContains: userId)
        .snapshots()
        .map(
          (snapshot) {
            final list = snapshot.docs
                .map((doc) => GroupModel.fromSnapshot(doc))
                .toList();
            list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return list;
          },
        );
  }

  CollectionReference<Map<String, dynamic>> _wishlistCol(
    String uid,
    String groupId,
  ) =>
      _firestore
          .collection('users')
          .doc(uid)
          .collection('wishlists')
          .doc(groupId)
          .collection('items');

  @override
  Future<List<WishlistItemModel>> getGroupWishlist(
    String uid,
    String groupId,
  ) async {
    final snap = await _wishlistCol(uid, groupId).get();
    return snap.docs
        .map((doc) => WishlistItemModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> addWishlistItem(
    String uid,
    String groupId,
    WishlistItemModel item,
  ) async {
    if (item.id.isEmpty) {
      await _wishlistCol(uid, groupId).add(item.toMap());
    } else {
      await _wishlistCol(uid, groupId).doc(item.id).set(item.toMap());
    }
  }

  @override
  Future<void> removeWishlistItem(
    String uid,
    String groupId,
    String itemId,
  ) async {
    await _wishlistCol(uid, groupId).doc(itemId).delete();
  }

  @override
  Future<void> updateWishlistItemImage(
    String uid,
    String groupId,
    String itemId,
    String imageUrl,
  ) async {
    await _wishlistCol(uid, groupId).doc(itemId).update({'imageUrl': imageUrl});
  }
}
