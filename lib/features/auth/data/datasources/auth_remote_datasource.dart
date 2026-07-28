// import '../../domain/failures/auth_failure.dart';
// import '../models/user_model.dart';

// abstract class AuthRemoteDatasource {
//   Future<UserModel> login({required String email, required String password});
// }

import '../dtos/user_dto.dart';

abstract class AuthRemoteDatasource {
  Future<UserDto> login({required String email, required String password});
}
