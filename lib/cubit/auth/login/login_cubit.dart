import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/auth_repository.dart';
import '../../../repository/cart_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repo;
  final CartRepository cartRepo;

  LoginCubit(this.repo, this.cartRepo) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginInProgress());

    try {
      final user = await repo.login(email, password);

      if (user == null) {
        emit(const LoginFailure("User data not found"));
        return;
      }

      final uid = FirebaseAuth.instance.currentUser!.uid;

      cartRepo.updateUser(uid);

      emit(LoginSuccess(user.email, user.address, user.phone));
    } catch (e) {
      emit(LoginFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }
}