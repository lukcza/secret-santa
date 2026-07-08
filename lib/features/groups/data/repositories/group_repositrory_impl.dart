import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/core/utils/validators.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/domain/usecases/get_user_by_uid.dart';
import 'package:secret_santa/features/groups/data/datasources/group_remote_data_source.dart';
import 'package:secret_santa/features/groups/data/models/group_model.dart';
import 'package:secret_santa/features/groups/data/repositories/group_repository.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'dart:math';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource _remoteDataSource;
  final FirebaseAuth _firebaseAuth;

  GroupRepositoryImpl({
    required GroupRemoteDataSource remoteDataSource,
    required FirebaseAuth firebaseAuth,
  }) : _remoteDataSource = remoteDataSource,
       _firebaseAuth = firebaseAuth;

  @override
  Future<Either<Failure, GroupEntity>> createGroup(GroupEntity group) async {
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

      final createdGroup = await _remoteDataSource.createGroup(groupModel);
      return Right(createdGroup);
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
  Future<Either<Failure, void>> updateGroup({
    required GroupEntity group,
  }) async {
    try {
      if (group.id.isEmpty) {
        return Left(ServerFailure("Invalid group ID"));
      }
      await _remoteDataSource.updateGroup(GroupModel.fromEntity(group));
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

  @override
  Future<Either<Failure, GroupEntity>> drawPairs(String groupId) async {
    try {
      final group = await _remoteDataSource.getGroupById(groupId);
      if (group.state != GroupStatus.active) {
        return Left(ServerFailure("Group is not active"));
      }
      if (group.participants.length < 3) {
        return Left(ServerFailure("Group has less than 3 participants"));
      }
      final participants = group.participants.keys.toList();
      final excluded = group.excludedPairs;

      final matches = <String, String>{};
      for (final participant in participants) {
        int random = Random().nextInt(participants.length);
        while (participant == participants[random] ||
            (excluded[participant]?.contains(participants[random]) ?? false)) {
          random = Random().nextInt(participants.length);
        }
        matches[participant] = participants[random];
      }

      await _remoteDataSource.updateGroup(group.copyWith(matches: matches));
      return Right(group.copyWith(matches: matches));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
