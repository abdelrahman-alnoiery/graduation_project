import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/features/profile_tab/domain/entity/profile_entity.dart';
import 'package:graduation_project/features/profile_tab/domain/repository/profile_repo.dart';

class UpdateProfileUseCase {
  final ProfileRepo profileRepo;
  UpdateProfileUseCase(this.profileRepo);

  Future<Either<Failure, ProfileEntity>> call({
    String? username,
    String? email,
  }) async {
    return await profileRepo.updateProfile(username: username, email: email);
  }
}
