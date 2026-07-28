import '../../../../core/error_handling/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';

class LoginUseCase {
  final AuthRepository _repo;
  const LoginUseCase(this._repo);

  Future<Result<AuthFailure, User>> call({
    required Email email,
    required Password password,
  }) {
    return _repo.login(email: email, password: password);
  }
}
