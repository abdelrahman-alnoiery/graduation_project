import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/profile_tab/domain/repository/profile_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/profile_entity.dart';

class UpdateProfileUseCase {
  final ProfileRepo profileRepo;
  UpdateProfileUseCase(this.profileRepo);

  Future<Either<Failure, ProfileEntity>> call({
    required String firstName,
    required String lastName,
    required String phone,
    required String language,
  }) async {
    return await profileRepo.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      language: language,
    );
  }
}
