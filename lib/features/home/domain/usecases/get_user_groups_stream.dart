import 'package:secret_santa/features/home/data/repositories/group_repository.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

class GetUserGroupsStream {
  final GroupRepository repository;

  GetUserGroupsStream(this.repository);

  Stream<List<GroupEntity>> call() {
    return repository.getUserGroupsStream();
  }
}