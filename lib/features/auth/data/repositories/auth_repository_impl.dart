import '../../../../core/common/result.dart';
import '../../../../core/services/auth_token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/token_refresh_datasource.dart';
import '../dtos/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final TokenRefreshDatasource _refreshDatasource;
  final AuthTokenStorage _tokenStorage;

  const AuthRepositoryImpl(
    this._remote, {
    required TokenRefreshDatasource refreshDatasource,
    required AuthTokenStorage tokenStorage,
  }) : _refreshDatasource = refreshDatasource,
       _tokenStorage = tokenStorage;

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

      // Persist tokens + user blob before returning so a process kill
      // immediately after login still leaves the session resumable.
      await _tokenStorage.write(
        accessToken: model.accessToken,
        refreshToken: model.refreshToken,
        user: model.toJson(),
      );

      return SuccessResult<AuthFailure, User>(model.toEntity());
    } on AuthFailure catch (f) {
      return FailureResult<AuthFailure, User>(f);
    } catch (_) {
      return const FailureResult<AuthFailure, User>(UnexpectedFailure());
    }
  }

  @override
  Future<Result<AuthFailure, User>> restoreSession() async {
    try {
      final stored = await _tokenStorage.read();
      final access = stored.accessToken;
      final refresh = stored.refreshToken;
      final userJson = stored.user;

      if (access == null ||
          access.isEmpty ||
          refresh == null ||
          refresh.isEmpty) {
        return const FailureResult<AuthFailure, User>(NoActiveSessionFailure());
      }

      if (userJson == null) {
        // Tokens but no cached user — clear so the UI shows "sign in".
        await _tokenStorage.clear();
        return const FailureResult<AuthFailure, User>(StorageFailure());
      }

      return SuccessResult<AuthFailure, User>(
        UserDto.fromJson(userJson).toEntity(),
      );
    } catch (_) {
      return const FailureResult<AuthFailure, User>(StorageFailure());
    }
  }

  @override
  Future<void> logout() async {
    // Best-effort: any failure to clear is non-fatal.
    try {
      await _tokenStorage.clear();
    } catch (_) {
      /* ignored */
    }
  }

  @override
  Future<Result<AuthFailure, void>> refreshTokens() async {
    try {
      final stored = await _tokenStorage.read();
      final refresh = stored.refreshToken;
      if (refresh == null || refresh.isEmpty) {
        return const FailureResult<AuthFailure, void>(NoActiveSessionFailure());
      }

      final fresh = await _refreshDatasource.refresh(refreshToken: refresh);

      // Preserve the cached user blob — refresh only swaps tokens.
      await _tokenStorage.writeTokens(
        accessToken: fresh.accessToken,
        refreshToken: fresh.refreshToken,
      );
      if (stored.user != null) {
        await _tokenStorage.write(
          accessToken: fresh.accessToken,
          refreshToken: fresh.refreshToken,
          user: stored.user,
        );
      }
      return const SuccessResult<AuthFailure, void>(null);
    } on TokenRefreshException catch (f) {
      // Refresh token is no longer valid; wipe stored credentials.
      await _tokenStorage.clear();
      return FailureResult<AuthFailure, void>(
        TokenRefreshFailure(details: f.message),
      );
    } on AuthFailure catch (f) {
      return FailureResult<AuthFailure, void>(f);
    } catch (_) {
      return const FailureResult<AuthFailure, void>(UnexpectedFailure());
    }
  }
}
