import '../../domain/entities/chat_answer.dart';

class ChatMessageItem {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final ChatAnswer? answer;

  const ChatMessageItem({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.answer,
  });
}

class ChatState {
  final bool isLoading;
  final String? error;
  final List<ChatMessageItem> messages;

  const ChatState({
    this.isLoading = false,
    this.error,
    this.messages = const [],
  });

  ChatState copyWith({
    bool? isLoading,
    String? error,
    List<ChatMessageItem>? messages,
    bool clearError = false,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      messages: messages ?? this.messages,
    );
  }
}
