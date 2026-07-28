import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';
import '../../application/usecases/login_usecase.dart';
import '../../providers/auth_providers.dart';

class AuthControllerState {
  final User? user;
  final AuthFailure? failure;

  const AuthControllerState({this.user, this.failure});

  const AuthControllerState.initial() : this(user: null, failure: null);

  AuthControllerState copyWith({User? user, AuthFailure? failure}) {
    return AuthControllerState(user: user ?? this.user, failure: failure);
  }
}

class AuthController extends AsyncNotifier<AuthControllerState> {
  late LoginUseCase _loginUseCase;

  @override
  Future<AuthControllerState> build() async {
    _loginUseCase = ref.read(loginUseCaseProvider);
    return const AuthControllerState.initial();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    final result = await _loginUseCase(
      email: Email(email),
      password: Password(password),
    );

    state = result.fold(
      (failure) =>
          AsyncData(AuthControllerState.initial().copyWith(failure: failure)),
      (user) => AsyncData(AuthControllerState.initial().copyWith(user: user)),
    );
  }
}
