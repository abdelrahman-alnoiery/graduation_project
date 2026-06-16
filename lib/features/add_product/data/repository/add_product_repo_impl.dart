import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/add_product/data/models/add_product_request_model.dart';

import '../../domain/entity/add_product_entity.dart';
import '../../domain/repository/add_product_repo.dart';
import '../dataSources/remote/add_product_remote_datasource.dart';

class AddProductRepoImpl implements AddProductRepo {
  final AddProductRemoteDatasource remoteDataSource;
  final CheckInternetConnection networkInfo;

  AddProductRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AddProductEntity>> addProduct({
    required String name,
    required String description,
    required String category,
    required double price,
    required int stock,
    required List<File> images,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final result = await remoteDataSource.addProduct(
        request: AddProductRequestModel(
          name: name,
          description: description,
          category: category,
          price: price,
          stock: stock,
        ),
        images: images,
      );
      return Right(
        AddProductEntity(
          id: result.id,
          name: result.name,
          category: result.category,
          price: result.price,
          imageUrl: result.imageUrl,
        ),
      );
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on DioException catch (e) {
      final msg =
          e.response?.data['message'] ??
          e.response?.data['error'] ??
          'Failed to add product';
      return Left(NetworkFailure(message: msg.toString()));
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}
