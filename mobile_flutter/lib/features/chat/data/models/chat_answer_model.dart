import '../../domain/entities/chat_answer.dart';

class ChatAnswerModel {
  final String answer;

  const ChatAnswerModel({
    required this.answer,
  });

  factory ChatAnswerModel.fromJson(Map<String, dynamic> json) {
    return ChatAnswerModel(
      answer: json['answer'] as String? ?? '',
    );
  }

  ChatAnswer toEntity() {
    return ChatAnswer(
      answer: answer,
    );
  }
}
