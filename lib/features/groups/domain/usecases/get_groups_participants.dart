import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/core/utils/validators.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/domain/usecases/get_user_by_uid.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';

class GetGroupsParticipants {
  final GroupRepository groupRepository;
  final GetUserByUid getUserByUid;

  GetGroupsParticipants(this.groupRepository, this.getUserByUid);

  Future<Either<Failure, List<UserEntity>>> call(String groupId) async {
    final groupResult = await groupRepository.getGroupById(groupId);

    return groupResult.fold((failure) => Left(failure), (group) async {
      try {
        final participantsUIDs = group.participantsUIDs;
        final futures = participantsUIDs.map((userId) async {
          if (!Validators.emailRegex.hasMatch(userId)) {
            final userResult = await getUserByUid(uid: userId);
            return userResult.fold((f) => null, (user) => user);
          }
          return null;
        });

        final usersNullable = await Future.wait(futures);
        final users = usersNullable.whereType<UserEntity>().toList();

        return Right(users);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    });
  }
}
