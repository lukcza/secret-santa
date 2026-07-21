import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';
import 'package:secret_santa/features/wishlist/domain/entities/wishlist_item_entity.dart';

class GetGroupWishlist {
  final GroupRepository repository;
  GetGroupWishlist(this.repository);

  Future<Either<Failure, List<WishlistItemEntity>>> call({
    required String uid,
    required String groupId,
  }) {
    return repository.getGroupWishlist(uid, groupId);
  }
}
