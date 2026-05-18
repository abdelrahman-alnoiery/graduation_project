import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/utils/constants_manager.dart';

class AiDioFactory {
  static Dio? _dio;

  static Dio getDio() {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 60), // ✅ من 10 لـ 60
        receiveTimeout: const Duration(seconds: 60), // ✅ من 10 لـ 60
        sendTimeout: const Duration(seconds: 60), // ✅ أضف ده
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
    final token = SharedPref.getString(AppConstants.userToken);
    print('Token being sent: $token'); // ✅ للتأكد
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
