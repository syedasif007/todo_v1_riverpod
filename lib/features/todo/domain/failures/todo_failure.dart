sealed class TodoFailure {
  const TodoFailure();
}

class NetworkFailure extends TodoFailure {
  const NetworkFailure();
}

class UnexpectedFailure extends TodoFailure {
  const UnexpectedFailure();
}
