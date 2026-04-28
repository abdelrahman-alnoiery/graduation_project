import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  });

  Future<Either<Failure, void>> sendOtp({required String email});

  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, void>> forgotPassword({required String email});

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<Either<Failure, void>> signOut();
}
