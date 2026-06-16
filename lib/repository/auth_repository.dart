import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

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
      final credential =
      await _auth.createUserWithEmailAndPassword(
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
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<UserModel?> login(
      String email,
      String password,
      ) async {
    try {
      final credential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final UserModel? user =
      box.get(credential.user!.uid);

      if (user == null) return null;

      return user;

    } on FirebaseAuthException {
      return null;
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