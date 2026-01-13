import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/home/data/datasources/group_remote_data_source.dart';
import 'package:secret_santa/features/home/data/models/group_models.dart';
import 'package:secret_santa/features/home/data/repositories/group_repository.dart';
import 'package:secret_santa/features/home/domain/entities/group_entity.dart';

class GroupRepositoryImpl implements GroupRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  GroupRepositoryImpl({required FirebaseFirestore firestore, required FirebaseAuth firebaseAuth}) 
      : _firestore = firestore,
        _firebaseAuth = firebaseAuth;
  @override
  Future<Either<Failure, void>> createGroup(GroupModel group) async {
    try {
      await GroupRemoteDataSource(_firestore).createGroup(group);
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
      final groupModels = await GroupRemoteDataSource(_firestore).fetchUserGroups(userId);
    
      return Right(groupModels);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> joinGroup(String groupCode) async {
    try{
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) {
        return Left(ServerFailure('User not authenticated'));
      }
      await GroupRemoteDataSource(_firestore).joinGroup(groupCode, userId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> leaveGroup(String groupCode) async {
    try{
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) {
        return Left(ServerFailure('User not authenticated'));
      }
      await GroupRemoteDataSource(_firestore).leaveGroup(groupCode, userId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, String>> getUserGroupCode(String userId) async {
    try {
      final groups = await GroupRemoteDataSource(_firestore).fetchUserGroups(userId);
      if (groups.isEmpty) {
        return Left(ServerFailure('No groups found for user'));
      }
      final groupCode = groups.first.inviteCode;
      return Right(groupCode);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String groupId) async {
    try {
      final group = await GroupRemoteDataSource(_firestore).getGroupById(groupId);
      return Right(group);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGroup(GroupModel group) async {
    try {
      await GroupRemoteDataSource(_firestore).updateGroup(group);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> generateGroupCode(String groupId) async {
    try {
      await GroupRemoteDataSource(_firestore).generateGroupCode(groupId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}