import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../domin/entity/user_entity.dart';
import '../../domin/repository/auth_repo.dart';
import '../dataSources/local/local_data_source.dart';
import '../dataSources/remote/auth_remote_ds.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final CheckInternetConnection networkInfo;

  AuthRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // ── Sign In ───────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final user = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      await localDataSource.saveToken(user.token ?? '');
      await localDataSource.saveUserId(user.id);
      await localDataSource.saveIsLoggedIn(true);
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  // ── Sign Up ───────────────────────────────────────
  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final user = await remoteDataSource.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
      );
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Send OTP ──────────────────────────────────────
  @override
  Future<Either<Failure, void>> sendOtp({required String email}) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      await remoteDataSource.sendOtp(email: email);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Verify OTP ────────────────────────────────────
  @override
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      await remoteDataSource.verifyOtp(email: email, otp: otp);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Forgot Password ───────────────────────────────
  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Reset Password ────────────────────────────────
  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      await remoteDataSource.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Sign Out ──────────────────────────────────────
  @override
  Future<Either<Failure, void>> signOut() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearUserData();
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
