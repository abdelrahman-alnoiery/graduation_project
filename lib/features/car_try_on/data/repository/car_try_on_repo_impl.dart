import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/car_try_on_entity.dart';
import '../../domain/repository/car_try_on_repo.dart';
import '../datasources/car_try_on_remote_datasource.dart';

// ⚠️ تأكد من كتابة عمل Import لكلاس فحص الإنترنت الصحيح من مشروعك إذا كان في مسار مختلف
// import '../../../../core/network/network_info.dart';

class CarTryOnRepoImpl implements CarTryOnRepo {
  final CarTryOnRemoteDatasource remoteDataSource;
  final dynamic
  networkInfo; // ✅ إضافة البارامتر لاستقبال كلاس فحص الإنترنت لتجنب خطأ الشاشة

  CarTryOnRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo, // 🔥 تم جعلها مطلوبة كما تطلبها الـ Screen في سطر 190
  });

  @override
  Future<Either<Failure, CarTryOnEntity>> tryOnCar({
    required String productId,
    required File carImage,
    required String productImageUrl,
    required String productName,
  }) async {
    try {
      print("📦 RepoImpl passing data to RemoteDataSource...");
      print("📦 Product Name: $productName");

      // يمكنك هنا إضافة شرط الـ networkInfo.isConnected إذا كنت تستخدمه لفحص الإنترنت قبل الـ API

      final carTryOnModel = await remoteDataSource.tryOnCar(
        productId: productId,
        carImage: carImage,
        productImageUrl: productImageUrl,
        productName: productName,
      );

      return Right(carTryOnModel);
    } on NetworkException catch (e) {
      print("❌ RepoImpl caught NetworkException: ${e.message}");
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print("❌ RepoImpl caught Unexpected Exception: $e");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
