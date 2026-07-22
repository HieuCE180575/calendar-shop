import '../../domain/entities/chat_answer.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<ChatAnswer> ask(String message) async {
    final model = await remoteDataSource.ask(message);
    return model.toEntity();
  }
}
