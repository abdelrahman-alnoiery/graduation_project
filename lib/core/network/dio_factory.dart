import 'package:dio/dio.dart';

import '../api/end_points.dart';

class DioFactory {
  static Dio? _dio;

  static Dio getDio() {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    )..interceptors.addAll([_LoggingInterceptor(), _AuthInterceptor()]);
    return _dio!;
  }

  static void resetDio() {
    _dio = null;
  }
}

// ── Logging Interceptor ───────────────────────────────
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}

// ── Auth Interceptor ──────────────────────────────────
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ⚠️ هيتضاف التوكن هنا لما الـ Backend يبعت الـ API
    // final token = SharedPref.getString(SharedPrefKeys.token);
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    super.onRequest(options, handler);
  }
}
