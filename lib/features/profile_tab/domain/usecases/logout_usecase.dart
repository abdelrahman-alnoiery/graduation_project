import 'package:dartz/dartz.dart';
import 'package:graduation_project/features/profile_tab/domain/repository/profile_repo.dart';

import '../../../../core/exceptions/failuers.dart';

class LogoutUseCase {
  final ProfileRepo profileRepo;
  LogoutUseCase(this.profileRepo);

  Future<Either<Failure, void>> call() async {
    return await profileRepo.logout();
  }
}
