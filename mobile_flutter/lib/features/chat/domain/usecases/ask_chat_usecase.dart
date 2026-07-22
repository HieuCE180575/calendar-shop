import '../entities/chat_answer.dart';
import '../repositories/chat_repository.dart';

class AskChatUseCase {
  final ChatRepository repository;

  AskChatUseCase(this.repository);

  Future<ChatAnswer> call(String message) {
    return repository.ask(message);
  }
}
