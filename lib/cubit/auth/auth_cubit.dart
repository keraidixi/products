import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthInitial()){
    checkLogin();
  }

  Future<void> signup(
    String email,
    String password,
    String address,
    String phone,
  ) async {
    emit(AuthInProgress());

    try {
      final success = await repo.signup(email, password, address, phone);

      if (!success) {
        emit(const AuthFailure("User already exists"));
        return;
      }

      emit(AuthSuccess(email, address, phone));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthInProgress());

    try {
      final user = await repo.login(email, password);

      if (user == null) {
        emit(const AuthFailure("Invalid email or password"));
        return;
      }

      emit(AuthSuccess(user.email, user.address, user.phone));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    await repo.logout();
    emit(AuthInitial());
  }

  Future<void> checkLogin() async {
    final user = repo.getCurrentUser();

    if (user != null) {
      emit(
        AuthSuccess(
          user.email,
          user.address,
          user.phone,
        ),
      );
    } else {
      emit(AuthInitial());
    }
  }
}
