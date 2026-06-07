import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/core/utils/validators.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/domain/usecases/get_user_by_uid.dart';
import 'package:secret_santa/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:secret_santa/features/groups/data/models/group_model.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource _remoteDataSource;
  final FirebaseAuth _firebaseAuth;

  GroupRepositoryImpl({
    required GroupRemoteDataSource remoteDataSource,
    required FirebaseAuth firebaseAuth,
  }) : _remoteDataSource = remoteDataSource,
       _firebaseAuth = firebaseAuth;

  @override
  Future<Either<Failure, void>> createGroup(GroupEntity group) async {
    try {
      final groupModel = GroupModel(
        id: group.id,
        title: group.title,
        description: group.description,
        authorUID: group.authorUID,
        participants: group.participants,
        participantsUIDs: group.participantsUIDs,
        budgetLimit: group.budgetLimit,
        currency: group.currency,
        eventDate: group.eventDate,
        createdAt: group.createdAt,
        inviteCode: group.inviteCode,
        state: group.state,
      );

      await _remoteDataSource.createGroup(groupModel);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getUserGroups() async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) {
        return Left(ServerFailure('User not authenticated'));
      }

      final groupModels = await _remoteDataSource.getUserGroups(userId);

      return Right(groupModels);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinGroup(String groupCode) async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) {
        return Left(ServerFailure('User not authenticated'));
      }
      await _remoteDataSource.joinGroup(groupCode, userId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveGroup(String groupCode) async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) {
        return Left(ServerFailure('User not authenticated'));
      }
      await _remoteDataSource.leaveGroup(groupCode, userId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId) async {
    try {
      final group = await _remoteDataSource.getGroupById(groupId);
      return Right(group);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getGroupCode(String groupId) async {
    try {
      final group = await _remoteDataSource.getGroupById(groupId);
      return Right(group.inviteCode);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> generateGroupCode(String groupId) async {
    try {
      if (groupId.isEmpty) {
        return Left(ServerFailure("Invalid group ID"));
      }
      await _remoteDataSource.generateGroupCode(groupId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGroup(GroupEntity group) async {
    try {
      if (group.id.isEmpty) {
        return Left(ServerFailure("Invalid group ID"));
      }
      await _remoteDataSource.updateGroup(
        GroupModel(
          id: group.id,
          title: group.title,
          description: group.description,
          authorUID: group.authorUID,
          participants: group.participants,
          participantsUIDs: group.participantsUIDs,
          budgetLimit: group.budgetLimit,
          currency: group.currency,
          eventDate: group.eventDate,
          createdAt: group.createdAt,
          inviteCode: group.inviteCode,
          state: group.state,
        ),
      );
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<GroupEntity>> getUserGroupsStream() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) {
      return Stream.error('User not authenticated');
    }
    return _remoteDataSource.getUserGroupsStream(userId);
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getGroupParticipants(
    String groupId,
    GetUserByUid getUserByUid,
  ) async {
    try {
      final group = await _remoteDataSource.getGroupById(groupId);
      final participants = group.participantsUIDs;
      final users = <UserEntity>[];
      for (final userId in participants) {
        final user = await getUserByUid(uid: userId);
        if (Validators.validateEmail(userId) != "Email is valid") {
          user.fold(
            (failure) {
              return Left(ServerFailure(failure.message));
            },
            (user) {
              users.add(user);
            },
          );
        }
      }
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
