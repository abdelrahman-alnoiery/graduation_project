import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';

import '../models/car_try_on_model.dart';
import 'car_try_on_remote_datasource.dart';

class CarTryOnRemoteDatasourceImpl implements CarTryOnRemoteDatasource {
  static const String _baseUrl = 'https://abdoelhadray-flux-car-api.hf.space';

  Dio _buildDio() {
    return Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );
  }

  @override
  Future<CarTryOnModel> tryOnCar({
    required String productId, // ✅ هنستخدمه عشان نجيب product image URL
    required File carImage,
    String? productImageUrl, // ✅ URL صورة المنتج من الـ ProductEntity
  }) async {
    try {
      final dio = _buildDio();

      // ✅ الـ API الجديد بيستنى car_image + product_image كـ files
      final formData = FormData.fromMap({
        'car_image': await MultipartFile.fromFile(
          carImage.path,
          filename: carImage.path.split('/').last,
        ),
        // ✅ نحمّل صورة المنتج من الـ URL وابعتها كـ bytes
        'product_image': await _urlToMultipartFile(productImageUrl ?? ''),
      });

      print('🚗 Sending to Car Try-On API...');
      print('📦 Product Image URL: $productImageUrl');

      final response = await dio.post('/ai/virtual-try-on', data: formData);

      print('✅ Car Try-On Response: ${response.data}');

      if (response.data is! Map<String, dynamic>) {
        throw NetworkException(message: 'Invalid response format');
      }

      final model = CarTryOnModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (!model.success || model.resultImageUrl.isEmpty) {
        throw NetworkException(message: 'Failed to generate result');
      }

      return model;
    } on DioException catch (e) {
      print('❌ Car Try-On DioException: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw NetworkException.fromDioError(e);
    } catch (e) {
      if (e is NetworkException) rethrow;
      print('❌ Car Try-On Exception: $e');
      throw NetworkException(message: e.toString());
    }
  }

  // ── تحميل صورة من URL وتحويلها لـ MultipartFile ────────
  Future<MultipartFile> _urlToMultipartFile(String imageUrl) async {
    // ✅ Dio منفصل خالص من الـ baseUrl
    final dio = Dio();
    final response = await dio.get<List<int>>(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data ?? [];
    final filename = imageUrl.split('/').last.split('?').first;
    return MultipartFile.fromBytes(bytes, filename: filename);
  }
}
