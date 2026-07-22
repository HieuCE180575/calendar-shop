import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_answer.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/ask_chat_usecase.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSource(ref.watch(apiClientProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(chatRemoteDataSourceProvider));
});

final askChatUseCaseProvider = Provider<AskChatUseCase>((ref) {
  return AskChatUseCase(ref.watch(chatRepositoryProvider));
});

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

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;

  ChatNotifier(this.ref)
      : super(
          ChatState(
            messages: [
              ChatMessageItem(
                text: 'Xin chao! Toi co the giup ban tim san pham, gia, ton kho va coupon dang ap dung.',
                isUser: false,
                timestamp: DateTime.fromMillisecondsSinceEpoch(0),
              ),
            ],
          ),
        );

  Future<void> sendMessage(String message) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final userMessage = ChatMessageItem(
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      messages: [...state.messages, userMessage],
    );

    try {
      final answer = await ref.read(askChatUseCaseProvider)(trimmed);
      final botMessage = ChatMessageItem(
        text: answer.answer,
        isUser: false,
        timestamp: DateTime.now(),
        answer: answer,
      );

      state = state.copyWith(
        isLoading: false,
        messages: [...state.messages, botMessage],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearChat() {
    state = ChatState(
      messages: [
        ChatMessageItem(
          text: 'Xin chao! Toi co the giup ban tim san pham, gia, ton kho va coupon dang ap dung.',
          isUser: false,
          timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        ),
      ],
    );
  }
}

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref);
});
