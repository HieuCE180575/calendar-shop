import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/chat_answer_model.dart';

class ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSource(this.apiClient);

  Future<ChatAnswerModel> ask(String message) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.chatAsk,
        data: {'message': message},
      );
      return ChatAnswerModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw apiClient.handleError(e);
    }
  }
}
