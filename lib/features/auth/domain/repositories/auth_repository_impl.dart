import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      final UserEntity userEntity = UserEntity(
        uid: user!.uid,
        email: user.email!,
        nickname: user.displayName,
        photoUrl: user.photoURL,
        groups: [],
        wishlist: [],
      );
      return Right(userEntity);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return Left(AuthFailure('No user is currently signed in.'));
      }
      final UserEntity userEntity = UserEntity(
        uid: user.uid,
        email: user.email!,
        nickname: user.displayName,
        photoUrl: user.photoURL,
        groups: [],
        wishlist: [],
      );
      return Right(userEntity);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String nickname,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      final UserEntity userEntity = UserEntity(
        uid: user!.uid,
        email: user.email!,
        nickname: nickname,
        photoUrl: user.photoURL,
        groups: [],
        wishlist: [],
      );
      return Right(userEntity);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
  
  @override
  // TODO: implement getCurrentUserStream
  Stream<UserEntity?> get getCurrentUserStream => throw UnimplementedError();   
}
