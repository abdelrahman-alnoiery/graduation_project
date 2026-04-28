import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/profile_tab/domain/repository/profile_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/profile_entity.dart';

class GetProfileUseCase {
  final ProfileRepo profileRepo;
  GetProfileUseCase(this.profileRepo);

  Future<Either<Failure, ProfileEntity>> call() async {
    return await profileRepo.getProfile();
  }
}
