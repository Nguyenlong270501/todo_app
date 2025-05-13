import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../auth/data/models/user.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Either<String, UserModel>> getProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Left('User not found');
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        return const Left('User data not found');
      }

      return Right(UserModel.fromMap(doc.data()!));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, UserModel>> updateProfile(UserModel user) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return const Left('User not found');
      }

      await _firestore.collection('users').doc(currentUser.uid).update({
        'avatarIndex': user.avatarIndex,
      });

      final updatedDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      return Right(UserModel.fromMap(updatedDoc.data()!));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
