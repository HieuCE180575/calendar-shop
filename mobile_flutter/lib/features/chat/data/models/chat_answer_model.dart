import '../../domain/entities/chat_answer.dart';
import '../../domain/entities/chat_source.dart';

class ChatSourceModel {
  final String type;
  final int? id;
  final String name;
  final double score;

  const ChatSourceModel({
    required this.type,
    required this.id,
    required this.name,
    required this.score,
  });

  factory ChatSourceModel.fromJson(Map<String, dynamic> json) {
    return ChatSourceModel(
      type: json['type'] as String? ?? '',
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0,
    );
  }

  ChatSource toEntity() {
    return ChatSource(
      type: type,
      id: id,
      name: name,
      score: score,
    );
  }
}

class ChatAnswerModel {
  final String normalizedQuery;
  final String answer;
  final List<ChatSourceModel> sources;
  final bool usedInference;
  final bool requiresClarification;

  const ChatAnswerModel({
    required this.normalizedQuery,
    required this.answer,
    required this.sources,
    required this.usedInference,
    required this.requiresClarification,
  });

  factory ChatAnswerModel.fromJson(Map<String, dynamic> json) {
    final sourcesJson = json['sources'] as List<dynamic>? ?? [];
    return ChatAnswerModel(
      normalizedQuery: json['normalizedQuery'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      sources: sourcesJson
          .map((item) => ChatSourceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      usedInference: json['usedInference'] as bool? ?? false,
      requiresClarification: json['requiresClarification'] as bool? ?? false,
    );
  }

  ChatAnswer toEntity() {
    return ChatAnswer(
      normalizedQuery: normalizedQuery,
      answer: answer,
      sources: sources.map((source) => source.toEntity()).toList(),
      usedInference: usedInference,
      requiresClarification: requiresClarification,
    );
  }
}
