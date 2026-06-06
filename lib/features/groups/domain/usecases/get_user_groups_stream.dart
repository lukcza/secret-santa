import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

class GetUserGroupsStream {
  final GroupRepository repository;

  GetUserGroupsStream(this.repository);

  Stream<List<GroupEntity>> call() {
    return repository.getUserGroupsStream();
  }
}
