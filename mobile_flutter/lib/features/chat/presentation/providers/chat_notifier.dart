import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_dependencies.dart';
import 'chat_state.dart';

const _chatGreeting =
    'Xin chào! Tôi có thể giúp bạn tìm sản phẩm, giá, tồn kho và coupon đang áp dụng.';

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;

  ChatNotifier(this.ref)
      : super(
          ChatState(
            messages: [
              ChatMessageItem(
                text: _chatGreeting,
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
          text: _chatGreeting,
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
