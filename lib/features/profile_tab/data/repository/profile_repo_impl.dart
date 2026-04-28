import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/core/utils/constants_manager.dart';
import 'package:graduation_project/features/profile_tab/domain/repository/profile_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/profile_entity.dart';
import '../dataSources/remote/profile_remote_data_source.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;
  final CheckInternetConnection networkInfo;

  ProfileRepoImpl({required this.remoteDataSource, required this.networkInfo});

  // ── Get Profile ───────────────────────────────────
  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Update Profile ────────────────────────────────
  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String language,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final profile = await remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        language: language,
      );
      return Right(profile);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Change Password ───────────────────────────────
  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      await remoteDataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Logout ────────────────────────────────────────
  @override
  Future<Either<Failure, void>> logout() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      await remoteDataSource.logout();
      await SharedPref.remove(AppConstants.userToken);
      await SharedPref.remove(AppConstants.isLoggedIn);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
