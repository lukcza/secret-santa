import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/datasources/group_remote_data_source_impl.dart';
import 'package:secret_santa/features/home/data/models/group_model.dart';
import 'package:secret_santa/features/home/data/repositories/group_repository.dart';
import 'package:secret_santa/features/home/data/repositories/group_repositrory_impl.dart'
    as _remoteDataSource;
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSourceImpl _remoteDataSource;
  final FirebaseAuth _firebaseAuth;

  GroupRepositoryImpl({
    required GroupRemoteDataSourceImpl remoteDataSource,
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
      if(group.id.isEmpty) {
        return Left(ServerFailure("Invalid group ID"));
      }
      await _remoteDataSource.updateGroup(GroupModel(
        id: group.id,
        title: group.title,
        description: group.description,
        authorUID: group.authorUID,
        participantsUIDs: group.participantsUIDs,
        budgetLimit: group.budgetLimit,
        currency: group.currency,
        eventDate: group.eventDate,
        createdAt: group.createdAt,
        inviteCode: group.inviteCode,
        state: group.state,
      ));
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
