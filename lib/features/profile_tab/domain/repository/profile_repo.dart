import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/features/profile_tab/domain/entity/profile_entity.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile({
    String? username,
    String? email,
  });
  Future<Either<Failure, void>> logout();
}
