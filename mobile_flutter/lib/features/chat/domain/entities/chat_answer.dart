import 'chat_source.dart';

class ChatAnswer {
  final String normalizedQuery;
  final String answer;
  final List<ChatSource> sources;
  final bool usedInference;
  final bool requiresClarification;

  const ChatAnswer({
    required this.normalizedQuery,
    required this.answer,
    required this.sources,
    required this.usedInference,
    required this.requiresClarification,
  });
}
