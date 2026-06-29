import 'dart:io';

import 'package:dio/dio.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';

import '../models/car_try_on_model.dart';
import 'car_try_on_remote_datasource.dart';

class CarTryOnRemoteDatasourceImpl implements CarTryOnRemoteDatasource {
  static const String _baseUrl = 'https://abdoellithy-somnium.hf.space';

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
    required String productId,
    required File carImage,
    required String productImageUrl, // 🔥 تعديل: جعلها إجبارية لمنع الـ null
    required String
    productName, // 🔥 تعديل: جعلها إجبارية لضمان وصول الاسم للسيرفر
  }) async {
    try {
      final dio = _buildDio();

      print('⏳ Downloading product image from URL...');
      // ✅ حمّل صورة المنتج من الـ URL
      final productImageBytes = await _downloadImage(productImageUrl, dio);

      // 🔥 تأمين الكلمة الدلالية للـ AI: إذا كان الاسم يحتوي على كلمات عجلات، نضمن تمريرها
      // وإذا كان فارغاً نضع 'wheel rim' كدليل ثابت بدلاً من accessory لضمان النزول عند الإطارات
      final String optimizedProductName = productName.trim().isNotEmpty
          ? productName
          : 'passenger car wheel rim';

      final formData = FormData.fromMap({
        'product_image': MultipartFile.fromBytes(
          productImageBytes,
          filename: 'product.jpg',
        ),
        'car_image': await MultipartFile.fromFile(
          carImage.path,
          filename: carImage.path.split('/').last,
        ),
        'product_name': optimizedProductName, // 🔥 تمرير الاسم المحسن والمؤمن
      });

      print('🚗 Sending to Car Try-On API...');
      print('📦 Product ID: $productId');
      print('📦 Sent Product Name to AI: $optimizedProductName');
      print('🖼️ Product Image URL: $productImageUrl');

      // ✅ الـ response صورة مباشرة مش JSON
      final response = await dio.post(
        '/generate-integration/',
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      print('✅ Car Try-On Status: ${response.statusCode}');
      print('✅ Response size: ${(response.data as List).length} bytes');

      final bytes = response.data as List<int>;

      return CarTryOnModel(
        success: true,
        resultImageUrl: '',
        resultImageBytes: bytes, // ✅ الصورة كـ bytes
      );
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

  Future<List<int>> _downloadImage(String url, Dio dio) async {
    try {
      final imageDio = Dio();
      final response = await imageDio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data ?? [];
    } catch (e) {
      print('❌ Error downloading product image: $e');
      return [];
    }
  }

  String _bytesToBase64(List<int> bytes) {
    const base64Chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    final buffer = StringBuffer();
    for (var i = 0; i < bytes.length; i += 3) {
      final b0 = bytes[i];
      final b1 = i + 1 < bytes.length ? bytes[i + 1] : 0;
      final b2 = i + 2 < bytes.length ? bytes[i + 2] : 0;
      buffer.write(base64Chars[(b0 >> 2) & 0x3F]);
      buffer.write(base64Chars[((b0 << 4) | (b1 >> 4)) & 0x3F]);
      buffer.write(
        i + 1 < bytes.length
            ? base64Chars[((b1 << 2) | (b2 >> 6)) & 0x3F]
            : '=',
      );
      buffer.write(i + 2 < bytes.length ? base64Chars[b2 & 0x3F] : '=');
    }
    return buffer.toString();
  }
}
