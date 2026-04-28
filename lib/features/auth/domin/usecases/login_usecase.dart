import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/user_entity.dart';
import '../repository/auth_repo.dart';

class LoginUseCase {
  final AuthRepo authRepo;

  LoginUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await authRepo.signIn(email: email, password: password);
  }
}
