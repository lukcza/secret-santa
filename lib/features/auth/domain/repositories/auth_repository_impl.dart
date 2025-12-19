import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:secret_santa/features/auth/data/models/user_model.dart';
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
  Future<UserModel> _getUserModel(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if(!doc.exists){
      throw Exception('User document does not exist');
    }
    return UserModel.fromSnapshot(doc);
  }
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
      final currentUserModel = await _getUserModel(user!.uid);

      final UserEntity userEntity = UserEntity(
        uid: user!.uid,
        email: user.email!,
        nickname: currentUserModel.nickname,
        photoUrl: currentUserModel.photoUrl,
        groups: List<String>.from(currentUserModel.groups ?? []),
        wishlist: List<String>.from(currentUserModel.wishlist ?? []),
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
      final currentUserModel = await _getUserModel(user.uid);
      return Right(currentUserModel.toEntity());
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
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
        'nickname': nickname,
        'email': email,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'groups': [],
        'wishlist': [],
      });
      print('User document created for UID: ${user.uid}');
      return Right(userEntity);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
  
  @override
  // TODO: implement getCurrentUserStream
  Stream<UserEntity?> get getCurrentUserStream {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        return null;
      }
      try{
        final docSnapshot = await _firestore.collection('users').doc(user.uid).get();
        if(!docSnapshot.exists){
          return null;
        }
        return UserModel.fromSnapshot(docSnapshot).toEntity();
      } catch (e) {
        return null;
      }
    });
  }
}
