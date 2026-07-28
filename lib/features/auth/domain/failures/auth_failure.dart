sealed class AuthFailure {
  const AuthFailure();
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure();
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure();
}

class UnexpectedFailure extends AuthFailure {
  const UnexpectedFailure();
}
