import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/profile_tab/data/dataSources/remote/profile_remote_data_source.dart';
import 'package:graduation_project/features/profile_tab/domain/entity/profile_entity.dart';
import 'package:graduation_project/features/profile_tab/domain/repository/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;
  final CheckInternetConnection networkInfo;

  ProfileRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final user = await remoteDataSource.getProfile();
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    String? username,
    String? email,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final user = await remoteDataSource.updateProfile(
        username: username,
        email: email,
      );
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}
