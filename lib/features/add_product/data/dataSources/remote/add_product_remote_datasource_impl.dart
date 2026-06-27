import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/utils/constants_manager.dart';
import 'package:graduation_project/features/add_product/data/models/add_product_request_model.dart';
import 'package:graduation_project/features/add_product/data/models/add_product_response_model.dart';

import 'add_product_remote_datasource.dart';

class AddProductRemoteDatasourceImpl implements AddProductRemoteDatasource {
  // ✅ Dio مستقل للـ multipart upload
  Dio _buildUploadDio() {
    final token = SharedPref.getString(AppConstants.userToken) ?? '';
    return Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  @override
  Future<AddProductResponseModel> addProduct({
    required AddProductRequestModel request,
    required List<File> images,
  }) async {
    final dio = _buildUploadDio();

    final List<MultipartFile> imageFiles = [];
    for (final file in images) {
      imageFiles.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }

    final formData = FormData.fromMap({
      ...request.toMap(),
      'images': imageFiles,
    });

    final response = await dio.post(EndPoints.products, data: formData);
    print(response);
    return AddProductResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
