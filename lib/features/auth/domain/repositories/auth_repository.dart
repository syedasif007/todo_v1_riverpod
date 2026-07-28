// import '../entities/user.dart';
// import '../failures/auth_failure.dart';
// import '../../domain/value_objects/email.dart';
// import '../../domain/value_objects/password.dart';

// abstract class AuthRepository {
//   Future<Result<AuthFailure, User>> login({
//     required Email email,
//     required Password password,
//   });

//   Future<Result<AuthFailure, void>> logout();
// }

import '../../../../core/error_handling/result.dart';
import '../entities/user.dart';
import '../failures/auth_failure.dart';
import '../value_objects/email.dart';
import '../value_objects/password.dart';

abstract class AuthRepository {
  Future<Result<AuthFailure, User>> login({
    required Email email,
    required Password password,
  });
}
