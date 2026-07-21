import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';
import 'package:secret_santa/features/wishlist/domain/entities/wishlist_item_entity.dart';

class AddWishlistItem {
  final GroupRepository repository;
  AddWishlistItem(this.repository);

  Future<Either<Failure, void>> call({
    required String uid,
    required String groupId,
    required WishlistItemEntity item,
  }) {
    return repository.addWishlistItem(uid, groupId, item);
  }
}
