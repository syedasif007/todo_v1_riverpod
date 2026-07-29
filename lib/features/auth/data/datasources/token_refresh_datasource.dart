/// Contract for refreshing an access token using a stored refresh token.
///
/// Returns a pair of fresh tokens on success, or throws if the refresh fails
/// (e.g. revoked refresh token, network down). Implementations are expected
/// to surface network/socket errors as exceptions which callers translate
/// into [NetworkFailure] or [InvalidCredentialsFailure].
abstract class TokenRefreshDatasource {
  /// Performs a refresh request and returns the newly issued tokens.
  ///
  /// Throws [TokenRefreshException] on auth failure and any underlying
  /// transport-level exception on connectivity issues.
  Future<({String accessToken, String refreshToken})> refresh({
    required String refreshToken,
  });
}

class TokenRefreshException implements Exception {
  final String message;
  const TokenRefreshException(this.message);

  @override
  String toString() => 'TokenRefreshException: $message';
}
