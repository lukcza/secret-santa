import 'package:secret_santa/features/groups/data/models/group_model.dart';
import 'package:secret_santa/features/wishlist/data/models/wishlist_item_model.dart';

abstract class GroupRemoteDataSource {
  Future<GroupModel> createGroup(GroupModel group);
  Future<List<GroupModel>> getUserGroups(String userId);
  Future<void> joinGroup(String groupCode, String userId);
  Future<void> leaveGroup(String groupCode, String userId);
  Future<GroupModel> getGroupById(String groupId);
  Future<void> updateGroup(GroupModel group);
  Future<void> generateGroupCode(String groupId);
  Stream<List<GroupModel>> getUserGroupsStream(String userId);

  // Wishlist per group (subcollection: users/{uid}/wishlists/{groupId}/items/{itemId})
  Future<List<WishlistItemModel>> getGroupWishlist(String uid, String groupId);
  Future<void> addWishlistItem(String uid, String groupId, WishlistItemModel item);
  Future<void> removeWishlistItem(String uid, String groupId, String itemId);
  Future<void> updateWishlistItemImage(String uid, String groupId, String itemId, String imageUrl);
}