import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';

class RemoveWishlistItem {
  final GroupRepository repository;
  RemoveWishlistItem(this.repository);

  Future<Either<Failure, void>> call({
    required String uid,
    required String groupId,
    required String itemId,
  }) {
    return repository.removeWishlistItem(uid, groupId, itemId);
  }
}
