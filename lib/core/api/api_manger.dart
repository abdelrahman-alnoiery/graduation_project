import 'package:dio/dio.dart';

import 'end_points.dart';

class ApiManager {
  static Dio? _dio;

  static Dio _getDio() {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    return _dio!;
  }

  static Future<Response> get(String endPoint) async {
    return await _getDio().get(endPoint);
  }

  static Future<Response> post(
    String endPoint, {
    required Map<String, dynamic> body,
  }) async {
    return await _getDio().post(endPoint, data: body);
  }

  static Future<Response> put(
    String endPoint, {
    required Map<String, dynamic> body,
  }) async {
    return await _getDio().put(endPoint, data: body);
  }

  static Future<Response> delete(String endPoint) async {
    return await _getDio().delete(endPoint);
  }
}
