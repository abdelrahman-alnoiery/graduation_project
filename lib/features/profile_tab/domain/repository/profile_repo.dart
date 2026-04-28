import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/profile_entity.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String language,
  });
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<Either<Failure, void>> logout();
}
