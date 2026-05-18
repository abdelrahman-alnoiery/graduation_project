import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';

import '../../../../../core/network/ai_dio_factory.dart';
import '../../models/ai_fixing_result_model.dart';
import '../../models/message_model.dart';
import 'chatbot_remote_data_source.dart';

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  // ── Check AI Health ───────────────────────────────
  Future<bool> _checkHealth() async {
    try {
      final dio = AiDioFactory.getDio();
      final response = await dio.get("${EndPoints.aiBaseUrl}${EndPoints.aiHealth}");
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── Send Message ──────────────────────────────────
  @override
  Future<MessageModel> sendMessage(String message) async {
    await Future.delayed(const Duration(seconds: 1));
    return MessageModel.bot(
      "Sorry, the chatbot service is currently unavailable. Please use the AI Car Damage feature by sending an image. 🚗",
    );
  }

  // ── Send Image (AI Predict) ───────────────────────
  @override
  Future<AiFixingResultModel> sendImage(String imagePath) async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        // ── Check Health First ──────────────────
        final isHealthy = await _checkHealth();
        if (!isHealthy) {
          await Future.delayed(const Duration(seconds: 3));
          retryCount++;
          continue;
        }

        final dio = AiDioFactory.getDio();
        final formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
        });

        final response = await dio.post("${EndPoints.aiBaseUrl}${EndPoints.aiPredict}", data: formData);

        // ✅ طباعة الـ response
        print('AI Response Status: ${response.statusCode}');
        print('AI Response Data: ${response.data}');
        print('AI Response Keys: ${(response.data as Map).keys}');

        return AiFixingResultModel.fromJson(response.data);
      } on DioException catch (e) {
        print('DioException: ${e.message}');
        print('DioException Response: ${e.response?.data}');
        retryCount++;
        if (retryCount == maxRetries) {
          throw NetworkException.fromDioError(e);
        }
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        print('Exception: $e');
        throw NetworkException(message: e.toString());
      }
    }

    throw NetworkException(message: "Failed after $maxRetries retries");
  }
}
