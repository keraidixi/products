import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../models/auth_model.dart';

class AuthRepository {
  final Box<UserModel> box;

  AuthRepository(this.box);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signup(
      String email,
      String password,
      String address,
      String phone,
      ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await box.put(
        credential.user!.uid,
        UserModel(
          email: email,
          password: password,
          address: address,
          phone: phone,
        ),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("User already exists");
      } else if (e.code == 'weak-password') {
        throw Exception("Password is too weak");
      } else if (e.code == 'invalid-email') {
        throw Exception("Invalid email");
      }

      throw Exception(e.message ?? "Signup failed");
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return box.get(credential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw Exception("Please signup first");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password");
      }  else if (e.code == 'invalid-email') {
        throw Exception("Invalid email format");
      }

      throw Exception(e.message ?? "Login failed");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  UserModel? getCurrentUser() {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) return null;

    return box.get(firebaseUser.uid);
  }
}