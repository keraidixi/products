import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/cart_repository.dart';
import 'auth_state.dart';
import '../../repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;
  final CartRepository cartRepo;

  AuthCubit(this.repo, this.cartRepo) : super(AuthInProgress()){
    checkLogin();
  }

  Future<void> logout() async {
    await repo.logout();
    cartRepo.updateUser('');
    emit(AuthInitial());
  }

  Future<void> checkLogin() async {
    final user = repo.getCurrentUser();
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (user != null && firebaseUser != null) {
      cartRepo.updateUser(firebaseUser.uid);

      emit(AuthSuccess(user.email, user.address, user.phone));

      cartRepo.loadCart();
    } else {
      cartRepo.updateUser('');
      emit(AuthInitial());
    }
  }
}