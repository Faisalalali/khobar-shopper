import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// To access [AuthProvider]
final authProvider = Provider<AuthProvider>((ref) => AuthProvider());

/// To return the auth state changes stream
final authStateChangeProvider = StreamProvider.autoDispose<User?>((ref) {
  return ref.watch(authProvider).authState;
});

class AuthProvider {
  // Auth attributes
  late FirebaseAuth _auth;
  User? _user;

  // Variables
  String? _uid;
  Object? _obj;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
  }

  // Getters
  String get uid => _uid!;
  User? get current_user => _auth.currentUser;
  Object? get obj => _obj;

  /// Getting the stream data about the user state changes
  Stream<User?> get authState => _auth.authStateChanges();

  // Setters
  void setUID(String? uid) {
    _uid = uid;
  }

  void setObj(Object? obj) {
    _obj = obj;
  }

  /// Sign in to the system with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCred.user != null) {
        _user = userCred.user;
        _uid = _user!.uid;
        if (!_user!.emailVerified) {
          await _user!.sendEmailVerification();
          throw 'Email not verified';
        }
        debugPrint('success user signed to the system');
        return;
      }
      //user signed out
      throw 'Please login again';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'You don\'t have an account, please register to the system';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong email or password';
      }
      debugPrint(e.toString());
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCred.user != null) {
        _user = userCred.user;
        _uid = _user!.uid;
        debugPrint('success user registered to the system');
        await _user!.sendEmailVerification();
        return;
      }
      // User signed out
      throw 'Please login again';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password is weak';
      } else if (e.code == 'email-already-in-use') {
        throw 'The email is already used, please login';
      }
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkEmailVerification() async {
    try {
      await _user!.reload();
      _user = _auth.currentUser;
      bool isVerified = _user!.emailVerified;
      debugPrint('auth $isVerified');
      return isVerified;
    } catch (e) {
      throw e;
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await _user!.sendEmailVerification();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _uid = null;
  }

  Future<void> deleteUser() async {
    await _auth.currentUser?.delete();
    _user = null;
    _uid = null;
  }
}
