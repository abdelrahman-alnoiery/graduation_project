import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';

import '../../../../../core/network/ai_dio_factory.dart';
import '../../models/ai_fixing_result_model.dart';
import '../../models/message_model.dart';
import 'chatbot_remote_data_source.dart';

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  // ── Dio مستقل للـ Chatbot API ────────────────────
  Dio _buildChatbotDio() {
    return Dio(
      BaseOptions(
        baseUrl: EndPoints.chatbotBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  // ── Check AI Health ───────────────────────────────
  Future<bool> _checkHealth() async {
    try {
      final dio = AiDioFactory.getDio();
      final response = await dio.get(
        "${EndPoints.aiBaseUrl}${EndPoints.aiHealth}",
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── Send Message ──────────────────────────────────
  @override
  Future<MessageModel> sendMessage(String message) async {
    try {
      final dio = _buildChatbotDio();

      final response = await dio.post(
        EndPoints.chatbotSend,
        data: {'message': message},
      );

      print('✅ Chatbot Response: ${response.data}');

      // ── الـ API بيرجع {"status":"success","reply":"..."}
      final reply = response.data['reply']?.toString() ?? '';

      if (reply.isEmpty) {
        return MessageModel.bot(
          "Sorry, I didn't get a response. Please try again. 🔄",
        );
      }

      return MessageModel.bot(reply);
    } on DioException catch (e) {
      print('❌ Chatbot DioException: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      return MessageModel.bot(
        "Sorry, I'm having trouble connecting. Please try again. 🔄",
      );
    } catch (e) {
      print('❌ Chatbot Exception: $e');
      return MessageModel.bot(
        "An unexpected error occurred. Please try again. 🔄",
      );
    }
  }

  // ── Send Image (AI Car Damage) ────────────────────
  // ✅ مش اتغيرت — بتشتغل مع الـ AI endpoint القديم
  @override
  Future<AiFixingResultModel> sendImage(String imagePath) async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
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

        final response = await dio.post(
          "${EndPoints.aiBaseUrl}${EndPoints.aiPredict}",
          data: formData,
        );

        print('✅ AI Response Status: ${response.statusCode}');
        print('✅ AI Response Data: ${response.data}');

        return AiFixingResultModel.fromJson(response.data);
      } on DioException catch (e) {
        print('❌ DioException: ${e.message}');
        retryCount++;
        if (retryCount == maxRetries) {
          throw NetworkException.fromDioError(e);
        }
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        print('❌ Exception: $e');
        throw NetworkException(message: e.toString());
      }
    }

    throw NetworkException(message: "Failed after $maxRetries retries");
  }
}
