import '../../../../core/common/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;

  const AuthRepositoryImpl(this._remote);

  @override
  Future<Result<AuthFailure, User>> login({
    required Email email,
    required Password password,
  }) async {
    try {
      final model = await _remote.login(
        email: email.value,
        password: password.value,
      );
      return SuccessResult<AuthFailure, User>(model.toEntity());
    } on AuthFailure catch (f) {
      return FailureResult<AuthFailure, User>(f);
    } catch (_) {
      return const FailureResult<AuthFailure, User>(UnexpectedFailure());
    }
  }
}
