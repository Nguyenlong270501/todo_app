import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthReponsitory {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //đăng nhập email và password
  Future<Either<String, UserModel>> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return const Left('Failed to sign in');
      }

      return Right(await _getUserData(user.uid));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return const Left('No user found with this email');
        case 'wrong-password':
          return const Left('Wrong password provided');
        case 'invalid-email':
          return const Left('Invalid email address');
        case 'user-disabled':
          return const Left('This account has been disabled');
        case 'too-many-requests':
          return const Left('Too many attempts. Please try again later');
        default:
          return Left('Authentication failed: ${e.message}');
      }
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }

  // get user data
  Future<UserModel> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  //đăng ký
  Future<Either<String, UserModel>> register(
    String email,
    String password,
    String userName,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return const Left('Failed to create account');
      }

      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'username': userName,
        'id': user.uid,
        'imageUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Right(await _getUserData(user.uid));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return const Left('Email is already registered');
        case 'invalid-email':
          return const Left('Invalid email address');
        case 'operation-not-allowed':
          return const Left('Email/password accounts are not enabled');
        case 'weak-password':
          return const Left('Password is too weak');
        default:
          return Left('Registration failed: ${e.message}');
      }
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }

  // save user data
  Future<void> saveUserData(UserModel user) async {
    try {
      final userData = user.toMap();
      await _firestore.collection('users').doc(user.id).set(userData);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  //đăng xuất
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
