import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/auth_repository.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository repo;

  SignupCubit(this.repo) : super(SignupInitial());

  Future<void> signup(
      String email,
      String password,
      String address,
      String phone,
      ) async {
    emit(SignupInProgress());

    try {
      await repo.signup(email, password, address, phone);
      emit(const SignupSuccess("Account Created Successfully"));
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
