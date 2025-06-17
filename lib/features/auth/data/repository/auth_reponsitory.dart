import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';

class AuthReponsitory {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // google login
  Future<Either<String, UserModel>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return const Left('Google sign in aborted');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        return const Left('Failed to sign in with Google');
      }

      // Check if user exists in Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Create new user document if it doesn't exist
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'username': user.displayName ?? 'User',
          'id': user.uid,
          'avatarIndex': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return Right(await _getUserData(user.uid));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return const Left(
            'Account already exists with this email but logged in with a different method',
          );
        case 'invalid-credential':
          return const Left('Invalid credential or expired');
        case 'operation-not-allowed':
          return const Left('This login method is not allowed');
        case 'user-disabled':
          return const Left('This account has been disabled');
        case 'user-not-found':
          return const Left('Account not found');
        case 'wrong-password':
          return const Left('Wrong password');
        case 'invalid-verification-code':
          return const Left('Invalid verification code');
        case 'invalid-verification-id':
          return const Left('Invalid verification ID');
        default:
          return Left('Login failed: ${e.message}');
      }
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }

  //facebook login
  Future<Either<String, UserModel>> signInWithFacebook() async {
    try {
      // Trigger the Facebook sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Get the access token
        final AccessToken accessToken = result.accessToken!;

        // Get user data from Facebook
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email",
        );

        // Create a credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.token,
        );

        // Sign in to Firebase with the Facebook credential
        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);

        final user = userCredential.user;
        if (user == null) {
          return const Left('Failed to sign in with Facebook');
        }

        // Check if user exists in Firestore
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // Create new user document if it doesn't exist
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email ?? userData['email'],
            'username': user.displayName ?? userData['name'] ?? 'User',
            'id': user.uid,
            'avatarIndex': 0,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        return Right(await _getUserData(user.uid));
      } else if (result.status == LoginStatus.cancelled) {
        return const Left('Facebook login cancelled');
      } else {
        return const Left('Facebook login failed');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return const Left(
            'Account already exists with this email but logged in with a different method',
          );
        case 'invalid-credential':
          return const Left('Invalid credential or expired');
        case 'operation-not-allowed':
          return const Left('This login method is not allowed');
        case 'user-disabled':
          return const Left('This account has been disabled');
        case 'user-not-found':
          return const Left('Account not found');
        default:
          return Left('Login failed: ${e.message}');
      }
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }
}
