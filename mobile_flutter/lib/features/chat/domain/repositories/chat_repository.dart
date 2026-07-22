import '../entities/chat_answer.dart';

abstract class ChatRepository {
  Future<ChatAnswer> ask(String message);
}
