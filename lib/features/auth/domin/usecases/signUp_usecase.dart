import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repo.dart';

class SignUpUseCase {
  final AuthRepo authRepo;

  SignUpUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    return await authRepo.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phone: phone,
    );
  }
}
