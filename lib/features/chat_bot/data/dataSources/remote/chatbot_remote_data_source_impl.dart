import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';

import '../../../../../core/api/api_manger.dart';
import '../../models/message_model.dart';
import 'chatbot_remote_data_source.dart';

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  // ── Send Message ──────────────────────────────────
  @override
  Future<MessageModel> sendMessage(String message) async {
    try {
      final response = await ApiManager.post(
        EndPoints.chatbot,
        body: {"message": message},
      );
      return MessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Send Image ────────────────────────────────────
  @override
  Future<MessageModel> sendImage(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });
      final response = await ApiManager.post(
        EndPoints.aiFixing,
        body: formData.fields.asMap().map((_, e) => MapEntry(e.key, e.value)),
      );
      return MessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
